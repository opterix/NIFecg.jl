#julia SVM_Model_Train_Wavelets.jl dim=X Cparam=Y Gamma=Z*(1/dim) 

julia SVM_Model_Train_Wavelets.jl 16 0.1 0.1 5 > logs/log_dwt5_exp1.txt &
julia SVM_Model_Train_Wavelets.jl 16 0.1 1 5 > logs/log_dwt5_exp2.txt &
julia SVM_Model_Train_Wavelets.jl 16 0.1 10 5 > logs/log_dwt5_exp3.txt &

julia SVM_Model_Train_Wavelets.jl 16 1 0.1 5 > logs/log_dwt5_exp4.txt &
julia SVM_Model_Train_Wavelets.jl 16 1 1 5 > logs/log_dwt5_exp5.txt &
julia SVM_Model_Train_Wavelets.jl 16 1 10 5 > logs/log_dwt5_exp6.txt &

julia SVM_Model_Train_Wavelets.jl 16 10 0.1 5 > logs/log_dwt5_exp7.txt &  
julia SVM_Model_Train_Wavelets.jl 16 10 1 5 > logs/log_dwt5_exp8.txt &
julia SVM_Model_Train_Wavelets.jl 16 10 10 5 > logs/log_dwt5_exp9.txt & 
