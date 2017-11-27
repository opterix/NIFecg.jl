VERSION >= v"0.1" && __precompile__()

module NIFecg # Non Invasive Fetal electrocardiogram

	#---------------------------------- LIBRARIES 
	using Reexport
	using PyPlot

	#------------------------------------ MODULES 
	include("loadDataModule.jl")
	include("preProcessingModule.jl")
	include("motherSubstractionModule.jl")
	include("fetalSubstractionModule.jl")
	
	@reexport using .loadDataModule
	@reexport using	.preProcessingModule
	@reexport using	.motherSubstractionModule
	@reexport using	.fetalSubstractionModule

	#----------------------- ADDITIONAL FUNCTIONS
	include("test/runTest.jl"); export MFMTest
	include("test/runTestDataBase.jl"); export MFMTestDB
	include("test/runTestDBPlot.jl"); export MFMTestDBPlot
	include("test/runTestWindow.jl"); export MFMTestWindow
	include("test/runToJavascript.jl"); export MFMJavascript
	include("share/divideSignal.jl"); export divideSignal	
	include("share/loadDataWindow.jl"); export loadDataWindow
	include("share/concatVar.jl"); export concatVar
	include("share/initializationAcum.jl"); export initializationAcum
	include("share/initConcatVar.jl"); export initConcatVar
	include("share/plotData.jl"); export plotData
	include("share/groupVar.jl"); export groupVar

end
