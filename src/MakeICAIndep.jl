function MakeICAIndep(AECG)

  AECG=AECG'
  for ii in 1:4
  println(ii)
  mv = vec(mean(AECG[ii,:],2))
  @assert size(AECG[ii,:]) == (m, n)
  if VERSION < v"0.5.0-dev+660"
      C = cov(AECG[ii,:]; vardim=2)
  else
      C = cov(AECG[ii,:], 2)
  end

  # FastICA

  M = fit(ICA, AECG[ii,:], k; do_whiten=false)
  @test isa(M, ICA)
  @test indim(M) == m
  @test outdim(M) == k
  @test mean(M) == mv
  W = M.W
  @test_approx_eq transform(M, AECG[ii,:]) W' * (AECG[ii,:] .- mv)
  @test_approx_eq W'W eye(k)
  AECG_nowhite[ii,:] = W'*AECG[ii,:]

  M = fit(ICA, AECG[ii,:], k; do_whiten=true)
  @test isa(M, ICA)
  @test indim(M) == m
  @test outdim(M) == k
  @test mean(M) == mv
  W = M.W
  @test_approx_eq W'C * W eye(k)
  AECG_white[ii,:] = W'*AECG[ii,:]
end

  win=10000
  figure(1)

  subplot(411)
  title("AECG NO WHITE")
   plot(t[1:win], AECG[1,1:win]', color="red", linewidth=1.0, linestyle="-")
   plot(t[1:win], AECG_nowhite[1,1:win]', color="black", linewidth=1.0, linestyle="-")

   subplot(412)
   plot(t[1:win], AECG[2,1:win]', color="red", linewidth=1.0, linestyle="-")
   plot(t[1:win], AECG_nowhite[2,1:win]', color="black", linewidth=1.0, linestyle="-")

   subplot(413)
   plot(t[1:win], AECG[3,1:win]', color="red", linewidth=1.0, linestyle="-")
   plot(t[1:win], AECG_nowhite[3,1:win]', color="black", linewidth=1.0, linestyle="-")

   subplot(414)
  plot(t[1:win], AECG[4,1:win]', color="red", linewidth=1.0, linestyle="-")
  plot(t[1:win], AECG_nowhite[4,1:win]', color="black", linewidth=1.0, linestyle="-")


   figure(2)

   subplot(411)
   title("AECG WHITE")
    plot(t[1:win], AECG[1,1:win]', color="red", linewidth=1.0, linestyle="-")
    plot(t[1:win], AECG_white[1,1:win]', color="black", linewidth=1.0, linestyle="-")

   subplot(412)
  plot(t[1:win], AECG[2,1:win]', color="red", linewidth=1.0, linestyle="-")
  plot(t[1:win], AECG_white[2,1:win]', color="black", linewidth=1.0, linestyle="-")

   subplot(413)
    plot(t[1:win], AECG[3,1:win]', color="red", linewidth=1.0, linestyle="-")
   plot(t[1:win], AECG_white[3,1:win]', color="black", linewidth=1.0, linestyle="-")

   subplot(414)
    plot(t[1:win], AECG[4,1:win]', color="red", linewidth=1.0, linestyle="-")
   plot(t[1:win], AECG_white[4,1:win]', color="black", linewidth=1.0, linestyle="-")

  return AECG_white, AECG_nowhite

end
