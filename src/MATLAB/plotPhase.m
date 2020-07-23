function plotPhase(fileName, timeSpan, outputDir)

dataName = strcat(fileName(1:end-4), '_', num2str(timeSpan(1)), '.mat');
dataDir = strcat(outputDir, 'data/');
load(strcat(dataDir, dataName));

h = figure(1); clf;
plotName = strcat(fileName(1:end-4), '_', num2str(timeSpan(1)), '.png');
plotDir = strcat(outputDir, 'phase/');
plotx      = 50;   % Screen position
ploty      = 50;   % Screen position
plotwidth  = 900;  % Width of figure
plotheight = 900;  % Height of figure (by default in pixels)
set(h, 'Position', [plotx ploty plotwidth plotheight]);

axis square;
hold on;
plot(FZdata(sample1), CZdata(sample1), 'b:');
plot(FZdata(sample2), CZdata(sample2), 'r:');
hold off;

% normalise plotting region
plotmin = min( ...
    min(FZdata([sample1, sample2])), ...
    min(CZdata([sample1, sample2])) ...
);
plotmax = max( ...
    max(FZdata([sample1, sample2])), ...
    max(CZdata([sample1, sample2])) ...
);
axis([plotmin, plotmax, plotmin, plotmax]);
grid on;

% write title and axis labels
titlestr = strcat(fileName, ' freq = ', num2str(freq));
title(titlestr, 'Interpreter', 'none');
xlabel("Fz-ref (\muV)");
ylabel("Cz-ref (\muV)");

% write legend
legendstr1 = strcat(num2str(timeSpan(1)), 's -- ', num2str(timeSpan(2)), 's');
legendstr2 = strcat(num2str(timeSpan(2)), 's -- ', num2str(timeSpan(3)), 's');
legend(legendstr1, legendstr2)

% save plot
if ~exist(plotDir, 'dir')
    mkdir(plotDir)
end
saveas(h,strcat(plotDir, plotName));
end
