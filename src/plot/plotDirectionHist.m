function plotDirectionHist(fileName, timeSpan)

bins = 42;

outputDir = './output/';
dataDir = strcat(outputDir, 'data/');
dataName = strcat(fileName(1:end-4), '_', num2str(timeSpan(1)), '.mat');
load(strcat(dataDir, dataName), 'directions1', 'directions2');

h = figure(12); clf;
plotName = strcat(fileName(1:end-4), '_', num2str(timeSpan(1)), '.png');
plotDir = strcat(outputDir, 'directions/');
plotx      = 50;   % Screen position
ploty      = 50;   % Screen position
plotwidth  = 600;  % Width of figure
plotheight = 500;  % Height of figure (by default in pixels)
set(h, 'Position', [plotx ploty plotwidth plotheight]);


polarhistogram([directions1, directions2], bins, 'FaceColor','red', 'FaceAlpha',.3);
hold on
polarhistogram(directions1, bins, 'FaceColor','blue','FaceAlpha',.3);
hold off

title('Directionalaity of phase space trajectory')

% save output
if ~exist(plotDir, 'dir')
    mkdir(plotDir)
end
saveas(h,strcat(plotDir, plotName));


end

