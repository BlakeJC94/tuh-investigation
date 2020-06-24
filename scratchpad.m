% This file is just for wuick tests of new ideas on a single snippet of data
%
%
%

% Load dependencies
addpath('./src/MATLAB/')
t = @(hour, min, sec) hour*60*60 + min*60 + sec;

% Set globals
fileName = '00000629_s001_t001.edf';
timeSpan = [t(0,1,47), t(0,1,57), t(0,2,17)];

outputDir = './output/scratchpad/';
if ~exist(outputDir, 'dir')
    mkdir(outputDir)
end



%% Load file %%%%%%%%

[FZdata, CZdata, sample1, sample2, freq, hdr, ~] = loadfile(fileName, timeSpan);





%% Plot data %%%%%%%%

h = figure(1); clf;
plotx      = 50;   % Screen position
ploty      = 50;   % Screen position
plotwidth  = 700; % Width of figure
plotheight = 700;  % Height of figure (by default in pixels)
set(h, 'Position', [plotx ploty plotwidth plotheight]);


% Fz plot
subplot(2, 1, 1);
hold on;
plot(seconds(sample1/freq), FZdata(sample1), 'b','DurationTickFormat','hh:mm:ss');
plot(seconds(sample2/freq), FZdata(sample2), 'r','DurationTickFormat','hh:mm:ss');
hold off;
% write title and axis labels
grid on
xlabel("Time");
ylabel("Fz-ref (\muV)");


% Cz plot
subplot(2, 1, 2);
hold on;
plot(seconds(sample1/freq), CZdata(sample1), 'b','DurationTickFormat','hh:mm:ss');
plot(seconds(sample2/freq), CZdata(sample2), 'r','DurationTickFormat','hh:mm:ss');
hold off;
% write title and axis labels
grid on
xlabel("Time");
ylabel("Cz-ref (\muV)");


% save to disk
plotName = strcat(fileName(1:end-4), '_', num2str(timeSpan(1)));
plotName = strcat(plotName, '_plot001', '.png');
plotDir = outputDir;
if ~exist(plotDir, 'dir')
    mkdir(plotDir);
end
saveas(gcf,strcat(plotDir, plotName));


