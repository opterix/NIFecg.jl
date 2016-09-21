function Plotting(AECG,AECG_white,AECG_sort)

# --- Size of window to plot
win=seconds*1000

PyPlot.close("all")

figure(1)
for ind in 1:m
subplot("41$(ind)")
title("AECG data")
 plot(t[1:win], AECG[1:win,ind], color="red", linewidth=1.0, linestyle="-")
end

figure(2)
for ind in 1:k
  subplot("$(k)1$(ind)")
  title("ICA_white $k")
  plot(t[1:win], AECG_white[1:win,ind], color="black", linewidth=1.0, linestyle="-")
end

figure(3)
for ind in 1:k
  subplot("$(k)1$(ind)")
title("ICA_white")
plot(t[1:win], AECG_sort[1:win,ind], color="blue", linewidth=1.0, linestyle="-")
end

end
