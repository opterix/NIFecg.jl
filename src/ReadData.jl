function ReadData()

  for j in 1:4
    for i in 1:1:n
      #println(i)
       if length(data[i+1,j+1]) > 2
         AECG[i,j] = float64(data[i+1,j+1])
       else
         AECG[i,j] = float64("0")
       end

    end
  end
  return AECG
end
