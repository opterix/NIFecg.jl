function initialVarModule()

 #

motherVar = Dict([
("AECGm_ica",zeros(Array{Float64}(ns,nch))),
("SVDrec",zeros(Array{Float64}(ns,nch))),
("AECGm_sort",zeros(Array{Float64}(ns,nch))),
("AECG_residual",zeros(Array{Float64}(ns,nch))),
("AECG_residual",zeros(Array{Float64}(ns,nch))),
("heart_rate_mother",[]),
("QRSm_value",[]),
("QRSm_pos",[])
])


fetalVar = Dict([
("AECGm_ica",zeros(Array{Float64}(ns,nch))),
("SVDrec",zeros(Array{Float64}(ns,nch))),
("AECGm_sort",zeros(Array{Float64}(ns,nch))),
("AECG_residual",zeros(Array{Float64}(ns,nch))),
("AECG_residual",zeros(Array{Float64}(ns,nch))),
("heart_rate_mother",[]),
("QRSm_value",[]),
("QRSm_pos",[])
])


return motherVar, fetalVar

end


motherVar = Dict([
("AECGm_ica",zeros(Array{Float64}(ns,nch))),
("SVDrec",zeros(Array{Float64}(ns,nch))),
("AECGm_sort",zeros(Array{Float64}(ns,nch))),
("AECG_residual",zeros(Array{Float64}(ns,nch))),
("AECG_residual",zeros(Array{Float64}(ns,nch))),
("heart_rate_mother",[]),
("QRSm_value",[]),
("QRSm_pos",[])
])
