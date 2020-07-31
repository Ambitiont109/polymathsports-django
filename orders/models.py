from django.db import models
from polymath.base.utils.models import TimeStampedUUIDModel, UUIDModel
from django.contrib.auth.models import User
from django.utils.translation import ugettext_lazy as _
# Create your models here.


class Card(TimeStampedUUIDModel):
    card_holder = models.ForeignKey(User, on_delete=models.CASCADE)
    name = models.CharField(max_length=30)
    card_number = models.CharField(max_length=16)
    expiry_date = models.DateField()
    cvv = models.BigIntegerField(null = True)
    card_provider = models.CharField(max_length=30, blank=True, null=True)
    card_logo = models.ImageField(null=True, blank=True, upload_to="cards")
    status = models.BooleanField(_('Card status'), default=True,
                                 help_text='Card is active or not active')

    class Meta:
        verbose_name = _('Card')

    def __str__(self):
        return "{} ({})".format(self.name, self.card_number)

