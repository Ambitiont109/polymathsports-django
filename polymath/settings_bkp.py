"""
Django settings for polymath project.

Generated by 'django-admin startproject' using Django 1.11.

For more information on this file, see
https://docs.djangoproject.com/en/1.11/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/1.11/ref/settings/
"""

import os
import json

# Build paths inside the project like this: os.path.join(BASE_DIR, ...)
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

with open(os.path.join(BASE_DIR,'config.json'), 'r') as config_file:
    config = json.load(config_file)

# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/1.11/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = config['SECRET_KEY']

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

ALLOWED_HOSTS = [
        '54.245.184.61'
        'polymathsports.com',
        '*'
        ]


# Application definition

INSTALLED_APPS = [
    'users.apps.UsersConfig',
    'orders',
    'models',
    # 'static_pages',
    'customer_support',
    'widget_tweaks',
    'clear_cache',
    'import_export', # For import of CSV files directly through Admin panel
    # 'django_celery_results',
    # 'djcelery',
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles'
    # 'django.contrib.sessions'
]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
    # 'django.contrib.sessions.middleware.SessionMiddleware'
]

ROOT_URLCONF = 'polymath.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [os.path.join(BASE_DIR, 'templates')],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.template.context_processors.media',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'polymath.wsgi.application'


# Database
# https://docs.djangoproject.com/en/1.11/ref/settings/#databases


DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': 'polymath', #LIVE DAATABASE
        'USER': 'polymath',
        'PASSWORD': 'codebrew-01c0b8f1de7',
        'HOST': 'localhost',
        'PORT': '5432',
    }
}


# Password validation
# https://docs.djangoproject.com/en/1.11/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    # {
    #     'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    # },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    # {
    #     'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    # },
    # {
    #     'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    # },
]


# Internationalization
# https://docs.djangoproject.com/en/1.11/topics/i18n/

LANGUAGE_CODE = 'en-us'

TIME_ZONE = 'UTC'

USE_I18N = True

USE_L10N = True

USE_TZ = True


# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/1.11/howto/static-files/

STATIC_URL = '/staticfiles/'

STATICFILES_DIRS = [
    os.path.join(BASE_DIR, "staticfiles"),
   # os.path.join(BASE_DIR, "static/profile"),
]

#STATIC_ROOT = os.path.join(BASE_DIR, 'staticfiles')
#STATIC_ROOT = STATIC_URL

LOGIN_URL = 'login'
LOGIN_REDIRECT_URL = 'home'
APPEND_SLASH=False

MESSAGE_LEVEL = 10

from django.contrib.messages import constants as messages

MESSAGE_TAGS = {
    messages.DEBUG: 'alert-info',
    messages.INFO: 'alert-info',
    messages.SUCCESS: 'alert-success',
    messages.WARNING: 'alert-warning',
    messages.ERROR: 'alert-danger',
}

# django.contrib.auth
# ------------------------------------------------------------------------------
# AUTH_USER_MODEL = 'users.User'
AUTHENTICATION_BACKENDS = (
    'django.contrib.auth.backends.ModelBackend',
    # 'electric_soul.auth.backends.SiteUserBackend'
)
ACCOUNT_ACTIVATION_DAYS = 7

AUTH_PASSWORD_VALIDATORS += [
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
        'OPTIONS': {
            'min_length': 8,
        }
    },
]

IMPORT_EXPORT_USE_TRANSACTIONS = True # For the import_export model

MEDIA_URL = '/media/'
MEDIA_ROOT = os.path.join(BASE_DIR, 'media')

# Email section
EMAIL_USE_TLS = True
EMAIL_HOST = 'in-v3.mailjet.com'
EMAIL_HOST_USER = '2a90f472fc73aef9e13b9c6d960e0fb4'
EMAIL_HOST_PASSWORD = '17ff71e9c40ec467df71c8d76924ec63'
EMAIL_PORT = 587
DEFAULT_FROM_EMAIL = config['MAILJET_EMAIL']

# Billing and payments
#STRIPE_SECRET_KEY = 'sk_test_Ot00cg3oiXBCmssiHmgd1zfz00OoIVzxBV'
#STRIPE_PUBLISHABLE_KEY = 'pk_test_SaQ9IHfske2orxsm3qpyAgnh00V5ILDySH'

# Billing and payments
if DEBUG:
    STRIPE_SECRET_KEY = 'sk_test_Ot00cg3oiXBCmssiHmgd1zfz00OoIVzxBV'
    STRIPE_PUBLISHABLE_KEY = 'pk_test_SaQ9IHfske2orxsm3qpyAgnh00V5ILDySH'
else:
    STRIPE_SECRET_KEY = config['STRIPE_SECRET_KEY']
    STRIPE_PUBLISHABLE_KEY = config['REAL_PUBLISHER_KEY']

# CELERY STUFF
# BROKER_URL = 'redis://localhost:6379'
# BROKER_TRANSPORT = 'redis'
# CELERY_BROKER_URL = 'redis://localhost:6379/0'
# CELERY_RESULT_BACKEND = 'redis://localhost:6379/0'
# CELERYBEAT_SCHEDULER   = 'djcelery.schedulers.DatabaseScheduler'

# CELERY_RESULT_BACKEND = 'redis://localhost:6379/0'
# CELERY_ACCEPT_CONTENT = ['application/json']
# CELERY_TASK_SERIALIZER = 'json'
# CELERY_RESULT_SERIALIZER = 'json'
# CELERY_TIMEZONE = 'Africa/Nairobi'

# CELERY_RESULT_BACKEND = 'django-db'
# CELERY_CACHE_BACKEND = 'django-cache'

'''
PRODUCTION SERVER
'''
# User subscriptions
FREE_SUBSCRIPTION_ID = '0e4af85e674b4782b56cd0d1be284670'
FREE_PLAN_ID = 'plan_HjNF7T5HbYKi4c'

BASIC_SUBSCRIPTION_ID = 'c3eec925b34b43cb8b72899cd4fafce7'
BASIC_PLAN_ID = 'plan_HjMbcmg7E8SQzB'

BASIC_WEEKLY_SUBSCRIPTION_ID = '9b46cf822be243e195a4da173c18221b'
BASIC_WEEKLY_PLAN_ID = 'plan_HjNJEV2b3u8NYp'


VIP_PLAN_ID = 'plan_HjNLdobzxvAHyJ'
VIP_SUBSCRIPTION_ID = 'e1561daad98b45d1a3cdb84d7fe41d7e'

VIP_ANNUAL_SUBSCRIPTION_ID = '8e59266edde646868d003b607b7a4815'
VIP_ANNUAL_PLAN_ID ='plan_HjNNZJrqd9nKcg'

SPORTS_PATH = os.path.join(BASE_DIR, 'sports/')

# payment done Successfully
# Request req_RfZAzafKJN2BjS: No such plan: sub_Gd9t24Gjws72Kx
