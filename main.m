
% load dependencies
addpath('./src/')
addpath('./src/process/')
addpath('./src/plot/')

t = @(hour, min, sec) hour*60*60 + min*60 + sec;
tspn = @(t) [max(t - 30, 0) , t, t + 30];


% declare vars
chx = "[Ff][Zz]";
chy = "[Cc][Zz]";
outputDir = './output/';
if ~exist(outputDir, 'dir')
    mkdir(outputDir)
end

samplesToPlot = cell(1,2);

samplesToPlot{1,1} = '00000629_s001_t001.edf';
samplesToPlot{1,2} = [t(0,1,30), t(0,1,50), t(0,1,50)];

samplesToPlot{2,1} = '00000675_s001_t001.edf';
samplesToPlot{2,2} = [t(0,1,47), t(0,1,57), t(0,2,17)];

samplesToPlot{3,1} = '00000675_s001_t001.edf';
samplesToPlot{3,2} = [t(0,4,10), t(0,4,26), t(0,4,42)];

samplesToPlot{4,1} ='00000675_s002_t001.edf';
samplesToPlot{4,2} = [t(0,3,10), t(0,3,25), t(0,3,30)];

samplesToPlot{5,1} ='00000795_s001_t002.edf';
samplesToPlot{5,2} = [t(0,3,20), t(0,3,31), t(0,3,41)];

samplesToPlot{6,1} = '00001278_s001_t001.edf';
samplesToPlot{6,2} = [t(0,2,33), t(0,2,43), t(0,2,47)];

samplesToPlot{7,1} ='00001770_s003_t000.edf';
samplesToPlot{7,2} = [t(0,1,19), t(0,1,20), t(0,1,30)];

samplesToPlot{8,1} ='00001981_s004_t000.edf';
samplesToPlot{8,2} =[t(0,5,5), t(0,5,20), t(0,5,22)];

samplesToPlot{9,1} ='00001984_s001_t001.edf';
samplesToPlot{9,2} =[t(0,4,53), t(0,5,7), t(0,5,15)];

samplesToPlot{10,1} = 'subject1.edf';
samplesToPlot{10,2} =  [t(0,0,40), t(0,0,60), t(0,0,60)];

samplesToPlot{11,1} = 'Seizure_003.mat';
samplesToPlot{11,2} = [t(0,4,30), t(0,4,35), t(0,5,0)];

samplesToPlot{12,1} = 'Seizure_008.mat';
samplesToPlot{12,2} = [t(0,3,50), t(0,4,5), t(0,4,50)];

samplesToPlot{13,1} = 'Seizure_046.mat';
samplesToPlot{13,2} = [t(0,1,5), t(0,1,10), t(0,1,40)];

samplesToPlot{14,1} = 'Seizure_053.mat';
samplesToPlot{14,2} = [t(0,3,30), t(0,3,50), t(0,4,20)];

samplesToPlot{15,1} = 'Seizure_090.mat';
samplesToPlot{15,2} = [t(0,5,10), t(0,5,20), t(0,5,50)];

% Construct and save fig for each (fileName, timeSpan) pair
for index = 1:size(samplesToPlot, 1)

    fileName = samplesToPlot{index, 1};
    timeSpan = samplesToPlot{index, 2};

    disp(fileName)
    disp(timeSpan)

    [xdata, ydata, tdata] = loadFile(fileName, timeSpan, chx, chy);
    processData(fileName, timeSpan, xdata, ydata, tdata);

    plotPhaseTrace(fileName, timeSpan);
    plotQuadVar(fileName, timeSpan);
    plotQuadVarEigVals(fileName, timeSpan);
    plotFlowField(fileName, timeSpan);
    plotDirectionHist(fileName, timeSpan);
    
    pause(1.0);

end

disp("Done!");