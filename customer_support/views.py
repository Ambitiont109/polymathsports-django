from django.shortcuts import render,redirect
from django.contrib import messages
from customer_support.models import ContactUs
from polymath.base.utils.email import send_mail
from .forms import contactForm
# from django.shortcuts import redirect



def contact_us(request):
    if request.method == 'POST':
        form = contactForm()
        # print(form.is_valid())
        name = request.POST.get("name")
        email = request.POST.get("email")
        subject = request.POST.get("subject")
        description = request.POST.get("description")

        if '@' not in email :
            messages.error(request, "please enter a valid email")
            return redirect('/customer-support/contact-us')
        else: 
            if name and email and  subject and description:
                contact_us = ContactUs.objects.create(
                    name=name,
                    email=email,
                    subject=subject,
                    description=description
                )
                contact_us.save()
                
                context = {
                    "name": name,
                    "email": email,
                    "subject": subject,
                    "description": description,
                    "site_url": request._current_scheme_host
                }
                    
                send_mail('Request submitted ', email_template_name=None,
                          context=context, to_email=['nirupma@yopmail.com'],
                          html_email_template_name='email/contact-us.html')

                messages.success(request, "Thank you for submitting your request")
                return redirect('/customer-support/contact-us')
            else:
                messages.error(request, "please do fill all the fields")
                return redirect('/customer-support/contact-us')

    else:
        form = contactForm(request.POST)

        context = {
            'form': form
            }
        return render(request, "main/contact-us.html",context = context)