from django.contrib import admin

# Register your models here.
from customer_support.models import ContactUs


@admin.register(ContactUs)
class ContactUsAdmin(admin.ModelAdmin):
    list_display = ('id', 'name', 'email', 'subject', 'created')
    search_fields = ('name', 'email', 'subject')
