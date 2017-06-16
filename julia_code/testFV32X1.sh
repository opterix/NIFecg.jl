#julia SVM_Model_Test_Wavelets.jl dim=X Cparam=Y Gamma=Z*(1/dim) 

#Lanzar de a 3 procesos!!
julia SVM_Model_Test_Wavelets.jl ../models/fetalmodelCh1_32_C0.1_gamma0.003125.jld > logs/res32_exp1.txt &
julia SVM_Model_Test_Wavelets.jl ../models/fetalmodelCh1_32_C0.1_gamma0.03125.jld > logs/res32_exp2.txt &
julia SVM_Model_Test_Wavelets.jl ../models/fetalmodelCh1_32_C0.1_gamma0.3125.jld > logs/res32_exp3.txt 
julia SVM_Model_Test_Wavelets.jl ../models/fetalmodelCh1_32_C1.0_gamma0.003125.jld > logs/res32_exp4.txt &
julia SVM_Model_Test_Wavelets.jl ../models/fetalmodelCh1_32_C1.0_gamma0.03125.jld > logs/res32_exp5.txt &
julia SVM_Model_Test_Wavelets.jl ../models/fetalmodelCh1_32_C1.0_gamma0.3125.jld > logs/res32_exp6.txt 
julia SVM_Model_Test_Wavelets.jl ../models/fetalmodelCh1_32_C10.0_gamma0.003125.jld > logs/res32_exp7.txt &
julia SVM_Model_Test_Wavelets.jl ../models/fetalmodelCh1_32_C10.0_gamma0.03125.jld > logs/res32_exp8.txt &
julia SVM_Model_Test_Wavelets.jl ../models/fetalmodelCh1_32_C10.0_gamma0.3125.jld > logs/res32_exp9.txt  
