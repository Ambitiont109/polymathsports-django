# -*- coding: utf-8 -*-
from __future__ import unicode_literals

import stripe
from django.contrib.sites.shortcuts import get_current_site
from django.shortcuts import render, redirect
from django.template import RequestContext
from django.http import JsonResponse, HttpResponseNotFound, HttpResponseBadRequest, HttpResponse, HttpResponseRedirect
from django.conf import settings
from django.template.loader import render_to_string
from django.utils.encoding import force_bytes, force_text
from django.utils.http import urlsafe_base64_encode, urlsafe_base64_decode
from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth import login as auth_login, authenticate
from django.contrib import messages
from django.contrib.auth.models import User
from django.contrib.auth.decorators import login_required
from django.contrib.auth.tokens import default_token_generator
# from django.core.mail import send_mail, EmailMessage
from users.models import Profile, SubscriptionPlan, UserSubscriptionOrder
from polymath.base.utils.email import send_mail
# from django.core.mail import send_mail

from orders.models import Card
from .models import Video, PrivacyPolicy, Terms, Education, Email
from .forms import NewsletterForm

import json
import urllib
from django.urls import reverse
import datetime
from datetime import timedelta

stripe.api_key = settings.STRIPE_SECRET_KEY 

def home(request):
    print( " ============ 1 ===================")
    context = {}
    if request.method == 'POST':
        newsletter_email = request.POST.get('newsletter_email')

        form = NewsletterForm(request.POST)
        if form.is_valid():
            form.save()
            messages.success(request, 'Thank you. You are now subscribed to our newsletter.')

            if request.user.is_authenticated:
                pass
        else:
            print('newsletter not valid')
            messages.error(request, 'Please enter a valid email address')

    context['vip_plan'] = settings.VIP_SUBSCRIPTION_ID

    try:
        context['video_homepage'] = Video.objects.all().last().video_homepage
    except:
        context['video_homepage'] = False

    return render(request, 'main/index.html', context)



def register(request):
    if not request.user.is_authenticated:
       
        print(" ============ Register v1 =============")

        plans = SubscriptionPlan.objects.all().order_by("amount")
        context = {'plans': plans}
        if request.method == 'POST':
            # subscription = UserSubscriptionOrder.objects.filter(user = request.user).first().subscription_plan
            # print(subscription)
            # plan_name
            # userDataDict = {}
            user_data = {}
            error = False

            password1 = request.POST.get("password")
            password2 = request.POST.get("password_again")
            name = request.POST.get("name")
            email = request.POST.get("email")
            username = request.POST.get("email")
            twitter = request.POST.get("twitter") 

            subscription = request.POST.get("Subscription-Plans")

            if User.objects.filter(username=request.POST.get("email").strip()).exists():
                messages.error(request, 'User with the same email already exists. Try with another email.')
                error = True

            elif not password1 or not password2:
                messages.error(request, "Enter password")
                error = True

            elif len(password1) < 8:
                messages.error(request, "Minimum password length should be 8")
                error = True

            elif not (password1 == password2):
                messages.error(request, "Mismatch password")
                error = True

            context.update({"name": name, "email": email, "twitter": twitter})
            if error:
                return render(request, 'auth/register.html', context)
            # return HttpResponse(subscription)

            if subscription == None:
                subscription = settings.FREE_SUBSCRIPTION_ID

           
            plan_name = SubscriptionPlan.objects.get(id = subscription ).name
            plan_amount = (SubscriptionPlan.objects.get(id = subscription)).amount

            user_data.update({'plan_name': plan_name, 'plan_amount': plan_amount,'subscription_id':subscription })

            # user_data.update({"plan_name":plan_name ,"plan_amount": plan_amount,"password":password1})

            form = UserCreationForm({"username": username, "password1": password1, "password2": password2})
            if form.is_valid():
                form.save()
                user = authenticate(username=username, password=password1)
                user.first_name = name
                user.email = email
                user.is_active = False
                user.save()

                profile = Profile.objects.create(
                    user=user,
                    twitter=twitter,
                    email=email,
                    subscription_id = subscription, 
                    newsletter_optin = True
                )

                profile.save()

                request.session['user_id'] = user.id

                # if plan_amount == 0:
                try:    
                    mail_template = Email.objects.get(name='activate')
                    mail_subject = mail_template.mail_subject

                    mail_context = {
                        'email_title': mail_template.mail_title,
                        'email_body': mail_template.mail_body,
                        'user': user,
                        'site_url': request._current_scheme_host,
                        'uid': urlsafe_base64_encode(force_bytes(user.pk)),
                        'token': default_token_generator.make_token(user),
                        'subscription': SubscriptionPlan.objects.get(id=subscription),
                    }
                    
                    send_mail(mail_subject, email_template_name=None,
                                context=mail_context, to_email=[user.email],
                                html_email_template_name='email/register-email.html')

                    messages.success(request, "Check your mail inbox to activate account !!")
                    return render(request, "auth/login.html")

                except Exception as ex:
                    messages.error(request, "mail not sent -- Email configurations required")
                    return render(request,"auth/login.html", context_instance=RequestContext(request))
                # else:

                #     return render(request, 'order/make-payment.html', context = user_data)
            else:
                if form.errors:
                    messages.error(request, form.errors)
                    return render(request, "auth/login.html")
        return render(request, 'auth/register.html', context)
    else:
        return redirect('/login')


def login(request):
    context = {}

    print( "============ login v1 =============")
    # SESSION_COOKIE_AGE = 360

    if request.user.is_authenticated:
        return render(request, 'main/index.html', {})

    if request.method == "POST":
        
        if not User.objects.filter(username=request.POST.get("email").strip()).exists():
            messages.warning(request, 'User with this email is does not exists')
            return HttpResponseRedirect(request.META.get('HTTP_REFERER'))

        username = request.POST.get("email")
        password = request.POST.get("password")
        # return HttpResponse(password)
        # remember_me = request.POST.get("remember_me")
        subscriptions = SubscriptionPlan.objects.all()
        
        user = authenticate(username=username, password=password)
        print(user)
        if user:
            auth_login(request, user)
            subscriptions = SubscriptionPlan.objects.all()
            
            user_subscription = request.user.profile.subscription_id
            subscriptions_ids = []
            for sub in subscriptions:
                if str(user_subscription) == str(sub.id):
                    context['user_subscription'] = sub.name

            renew_subscription(request.user.id)

            context['user'] = user

            response = render(request, 'auth/profile.html', context)

            if 'remember_me' in request.POST:    
                response.set_cookie('username',username)
                response.set_cookie('password',password)
            print('remember_me',request.COOKIES)

            update_profile(user.id)

            return render(request, 'auth/profile.html', context)
        else:
            user = User.objects.filter(email=username).first()
            if user and not user.is_active:
                messages.error(request, "Please check your email inbox to activate your account")
                return render(request, 'auth/login.html', {"email": username})
            messages.error(request, 'Invalid password.. Please Try again')
            return redirect(request.META.get('HTTP_REFERER'))
    return render(request, 'auth/login.html', {})


from django.contrib.auth import logout
def logout_view(request):
    logout(request)
    return render(request, 'auth/login.html', {})
    


@login_required
def profile(request):
    print( " ============ profile v1 =============")
    context = {}


    # Profile Update
    if request.method == "POST":
        profile_pic = request.FILES.get("profile_pic")
        if not profile_pic:
            profile_pic = request.FILES.get("old_profile_pic")

        name = request.POST.get("name")
        twitter = request.POST.get("twitter")

        profile, created = Profile.objects.get_or_create(user=request.user)
        if name:
            profile.user.first_name = name
            profile.user.save()
        if twitter:
            profile.twitter = twitter
        if profile_pic:
            profile.profile_pic = profile_pic
        
        profile.subscription_id = Profile.objects.get(user=request.user).subscription_id
        # profile.subscription_name = SubscriptionPlan.objects.get(User=request.user).
        if request.POST.get('newsletter') == 'on':
            profile.newsletter_optin = True
        else:
            profile.newsletter_optin = False

        profile.save()
        messages.success(request, 'Profile updates saved.')
        context['user'] = profile.user

        subscriptions = SubscriptionPlan.objects.all()
        user_subscription = request.user.profile.subscription_id
        for sub in subscriptions:
            if str(user_subscription) == str(sub.id):
                context['user_subscription'] = sub
                break
        
        return render(request, 'auth/profile.html',context)

    subscriptions = SubscriptionPlan.objects.all()
    user_subscription = request.user.profile.subscription_id
    for sub in subscriptions:
        if str(user_subscription) == str(sub.id):
            context['user_subscription'] = sub
            break

    print(f'context: {context}')
    context['user'] = request.user

    update_profile(request.user.id)


    return render(request, 'auth/profile.html', context)


@login_required
def change_password(request):
    if request.method == "POST":
        user = request.user
        old_password = request.POST.get("old_password")
        password1 = request.POST.get("password1")
        password2 = request.POST.get("password2")
        error = False
        if not password1:
            messages.error(request, "Wrong old password")
            error =True
        elif len(password1) < 8:
            messages.error(request, "minimum password length should be 8")
            error = True
        elif not (password1 == password2):
            messages.error(request, "Mismatch password")
            error=True
        elif old_password == password1:
            messages.error(request, "This password is already used, Please Enter a new Password")

        if error:
            return HttpResponseRedirect(request.META.get('HTTP_REFERER'))

        authenticated = authenticate(username=user.username, password=old_password)

        if authenticated:
            try:

                user.set_password(password1)
                user.save()
                messages.success(request, "Successfully changed the password, Login Again..")
                logout(request)
                return redirect('login')
            except Exception as ex:
                messages.error(request, ex.message)
        else:
            messages.error(request, "You have entered the wrong current Password, Try again")

    return render(request, 'auth/change-password.html', {})


def reset_password(request):
    if request.method == "POST":
        user = request.user
        password1 = request.POST.get("password1")
        password2 = request.POST.get("password2")
        error = False
        if not password1:
            messages.error(request, "Enter password")
            error =True
        elif len(password1) < 8:
            messages.error(request, "Minimum password length should be 8")
            error = True
        elif not (password1 == password2):
            messages.error(request, "Mismatch password")
            error=True

        if error:
            return HttpResponseRedirect(request.META.get('HTTP_REFERER'))

        try:
            user.set_password(password1)
            user.save()
            messages.success(request, "Successfully changed the password, Login Again..")
            logout(request)
            return redirect('login')
        except Exception as ex:
            messages.error(request, ex.message)

    return render(request, 'auth/reset-password.html', {})


def modeling_packages(request):
    context = {}
    if request.user.is_authenticated:

        user_subscription_id = request.user.profile.subscription_id
        
        subscription_end_date = Profile.objects.filter(user = request.user).first().subscription_end_date
        # subscription = Profile.objects.get(user = request.user).subscription_id
        # subscription_name = SubscriptionPlan.objects.get(id=subscription).name    

        subscriptions = SubscriptionPlan.objects.all()
        subscriptions_ids = []
        for sub in subscriptions:

            subscriptions_ids.append(sub.id)
            subid = sub.id
            
            sub_id_change = "".join(str(subid).split("-"))
            
            if user_subscription_id.strip() == sub_id_change:
                context['plan'] = sub.name
                print(f'Found plan: {sub.name}')
                break
            else:
                print('NO PLAN')
                context['plan'] = 'None'

        context['vip_id'] = settings.VIP_SUBSCRIPTION_ID        
        context['vip_ann_id'] = settings.VIP_ANNUAL_SUBSCRIPTION_ID        
        context['basic_id'] = settings.BASIC_WEEKLY_SUBSCRIPTION_ID        
        context['free_id'] = settings.FREE_SUBSCRIPTION_ID        
        # context['plan'] = subscription_name

        return render(request, 'models/modeling-packages.html', context)


    else: 
        context['vip_id'] = settings.VIP_SUBSCRIPTION_ID        
        context['vip_ann_id'] = settings.VIP_ANNUAL_SUBSCRIPTION_ID        
        context['basic_id'] = settings.BASIC_WEEKLY_SUBSCRIPTION_ID        
        context['free_id'] = settings.FREE_SUBSCRIPTION_ID        
        return render(request, 'models/modeling-packages.html', context)

    # Downgrading/Upgrading Plans

def forgot_password(request):
    if request.method == "POST":
        email = request.POST.get("email")

        if email:
            if '@' in email: 

                user = User.objects.filter(email=email).first()
                print(user)
                # return HttpResponse(user)
                if user is not None :
                    token_generator = default_token_generator

                    context = {
                        'site_url': request._current_scheme_host,
                        'uidb64':  urlsafe_base64_encode(force_bytes(user.pk)),
                        'token': token_generator.make_token(user),
                        'user': user
                    }

                    msg = '{site_url}/reset/{uidb64}/{token}/'.format(**context)
                    print(msg)

                    try:
                        send_mail('Reset Password', email_template_name=None,
                                  context=context, to_email=[email],
                                  html_email_template_name='email/change-password.html')
                        messages.success(request, "Check your mail inbox to reset password !!")

                    except Exception as ex:
                        print(ex)
                        messages.error(request, "Email configurations Error !!!")
                    return redirect('/login')
                else:
                    messages.error(request, "This email is not registered to us. Please register first ")
                    return redirect('/register')
            else:
                messages.error(request, "please enter a valid email ")
                return redirect('/forgot-password')
        else:
            messages.error(request, "please do enter the email ")
            return redirect('/forgot-password')
    else:
        return render(request, 'auth/forgot-password.html', {})


def activate(request, uidb64, token):
    try:
        uid = force_text(urlsafe_base64_decode(uidb64))
        user = User.objects.get(pk=uid)
    except(TypeError, ValueError, OverflowError, User.DoesNotExist):
        user = None
    if user is not None and default_token_generator.check_token(user, token):
        user.is_active = True
        user.save()
        auth_login(request, user)
        # messages.success(request, 'Thank you for your email confirmation. Now you can login your account')
        return redirect('/profile')
        # return HttpResponse('Thank you for your email confirmation. Now you can login your account.')
    else:
        return HttpResponse('Activation link is invalid!')


def reset_password_done(request):
    messages.success(request, "Password Reset Successfully, Please login now..")
    return redirect('login')

'''
RUN ONCE: 
1) Edit below to create the plans for the platform 
2) Open page <SITE>/manage-stripe/
3) Copy the plan ID (not the prod_ID) to the admin panel "Subscription Plans" section into the corresponding plans
4) Change the duration (in the admin new subs) accordingly 
'''
def manage_stripe(request):
    print(f"***************  STRIPE ACTION ****************")
    # Dashboard: https://dashboard.stripe.com/test/dashboard
    # Create plan: https://stripe.com/docs/api/plans/create
    # Create subscription: https://stripe.com/docs/api/subscriptions/create
    # print("**************", stripe.Plan.list())
    context = {}
    stripe.api_key = settings.STRIPE_SECRET_KEY
    
    interval = {'year':365, 'month':30, 'week':7, 'day':1}

    new_subscription = SubscriptionPlan()

    if request.method == 'POST':

        if 'add_plan' in request.POST:
            subs_name = request.POST.get('subs_name')
            subs_amount = request.POST.get('subs_amount')
            subs_interval = request.POST.get('subs_interval')
            stripe_new_plan = stripe.Plan.create(
                amount=subs_amount,
                currency="usd",
                interval=subs_interval,
                product={"name": subs_name},
                )
            
            new_subscription.name = subs_name
            new_subscription.plan_id = stripe_new_plan.id
            new_subscription.amount = stripe_new_plan.amount
            new_subscription.duration = datetime.timedelta(days=interval[subs_interval])

            new_subscription.save()
        
        # elif 'delete_plan' in request.POST:

        #     subs_delete_plan_id = request.POST.get('delet_plan_id')

        #     print(f"DELETE: ***************{subs_delete_plan_id}****************")

        #     stripe_delete_plan = stripe.Plan.delete(subs_delete_plan_id)
        #     print(stripe_delete_plan)

    # context['stripe_plans'] = stripe.Plan.list(limit=5)
    context['stripe_plans'] = stripe.Plan.list()
    for aa in stripe.Plan.list():
        print(aa)
    
    return render(request, 'order/manage_stripe.html', context)

def manage_stripe_delete(request):
    
    stripe.api_key = settings.STRIPE_SECRET_KEY

    subs_delete_plan_id = request.POST.get('value')

    print(f"DELETE: ***************{subs_delete_plan_id}****************")

    stripe_delete_plan = stripe.Plan.delete(subs_delete_plan_id)
    
    return HttpResponse('Ok') 


@login_required
def make_payment(request,subscription_id):

    print(f"MAKE PAYMENT: ***************{(SubscriptionPlan.objects.get(id__icontains = subscription_id)).plan_id}****************")
    plan_name = SubscriptionPlan.objects.get(id__icontains = subscription_id ).name
    plan_amount = (SubscriptionPlan.objects.get(id__icontains = subscription_id)).amount

    user_data = {'plan_name':plan_name, 'plan_amount':plan_amount, 'subscription_id':subscription_id}
    
    if 'user_id' not in request.session:
        user = User.objects.get(id = request.user.id)
    else:
        user = User.objects.get(id = request.session['user_id'])


    if request.method == 'POST':
        # return HttpResponse(request.user)
        print('request data', request.POST)

        stripe.api_key = settings.STRIPE_SECRET_KEY

        name = request.POST.get("name")
        card_number = request.POST.get("card_number")
        expiry_date = request.POST.get("expiry_date")
        cvv = request.POST.get("cvv")
        
        # print(name, card_number, expiry_date, cvv)
        if name and card_number and expiry_date and cvv:
            exp_year = int(expiry_date[:4])
            exp_month = int(expiry_date[5:7])
            print(exp_month,exp_year)

 
            email = user.email

            try:
                token = stripe.Token.create(
                    card={
                        "number": card_number,
                        "exp_month": exp_month,
                        "exp_year": exp_year,
                        "cvc": cvv,
                    }
                )
                
                # return HttpResponse(type(email))
                customer = stripe.Customer.create(
                    name = name,
                    email = email
                )
                
                payment_method = stripe.PaymentMethod.create(
                    type="card",
                    card={
                        "number": card_number,
                        "exp_month": exp_month,
                        "exp_year": exp_year,
                        "cvc": cvv,
                        },
                    )
                
                attach_pm = stripe.PaymentMethod.attach(
                        payment_method.id,
                        customer=customer.id,
                        )

                
                subscription = stripe.Subscription.create(
                    customer=customer.id,
                    items=[
                    {
                      "plan": (SubscriptionPlan.objects.get(id__icontains = subscription_id)).plan_id
                      # 'quantity': 1,
                    }
                    ],
                    default_payment_method=payment_method.id
                )
                
                subscription_end_date = datetime.date.fromtimestamp(subscription.current_period_end)
                
                # return HttpResponse(int(user_data['plan_amount'][0])*100)
                charge = stripe.Charge.create(
                    amount=int(plan_amount)*100,
                    currency='usd',
                    description='A Subscription charge',
                    source=token
                )
                
                profile = Profile.objects.get(user_id = user.id)
                profile.stripe_customer_key = customer.id
                profile.customer_payment_method = payment_method.id
                profile.subscription_end_date = subscription_end_date
                profile.auto_renew = True
                # profile.subscription_id = subscription.id
                profile.subscription_id = subscription_id
                profile.email = email

                profile.customer_subscription_id = subscription.id     
                
                profile.save()

                cvv = hash(request.POST.get("cvv"))

                # user1 = authenticate(username=user_data['email'][0], password=user_data['password'][0])
                user = User.objects.filter(id = user.id).first()

                if user is not None:
                    user.is_active = True
                    auth_login(request, user)
                    user.save()
                    
                    mail_template = Email.objects.get(name='subscription')
                    mail_subject = mail_template.mail_subject

                    try:    
                        mail_context = {
                            'email_title': mail_template.mail_title,
                            'email_body': mail_template.mail_body,
                            'user': user,
                            'site_url': request._current_scheme_host,
                            'uid': urlsafe_base64_encode(force_bytes(user.pk)),
                            'token': default_token_generator.make_token(user),
                            'subscription': SubscriptionPlan.objects.get(id=subscription_id),
                        }

                        send_mail(mail_subject, email_template_name=None,
                                    context=mail_context, to_email=[user.email],
                                    html_email_template_name='email/subscription.html')

                        messages.success(request, "Thank you for upgrading to our premium plan !!")
                        # return redirect("/profile")

                    except Exception as ex:
                        messages.error(request, "mail not sent -- Email configurations required")
                        return render(request,"auth/login.html", context_instance=RequestContext(request))

                else:
                    mail_template = Email.objects.get(name='activate')
                    mail_subject = mail_template.mail_subject
                    
                    try:    
                        mail_context = {
                            'email_title': mail_template.mail_title,
                            'email_body': mail_template.mail_body,
                            'user': user,
                            'site_url': request._current_scheme_host,
                            'uid': urlsafe_base64_encode(force_bytes(user.pk)),
                            'token': default_token_generator.make_token(user),
                            'subscription': SubscriptionPlan.objects.get(id=subscription_id),
                        }
                        send_mail(mail_subject, email_template_name=None,
                                    context=mail_context, to_email=[user.email],
                                    html_email_template_name='email/register-email.html')

                        messages.success(request, "Check your mail inbox to activate account !!")
                        return render(request, "auth/login.html")

                    except Exception as ex:
                        messages.error(request, "mail not sent -- Email configurations required")
                        return render(request,"auth/login.html", context_instance=RequestContext(request))
                    

                user_subscription = UserSubscriptionOrder.objects.create(
                    user=user,
                    active=True,
                    subscription_plan_id=subscription_id
                )
                user_subscription.save()


                messages.success(request, "payment done Successfully")

                return redirect('/profile')
            except Exception as ex:
                print(ex)
                messages.error(request, ex)
                return render(request, 'order/make-payment.html' ,context = user_data)
        else:
            messages.error(request,'please do fill all the required fields')
            # return redirect('/make-payment?user_data1=%s'%urllib.parse.urlencode(context))
            return render(request, 'order/make-payment.html' ,context = user_data)
            # return reverse('make_payment',context = user_data)
    else:
        return render(request, 'order/make-payment.html' ,context = user_data)
        # return redirect('/make-payment)
    # cards = Card.objects.filter(card_holder=request.session['email'], status=True)
    # context={
    #     'user_data1' : user_data1
    # }
    # return render(request, 'order/make-payment.html' ,context = context)

@login_required
def remove_card(request):
    card_id = request.GET.get("card-id")
    try:
        card = Card.objects.get(id=card_id, card_holder=request.user)
        card.status = False
        card.save()
        messages.success(request, "Card Removed")

    except Card.DoesNotExists:
        messages.error(request, "Invalid user request")
    cards = Card.objects.filter(card_holder=request.user, status=True)
    return render(request, "order/make-payment.html", {'cards': cards})


def renew_subscription(user_id):
    print(f"Subscription renew: ID ***************{user_id}****************")
    user = Profile.objects.get(user=user_id)
    
    subscription_end_date = user.subscription_end_date
    auto_renew = user.auto_renew

    today = datetime.date.today()
    
    if subscription_end_date:
        if subscription_end_date >= today and auto_renew:
            updated_date = subscription_end_date + timedelta(30)
            user.subscription_end_date = updated_date
            user.save()
        elif subscription_end_date < today and not auto_renew:
            user_profile.subscription_id = settings.FREE_SUBSCRIPTION_ID
            user.save()
        else:
            pass

    return
    

def cancel_subscription(user_id, subscription):
    print(f"Canceling: ***************{user_id}****************")
    stripe.api_key = settings.STRIPE_SECRET_KEY
    user_stripe_subscription_id = User.objects.get(id=user_id).profile.customer_subscription_id
    stripe.Subscription.delete(user_stripe_subscription_id)

    # Updating DB
    user_profile = User.objects.get(id=user_id).profile
    user_profile.stripe_customer_key = ''
    user_profile.customer_subscription_id = ''
    user_profile.auto_renew = False
    user_profile.subscription_id = subscription
    # user_profile.subscription_id = settings.FREE_SUBSCRIPTION_ID
    user_profile.save()

    return


def update_profile(user_id):
    profile = User.objects.get(id=user_id).profile
    profile.user_subscription_name = SubscriptionPlan.objects.get(id=profile.subscription_id).name
    profile.user_active = User.objects.get(id=user_id).is_active
    profile.save()
    return


def change_subscription(user_id, to_subscription_id):
    
    # Stripe Docs: https://stripe.com/docs/billing/subscriptions/upgrading-downgrading

    stripe.api_key = settings.STRIPE_SECRET_KEY
    user_stripe_subscription_id = User.objects.get(id=user_id).profile.customer_subscription_id

    current_stripe_subscription = stripe.Subscription.retrieve(user_stripe_subscription_id)

    to_stripe_subscription_id = SubscriptionPlan.objects.get(id=to_subscription_id).plan_id

    stripe.Subscription.modify(
        current_stripe_subscription.id,
        cancel_at_period_end=False,
        items=[{
            'id': current_stripe_subscription['items']['data'][0].id,
            'plan': to_stripe_subscription_id,
        }]
        )

    # Updating DB
    user_profile = User.objects.get(id=user_id).profile
    
    # # Updating dates
    # if to_subscription_id == settings.VIP_ANNUAL_SUBSCRIPTION_ID:
    #     current_end_date = User.objects.get(id=user_id).profile.subscription_end_date
    #     new_end_date =current_end_date + timedelta(365)
    #     user_profile.subscription_end_date = new_end_date
    
    user_profile.subscription_id = to_subscription_id
    user_profile.auto_renew = True
    user_profile.save()

    return

# @login_required
def modelling_package(request,subscription):
    plans = SubscriptionPlan.objects.all().order_by("amount")
    context = {'plans': plans}

    # return HttpResponse(value)    
    if request.user.is_authenticated:
        user_id = request.user.id
        subscription_end_date = Profile.objects.filter(user = request.user).first().subscription_end_date
        today = datetime.date.today()
        user_subscription_id = Profile.objects.filter(user = request.user).first().subscription_id
        # Handeling VIPs
        
        if str(user_subscription_id) == settings.VIP_SUBSCRIPTION_ID or str(user_subscription_id) == settings.VIP_ANNUAL_SUBSCRIPTION_ID:
            
            # Upgrading to Annual
            if str(subscription) == settings.VIP_ANNUAL_SUBSCRIPTION_ID and str(user_subscription_id) == settings.VIP_SUBSCRIPTION_ID:
                make_payment(request, subscription)
                change_subscription(user_id,settings.VIP_ANNUAL_SUBSCRIPTION_ID)
                messages.info(request, 'Your VIP subscription was changed to annual.')
                return redirect('/modeling-packages')

            # Changing to VIP monthly
            elif str(user_subscription_id) == settings.VIP_ANNUAL_SUBSCRIPTION_ID and str(subscription) == settings.VIP_SUBSCRIPTION_ID:
                change_subscription(user_id,settings.VIP_SUBSCRIPTION_ID)
                messages.info(request, 'Your VIP subscription was changed to annual.')
                return redirect('/modeling-packages')

            # Downgrading to FREE plan:
            elif str(subscription) == settings.FREE_SUBSCRIPTION_ID:
                # Cancel Stripe
                cancel_subscription(user_id, subscription)
                print(f"Cancel VIP for: ***************{user_id}****************")
                # Send email
                messages.info(request, 'Your VIP subscription was canceled. You will be downgraded to the Free plan after the current billing cycle.')
                return redirect('/modeling-packages')
            
            #Downgrading to Basic
            else:
                change_subscription(user_id,settings.BASIC_WEEKLY_SUBSCRIPTION_ID)
                print(f"Downgrade to Basic for: ***************{user_id}****************")
                # Change stripe to basic
                # Send email
                messages.info(request, 'Your VIP subscription was canceled. You have been downgraded to the Basic plan.')
                return redirect('/modeling-packages')
        
        #Handling Basic users
        elif str(user_subscription_id) == settings.BASIC_WEEKLY_SUBSCRIPTION_ID:
            # Downgrading to Free plan
            if str(subscription) == settings.FREE_SUBSCRIPTION_ID:
                # Cancel Stripe
                cancel_subscription(user_id, subscription)
                print(f"Cancel Basic for: ***************{user_id}****************")
                # Send email
                messages.info(request, 'Your Basic subscription was canceled. You have been downgraded to the Free plan.')
                return redirect('/modeling-packages')
            
            # Upgrading to VIP
            else:
                plan_name = SubscriptionPlan.objects.get(id = subscription ).name
                plan_amount = (SubscriptionPlan.objects.get(id = subscription)).amount

                user_data = {'subscription_id':subscription, 'plan_name': plan_name, 'plan_amount': plan_amount}

                return render(request, 'order/make-payment.html', context = user_data)
        
        # Handling Free users
        else:                
            # Upgrading to the desired plan
            plan_name = SubscriptionPlan.objects.get(id__icontains = subscription).name
            plan_amount = (SubscriptionPlan.objects.get(id__icontains = subscription)).amount

            user_data = {'subscription_id':subscription, 'plan_name': plan_name, 'plan_amount': plan_amount}

            return render(request, 'order/make-payment.html', context = user_data)

    else:
        # Choosing a Free plan

        messages.success(request, 'Please do register first to select a package ')
        return render(request, 'auth/register.html', context)
        # return redirect('/register')


def learning_section_video(request):
    # return HttpResponse(Video.objects.filter(id = '1').first())
    context = {}

    try:
        context['video_education'] = Video.objects.all().last().video_education
    except:
        context['video_education'] = False


    context['education_sections'] = Education.objects.all()

    return render(request, 'learning/learning-section-video.html',context)

@login_required
def learning_section(request): 
    # return HttpResponse('nirupma')
    plan_name = (str(UserSubscriptionOrder.objects.filter(user = request.user).first()).split('(')[1]).replace(')', '').strip()
    print(plan_name)

    if plan_name == 'MONTHLY' or plan_name == 'YEARLY':

        context = {
            'video1': Video.objects.filter(id = '1'),
            'video2': Video.objects.filter(id = '2'),
            'video3': Video.objects.filter(id = '3'),
            'video4': Video.objects.filter(id = '4'),
            'video5': Video.objects.filter(id = '5'),
            'video6': Video.objects.filter(id = '6')
        }
        
        return render(request, 'learning/learning-section.html', context = context)
    else:
        return redirect('learning-section')

def privacy_policy(request):
    context = {}

    context['policy'] = PrivacyPolicy.objects.all().last()

    return render(request, 'main/privacy-policy.html', context)

# def newsletter(request, newsletter_email):
#     messages.success(request, 'Thank you. You are now subscribed to our newsletter.')
#     return render(request, 'main/index.html')
def terms(request):
    context = {}
    context['terms'] = Terms.objects.all().last()
    return render(request, 'main/terms-and-conditions.html', context)