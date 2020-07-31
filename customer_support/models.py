from django.db import models

# Create your models here.
from polymath.base.utils.models import TimeStampedUUIDModel


class ContactUs(TimeStampedUUIDModel):
    name = models.CharField(max_length=100)
    email = models.EmailField(max_length=200)
    subject = models.CharField(max_length=200)
    description = models.TextField(max_length=2500)

    def __str__(self):
        return "{} ({})".format(self.name, self.email)

    class Meta:
        verbose_name_plural = 'Contact us'

# class Videosdsgf(TimeStampedUUIDModel):
# 	videos = models.CharField(max_length=100)

	# def __str__(self):
 #        return "{} ({})".format(self.name, self.email)

 