function plotPhaseTrace(fileName, timeSpan, outputDir)

dataName = strcat(fileName(1:end-4), '_', num2str(timeSpan(1)), '.mat');
dataDir = strcat(outputDir, 'data/');
load(strcat(dataDir, dataName));

h = figure(1); clf;
plotName = strcat(fileName(1:end-4), '_', num2str(timeSpan(1)), '.png');
plotDir = strcat(outputDir, 'phase/');
plotx      = 50;   % Screen position
ploty      = 50;   % Screen position
plotwidth  = 1000;  % Width of figure
plotheight = 500;  % Height of figure (by default in pixels)
set(h, 'Position', [plotx ploty plotwidth plotheight]);

subsample1 = find(tdata <= timeSpan(2));
subsample2 = find(tdata >  timeSpan(2));

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
titlestr = strcat(fileName, ' freq = ', num2str(freq));
title(titlestr, 'Interpreter', 'none');
xlabel("Fz-ref (\muV)");
ylabel("Cz-ref (\muV)");
% write legend
legendstr1 = strcat(num2str(timeSpan(1)), 's -- ', num2str(timeSpan(2)), 's');
legendstr2 = strcat(num2str(timeSpan(2)), 's -- ', num2str(timeSpan(3)), 's');
legend(legendstr1, legendstr2)


% %% Trace plot x %%%%%%%%
%
subplot(2,4,[3,4]);
hold on;
plot( ...
    seconds(tdata(subsample1)), xdata(subsample1), ...
    'b','DurationTickFormat','hh:mm:ss' ...
);
plot( ...
    seconds(tdata(subsample2)), xdata(subsample2), ...
    'r','DurationTickFormat','hh:mm:ss' ...
);
hold off;
% write title and axis labels
grid on
xlabel("Time");
ylabel("Fz-ref (\muV)");


% %% Trace plot y %%%%%%%%
%
subplot(2,4,[7,8]);
hold on;
plot( ...
    seconds(tdata(subsample1)), ydata(subsample1), ...
    'b','DurationTickFormat','hh:mm:ss' ...
);
plot( ...
    seconds(tdata(subsample2)), ydata(subsample2), ...
    'r','DurationTickFormat','hh:mm:ss' ...
);
hold off;
% write title and axis labels
grid on
xlabel("Time");
ylabel("Fz-ref (\muV)");

% %% Save plots %%%%%%%%
%
if ~exist(plotDir, 'dir')
    mkdir(plotDir)
end
saveas(h,strcat(plotDir, plotName));
end






