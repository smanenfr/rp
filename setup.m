%% Compile RP mex file
clc
cd('mex')
if(exist('RP_mex.mexa64', 'file') == 0)
  delete('RP_mex.mexa64');
end
disp('Compiling RP mex file...');
% Release:
mex ../src/RP_mex.cpp ../src/stopwatch/Stopwatch.cpp -I/usr/include/opencv -L/usr/lib -lcv -lhighgui -lcxcore -lml -lcvaux
% Debug:
% mex -g ../src/RP_mex.cpp ../src/stopwatch/Stopwatch.cpp -I/usr/include/opencv -L/usr/lib -lcv -lhighgui -lcxcore -lml -lcvaux
cd('../');

%% Generate configuration files:
cd('config')
disp('Generating configuration files...');
GenerateRPConfig();
GenerateRPConfig_4segs();
cd('../');
