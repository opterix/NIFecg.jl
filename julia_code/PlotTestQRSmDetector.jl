function PlotTestQRSmDetector(test_path,file_name,QRSm_pos,QRSm_value,t,AECG_white)

PyPlot.close("all")

figure(1)
     title("$(file_name) Test QRSm detector (samples:$(num_sample))")#-Heart rate: $(heart_rate_mother[i])")
     plot(QRSm_pos[:,1]',QRSm_value[:,1]', "ro")
     plot(t[1:num_sample], AECG_white[1:num_sample,1], color="black", linewidth=1.0, linestyle="-")
     savefig("$(test_path)$(file_name)_full.png")

end
