from django.db import models
from polymath.base.utils.models import TimeStampedUUIDModel, UUIDModel
from django.contrib.auth.models import User
from django.utils.translation import ugettext_lazy as _
from jsonfield import JSONField
# Create your models here.

class Sports(TimeStampedUUIDModel):
    name = models.CharField(max_length=50, unique=True)
    status = models.BooleanField(_('Sport status'), default=True,
                                 help_text='Sport is active or not active')

    class Meta:
        verbose_name = _('Sports')
        verbose_name_plural = 'Sports'

    def __str__(self):
        return "{}".format(self.name)

class Game(TimeStampedUUIDModel):
    sport = models.ForeignKey(Sports, default=1, on_delete=models.SET_DEFAULT)
    teams = models.CharField(max_length=250)
    date = models.DateTimeField()
    active = models.BooleanField(_('Game Active'), default=True)

    class Meta:
        verbose_name = _('Games')
        verbose_name_plural = 'Games'

    def __str__(self):
        return "{}".format(self.teams)

class TargetVarriables(TimeStampedUUIDModel):
    sport = models.ForeignKey(Sports,default=1, on_delete=models.SET_DEFAULT)
    name = models.CharField(max_length=50)
    status = models.BooleanField(_('Target variable status'), default=True,
                                 help_text='Target variable is active or not active')

    class Meta:
        verbose_name_plural = 'Target Varriables'

    def __str__(self):
        return "{}".format(self.name)

class PredictorsVariablesSubCategories(TimeStampedUUIDModel):
    STATUS = (
        ('True', 'True'),
        ('False', 'False'),
    )
    sub_category_name = models.CharField(max_length=100)
    category_status = models.CharField(max_length=10, choices=STATUS)

    class Meta:
        verbose_name_plural = 'predictors sub categories'

    def __str__(self):
        return "{}".format(self.sub_category_name)

class PredictorsVariablesCategories(TimeStampedUUIDModel):
    STATUS = (
        ('True', 'True'),
        ('False', 'False'),
    )
    category_name = models.CharField(max_length=100)
    category_status = models.CharField(max_length=10, choices=STATUS)

    class Meta:
        verbose_name_plural = 'predictors categories'

    def __str__(self):
        return "{}".format(self.category_name)



class PredictorVarriables(TimeStampedUUIDModel):
    ACCESS = ((
        'free','free'),
        ('premium','premium')
        )
    sport = models.ForeignKey(Sports, default=1, on_delete=models.SET_DEFAULT)

    category = models.ForeignKey(PredictorsVariablesCategories, null=True, on_delete=models.CASCADE)
    sub_category = models.ForeignKey(PredictorsVariablesSubCategories, null=True, on_delete=models.CASCADE)

    # name = models.CharField(max_length=250, unique=True)
    name = models.CharField(max_length=250)
    description = models.TextField(max_length=350, null=True, help_text='Predictors variables description text')
    access = models.CharField(max_length=250, null=True, blank=True, choices=ACCESS, help_text='Access for Free user and Primium User.')
    status = models.BooleanField(_('Predictor status'), default=True,
                                 help_text='Predictor is active or not active')
    

    class Meta:
        verbose_name_plural = 'Predictor Varriables'

    def __str__(self):
        return "{}".format(self.name)

class MLAlgorithms(TimeStampedUUIDModel):
    ACCESS = ((
        'free','free'),
        ('premium','premium')
        )
    TYPE = (
            ('classifier', 'classifier'),
            ('regressor', 'regressor')
        )

    name = models.CharField(max_length=250, unique=True)
    access = models.CharField(max_length=250, null=True, blank=True, default='free', choices=ACCESS, help_text='Access for Free user and Primium User.')
    status = models.BooleanField(_('Algorithm status'), default=True, help_text='Algorithm is active or not active')
    algo_type = models.CharField(max_length=30, null=True, choices=TYPE)


    class Meta:
        verbose_name = _('Algorithm')
        verbose_name_plural = 'Algorithms'

    def __str__(self):
        return "{}".format(self.name)

class UserModels(TimeStampedUUIDModel):
    # user = models.OneToOneField(User,default=1, on_delete=models.SET_DEFAULT)
    # model_name = models.CharField(max_length=250, blank=False)
    # model_sport = models.ForeignKey(Sports,default=1, on_delete=models.SET_DEFAULT)
    # model_game = models.ForeignKey(Game, default=1, on_delete=models.SET_DEFAULT)
    # model_target_variables = models.CharField(max_length=250)
    # model_predictor_variables = models.CharField(max_length=250)
    # model_variables_manipulation = models.CharField(max_length=250)
    # model_algorithm = models.ForeignKey(MLAlgorithms, default=1, on_delete=models.SET_DEFAULT)

    user = models.ForeignKey(User,default=1, on_delete=models.SET_DEFAULT)
    model_name = models.CharField(max_length=250, blank=False)
    model_type = models.CharField(max_length=250, blank=True)
    model_sport = models.CharField(max_length=250)
    model_game = models.CharField(max_length=2500)
    model_target_variables = models.CharField(max_length=250)
    model_predictor_variables = models.CharField(max_length=2500)
    model_variables_manipulation = models.CharField(max_length=2500)
    model_cross_validation_folds = models.IntegerField(default=1)
    model_algorithm = models.CharField(max_length=250)
    model_score = models.FloatField()
    model_saved_path = models.CharField(max_length=500)

    model_train_score = models.FloatField(null=True)
    model_test_score = models.FloatField(null=True)

    model_classification_report = JSONField(max_length=1000, null=True)
    # model_graph_data_x = models.BinaryField(null=True)
    # model_graph_data_y = models.BinaryField(max_length=25000, null=True)
    model_graph_data = JSONField(null=True)

    model_train_mae = models.FloatField(null=True)
    model_test_mae = models.FloatField(null=True)


    class Meta:
        verbose_name = _('User Models')
        verbose_name_plural = 'Users Models'

    def __str__(self):
        return "{}".format(self.user)

# class ModelReport(models.Model):
#     model = models.OneToOneField(UserModels, on_delete=models.CASCADE)
#     test_score = models.CharField(max_length=50, null=True)
#     train_score = models.CharField(max_length=50, null=True)
#     classification_report = models.CharField(max_length=1000, null=True)

#     class Meta:
#         verbose_name = _('Model Report')
#         verbose_name_plural = 'Model Reports'
    

class PredictorManipulations(TimeStampedUUIDModel):
    CHOICES = (
        (1, 'Multiply'),
        (2, 'Cube'),
        (3, 'Power of'),
        (4, 'Square Root'),
    )
    user = models.ForeignKey(User, default=1, on_delete=models.SET_DEFAULT)
    manipulation = models.CharField(max_length=200, null=True, choices=CHOICES)
    predictors = models.CharField(max_length=300)
    manipulator_value = models.CharField(max_length=20, null=True) 

    class Meta:
        verbose_name = _('User Predictors Manipulations')

    def __str__(self):
        return "{}".format(self.user)
