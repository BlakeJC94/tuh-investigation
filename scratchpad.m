% This file is just for quick tests of new ideas on a single snippet of data
%
%
%

% Load dependencies
addpath('./src/process/')
addpath('./src/plot/')
t = @(hour, min, sec) hour*60*60 + min*60 + sec;

% Set globals
fileName = '00000675_s001_t001.edf';
timeSpan = [t(0,4,10), t(0,4,26), t(0,4,42)];
chx = "[Ff][Zz]";
chy = "[Cc][Zz]";

outputDir = './output/scratchpad/';
if ~exist(outputDir, 'dir')
    mkdir(outputDir)
end

[xdata, ydata, tdata] = loadFile(fileName, timeSpan, chx, chy);
processData(fileName, timeSpan, xdata, ydata, tdata);

plotPhaseTrace(fileName, timeSpan);
plotQuadVarEigVals(fileName, timeSpan);


A = [1, 4; 
    4, 5];

[V,D] = eig(A);
ax = D(1,1)*V(1,1);
ay = D(1,1)*V(2,1);
bx = D(2,2)*V(1,2);
by = D(2,2)*V(2,2);

theta = linspace(0, 2*pi, 200);
x = ax*sin(theta) + bx*cos(theta);
y = ay*sin(theta) + by*cos(theta);

figure;
plot(x,y);