from django import forms

from .models import ContactUs

class contactForm(forms.ModelForm):
    name        = forms.CharField(max_length = 100,widget=forms.TextInput(attrs={'class': "form-control",'id':"name", 'name' : "name", 'placeholder': 'Name'}))
    email       = forms.EmailField(max_length = 200,widget=forms.TextInput(attrs={'class': "form-control",'id':"email", 'name' : "email", 'placeholder': 'Email'}))
    subject     = forms.CharField(max_length = 200, widget=forms.TextInput(attrs={'class': "form-control",'id':"subject", 'name' : "subject", 'placeholder': 'Subject'}))
    description = forms.CharField(widget=forms.Textarea(attrs={"rows":5, "cols":20,'class': "form-control",'id':"description", 'name' : "description", 'placeholder': 'Description' }), max_length = 2500)

    class Meta:
        model = ContactUs
        fields = ('name','email','subject','description')