#julia SVM_Model_Train_Wavelets.jl dim=X Cparam=Y Gamma=Z*(1/dim) 

julia SVM_Model_Train_Wavelets.jl 16 0.1 0.1 7 > logs/log_dwt7_exp1.txt &
julia SVM_Model_Train_Wavelets.jl 16 0.1 1 7 > logs/log_dwt7_exp2.txt &
julia SVM_Model_Train_Wavelets.jl 16 0.1 10 7 > logs/log_dwt7_exp3.txt
  
julia SVM_Model_Train_Wavelets.jl 16 1 0.1 7 > logs/log_dwt7_exp4.txt &
julia SVM_Model_Train_Wavelets.jl 16 1 1 7 > logs/log_dwt7_exp5.txt &
julia SVM_Model_Train_Wavelets.jl 16 1 10 7 > logs/log_dwt7_exp6.txt 

julia SVM_Model_Train_Wavelets.jl 16 10 0.1 7 > logs/log_dwt7_exp7.txt &  
julia SVM_Model_Train_Wavelets.jl 16 10 1 7 > logs/log_dwt7_exp8.txt &
julia SVM_Model_Train_Wavelets.jl 16 10 10 7 > logs/log_dwt7_exp9.txt  
