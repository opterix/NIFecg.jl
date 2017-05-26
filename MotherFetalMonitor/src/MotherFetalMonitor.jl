VERSION >= v"0.1" && __precompile__()

module MotherFetalMonitor

#---------------------------------- LIBRARIES 
using Reexport

#------------------------------------ MODULES 
include("loadDataModule.jl")
include("preProcessingModule.jl")
include("motherSubstractionModule.jl")
include("fetalSubstractionModule.jl")
include("plotModule.jl")

@reexport using .loadDataModule
@reexport using	.preProcessingModule
@reexport using	.motherSubstractionModule
@reexport using	.fetalSubstractionModule
@reexport using	.plotModule


#----------------------- ADDITIONAL FUNCTIONS
include("runTest.jl"); export sourceSeparationTest
include("groupVar.jl"); export groupVar

end
