function [magnetFamily, directory, files, magLength, magWidth ] = choose_magnet_family( magnetFamily )

switch magnetFamily
    case 'SPMBA__HWP'
        group_name = 'Dipoles' ; magLength = 6720.0e-3; magWidth = 844.0e-3;
    case 'SPMBB__HWP'
        group_name = 'Dipoles' ; magLength = 6700.0e-3; magWidth = 844.0e-3;
    case 'SPQM___FWP'
        group_name = 'Quadrupoles' ; magLength = 3346.0e-3; magWidth = 720.0e-3;
end
% d = '\\cern.ch\dfs\Users\v\vkorchev\Documents\ECurves\TransferFunctions\SPS_LHC_NEA\Dipoles\SPMBA__HWP'; family_name = 'SPMBA__HWP' ;
directory = ['\\cern.ch\dfs\Users\v\vkorchev\Documents\ECurves\TransferFunctions\SPS_LHC_NEA\' group_name '\' magnetFamily];
files = dir(fullfile(directory, '*.xls'));
% S = dir('*.xlsx');

end

