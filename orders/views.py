from django.contrib.auth.decorators import login_required
from django.shortcuts import render ,redirect
from .models import Card
from django.contrib import messages
from django.conf import settings
import stripe
# Create your views here.


@login_required
def add_card(request):
    print('request.user',type(request.user))
    if request.method == 'POST':

        print('request data', request.POST)
        stripe.api_key = settings.STRIPE_SECRET_KEY

        name = request.POST.get("name")
        card_number = request.POST.get("card-number")
        expiry_date = request.POST.get("expiry-date")
        # cvv = request.POST.get("cvv")
        exp_year = int(expiry_date[:4])
        exp_month = int(expiry_date[5:7])
        print(exp_month,exp_year)

        cvv = hash(request.POST.get("cvv"))
        if name and card_number and expiry_date and cvv:

            cards = Card.objects.filter(card_holder=request.user, status=True)
            for i in cards:
                if i.card_number == card_number:
                    messages.error(request,'card already exist, please try any other card ')
                    return redirect('/orders/add-card')
            else:

                try:
                    # token = stripe.Token.create(
                    #     card={
                    #         "number": card_number,
                    #         "exp_month": exp_month,
                    #         "exp_year": exp_year,
                    #         "cvc": cvv,
                    #     }
                    # )

                    # charge = stripe.Charge.create(
                    #     amount=500,
                    #     currency='usd',
                    #     description='A Django charge',
                    #     source=token
                    # )

                    print("request.user",request.user)
                    card = Card.objects.create(
                        name=name,
                        card_number=card_number,
                        expiry_date=expiry_date,
                        cvv=cvv,
                        card_holder=request.user
                    )
                    card.save()
                    messages.success(request, "Card added")
                except Exception as ex:
                    print(ex)
                    messages.error(request, ex)
        else:
            messages.error('please do fill all the fields')

    cards = Card.objects.filter(card_holder=request.user, status=True)
    return render(request, "order/add-card.html", {'cards': cards})


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
    return render(request, "order/add-card.html", {'cards': cards})


def payment():
    return None