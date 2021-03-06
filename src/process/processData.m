function processData(fileName, timeSpan, xdata, ydata, tdata)
%processData Converts fileName and timeSpan into mat file
%
% Saves
% -----
% results : mat file
%     xdata, ydata, tdata : vectors
%         Data for plotting and processing
%     qVarxx, qVaryy, qVarxy : cells {sRateFracInd, QvOrTime}
%         Tvecs included in 2nd dim due to downsampling
%     qVarmat : array (covdim1, covdim2, sampleStep)
%         Only max sample rate is recorded here
%     eigvals : matrix (eigInd, sampleStep)
%     eigvecs : array (eigInd, dim, sampleStep)

% Load dependencies and set globals %%%%%%%%
addpath('./src/process/');
outputDir = './output/';


% Calculate quadratic variation matrix %%%%%%%%
sRateFracs = [1];
windowLength = 128;

qVarxx = calcQuadVar(xdata, xdata, tdata, sRateFracs, windowLength);
qVaryy = calcQuadVar(ydata, ydata, tdata, sRateFracs, windowLength);
qVarxy = calcQuadVar(xdata, ydata, tdata, sRateFracs, windowLength);

qVarmat = zeros(2, 2, length(tdata));
qVarmat(1,1,:) = qVarxx{end,1};
qVarmat(2,2,:) = qVaryy{end,1};
qVarmat(1,2,:) = qVarxy{end,1};
qVarmat(2,1,:) = qVarxy{end,1};


% Calculate eigendata %%%%%%%%
eigVals = zeros(2,length(tdata));
eigVecs = zeros(2,2,length(tdata));
for i = 1:length(tdata)
    [V, D] = eig(qVarmat(:,:,i));
    eigVals(:,i) = diag(D);
    eigVecs(:,:,i) = V;
end

% Calculate average flow field
spacing = range([xdata, ydata])/24;
[flowField, flowField1, flowField2] = calcFlowField(xdata, ydata, tdata, timeSpan, spacing);


% Calculate directionality hist
dirThreshold = 150*(pi/180);
[binEdges, binCounts1, binCounts2, times1, times2] = calcDirectionHist(xdata, ydata, tdata, timeSpan, dirThreshold);


% Save data to mat files for plots %%%%%%%%
dataName = strcat(fileName(1:end-4), '_', num2str(timeSpan(1)), '.mat');
dataDir = strcat(outputDir, 'data/');
if ~exist(dataDir, 'dir')
    mkdir(dataDir)
end
save(...
    strcat(dataDir, dataName), ...
    'xdata', 'ydata', 'tdata', ...
    'qVarxx', 'qVaryy', 'qVarxy', 'windowLength', ...
    'qVarmat', 'eigVals', 'eigVecs', ...
    'flowField', 'flowField1', 'flowField2',  ...
    'binEdges', 'binCounts1', 'binCounts2', ...
    'times1', 'times2' ...
);


end
