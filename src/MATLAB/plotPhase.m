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

subsample1 = sample(sample <= freq*fix(timeSpan(2)));
subsample2 = sample(sample >  freq*fix(timeSpan(2)));

axis square;
hold on;
plot(FZdata(subsample1), CZdata(subsample1), 'b:');
plot(FZdata(subsample2), CZdata(subsample2), 'r:');
hold off;

% normalise plotting region
plotmin = min( ...
    min(FZdata([subsample1, subsample2])), ...
    min(CZdata([subsample1, subsample2])) ...
);
plotmax = max( ...
    max(FZdata([subsample1, subsample2])), ...
    max(CZdata([subsample1, subsample2])) ...
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
