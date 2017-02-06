
include("Main.jl");

global nch,AECG,ns,t,sr,AECG_clean,QRSm_pos,QRSm_value,QRSf_pos,QRSf_value,AECG_white,fetal_annot,AECGf2,QRSfcell_pos,QRSfcell_value,heart_rate_mother,heart_rate_feto,AECGm;
data_path="../data"
list_file=readdir(data_path)
num_files=size(list_file,1)

for i in 1:num_files
#for i in 19:19
file_name = list_file[i]
file_name = file_name[1:end-4]
println("Procesando Imagen $(file_name)")
(nch,AECG,ns,t,sr,AECG_clean,QRSm_pos,QRSm_value,QRSf_pos,QRSf_value,AECG_white,fetal_annot,AECGf2,QRSfcell_pos,QRSfcell_value,heart_rate_mother,heart_rate_feto,AECGm)=process_fetal(file_name);


#Plotting([2])
#manager = get_current_fig_manager()
#manager[:window][:attributes]("-zoomed", 1)
#sleep(1)
#manager[:window][:attributes]("-zoomed", 2)
#savefig("../test_image/$(file_name)_fig$(2).png") 

#Plotting([3])
#manager = get_current_fig_manager()
#manager[:window][:attributes]("-zoomed", 1)
#sleep(1)
#manager[:window][:attributes]("-zoomed", 2)
#savefig("../test_image/$(file_name)_fig$(3).png") 



Plotting([5])
manager = get_current_fig_manager()
manager[:window][:attributes]("-zoomed", 1)
sleep(1)
manager[:window][:attributes]("-zoomed", 2)
savefig("../test_image/$(file_name)_fig$(5).png") 




Plotting([6])
manager = get_current_fig_manager()
manager[:window][:attributes]("-zoomed", 1)
sleep(1)
manager[:window][:attributes]("-zoomed", 2)
savefig("../test_image/$(file_name)_fig$(6).png") 


Plotting([7])
manager = get_current_fig_manager()
manager[:window][:attributes]("-zoomed", 1)
sleep(1)
manager[:window][:attributes]("-zoomed", 2)
savefig("../test_image/$(file_name)_fig$(7).png") 

Plotting([5 6 8])
manager = get_current_fig_manager()
manager[:window][:attributes]("-zoomed", 1)
sleep(1)
manager[:window][:attributes]("-zoomed", 2)
savefig("../test_image/$(file_name)_fig$(8).png") 



end



