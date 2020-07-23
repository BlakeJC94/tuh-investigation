function plotMotion(fileName, timeSpan, outputDir)

dataName = strcat(fileName(1:end-4), '_', num2str(timeSpan(1)), '.mat');
dataDir = strcat(outputDir, 'data/');
load(strcat(dataDir, dataName));


h = figure(3); clf;
plotName = strcat(fileName(1:end-4), '_', num2str(timeSpan(1)), '.png');
plotDir = strcat(outputDir, 'accel/');
plotx      = 50;   % Screen position
ploty      = 50;   % Screen position
plotwidth  = 900;  % Width of figure
plotheight = 1200; % Height of figure (by default in pixels)
set(h, 'Position', [plotx ploty plotwidth plotheight]);

% Plot distance
subplot(3, 1, 1);
hold on
plot(seconds(sample1/freq), disttrav(sample1), 'b');
plot(seconds(sample2/freq), disttrav(sample2), 'r');
hold off
% write title and axis labels
title("``dist''"); xlabel("Time"); ylabel("\muV");

% Plot speed
subplot(3, 1, 2);
hold on
plot(seconds(sample1/freq), speed(sample1), 'b');
plot(seconds(sample2/freq), speed(sample2), 'r');
hold off
% write title and axis labels
title("``speed''"); xlabel("Time"); ylabel("\muV s^{-1}");

% Plot acceleration
subplot(3, 1, 3);
hold on
plot(seconds(sample1/freq), accel(sample1), 'b');
plot(seconds(sample2(1:end-1)/freq), accel(sample2(1:end-1)), 'r');
hold off
% write title and axis labels
title("``accel''"); xlabel("Time"); ylabel("\muV s^{-2}");

% save to disk
if ~exist(plotDir, 'dir')
    mkdir(plotDir)
end
saveas(gcf,strcat(plotDir, plotName));





end
