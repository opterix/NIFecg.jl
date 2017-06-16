#julia SVM_Model_Train_Wavelets.jl dim=X Cparam=Y Gamma=Z*(1/dim) 

julia SVM_Model_Train_Wavelets.jl 32 0.1 0.1 > logs/log32_exp1.txt &
julia SVM_Model_Train_Wavelets.jl 32 0.1 1 > logs/log32_exp2.txt &
julia SVM_Model_Train_Wavelets.jl 32 0.1 10 > logs/log32_exp3.txt &

julia SVM_Model_Train_Wavelets.jl 32 1 0.1 > logs/log32_exp4.txt &
julia SVM_Model_Train_Wavelets.jl 32 1 1 > logs/log32_exp5.txt &
julia SVM_Model_Train_Wavelets.jl 32 1 10 > logs/log32_exp6.txt &

julia SVM_Model_Train_Wavelets.jl 32 10 0.1 > logs/log32_exp7.txt &  
julia SVM_Model_Train_Wavelets.jl 32 10 1 > logs/log32_exp8.txt &
julia SVM_Model_Train_Wavelets.jl 32 10 10 > logs/log32_exp9.txt & 
