include("main.jl");
include("saveResults.jl");

data_path="../data"
list_file=readdir(data_path)
num_files=size(list_file,1)

for i in 1:num_files
	file_name = list_file[i]
	file_name = file_name[1:end-4]
	println("Procesando record $(file_name)")
	(nch,ns,t,sr,fetal_annot,AECG,AECG_clean,
AECGm_ica,AECGm_sort,AECG_residual,QRSm_pos,QRSm_value,heart_rate_mother,SVDrec,
AECGf_sort,QRSf_pos,QRSf_value,QRSfcell_pos,QRSfcell_value,heart_rate_feto, QRSfcell_pos_smooth, SMI, gini_measure)=sourceSeparationECG(file_name);

saveResults(file_name,QRSf_pos)
end
