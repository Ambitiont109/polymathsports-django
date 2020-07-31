#!/bin/sh

## Run the R scripts
echo "<<<<<<  NCAAB >>>>>>>>"
echo ""
cd ${HOME}/Polymath/polymath/sports/ncaab
/usr/bin/Rscript master_script.R 

echo "<<<<<<  NFL >>>>>>>>"
echo ""
cd ${HOME}/Polymath/polymath/sports/nfl
/usr/bin/Rscript master_script.R

echo "<<<<<<  NCAAF >>>>>>>>"
echo ""
cd ${HOME}/Polymath/polymath/sports/ncaaf
/usr/bin/Rscript master_script.R

echo "<<<<<<  NBA >>>>>>>>"
echo ""
cd ${HOME}/Polymath/polymath/sports/nba
/usr/bin/Rscript master_script.R
