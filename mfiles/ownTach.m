function [heart_rate] = ownTach(array)
    acum = 0;
    for i = 5:5:60
        acum = acum+1;
        idx = find(array > ((i-5)*1000) & array <= (i*1000));
        heart_rate(acum,1) = (60*length(idx))/5;   
    end
end