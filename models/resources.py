## Source: https://simpleisbetterthancomplex.com/packages/2016/08/11/django-import-export.html

from import_export import resources
from .models import PredictorVarriables

class PredictorsResource(resources.ModelResource):
    class Meta:
        model = PredictorVarriables