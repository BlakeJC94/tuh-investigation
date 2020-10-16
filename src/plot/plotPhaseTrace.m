function plotPhaseTrace(fileName, timeSpan)

outputDir = './output/';
dataDir = strcat(outputDir, 'data/');
dataName = strcat(fileName(1:end-4), '_', num2str(timeSpan(1)), '.mat');
load(strcat(dataDir, dataName), 'xdata', 'ydata', 'tdata');

h = figure(1); clf;
plotName = strcat(fileName(1:end-4), '_', num2str(timeSpan(1)), '.png');
plotDir = strcat(outputDir, 'phase/');
plotx      = 50;   % Screen position
ploty      = 50;   % Screen position
plotwidth  = 1000;  % Width of figure
plotheight = 500;  % Height of figure (by default in pixels)
set(h, 'Position', [plotx ploty plotwidth plotheight]);

subsample1 = find(tdata < timeSpan(2));
subsample2 = find(tdata >=  timeSpan(2));

% %% Phase plot %%%%%%%%
%
subplot(2,4,[1,2,5,6]);
axis square;
hold on;
plot(xdata(subsample1), ydata(subsample1), 'b:');
plot(xdata(subsample2), ydata(subsample2), 'r:');
hold off;
% normalise plotting region
plotmin = min(min(xdata(:)), min(ydata(:)));
plotmax = max(max(xdata(:)), max(ydata(:)));
axis([plotmin,plotmax, plotmin, plotmax]);
grid on;
% write title and axis labels
title(fileName, 'Interpreter', 'none');
xlabel("\muV");
ylabel("\muV");
% write legend
legendstr1 = strcat(num2str(timeSpan(1)), 's -- ', num2str(timeSpan(2)), 's');
legendstr2 = strcat(num2str(timeSpan(2)), 's -- ', num2str(timeSpan(3)), 's');
legend(legendstr1, legendstr2)


% %% Trace plots %%%%%%%%
%
plotCell{1} = xdata;
plotCell{2} = ydata;
for i = 1:2
    subplot(2,4,[4*i-1,4*i]);
    
    x1 = seconds(tdata(subsample1));
    y1= plotCell{i}(subsample1);
    plot(x1, y1, 'b','DurationTickFormat','hh:mm:ss');
    hold on;
    x2 = seconds(tdata(subsample2));
    y2= plotCell{i}(subsample2);
    plot(x2, y2, 'r','DurationTickFormat','hh:mm:ss');
    hold off;
    % write title and axis labels
    grid on
    xlabel("Time");
    ylabel("\muV");
end


% %% Save plots %%%%%%%%
%
if ~exist(plotDir, 'dir')
    mkdir(plotDir)
end
saveas(h,strcat(plotDir, plotName));
end






