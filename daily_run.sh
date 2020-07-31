#!/bin/sh

## Run the R scripts
echo "<<<<<<  Running the R Scripts >>>>>>>>"
echo ""
/usr/bin/env bash -c 'sh ${HOME}/Polymath/polymath/run_R.sh |& tee $HOME/daily_R_run.log'

# Load the CSV files
echo "<<<<<<  Loading CSV to DB >>>>>>>>"
echo ""
python3 ${HOME}/Polymath/polymath/sports/dataentry.py 
 