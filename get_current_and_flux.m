function [Current, Flux] = get_current_and_flux( excelFiles, data, data_mtx )

Current = [] ;
Flux = [] ;

% string_contains_numeric = @(S) ~isnan(str2double(S));

% for k = 1:numel(excelFiles)
%     tmp = [excelFiles(k).folder  '\' excelFiles(k).name];
%     [~,sheetName]=xlsfinfo(tmp);
%     for j = 1:numel(sheetName)
%         if data_mtx{k,j} == 1
%             for a = 1:size(data{k,j},1)
%                 for b = 1:size(data{k,j},2)
%                     % search for 'Courant'
%                     if ( is_word_in_the_sheet( data{k,j}(a,b), 'Courant' ) )
%                         % concatenate to Current, the 5 rows below
%                         Current = [ Current; data{k,j}(a+1:a+5,b) ];
%                     end
%                     if ( strcmp(data{k,j}(a,b),'Flux') == 1 )
%                         % concatenate to Flux, the 5 rows below
%                         Flux = [ Flux; data{k,j}(a+1:a+5,b) ];
%                     end
%                 end
%             end
%         end
%     end
% end

clear tmp
aux = true ;
for k = 1:numel(excelFiles)
    tmp = [excelFiles(k).folder  '\' excelFiles(k).name];
    [~,sheetName]=xlsfinfo(tmp);
    aux = true ;
    for j = 1:numel(sheetName)
        % and(is_word_in_the_sheet(excelFiles(k),'Courant'), is_word_in_the_sheet(excelFiles(k),'Flux'))
        if( data_mtx{k,j} )
            for a = 1:size(data{k,j},1)
                for b = 1:size(data{k,j},2)-2
                    %and( strcmp(data{k,j}(a,b),'Courant'), or( strcmp(data{k,j}(a,b+1),'Flux'), strcmp(data{k,j}(a,b+2),'Flux') ) )
                    if( and( aux, and( strcmp(data{k,j}(a,b),'Courant'), or( strcmp(data{k,j}(a,b+1),'Flux'), strcmp(data{k,j}(a,b+2),'Flux') ) ) ) )
                        Current = [ Current; data{k,j}(a+1:a+5,b) ];
                        aux = false;
                        if ( and( aux, strcmp(data{k,j}(a,b+1),'Flux') ) )
                            Flux = [ Flux; data{k,j}(a+1:a+5,b+1) ];
                        else
                            Flux = [ Flux; data{k,j}(a+1:a+5,b+2) ];
                        end
                    end
                end
            end
            if ( aux == false) 
                break;
            end
        end
    end
end

Current = cell2mat(Current) ;
Flux = cell2mat(Flux) ;

end

