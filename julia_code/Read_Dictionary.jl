#### Leo los diccionarios generados para la descomposición Wavelet


## Recursos ##

data_dictio="../Dictionaries"
list_file=readdir(data_dictio)
num_files=size(list_file,1);
B=load("$(data_dictio)/$(list_file[1])");

Mat_To_Wavelet_Pos=B["pos_examples"];
Mat_To_Wavelet_Neg=B["neg_examples"];

for i in 2:num_files
    file_name = list_file[i];
    println("Procesando Dictionary $(file_name)")
    d = load("$(data_dictio)/$(file_name)")
    Mat_To_Wavelet_Pos=vcat(Mat_To_Wavelet_Pos,d["pos_examples"]);
    Mat_To_Wavelet_Neg=vcat(Mat_To_Wavelet_Neg,d["neg_examples"]);
end
