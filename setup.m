%% Compile RP mex file
clc
mexDir = 'cmex';
if(exist(mexDir, 'dir') ~= 0)
  rmdir(mexDir, 's');
end
mkdir(mexDir)
cd(mexDir);
disp('Compiling RP mex file...');
% Release:
mex ../src/RP_mex.cpp ../src/stopwatch/Stopwatch.cpp
% Debug:
% mex -g ../src/RP_mex.cpp ../src/stopwatch/Stopwatch.cpp
cd('../');

%% Generate configuration files:
cd('config')
disp('Generating configuration files...');
GenerateRPConfig();
GenerateRPConfig_4segs();
cd('../');
