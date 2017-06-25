#julia RF_Model_Test_Wavelets.jl dim=X Cparam=Y NTrees=Z*(1/dim) 

#Lanzar de a 3 procesos!!
julia RF_Model_Test_Wavelets.jl ../models/RFmodel_Ch1_16_randFeats4_nTrees10_dwt_levels5.jld > logs/resRF_dwt5_exp1.txt &
julia RF_Model_Test_Wavelets.jl ../models/RFmodel_Ch1_16_randFeats4_nTrees50_dwt_levels5.jld > logs/resRF_dwt5_exp2.txt &
julia RF_Model_Test_Wavelets.jl ../models/RFmodel_Ch1_16_randFeats4_nTrees150_dwt_levels5.jld > logs/resRF_dwt5_exp3.txt 
julia RF_Model_Test_Wavelets.jl ../models/RFmodel_Ch1_16_randFeats4_nTrees10_dwt_levels6.jld > logs/resRF_dwt6_exp1.txt &
julia RF_Model_Test_Wavelets.jl ../models/RFmodel_Ch1_16_randFeats4_nTrees50_dwt_levels6.jld > logs/resRF_dwt6_exp2.txt &
julia RF_Model_Test_Wavelets.jl ../models/RFmodel_Ch1_16_randFeats4_nTrees150_dwt_levels6.jld > logs/resRF_dwt6_exp3.txt 
julia RF_Model_Test_Wavelets.jl ../models/RFmodel_Ch1_16_randFeats4_nTrees10_dwt_levels7.jld > logs/resRF_dwt7_exp1.txt &
julia RF_Model_Test_Wavelets.jl ../models/RFmodel_Ch1_16_randFeats4_nTrees50_dwt_levels7.jld > logs/resRF_dwt7_exp2.txt &
julia RF_Model_Test_Wavelets.jl ../models/RFmodel_Ch1_16_randFeats4_nTrees150_dwt_levels7.jld > logs/resRF_dwt7_exp3.txt  
