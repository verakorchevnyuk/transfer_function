function [  ] = check_files( data_mtx, excelFiles )

tmp = cell2mat(data_mtx);
for j = 1:size(tmp,1)
    if (nnz(tmp(j,:)) == 0 )
        disp(['Please check the file: ' excelFiles(j).name])
    end   
end

end

