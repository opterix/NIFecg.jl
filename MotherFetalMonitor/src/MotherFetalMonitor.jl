VERSION >= v"0.1" && __precompile__()

module MotherFetalMonitor

#---------------------------------- LIBRARIES 
using Reexport

#------------------------------------ MODULES 
include("initialVarModule.jl")
include("loadDataModule.jl")
include("preProcessingModule.jl")
include("motherSubstractionModule.jl")
include("fetalSubstractionModule.jl")
include("storageVarModule.jl")
include("plotModule.jl")
include("runTest.jl")

@reexport using .initialVarModule
@reexport using .loadDataModule
@reexport using	.preProcessingModule
@reexport using	.motherSubstractionModule
@reexport using	.fetalSubstractionModule
@reexport using	.plotModule

#----------------------- ADDITIONAL FUNCTIONS
export sourceSeparationTest
#global nch,ns,t,sr,fetal_annot,AECG,AECG_clean,motherVar,fetalVar
#export nch,ns,t,sr,fetal_annot,AECG,AECG_clean,motherVar,fetalVar

end
