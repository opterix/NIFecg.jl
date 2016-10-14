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

signal = AECG_fnotch[1:num_sample,i]

medline=[median(signal),median(signal)]
tmedline=[1,t[num_sample]]
plot(tmedline[:],medline[:], color="black", linewidth=2.0, linestyle="-")


difference = abs(signal - median(signal))
median_difference = median(difference)

medline1 = medline .+ median_difference; 
medline2 = medline .- median_difference 
plot(tmedline[:],medline1[:], color="black", linewidth=1.0, linestyle="--")
plot(tmedline[:],medline2[:], color="black", linewidth=1.0, linestyle="--")


s =  (difference / float(median_difference))
plot(t[1:num_sample],s[1:num_sample], "bo", linewidth=1.0)


median_s =  [median(s),median(s)]
plot(tmedline[:],median_s[:], color="yellow", linewidth=1.0, linestyle="-")

max,pos = findmax(s)
println(max)
println(pos)
plot(pos/1000,max, "yo")
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
