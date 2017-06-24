#julia SVM_Model_Test_Wavelets.jl dim=X Cparam=Y Gamma=Z*(1/dim) 

#Lanzar de a 3 procesos!!
julia SVM_Model_Test_Wavelets.jl ../models/fetalmodelCh1_16_C0.1_gamma0.00625_dwt_levels7.jld > logs/res_dwt7_exp1.txt &
julia SVM_Model_Test_Wavelets.jl ../models/fetalmodelCh1_16_C0.1_gamma0.0625_dwt_levels7.jld > logs/res_dwt7_exp2.txt &
julia SVM_Model_Test_Wavelets.jl ../models/fetalmodelCh1_16_C0.1_gamma0.625_dwt_levels7.jld > logs/res_dwt7_exp3.txt 
julia SVM_Model_Test_Wavelets.jl ../models/fetalmodelCh1_16_C1.0_gamma0.00625_dwt_levels7.jld > logs/res_dwt7_exp4.txt &
julia SVM_Model_Test_Wavelets.jl ../models/fetalmodelCh1_16_C1.0_gamma0.0625_dwt_levels7.jld > logs/res_dwt7_exp5.txt &
julia SVM_Model_Test_Wavelets.jl ../models/fetalmodelCh1_16_C1.0_gamma0.625_dwt_levels7.jld > logs/res_dwt7_exp6.txt 
julia SVM_Model_Test_Wavelets.jl ../models/fetalmodelCh1_16_C10.0_gamma0.00625_dwt_levels7.jld > logs/res_dwt7_exp7.txt &
julia SVM_Model_Test_Wavelets.jl ../models/fetalmodelCh1_16_C10.0_gamma0.0625_dwt_levels7.jld > logs/res_dwt7_exp8.txt &
julia SVM_Model_Test_Wavelets.jl ../models/fetalmodelCh1_16_C10.0_gamma0.625_dwt_levels7.jld > logs/res_dwt7_exp9.txt  
