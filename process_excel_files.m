% Collect data from several excel files
clear 
close all

[magnetFamily, directory, excelFiles, magLength, magWidth ] = choose_magnet_family( 'SPMBB__HWP' );
% SPMBA__HWP
% SPMBB__HWP
% SPQM___FWP

[ data ] = get_data_from_excel( excelFiles );

% are the words 'Courant' and 'Flux' in the file?
data_mtx = select_useful_files( excelFiles, data );

[Current, Flux] = get_current_and_flux( excelFiles, data, data_mtx );

%% Check files
check_files( data_mtx, excelFiles );

%% Plotting

figure(1)
scatter( Current, Flux)
title(['Excitation Curve for ' magnetFamily], 'Interpreter', 'none')
xlabel ('Current [A]')
ylabel ('Flux [V.s]')
grid on

saveas(figure(1),[pwd '/Output_figures/excitation_curve_' magnetFamily '.png']);

% sol_mtx = [Current Flux/(mag_length*mag_width)] ;
sol_mtx = [Current Flux] ;
[idx, C_points] = kmeans ( sol_mtx, 5 );
clear tmp
C_points = sort(C_points,1);
figure(2);
plot( sol_mtx(idx==1,1), sol_mtx(idx==1,2), 'r.', 'MarkerSize', 12)
hold on
plot( sol_mtx(idx==2,1), sol_mtx(idx==2,2), 'b.', 'MarkerSize', 12)
plot( sol_mtx(idx==3,1), sol_mtx(idx==3,2), 'm.', 'MarkerSize', 12)
plot( sol_mtx(idx==4,1), sol_mtx(idx==4,2), 'y.', 'MarkerSize', 12)
plot( sol_mtx(idx==5,1), sol_mtx(idx==5,2), 'g.', 'MarkerSize', 12)

plot(C_points(:,1), C_points(:,2), 'kx', 'MarkerSize', 15, 'LineWidth', 1)

tmp1 = num2str( C_points(:,1) );
tmp2 = num2str( C_points(:,2) );
clear tmp
for a = 1:size(tmp1,1)
    tmp(a,:) = ['(' tmp1(a,:) '; ' tmp2(a,:) ')'];
end
clusters_text = cellstr( tmp );
dx = max(C_points(:,1))*0.0204; dy = max(C_points(:,2))*0.0263; % displacement so the text does not overlay the data points
text(C_points(1:4,1)+dx, C_points(1:4,2)+dy, clusters_text(1:4)); % /!\ BRUTE FORCE /!\
text(C_points(5,1)-max(C_points(:,1))*0.3163, C_points(5,2)+dy, clusters_text(5)); % fifth is different (!)
% dx = 100; dy = 0.3;
% text(C_points(1:4,1)+dx, C_points(1:4,2)+dy, clusters_text(1:4)); % /!\ BRUTE FORCE /!\
% text(C_points(5,1)-1550, C_points(5,2)+dy, clusters_text(5)); % fifth is different (!)

legend('Cluster 1', 'Cluster 2', 'Cluster 3', 'Cluster 4', 'Cluster 5', 'Centroids', 'Location', 'NW')
title (['Cluster Assignments and Centroids for ' magnetFamily], 'Interpreter', 'none')
hold off
xlabel ('Current [A]')
ylabel ('Flux [V.s]')
grid on

saveas(figure(2),[pwd '/Output_figures/clusters_' magnetFamily '.png']);

%% Write file
file_name = [pwd '/Output_text_files/' magnetFamily '.txt'];
fid = fopen( file_name, 'wt' );
% line 1
fprintf(fid, [ 'Magnet Family = ' num2str(magnetFamily) '\n'] ); 
% line 2
fprintf( fid, [ 'Magnetic length [m] = ' num2str(magLength) '\n'] ); 
% line 3
fprintf( fid, [ 'Magnetic width [m] = ' num2str(magWidth) '\n'] ); 
% line 4
fprintf( fid, [ 'Total files [#] = ' num2str(size(data,1)) '\n'] ); 
% line 5
total_num_sheets = sum(sum(~cellfun(@isempty,data_mtx),2)) ;
fprintf( fid, [ 'Total sheets [#] = ' num2str(total_num_sheets) '\n'] ); 
% line 6
useful_sheets = size(sol_mtx,1) /5;
fprintf( fid, [ 'Useful sheets [#] = ' num2str(useful_sheets) '\n'] ); 
% line 7
useful_info = useful_sheets /total_num_sheets;
fprintf( fid, [ 'Useful info [frac] = ' num2str(useful_info) '\n'] ); 
% line 8
fprintf( fid, [ 'C_points = {(' num2str(C_points(1,1)) ', ' num2str(C_points(1,2)) '); ' ...
    '(' num2str(C_points(2,1)) ', ' num2str(C_points(2,2)) '); ' ...
    '(' num2str(C_points(3,1)) ', ' num2str(C_points(3,2)) '); ... \n' ...
    '... (' num2str(C_points(4,1)) ', ' num2str(C_points(4,2)) '); ' ...
    '(' num2str(C_points(5,1)) ', ' num2str(C_points(5,2)) ')}' '\n'] ); 

% line 9
sol_mtx = sort(sol_mtx, 1);
for aux = 1:5
    stand_dev(aux) = norm(std(sol_mtx((aux-1)*size(sol_mtx,1)/5+1 : aux*size(sol_mtx,1)/5,:)));
    mean_val(aux,:) = mean(sol_mtx((aux-1)*size(sol_mtx,1)/5+1 : aux*size(sol_mtx,1)/5,:));
end
fprintf( fid, [ 'std = (' num2str(stand_dev(1)) ', ' num2str(stand_dev(2)) ', ' ...
    num2str(stand_dev(3)) ', ' num2str(stand_dev(4)) ', ' num2str(stand_dev(5)) ') ' ] ); 
fclose(fid);

%% Save workspace
save([ 'Workspaces\' magnetFamily ]);