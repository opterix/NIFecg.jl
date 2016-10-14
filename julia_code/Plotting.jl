function Plotting()


PyPlot.close("all")

figure(1)
for i in 1:m
subplot("41$(i)")
if i == 1 title("AECG data") end
 plot(t[1:num_sample], AECG[1:num_sample,i], color="red", linewidth=1.0, linestyle="-")
end
figure(2)
for i in 1:m
subplot("41$(i)")
if i == 1 title("AECG notch") end
 plot(t[1:num_sample], AECG_fnotch[1:num_sample,i], color="red", linewidth=1.0, linestyle="-")
end

figure(3)
for i in 1:m
subplot("41$(i)")
if i == 1 title("AECG clean") end
 plot(t[1:num_sample], AECG_clean[1:num_sample,i], color="red", linewidth=1.0, linestyle="-")
end

 figure(4)
 for i in 1:k
   subplot("$(k)1$(i)")
   if i == 1
     title("ICA_white")
     plot(QRSm_pos[:,1]',QRSm_value[:,1]', "ro")
     #plot(QRSm_pos[2,:]',QRSm_value[2,:]', "bo")
   end
   plot(t[1:num_sample], AECG_white[1:num_sample,i], color="black", linewidth=1.0, linestyle="-")
 end

# figure(4)
# for i in 1:k
#   subplot("$(k)1$(i)")
# if i == 1 title("ICA_sort") end
# plot(t[1:num_sample], AECG_sort[1:num_sample,i], color="blue", linewidth=1.0, linestyle="-")
# end
#
 end
