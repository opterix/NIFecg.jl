#julia RF_Model_Test_Wavelets.jl dim=X Cparam=Y NTrees=Z*(1/dim) 

julia RF_Model_Test_WaveletsX4.jl ../models/RFmodelX4_Ch1_16_randFeats4_nTrees10_dwt_levels5.jls > logs/resRFX4_dwt5_exp1.txt &

julia RF_Model_Test_WaveletsX4.jl ../models/RFmodelX4_Ch1_16_randFeats4_nTrees10_dwt_levels6.jls > logs/resRFX4_dwt6_exp1.txt &

julia RF_Model_Test_WaveletsX4.jl ../models/RFmodelX4_Ch1_16_randFeats4_nTrees10_dwt_levels7.jls > logs/resRFX4_dwt7_exp1.txt &
