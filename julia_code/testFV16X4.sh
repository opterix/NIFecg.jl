#julia SVM_Model_Test_Wavelets.jl dim=X Cparam=Y Gamma=Z*(1/dim) 

#Lanzar de a 3 procesos!!
julia SVM_Model_Test_WaveletsX4.jl ../models/LIBSVM_fetalmodelX4_16_C0.1_gamma0.00625.jld > logs/resX4_exp1.txt &
julia SVM_Model_Test_WaveletsX4.jl ../models/LIBSVM_fetalmodelX4_16_C0.1_gamma0.0625.jld > logs/resX4_exp2.txt &
julia SVM_Model_Test_WaveletsX4.jl ../models/LIBSVM_fetalmodelX4_16_C0.1_gamma0.625.jld > logs/resX4_exp3.txt 
julia SVM_Model_Test_WaveletsX4.jl ../models/LIBSVM_fetalmodelX4_16_C1.0_gamma0.00625.jld > logs/resX4_exp4.txt &
julia SVM_Model_Test_WaveletsX4.jl ../models/LIBSVM_fetalmodelX4_16_C1.0_gamma0.0625.jld > logs/resX4_exp5.txt &
julia SVM_Model_Test_WaveletsX4.jl ../models/LIBSVM_fetalmodelX4_16_C1.0_gamma0.625.jld > logs/resX4_exp6.txt 
julia SVM_Model_Test_WaveletsX4.jl ../models/LIBSVM_fetalmodelX4_16_C10.0_gamma0.00625.jld > logs/resX4_exp7.txt &
julia SVM_Model_Test_WaveletsX4.jl ../models/LIBSVM_fetalmodelX4_16_C10.0_gamma0.0625.jld > logs/resX4_exp8.txt &
julia SVM_Model_Test_WaveletsX4.jl ../models/LIBSVM_fetalmodelX4_16_C10.0_gamma0.625.jld > logs/resX4_exp9.txt  
