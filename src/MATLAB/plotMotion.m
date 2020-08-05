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

subsample1 = sample(sample <= freq*fix(timeSpan(2)));
subsample2 = sample(sample >  freq*fix(timeSpan(2)));

% Plot distance
subplot(3, 1, 1);
hold on
plot(seconds(subsample1/freq), disttrav(subsample1), 'b');
plot(seconds(subsample2/freq), disttrav(subsample2), 'r');
hold off
% write title and axis labels
title("``dist''"); xlabel("Time"); ylabel("\muV");

% Plot speed
subplot(3, 1, 2);
hold on
plot(seconds(subsample1/freq), speed(subsample1), 'b');
plot(seconds(subsample2/freq), speed(subsample2), 'r');
hold off
% write title and axis labels
title("``speed''"); xlabel("Time"); ylabel("\muV s^{-1}");

% Plot acceleration
subplot(3, 1, 3);
hold on
plot(seconds(subsample1/freq), accel(subsample1), 'b');
plot(seconds(subsample2(1:end-1)/freq), accel(subsample2(1:end-1)), 'r');
hold off
% write title and axis labels
title("``accel''"); xlabel("Time"); ylabel("\muV s^{-2}");

% save to disk
if ~exist(plotDir, 'dir')
    mkdir(plotDir)
end
saveas(gcf,strcat(plotDir, plotName));





end
