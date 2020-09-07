function plotTrace(fileName, timeSpan, outputDir)

dataName = strcat(fileName(1:end-4), '_', num2str(timeSpan(1)), '.mat');
dataDir = strcat(outputDir, 'data/');
load(strcat(dataDir, dataName));


h = figure(2); clf;
plotName = strcat(fileName(1:end-4), '_', num2str(timeSpan(1)), '.png');
plotDir = strcat(outputDir, 'trace/');
plotx      = 50;   % Screen position
ploty      = 50;   % Screen position
plotwidth  = 900;  % Width of figure
plotheight = 700;  % Height of figure (by default in pixels)
set(h, 'Position', [plotx ploty plotwidth plotheight]);

subsample1 = sample(sample <= freq*fix(timeSpan(2)));
subsample2 = sample(sample >  freq*fix(timeSpan(2)));

% Fz trace
subplot(2, 1, 1);
hold on;
plot( ...
    seconds(subsample1/freq), FZdata(subsample1), ...
    'b','DurationTickFormat','hh:mm:ss' ...
);
plot( ...
    seconds(subsample2/freq), FZdata(subsample2), ...
    'r','DurationTickFormat','hh:mm:ss' ...
);
hold off;

% write title and axis labels
grid on
xlabel("Time");
ylabel("Fz-ref (\muV)");


% Cz trace
subplot(2, 1, 2);
hold on;
plot( ...
    seconds(subsample1/freq), CZdata(subsample1), ...
    'b','DurationTickFormat','hh:mm:ss' ...
);
plot( ...
    seconds(subsample2/freq), CZdata(subsample2), ...
    'r','DurationTickFormat','hh:mm:ss' ...
);
hold off;

% write title and axis labels
grid on
xlabel("Time");
ylabel("Cz-ref (\muV)");

% save to disk
if ~exist(plotDir, 'dir')
    mkdir(plotDir)
end
saveas(h,strcat(plotDir, plotName));



end
