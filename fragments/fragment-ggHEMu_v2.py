import FWCore.ParameterSet.Config as cms

externalLHEProducer = cms.EDProducer("ExternalLHEProducer",
    args = cms.vstring('/cvmfs/cms.cern.ch/phys_generator/gridpacks/slc7_amd64_gcc700/13p6TeV/powheg/V2/gg_H/gg_H_quark-mass-effects_slc7_amd64_gcc700_CMSSW_10_6_0_gg_H_quark-mass-effects.tgz'),
    nEvents = cms.untracked.uint32(5000),
    numberOfParameters = cms.uint32(1),
    outputFile = cms.string('cmsgrid_final.lhe'),
    scriptName = cms.FileInPath('GeneratorInterface/LHEInterface/data/run_generic_tarball_cvmfs.sh'),
    generateConcurrently = cms.untracked.bool(True)
)


import FWCore.ParameterSet.Config as cms
from Configuration.Generator.Pythia8CommonSettings_cfi import *
from Configuration.Generator.MCTunesRun3ECM13p6TeV.PythiaCP5Settings_cfi import *
from Configuration.Generator.Pythia8PowhegEmissionVetoSettings_cfi import *
from Configuration.Generator.PSweightsPythia.PythiaPSweightsSettings_cfi import *

generator = cms.EDFilter("Pythia8ConcurrentHadronizerFilter",
                       	comEnergy = cms.double(13600.0),
                       	filterEfficiency = cms.untracked.double(1),
                       	maxEventsToPrint = cms.untracked.int32(1),
                       	pythiaHepMCVerbosity = cms.untracked.bool(False),
                       	pythiaPylistVerbosity = cms.untracked.int32(1),
                       	PythiaParameters = cms.PSet(
      					    pythia8CommonSettingsBlock,
                            pythia8CP5SettingsBlock,
					        pythia8PowhegEmissionVetoSettingsBlock, 
                            pythia8PSweightsSettingsBlock,
      					    processParameters = cms.vstring(
                                'POWHEG:nFinal = 1',                            
          					    '25:m0 = 125.0',
          					    '25:addChannel 1 0.1 100 11 -13',
          					    '25:addChannel 1 0.1 100 13 -11',
          					    '25:onMode = off',
          					    '25:onIfMatch 11 13'
          					    ),
      					    parameterSets = cms.vstring(
                          		'pythia8PowhegEmissionVetoSettings',
                            	'pythia8CommonSettings',
                                'pythia8CP5Settings',
                                'pythia8PSweightsSettings',
                            	'processParameters',
                            	)
      					)
)

ProductionFilterSequence = cms.Sequence(generator)
