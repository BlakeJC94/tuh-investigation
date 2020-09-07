function processData(filename, timespan, chx, chy)

% % Load dependencies and set globals %%%%%%%%
%
addpath('./src/MATLAB/');
addpath('./src/MATLAB/edf-tools/');
addpath('./src/MATLAB/process/');

outputDir = './output/';
if ~exist(outputDir, 'dir')
    mkdir(outputDir)
end

% % Load EDF
%
[xdata, ydata, tdata, freq, ~, ~] = loadfile(fileName, timeSpan, chx, chy)

% % Process EDF
%
% %% Calculate quadratic variation %%%%%%%%
%
qvarxx = calcQuadvar(xdata, xdata, tdata);
qvaryy = calcQuadvar(ydata, ydata, tdata);
qvarxy = calcQuadvar(xdata, ydata, tdata);

% %% Calculate eigenvalues %%%%%%%% TODO
%


% %% Save data to mat files for plots %%%%%%%%
%
dataName = strcat(fileName(1:end-4), '_', num2str(timeSpan(1)), '.mat');
dataDir = strcat(outputDir, 'data/');
if ~exist(dataDir, 'dir')
    mkdir(dataDir)
end
save(...
    strcat(dataDir, dataName), ...
    'fileName', ,'timeSpan', 'chx', 'chy', ...
    'xdata', 'ydata', 'tdata', 'freq', ...
    'qvarxx', 'qvaryy', 'qvarxy' ...
);


end
