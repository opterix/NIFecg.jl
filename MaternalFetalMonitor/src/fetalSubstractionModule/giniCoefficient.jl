function giniCoefficient(in_array)
    # Compute the gini coefficient for an array

    #Convert to 1D array
    in_array=vec(in_array);

    #Only positive values
    in_array=abs(in_array);

    #Adding small float number to avoid zero division
    in_array=in_array+eps();
    in_array=sort(in_array);
    idx=collect(1:length(in_array));

    n=length(in_array)

    #print(sum((2*idx-n-1).*in_array)/(n*sum(in_array)))
    
    return sum((2*idx-n-1).*in_array)/(n*sum(in_array))
    
end
