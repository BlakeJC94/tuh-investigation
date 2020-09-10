function processData(fileName, timeSpan, outputDir, chx, chy)

% % Load dependencies and set globals %%%%%%%%
%
addpath('./src/MATLAB/');
addpath('./src/MATLAB/edf-tools/');
addpath('./src/MATLAB/process/');


% % Load EDF
%
[xdata, ydata, tdata, freq, ~, ~] = loadfile(fileName, timeSpan, chx, chy);

% % Process EDF
%
% %% Calculate quadratic variation %%%%%%%%
%
qvarxx = calcQuadvar(xdata, xdata, tdata, [1]);
qvaryy = calcQuadvar(ydata, ydata, tdata, [1]);
qvarxy = calcQuadvar(xdata, ydata, tdata, [1]);



% %% Calculate eigenvalues %%%%%%%% TODO
%
% qvarmat = zeros(2,2,length(tdata));
% qvarmat(1,1,:) = qvarxx{end,1};
% qvarmat(2,2,:) = qvaryy{end,1};
% qvarmat(1,2,:) = qvarxy{end,1};
% qvarmat(2,1,:) = qvarxy{end,1};
% eigvals = zeros(length(tdata), 2);
% for i = 1:length(tdata)
%     eigvals(i,:) = eig(qvarmat(:,:,i));
% end


% %% Save data to mat files for plots %%%%%%%%
%
dataName = strcat(fileName(1:end-4), '_', num2str(timeSpan(1)), '.mat');
dataDir = strcat(outputDir, 'data/');
if ~exist(dataDir, 'dir')
    mkdir(dataDir)
end
save(...
    strcat(dataDir, dataName), ...
    'fileName', 'timeSpan', 'chx', 'chy', ...
    'xdata', 'ydata', 'tdata', 'freq', ...
    'qvarxx', 'qvaryy', 'qvarxy' ...
);


end
