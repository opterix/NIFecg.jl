function Plotting(AECG,AECG_white,AECG_sort)

# --- Size of window to plot
win=10000

PyPlot.close("all")

figure(1)

subplot(411)
title("AECG data")
 plot(t[1:win], AECG[1:win,1], color="red", linewidth=1.0, linestyle="-")
subplot(412)
 plot(t[1:win], AECG[1:win,2], color="red", linewidth=1.0, linestyle="-")
subplot(413)
 plot(t[1:win], AECG[1:win,3], color="red", linewidth=1.0, linestyle="-")
subplot(414)
 plot(t[1:win], AECG[1:win,4], color="red", linewidth=1.0, linestyle="-")

figure(2)

subplot(411)
title("ICA_white")
plot(t[1:win], AECG_white[1:win,1], color="red", linewidth=1.0, linestyle="-")
subplot(412)
plot(t[1:win], AECG_white[1:win,2], color="black", linewidth=1.0, linestyle="-")
subplot(413)
plot(t[1:win], AECG_white[1:win,3], color="blue", linewidth=1.0, linestyle="-")
subplot(414)
plot(t[1:win], AECG_white[1:win,4], color="blue", linewidth=1.0, linestyle="-")

figure(3)

subplot(411)
title("ICA_sort")
plot(t[1:win], AECG_sort[1:win,1], color="red", linewidth=1.0, linestyle="-")
subplot(412)
plot(t[1:win], AECG_sort[1:win,2], color="black", linewidth=1.0, linestyle="-")
subplot(413)
plot(t[1:win], AECG_sort[1:win,3], color="blue", linewidth=1.0, linestyle="-")
subplot(414)
plot(t[1:win], AECG_sort[1:win,4], color="blue", linewidth=1.0, linestyle="-")

end
