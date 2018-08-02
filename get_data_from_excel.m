%function [ data, sheetName ] = get_data_from_excel( files )
function [ data ] = get_data_from_excel( files )

for k = 1:numel(files)
    %[~,~,C{k} ] = xlsread(S(k).name);
    tmp = [files(k).folder  '\' files(k).name];
    % [~,sheet_name]=xlsfinfo(S(k).name);
    [~,sheetName]=xlsfinfo(tmp);
    for j=1:numel(sheetName)
%         [~,~,data{k,j}]=xlsread(S(k).name,sheet_name{j});
        [~,~,data{k,j}]=xlsread(tmp, sheetName{j});
    end
end

end

