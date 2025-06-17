#!/bin/bash

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
echo "==> Creating and moving into working directory 2023postBPix_GluGluHToEMu..."
mkdir -p 2023postBPix_GluGluHToEMu
cd 2023postBPix_GluGluHToEMu || exit
echo "Done."

# Setup CMSSW environment
echo "==> Setting up CMSSW_13_0_13..."
cmsrel CMSSW_13_0_13
cd CMSSW_13_0_13/src
mkdir -p Configuration/GenProduction/python/
cp ../../../fragments/fragment-ggHiggsEMu.py Configuration/GenProduction/python/Run3Summer23BPixLHEGS-ggHiggsToEMu-fragment.py
cmsenv
echo "Done."

# Build CMSSW
echo "==> Building CMSSW project..."
scram b -j $(nproc)
echo "Done."

#########################
######### LHEGS #########
#########################

# Create configuration
echo "==> Creating LHEGS configuration file..."
cmsDriver.py Configuration/GenProduction/python/Run3Summer23BPixLHEGS-ggHiggsToEMu-fragment.py --eventcontent RAWSIM,LHE --customise Configuration/DataProcessing/Utils.addMonitoring --datatier GEN-SIM,LHE --conditions 130X_mcRun3_2023_realistic_postBPix_v2 --beamspot Realistic25ns13p6TeVEarly2023Collision --customise_commands process.RandomNumberGeneratorService.externalLHEProducer.initialSeed="12345" --step LHE,GEN,SIM --geometry DB:Extended --era Run3_2023 --python_filename Run3Summer23BPixwmLHEGS-ggHiggsToEMu_cfg.py --fileout file:Run3Summer23BPixwmLHEGS-ggHiggsToEMu.root --number $nevents --number_out $nevents --no_exec --mc
echo "Done."

# Run production
echo "==> Running LHEGS production..."
cmsRun Run3Summer23BPixwmLHEGS-ggHiggsToEMu_cfg.py
echo "Done."

cd ../../

##########################
######### PREMIX #########
##########################

# Setup CMSSW environment
echo "==> Setting up CMSSW_13_0_14..."
cmsrel CMSSW_13_0_14
cd CMSSW_13_0_14/src
cmsenv
echo "Done."

# Create configuration
echo "==> Creating PREMIX (DIGI) configuration file..."
#pileupfile="dbs:/Neutrino_E-10_gun/Run3Summer21PrePremix-Summer23_130X_mcRun3_2023_realistic_v13-v1/PREMIX"
pileupfile="filelist:../../../pileup/fileslist_Neutrino_E-10_gun.txt"
cmsDriver.py  --eventcontent PREMIXRAW --customise Configuration/DataProcessing/Utils.addMonitoring --datatier GEN-SIM-RAW --conditions 130X_mcRun3_2023_realistic_postBPix_v2 --step DIGI,DATAMIX,L1,DIGI2RAW,HLT:2023v12 --procModifiers premix_stage2 --geometry DB:Extended --datamix PreMix --era Run3_2023 --python_filename Run3Summer23BPixDRPremix-ggHiggsToEMu_1_cfg.py --fileout file:Run3Summer23BPixDRPremix-ggHiggsToEMu_0.root --filein file:../../CMSSW_13_0_13/src/Run3Summer23BPixwmLHEGS-ggHiggsToEMu.root --number $nevents --number_out $nevents --pileup_input $pileupfile --no_exec --mc
echo "Done."

# Run production
echo "==> Running PREMIX (DIGI) production..."
cmsRun Run3Summer23BPixDRPremix-ggHiggsToEMu_1_cfg.py
echo "Done."

# Create configuration
echo "==> Creating PREMIX (RECO) configuration file..."
cmsDriver.py  --eventcontent AODSIM --customise Configuration/DataProcessing/Utils.addMonitoring --datatier AODSIM --conditions 130X_mcRun3_2023_realistic_postBPix_v2 --step RAW2DIGI,L1Reco,RECO,RECOSIM --geometry DB:Extended --era Run3_2023 --python_filename Run3Summer23BPixDRPremix-ggHiggsToEMu_2_cfg.py --fileout file:Run3Summer23BPixDRPremix-ggHiggsToEMu.root --filein file:Run3Summer23BPixDRPremix-ggHiggsToEMu_0.root --number $nevents --number_out $nevents --no_exec --mc
echo "Done."

# Run production
echo "==> Running PREMIX (RECO) production..."
cmsRun Run3Summer23BPixDRPremix-ggHiggsToEMu_2_cfg.py
echo "Done."

###########################
######### MiniAOD #########
###########################

# Create configuration
echo "==> Creating MiniAOD configuration file..."
cmsDriver.py  --eventcontent MINIAODSIM --customise Configuration/DataProcessing/Utils.addMonitoring --datatier MINIAODSIM --conditions 130X_mcRun3_2023_realistic_postBPix_v2 --step PAT --geometry DB:Extended --era Run3_2023 --python_filename Run3Summer23BPixMiniAODv4-ggHiggsToEMu_cfg.py --fileout file:Run3Summer23BPixMiniAODv4-ggHiggsToEMu.root --filein file:Run3Summer23BPixDRPremix-ggHiggsToEMu.root --number $nevents --number_out $nevents --no_exec --mc
echo "Done."

# Run production
echo "==> Running MiniAOD production..."
cmsRun  Run3Summer23BPixMiniAODv4-ggHiggsToEMu_cfg.py
echo "Done."

###########################
######### NanoAOD #########
###########################

# Create configuration
echo "==> Creating NanoAOD configuration file..."
cmsDriver.py  --eventcontent NANOEDMAODSIM --customise Configuration/DataProcessing/Utils.addMonitoring --datatier NANOAODSIM --conditions 130X_mcRun3_2023_realistic_postBPix_v2 --step NANO --scenario pp --era Run3_2023 --python_filename Run3Summer23BPixNanoAODv12-ggHiggsToEMu_cfg.py --fileout file:Run3Summer23BPixNanoAODv12-ggHiggsToEMu.root --filein file:Run3Summer23BPixMiniAODv4-ggHiggsToEMu.root --number $nevents --number_out $nevents --no_exec --mc
echo "Done."

# Run production
echo "==> Running NanoAOD production..."
cmsRun  Run3Summer23BPixNanoAODv12-ggHiggsToEMu_cfg.py
echo "Done."

cd ../../

# Move all output data
echo "==> Moving all output files to directory data/..."
mkdir -p data/
mv CMSSW_*/src/Run3Summer23BPix*ggHiggsToEMu*.root data/
cd ../
echo "Done."

