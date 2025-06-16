#!/bin/bash

# Run in singularity cmssw-el8

# Cloned from repo: git clone git@github.com:cmarper/Hlfv_prod_Run3.git

# Exit on any error
set -e

# Settings
nevents=1

# Initialize CMS VOMS proxy
echo "==> Initializing CMS VOMS proxy..."
voms-proxy-init --voms cms
echo "Done."

# Create and move into the working directory
echo "==> Creating and moving into working directory 2022postEE_GluGluHToTauMu..."
mkdir -p 2022postEE_GluGluHToTauMu
cd 2022postEE_GluGluHToTauMu || exit
echo "Done."

# Setup CMSSW environment
echo "==> Setting up CMSSW_12_4_11_patch3..."
cmsrel CMSSW_12_4_11_patch3
cd CMSSW_12_4_11_patch3/src
cmsenv
echo "Done."

# Build CMSSW
echo "==> Building CMSSW project..."
scram b -j $(nproc)
cmsenv
echo "Done."

#########################
######### LHEGS #########
#########################

# Create configuration
echo "==> Creating LHEGS configuration file..."
mkdir -p Configuration/GenProduction/python/
cp ../../Hlfv_prod_Run3/fragments/fragment-ggHiggsTauMu.py Configuration/GenProduction/python/Run3Summer22EELHEGS-ggHiggsToTauMu-fragment.py
cmsDriver.py Configuration/GenProduction/python/Run3Summer22EELHEGS-ggHiggsToTauMu-fragment.py --eventcontent RAWSIM,LHE --customise Configuration/DataProcessing/Utils.addMonitoring --datatier GEN-SIM,LHE --conditions 124X_mcRun3_2022_realistic_postEE_v1 --beamspot Realistic25ns13p6TeVEarly2022Collision --customise_commands process.RandomNumberGeneratorService.externalLHEProducer.initialSeed="12345" --step LHE,GEN,SIM --geometry DB:Extended --era Run3 --python_filename Run3Summer22EEwmLHEGS-ggHiggsToTauMu_cfg.py --fileout file:Run3Summer22EEwmLHEGS-ggHiggsToTauMu.root --number $nevents --number_out $nevents --no_exec --mc
echo "Done."

# Run production
echo "==> Running LHEGS production..."
cmsRun ../../configs/Hlfv_prod_Run3/Run3Summer22EEwmLHEGS-ggHiggsToTauMu_cfg.py
echo "Done."

##########################
######### PREMIX #########
##########################

# Create configuration
echo "==> Creating PREMIX (DIGI) configuration file..."
#pileupfile="dbs:/Neutrino_E-10_gun/Run3Summer21PrePremix-Summer22_124X_mcRun3_2022_realistic_v11-v2/PREMIX"
pileupfile="dbs:/MinBias_TuneCP5_13p6TeV-pythia8/Run3Summer22GS-124X_mcRun3_2022_realistic_v10-v1/GEN-SIM"
cmsDriver.py  --eventcontent RAWSIM --pileup AVE_70_BX_25ns --customise Configuration/DataProcessing/Utils.addMonitoring --datatier GEN-SIM-RAW --conditions 124X_mcRun3_2022_realistic_postEE_v1 --step DIGI,L1,DIGI2RAW,HLT:2022v14 --geometry DB:Extended --era Run3 --python_filename Run3Summer22EEDR-ggHiggsToTauMu_1_cfg.py --fileout file:Run3Summer22EEDR-ggHiggsToTauMu_0.root --filein file:Run3Summer22EEwmLHEGS-ggHiggsToTauMu.root --number $nevents --number_out $nevents --pileup_input $pileupfile --no_exec --mc
echo "Done."

# Run production
echo "==> Running PREMIX (DIGI) production..."
cmsRun ../../configs/Hlfv_prod_Run3/Run3Summer22EEDR-ggHiggsToTauMu_1_cfg.py
echo "Done."

# Create configuration
echo "==> Creating PREMIX (RECO) configuration file..."
cmsDriver.py  --eventcontent AODSIM --customise Configuration/DataProcessing/Utils.addMonitoring --datatier AODSIM --conditions 124X_mcRun3_2022_realistic_postEE_v1 --step RAW2DIGI,L1Reco,RECO,RECOSIM --geometry DB:Extended --era Run3 --python_filename Run3Summer22EEDR-ggHiggsToTauMu_2_cfg.py --fileout file:Run3Summer22EEDR-ggHiggsToTauMu.root --filein file:Run3Summer22EEDR-ggHiggsToTauMu_0.root --number $nevents --number_out $nevents --no_exec --mc
echo "Done."

# Run production
echo "==> Running PREMIX (RECO) production..."
cmsRun ../../configs/Hlfv_prod_Run3/Run3Summer22EEDR-ggHiggsToTauMu_2_cfg.py
echo "Done."

cd ../../

###########################
######### MiniAOD #########
###########################

# Setup CMSSW environment
echo "==> Setting up CMSSW_13_0_13..."
cmsrel CMSSW_13_0_13
cd CMSSW_13_0_13/src
cmsenv
echo "Done."

# Create configuration
echo "==> Creating MiniAOD configuration file..."
cmsDriver.py  --eventcontent MINIAODSIM --customise Configuration/DataProcessing/Utils.addMonitoring --datatier MINIAODSIM --conditions 130X_mcRun3_2022_realistic_postEE_v6 --step PAT --geometry DB:Extended --era Run3,run3_miniAOD_12X --python_filename Run3Summer22EEMiniAODv4-ggHiggsToTauMu_cfg.py --fileout file:Run3Summer22EEMiniAODv4-ggHiggsToTauMu.root --filein file:../../CMSSW_12_4_11_patch3/src/Run3Summer22EEDR-ggHiggsToTauMu.root --number $nevents --number_out $nevents --no_exec --mc
echo "Done."

# Run production
echo "==> Running MiniAOD production..."
cmsRun ../../configs/Hlfv_prod_Run3/Run3Summer22EEMiniAODv4-ggHiggsToTauMu_cfg.py
echo "Done."

###########################
######### NanoAOD #########
###########################

# Create configuration
echo "==> Creating NanoAOD configuration file..."
cmsDriver.py  --eventcontent NANOEDMAODSIM --customise Configuration/DataProcessing/Utils.addMonitoring --datatier NANOAODSIM --conditions 130X_mcRun3_2022_realistic_postEE_v6 --step NANO --scenario pp --era Run3 --python_filename Run3Summer22EENanoAODv12-ggHiggsToTauMu_cfg.py --fileout file:Run3Summer22EENanoAODv12-ggHiggsToTauMu.root --filein file:Run3Summer22EEMiniAODv4-ggHiggsToTauMu.root --number $nevents --number_out $nevents --no_exec --mc
echo "Done."

# Run production
echo "==> Running NanoAOD production..."
cmsRun ../../configs/Hlfv_prod_Run3/Run3Summer22EENanoAODv12-ggHiggsToTauMu_cfg.py
echo "Done."

cd ../../

# Move all output data
echo "==> Moving all output files to directory data/..."
mkdir -p data/
mv CMSSW_*/src/Run3Summer22EE*ggHiggsToTauMu*.root data/
echo "Done."

