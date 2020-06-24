function eegdiffplot(fileName, timeSpan)
% Plots Fz and Cz in two different colours across two timespans
% fileName : str
% timeSpan : 1x3 double (seconds)


%% Load dependencies and set globals %%%%%%%%

addpath('./src/MATLAB/edf-tools/');

outputDir = './output/';
if ~exist(outputDir, 'dir')
    mkdir(outputDir)
end


%% Load file %%%%%%%%

[FZdata, CZdata, sample1, sample2, freq, hdr, ~] = loadfile(fileName, timeSpan);


%% Calculate distance, speed, and acceleration %%%%%%%%

timeSeries = [FZdata(:), CZdata(:)];  % indexed by (sample, position)

distance = vecnorm(...
    cumsum(timeSeries(:, [1,2]), 1)/freq,...
    2, 2 ...
);
speed = vecnorm(...
    timeSeries(:, [1,2]),...
    2, 2 ...
);
accel = vecnorm(...
    diff(timeSeries(:, [1,2]), 1)*freq,...
    2, 2 ...
);

%% Save data to mat files %%%%%%%%
dataName = strcat(fileName(1:end-4), '_', num2str(timeSpan(1)), '.mat');
dataDir = strcat(outputDir, 'data/');
if ~exist(dataDir, 'dir')
    mkdir(dataDir)
end
save(...
    strcat(dataDir, dataName),...
    'fileName', 'FZdata', 'CZdata',...
    'freq', 'sample1', 'sample2',...
    'distance', 'speed', 'accel'...
);




%% Plot data %%%%%%%%

h = figure(1); clf;
plotx      = 50;   % Screen position
ploty      = 50;   % Screen position
plotwidth  = 1800; % Width of figure
plotheight = 700;  % Height of figure (by default in pixels)
set(h, 'Position', [plotx ploty plotwidth plotheight]);

% phase plot
subplot(2, 8, [1 2 3 9 10 11]);
axis square;
hold on;
plot(FZdata(sample1), CZdata(sample1), 'b:');
plot(FZdata(sample2), CZdata(sample2), 'r:');
hold off;
% normalise plotting region
plotmin = min(min(FZdata([sample1, sample2])), min(CZdata([sample1, sample2])));
plotmax = max(max(FZdata([sample1, sample2])), max(CZdata([sample1, sample2])));
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


% Fz plot
subplot(2, 8, [5 6 7 8]);
hold on;
plot(seconds(sample1/freq), FZdata(sample1), 'b','DurationTickFormat','hh:mm:ss');
plot(seconds(sample2/freq), FZdata(sample2), 'r','DurationTickFormat','hh:mm:ss');
hold off;
% write title and axis labels
grid on
xlabel("Time");
ylabel("Fz-ref (\muV)");


% Cz plot
subplot(2, 8, [13 14 15 16]);
hold on;
plot(seconds(sample1/freq), CZdata(sample1), 'b','DurationTickFormat','hh:mm:ss');
plot(seconds(sample2/freq), CZdata(sample2), 'r','DurationTickFormat','hh:mm:ss');
hold off;
% write title and axis labels
grid on
xlabel("Time");
ylabel("Cz-ref (\muV)");


% save to disk
plotName = strcat(fileName(1:end-4), '_', num2str(timeSpan(1)), '.png');
plotDir = strcat(outputDir, 'phase/');
if ~exist(plotDir, 'dir')
    mkdir(plotDir)
end
saveas(gcf,strcat(plotDir, plotName));




%% Plot motion %%%%%%%%

h = figure(2); clf;
plotx      = 50;   % Screen position
ploty      = 50;   % Screen position
plotwidth  = 900;  % Width of figure
plotheight = 1200; % Height of figure (by default in pixels)
set(gcf, 'Position', [plotx ploty plotwidth plotheight]);


% Plot distance
subplot(3, 1, 1);
hold on
plot(seconds(sample1/freq), distance(sample1), 'b');
plot(seconds(sample2/freq), distance(sample2), 'r');
hold off
% write title and axis labels
title("``dist''"); xlabel("Time"); ylabel("\muV s");


% Plot speed
subplot(3, 1, 2);
hold on
plot(seconds(sample1/freq), speed(sample1), 'b');
plot(seconds(sample2/freq), speed(sample2), 'r');
hold off
% write title and axis labels
title("``speed''"); xlabel("Time"); ylabel("\muV");


% Plot acceleration
subplot(3, 1, 3);
hold on
plot(seconds(sample1/freq), accel(sample1), 'b');
plot(seconds(sample2(1:end-1)/freq), accel(sample2(1:end-1)), 'r');
hold off
% write title and axis labels
title("``accel''"); xlabel("Time"); ylabel("\muV s^{-1}");


% save to disk
plotName = strcat(fileName(1:end-4), '_', num2str(timeSpan(1)), '.png');
plotDir = strcat(outputDir, 'accel/');
if ~exist(plotDir, 'dir')
    mkdir(plotDir)
end
saveas(gcf,strcat(plotDir, plotName));


end




