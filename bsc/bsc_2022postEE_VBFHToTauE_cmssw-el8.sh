#!/bin/bash

# Exit on any error
set -e

# Setup CMSSW environment
echo "==> Setting up CMSSW_12_4_11_patch3..."
cmsrel CMSSW_12_4_11_patch3
cd CMSSW_12_4_11_patch3/src
cmsenv
echo "Done."
cd ../../

#########################
######### LHEGS #########
#########################

# Run production
echo "==> Running LHEGS production..."
cmsRun Run3Summer22EEwmLHEGS-VBFHiggsToTauE_cfg.py
echo "Done."

##########################
######### PREMIX #########
##########################

# Run production
echo "==> Running PREMIX (DIGI) production..."
cmsRun Run3Summer22EEDR-VBFHiggsToTauE_1_cfg.py
echo "Done."

# Run production
echo "==> Running PREMIX (RECO) production..."
cmsRun Run3Summer22EEDR-VBFHiggsToTauE_2_cfg.py
echo "Done."

###########################
######### MiniAOD #########
###########################

# Setup CMSSW environment
echo "==> Setting up CMSSW_13_0_13..."
cmsrel CMSSW_13_0_13
cd CMSSW_13_0_13/src
cmsenv
echo "Done."
cd ../../

# Run production
echo "==> Running MiniAOD production..."
cmsRun Run3Summer22EEMiniAODv4-VBFHiggsToTauE_cfg.py 
echo "Done."

###########################
######### NanoAOD #########
###########################

# Run production
echo "==> Running NanoAOD production..."
cmsRun Run3Summer22EENanoAODv12-VBFHiggsToTauE_cfg.py
echo "Done."

