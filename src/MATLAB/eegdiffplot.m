function eegdiffplot(fileName, timeSpan)
% Plots Fz and Cz in two different colours across two timespans
% fileName : str
% timeSpan : 1x3 double (seconds)


% % Load dependencies and set globals %%%%%%%%
%
addpath('./src/MATLAB/');
addpath('./src/MATLAB/edf-tools/');

outputDir = './output/';
if ~exist(outputDir, 'dir')
    mkdir(outputDir)
end


% % Load file %%%%%%%%
%
[FZdata, CZdata, sample, freq, hdr, ~] = loadfile(fileName, timeSpan);



% % Process EDF
%
% %% Calculate distance, speed, and acceleration %%%%%%%%
%
[disttrav, speed, accel] = calcMotion(FZdata, CZdata, freq);

% %% Calculate spectrum for each segment %%%%%%%%
%
subsample1 = sample(sample <  freq*fix(timeSpan(2)));
subsample2 = sample(sample >= freq*fix(timeSpan(2)));

[FZfq1, FZspect1] = calcSpect(FZdata(subsample1), freq);
[FZfq2, FZspect2] = calcSpect(FZdata(subsample2), freq);

[CZfq1, CZspect1] = calcSpect(CZdata(subsample1), freq);
[CZfq2, CZspect2] = calcSpect(CZdata(subsample2), freq);

% %% Calculate periodograms (wavelets) TODO
%
% FZspectrogram1 = calcSpect(FZdata([sample1, sample2]), freq);
% CZspectrogram1 = calcSpect(CZdata([sample1, sample2]), freq);

% %% Calculate Quadratic variation %%%%%%%%
%
FZquadvar = calcQuadvar(FZdata, sample);
CZquadvar = calcQuadvar(CZdata, sample);

% %% Save data to mat files %%%%%%%%
%
dataName = strcat(fileName(1:end-4), '_', num2str(timeSpan(1)), '.mat');
dataDir = strcat(outputDir, 'data/');
if ~exist(dataDir, 'dir')
    mkdir(dataDir)
end
save(...
    strcat(dataDir, dataName), ...
    'fileName', 'FZdata', 'CZdata', ...
    'freq', 'sample', 'timeSpan', ...
    'disttrav', 'speed', 'accel', ...
    'FZfq1', 'FZspect1', 'FZfq2', 'FZspect2', ...
    'CZfq1', 'CZspect1', 'CZfq2', 'CZspect2', ...
    'FZquadvar', 'CZquadvar' ...
);




% % Plot data %%%%%%%%
%
% %% Phase plot %%%%%%%%
%
plotPhase(fileName, timeSpan, outputDir);

% %% Trace plot %%%%%%%%
%
plotTrace(fileName, timeSpan, outputDir);

% %% Motion plot %%%%%%%%
%
plotMotion(fileName, timeSpan, outputDir);

% %% Spect plot %%%%%%%%
%
plotSpects(fileName, timeSpan, outputDir);

% %% Quadvar plot %%%%%%%%
%
plotQuadvar(fileName, timeSpan, outputDir);


end
