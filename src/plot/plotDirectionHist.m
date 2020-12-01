function plotDirectionHist(fileName, timeSpan)

bins = 42;

outputDir = './output/';
dataDir = strcat(outputDir, 'data/');
dataName = strcat(fileName(1:end-4), '_', num2str(timeSpan(1)), '.mat');
load(strcat(dataDir, dataName), 'directions1', 'directions2', 'times1', 'times2');


h = figure(12); clf;
plotName = strcat(fileName(1:end-4), '_', num2str(timeSpan(1)), '.png');
plotDir = strcat(outputDir, 'directions/');
plotx      = 50;   % Screen position
ploty      = 50;   % Screen position
plotwidth  = 1000;  % Width of figure
plotheight = 500;  % Height of figure (by default in pixels)
set(h, 'Position', [plotx ploty plotwidth plotheight]);

subplot(1,2,1);
polarhistogram(directions1, bins, 'FaceColor','blue');
title('Trajectory directions in segment 1');

subplot(1,2,2);
polarhistogram(directions2, bins, 'FaceColor','red');
title('Trajectory directions in segment 2');

% save output
if ~exist(plotDir, 'dir')
    mkdir(plotDir)
end
saveas(h,strcat(plotDir, plotName));


h = figure(14); clf;
plotName = strcat(fileName(1:end-4), '_', num2str(timeSpan(1)), '.png');
plotDir = strcat(outputDir, 'transitions/');
plotx      = 50;   % Screen position
ploty      = 50;   % Screen position
plotwidth  = 1000;  % Width of figure
plotheight = 300;  % Height of figure (by default in pixels)
set(h, 'Position', [plotx ploty plotwidth plotheight]);

subplot(1,2,1);
histogram(times1, 21, 'BinLimits', [0,max([times1, times2])], 'FaceColor', 'blue');
xlabel('Time (s)')
ylabel('Counts')
title('Distribution of times of direction changes in segment 1');

subplot(1,2,2);
histogram(times2, 21, 'BinLimits', [0,max([times1, times2])], 'FaceColor', 'red');
xlabel('Time (s)')
ylabel('Counts')
title('Distribution of times of direction changes in segment 2');



% save output
if ~exist(plotDir, 'dir')
    mkdir(plotDir)
end
saveas(h,strcat(plotDir, plotName));

end

