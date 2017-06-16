#julia SVM_Model_Train_WaveletsX4.jl dim=X Cparam=Y Gamma=Z*(1/dim) 

julia SVM_Model_Train_WaveletsX4.jl 16 0.1 0.1 > logs/logX4_exp1.txt &
julia SVM_Model_Train_WaveletsX4.jl 16 0.1 1 > logs/logX4_exp2.txt &
julia SVM_Model_Train_WaveletsX4.jl 16 0.1 10 > logs/logX4_exp3.txt &

julia SVM_Model_Train_WaveletsX4.jl 16 1 0.1 > logs/logX4_exp4.txt &
julia SVM_Model_Train_WaveletsX4.jl 16 1 1 > logs/logX4_exp5.txt &
julia SVM_Model_Train_WaveletsX4.jl 16 1 10 > logs/logX4_exp6.txt &

julia SVM_Model_Train_WaveletsX4.jl 16 10 0.1 > logs/logX4_exp7.txt &  
julia SVM_Model_Train_WaveletsX4.jl 16 10 1 > logs/logX4_exp8.txt &
julia SVM_Model_Train_WaveletsX4.jl 16 10 10 > logs/logX4_exp9.txt & 
