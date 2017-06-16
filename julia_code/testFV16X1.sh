#julia SVM_Model_Test_Wavelets.jl dim=X Cparam=Y Gamma=Z*(1/dim) 

#Lanzar de a 3 procesos!!
julia SVM_Model_Test_Wavelets.jl ../models/fetalmodelCh1_16_C0.1_gamma0.00625.jld > logs/res_exp1.txt &
julia SVM_Model_Test_Wavelets.jl ../models/fetalmodelCh1_16_C0.1_gamma0.0625.jld > logs/res_exp2.txt &
julia SVM_Model_Test_Wavelets.jl ../models/fetalmodelCh1_16_C0.1_gamma0.625.jld > logs/res_exp3.txt 
julia SVM_Model_Test_Wavelets.jl ../models/fetalmodelCh1_16_C1.0_gamma0.00625.jld > logs/res_exp4.txt &
julia SVM_Model_Test_Wavelets.jl ../models/fetalmodelCh1_16_C1.0_gamma0.0625.jld > logs/res_exp5.txt &
julia SVM_Model_Test_Wavelets.jl ../models/fetalmodelCh1_16_C1.0_gamma0.625.jld > logs/res_exp6.txt 
julia SVM_Model_Test_Wavelets.jl ../models/fetalmodelCh1_16_C10.0_gamma0.00625.jld > logs/res_exp7.txt &
julia SVM_Model_Test_Wavelets.jl ../models/fetalmodelCh1_16_C10.0_gamma0.0625.jld > logs/res_exp8.txt &
julia SVM_Model_Test_Wavelets.jl ../models/fetalmodelCh1_16_C10.0_gamma0.625.jld > logs/res_exp9.txt  
