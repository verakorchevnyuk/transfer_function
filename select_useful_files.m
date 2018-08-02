function [ data_mtx] = select_useful_files( excel_files, data )

for k = 1:numel(excel_files)
    for j = 1:size(data(k,:),2)
        data_mtx{k,j} = false;
        if ( is_word_in_the_sheet(data{k,j}, 'Courant') || is_word_in_the_sheet(data{k,j}, 'courant') )
            % where
            % data_mtx{k,j} = ( any(strcmp(data{k,j}(:),'Courant')) && (any(strcmp(data{k,j+1}(:),'Flux')) || any(strcmp(data{k,j+2}(:),'Flux')) ) );
            data_mtx{k,j} = logical( any(strcmp(data{k,j}(:),'Courant')) && (any(strcmp(data{k,j}(:),'Flux'))) );
        end
    end
end

end

