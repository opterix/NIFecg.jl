function smoothRR(FQRSdetections, nch, fs, flag)

	if flag == 1 # mother
		max_frr = 1*fs;
		min_frr = 0.55*fs;
	elseif flag == 2 #fetal 
		max_frr = 0.55*fs;
		min_frr = 0.35*fs;
	end

	smooth_FQRS = Array{Float64}[[],[],[],[]];

	for i in 1:nch

		medSamples=5
		conteo=medSamples

		auxFQRSdet = copy(FQRSdetections[i])*fs;
		
		while conteo<size(auxFQRSdet,1)-1
			med=median(diff(auxFQRSdet[conteo-medSamples+1:conteo]));
			#println(med);

			if med>min_frr && med<max_frr
				dTplus = auxFQRSdet[conteo+1]-auxFQRSdet[conteo]; #rr siguiente
				dTminus = auxFQRSdet[conteo]-auxFQRSdet[conteo-1]; #rr anterior

				if dTplus<0.7*med && dTminus<1.2*med
					#Extra detection
					#Eliminar detección
					deleteat!(auxFQRSdet, conteo+1);
					#println("QRS eliminado");
				elseif dTplus>1.75*med && dTminus>0.7*med
					#Pulso no detectado
					#usar la mediana del RR para insertar pulso no detectado
					missedFQRS= round(auxFQRSdet[conteo] + med);
					insert!(auxFQRSdet, conteo+1, missedFQRS);
					#println("QRS insertado");
				else
					#Detección normal
					conteo=conteo+1;
				end
			else
				#rr out of physiological range
				conteo = conteo+1;
			end
		end

		smooth_FQRS[i]=auxFQRSdet/fs;
		
	end

return smooth_FQRS;

end

