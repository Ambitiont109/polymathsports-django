#  Production Notes
## ###################

## Linux Machine 
1)  Access:
change the pesmissions on the PEM:
chmod 600 polymath.pem

SSH Access: ssh -i polymath.pem ubuntu@ec2-54-187-194-206.us-west-2.compute.amazonaws.com
USER: ubuntu

### Activate the virtual environment.
From Polymath dir:
% source venv_polymath/bin/activate

% cd /home/ubuntu/Polymath/polymath/models

ml_models.py

## Directory Structure (the "important directories")
/home/ubuntu/
--- Polymath
    |
    ---- polymath
        |
        --- media
        --- models (ML related)
        --- polymath (django project)
        --- static
        --- templates (html files)
        --- users (subscription, users management...)
        --- sports
            |
            -- nfl
            -- nba
            -- naccb
            -- naccf
        
## PostGres DB
* The following command will open a postgres command prompt in which you can view DB content.

% psql -d polymath

* To get commands list from the command line:
polymath-# \? 

## To update the Python code into the running server:
sudo systemctl restart supervisor

## Done
2) Copy the gunicorn_start.bash to the user home directory
3) Use the NginX conf file

### Automation
The cron script is scheduled to run at 03:00 EST. It executes: /home/ubuntu/Polymath/polymath/daily_run.sh
The former script runs the R master scripts and load the updated CSV files onto the DB.

### Monitoring log files
A log file with the run errors loading the CSV files:
/home/ubuntu/daily_CSV_run.log

A log file with the run errors running the R scripts:
/home/ubuntu/daily_R_run.log



## Migration Notes
1) Update the subscription plans in the admin panel and settings.py:
    1.1 settings.py :
        1.1.1 Put the new subscription IDs instead of the old ones.
    1.2 admin:
        1.2.1 Insert the Stripe Plan_<ID>  into each plan ID
        1.2.2 Update the price and the status

2) Add sports in the admin (just the name, e.g. NFL)
    2.1) Setup the 
3) Load the predictors for each sport to the admin area. 
* Make sure to uodate the sport_id in the CSV file
4) From the sports directory (where the dataentry.py is) run from shell: export SPORTS_DATA=$PWD 
5) Make sure dataentry.py script was and is executing on a daily basis, to load the latest FInal CSV files 
6) Add predictor variables (HomeWin, HomeScore...)
7) Add Algorithms

# New Sport Onboarding
1) Make sure to have the predictors for that sport. Upload them to the admin (make sure you change the sports ID in the CSV file according to the sport in the admin)
2) Inside each sport a user_models directory to hold the models users creating
3) Add the run script to the crone file for execution
4) 

## Admin Area
User: polymath_admi
Pass: Polymath2020!

## AWS
user: polymathsports@gmail.com

### Monitoring
* An alarm was set on AWS to trigger when a system status check fails.

# Stripe
** Stripe dashboard: https://dashboard.stripe.com/

## Note:
There are three plans in use at the moment: VIP Monthly, Basic Monthly and FREE. 
Theses names are "hard wired" into the code, so to use the flow below (change the plans attributes), you should be using on these three names.
Adding more plan names will require additional coding.

## Adding a subscription plan
1) Go to: http://127.0.0.1:8000/manage-stripe/
2) Enter plan details
3) Click Add Plan to create the plan
4) Activate the status of the plan from the admin area.

** Check that it's added to the page table (top), and to the admin.

## To delete a plan FROM STRIPE!!
1) Same page.
2) Make sure you see the Plan ID from Admin on this page
3) Copy/Paste into the plan deletion field
4) Click Delete Plan

** Make sure to delete the plan manually from the admin area as well.

