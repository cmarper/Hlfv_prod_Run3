#!/bin/bash

# Exit on any error
set -e

# Setup CMSSW environment
echo "==> Setting up CMSSW_13_0_13..."
cmsrel CMSSW_13_0_13
cd CMSSW_13_0_13/src
cmsenv
echo "Done."
cd ../../

#########################
######### LHEGS #########
#########################

# Run production
echo "==> Running LHEGS production..."
cmsRun Run3Summer23BPixwmLHEGS-ggHiggsToTauE_cfg.py
echo "Done."

##########################
######### PREMIX #########
##########################

# Setup CMSSW environment
echo "==> Setting up CMSSW_13_0_14..."
cmsrel CMSSW_13_0_14
cd CMSSW_13_0_14/src
cmsenv
echo "Done."
cd ../../

# Run production
echo "==> Running PREMIX (DIGI) production..."
cmsRun Run3Summer23BPixDRPremix-ggHiggsToTauE_1_cfg.py
echo "Done."

# Run production
echo "==> Running PREMIX (RECO) production..."
cmsRun Run3Summer23BPixDRPremix-ggHiggsToTauE_2_cfg.py
echo "Done."

###########################
######### MiniAOD #########
###########################

# Run production
echo "==> Running MiniAOD production..."
cmsRun Run3Summer23BPixMiniAODv4-ggHiggsToTauE_cfg.py
echo "Done."

###########################
######### NanoAOD #########
###########################

# Run production
echo "==> Running NanoAOD production..."
cmsRun  Run3Summer23BPixNanoAODv12-ggHiggsToTauE_cfg.py
echo "Done."

