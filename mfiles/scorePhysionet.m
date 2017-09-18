function [score,scoreAcum] = scorePhysionet(pathData)

    fileFolderList = dir([pathData,'/*.dat']);
    ind = 51;
    for i = ind : length(fileFolderList) 
        i
        pathFile = ([pathData,'/',fileFolderList(i).name(1:3)]);
        [annot] = tach(pathFile,'fqrs',[],[],12);
        [result] = tach(pathFile,'entry1',[],[],12);
        length(annot)
        length(result)

        [scoreAcum(i-ind+1,1)] = scoreRMSE(annot,result);
        
        if i == length(fileFolderList)
            score = mean(scoreAcum);
        end
     end

end

function [score] = scoreRMSE(annot,result)
    
    if length(annot) > length(result)
        result = vertcat(result, zeros((length(annot)-length(result)),1));
    end
    length(result)
    for i=1:length(annot)
        sdiff(i) = (annot(i)-result(i))^2;
    end
    score = (mean(sdiff))

end