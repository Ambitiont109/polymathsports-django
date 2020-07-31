from django import forms
from django.forms import ModelForm
from django.core.exceptions import ValidationError
from django.utils.translation import ugettext_lazy as _
# from django_select2 import ModelSelect2Widget 

from .models import Sports, Game, UserModels, PredictorManipulations

class UserSportGameSelection(forms.Form):
    model_name = forms.CharField(max_length=200)
    sport = forms.CharField(max_length=200)
    games = forms.CharField(max_length=200)

    def validate(self, user_flow):
        if user_flow == 'build_model':
            if self.sport == '' or self.games == '' or self.model_name == '' or self.sport == None or self.games == None or self.model_name == None:
                return False
        else:
            if self.sport == '' or self.games == '' or self.sport == None or self.games == None:
                return False
            # raise ValidationError(_('Not enough data'))

        return self.games, self.sport

class UserTargetVariableSelection(forms.Form):
    target_variable = forms.CharField(max_length=200)

class UserModelDataForm(ModelForm):
    class Meta:
        model = UserModels
        fields = [
                'user',
                'model_name',
                'model_sport',
                'model_game',
                'model_target_variables',
                'model_predictor_variables',
                'model_variables_manipulation',
                'model_algorithm'
        ]

class PredictorManipulationFrom(forms.ModelForm):
    class Meta:
        model = PredictorManipulations
        fields = [
            'user',
            'manipulation',
            'manipulator_value',
            'predictors',
        ]

    # class Meta:
    #     model = Games
    #     fields = ('sport', 'name')

    # def __init__(self, *args, **kwargs):
    #     super().__init__(*args, **kwargs)
    #     self.fields['sport'].queryset = Sports.objects.none()

    #     if 'sport' in self.data:
    #         try:
    #             sport_id = int(self.data.get('sport'))
    #             self.fields['game'].queryset = Games.objects.filter(sport_id=sport_id).order_by('name')
    #         except (ValueError, TypeError):
    #             pass  # invalid input from the client; ignore and fallback to empty Games queryset
    #     elif self.instance.pk:
    #         self.fields['game'].queryset = self.instance.sport.order_by('name')

