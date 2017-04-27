function plotModule(graph=0)
#  0  - all
# [1] - AECG
# [2] - AECG_clean
# [3] - AECG_white with QRSm_pos
# [4] - SVDrec
# [5] - AECGm
# [6] - AECGf
# [7] - AECGf with QRSf_pos, AECG_white and QRSm_pos
# diff number - none plot
# diff compositions [1 3 4] or [3 5 6], as you wish

close("all")

if findfirst(graph,1) != 0 || findfirst(graph,0) != 0
figure(1)
for i in 1:nch
subplot("$(nch)1$(i)")
#if i == 1 title("AECG data") end
    plot(t[1:ns], AECG[1:ns,i], color="black", linewidth=1.0, linestyle="-")
    title("Original signals")
end
end

#-----------------------------------------------

if findfirst(graph,2) != 0 || findfirst(graph,0) != 0
    figure(2)

#    a=collect(-999.9:0.2:999.9)/2;  #Solamente funciona en ventanas de 10segundos
    
    for i in 1:nch
        #subplot("42$(2*i-1)")
        subplot("$(nch)1$(i)")
#if i == 1 title("AECG clean") end
        plot(t[1:ns], AECG_clean[1:ns,i], color="black", linewidth=1.0, linestyle="-")
        title("Filtered signals")

#        subplot("42$(2*i)")
#
 #       plot(a,abs(fftshift(fft(AECG_clean[1:ns,i]))), color="black", linewidth=1.0, linestyle="-")
        #plot(a, angle(fftshift))
 #       xlim(0, 100);
        
end
end

#-----------------------------------------------

if findfirst(graph,3) != 0 || findfirst(graph,0) != 0
figure(3)
for i in 1:nch
   subplot("$(nch)1$(i)")
   plot(t[1:ns], AECGm_ica[1:ns,i], color="black", linewidth=1.0, linestyle="-")
   plot(QRSm_pos[:,1]',zeros(size(QRSm_pos,1),1)', "ro")#plot(QRSm_pos[:,1]',QRSm_value[:,1]', "ro")
       title("First ICA")
end
end

#-----------------------------------------------

if findfirst(graph,4) != 0 || findfirst(graph,0) != 0
    figure(4)


    
for i in 1:nch
   subplot("41$(i)")
#if i == 1 title("SVD reconstruction") end
    #plot(t[1:ns], SVDrec[1:ns,i], color="black", linewidth=1.0, linestyle="-")
    
    plot(t[1:ns], AECG_residual[1:ns,i], color="black", linewidth=1.0, linestyle="-")
    plot(fetal_annot/sr,zeros(size(fetal_annot,1)),"go") 

    title("residual signals")
end
end

#-----------------------------------------------

if findfirst(graph,5) != 0 || findfirst(graph,0) != 0
    figure(5)

    a=collect(-999.9:0.2:999.9)/2;  #Solamente funciona en ventanas de 10segundos

    for i in 1:nch
           subplot("42$(2*i-1)")
        #if i == 1 title("AECG feto (after ICA-sorted)") end
     

    plot(a,abs(fftshift(fft(AECG_residual[1:ns,i]))), color="black", linewidth=1.0, linestyle="-")
    #plot(a, angle(fftshift))
    xlim(0, 100);

subplot("42$(2*i)")

#   subplot("41$(i)")
#if i == 1 title("AECG subtract SVD reconstruction") end
        plot(t[1:ns], AECG_residual[1:ns,i], color="black", linewidth=1.0, linestyle="-")
        plot(fetal_annot/sr,zeros(size(fetal_annot,1)),"go") 
    title("Residuals signals")
end
end

#-----------------------------------------------
if findfirst(graph,6) != 0 || findfirst(graph,0) != 0
    figure(6)

for i in 1:nch
subplot("42$(2*i-1)")

    plot(t[1:ns], AECGf_sort[1:ns,i], color="black", linewidth=1.0, linestyle="-")
    plot(fetal_annot/sr,zeros(size(fetal_annot,1)),"go")
    plot(QRSfcell_pos_smooth[i], zeros(size(QRSfcell_pos_smooth[i],1),1), "ro")
    title("Sorted Second ICA signals. SMI=$(SMI[i]). gini=$(giniMeasure[i])")

subplot("42$(2*i)")

    plot(t[1:ns], AECGf_sort[1:ns,i], color="black", linewidth=1.0, linestyle="-")
    plot(fetal_annot/sr,zeros(size(fetal_annot,1)),"go")
    plot(QRSfcell_pos[i]',QRSfcell_value[i]', "ro")
    title("Sorted Second ICA signals")
end
end

#-----------------------------------------------
if findfirst(graph,7) != 0 || findfirst(graph,0) != 0

figure(7)
subplot(211)
title("Ritmo cardíaco materno = $(heart_rate_mother)")
plot(t[1:ns], AECGm_sort[1:ns,1], color="black", 
linewidth=1.0, linestyle="-")
plot(QRSm_pos[:,1]',zeros(size(QRSm_pos,1),1)', "ro")
subplot(212)
title("Ritmo cardíaco fetal = $(heart_rate_feto)")
    #plot(QRSf_pos[:,1]',QRSf_value[:,1]', "bo")

    
plot(t[1:ns], AECGf_sort[1:ns,1], color="black", linewidth=1.0, linestyle="-")
     

   plot(fetal_annot/sr,zeros(size(fetal_annot,1)),"go")
   plot(QRSf_pos[:,1], zeros(size(QRSf_pos[:,1],1),1)+0.5, "bo")

end




end


