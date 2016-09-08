
a=readcsv("../data/a01.csv") #read file
b=a[3:end, 1] #Extract one channel information

f(x) = typeof(x)==Float64 #function to test if elements are float

bool_floats = broadcast(f,b)
bool_floats = convert(Array{Bool,1}, bool_floats) #Convert array to boolean appropiate for logical indexing
b[~bool_floats]=NaN #Convert all non-number strings to NaN
b=convert(Array{Float64,1}, b) #Convert to Float array
