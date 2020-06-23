function eegdiffplot(filename, timespan)
% Plots Fz and Cz in two different colours across two timespans
% filename : str
% timespan : 1x3 double (seconds)


%% Load dependencies and set globals %%%%%%%%

addpath('./src/MATLAB/edf-tools/');

outputDir = './output/';
if ~exist(outputDir, 'dir')
    mkdir(outputDir)
end

%% Load file %%%%%%%%

% find directory
allfiles = struct2cell(dir('./edf/dev/**/*.edf'));
for ind = 1:size(allfiles,2)
    label = allfiles{1,ind};
    if ~isempty(regexp(label, filename, "once"))
        filedir = allfiles{2,ind};
        break
    end
end

% error out if the filename isn't found
if ~exist('filedir')
    error('B: file not found')
end

% load edf
[hdr, record] = edfread(strcat(filedir, '/', filename));

% extract channels of interest
FZch = findChannel(hdr, "[Ff][Zz]");
FZdata = record(FZch, :);
CZch = findChannel(hdr, "[Cc][Zz]");
CZdata = record(CZch, :);




%% Parse timespans %%%%%%%%

FZfreq = hdr.frequency(FZch);
CZfreq = hdr.frequency(FZch);

if FZfreq == CZfreq
    freq = FZfreq;
else
    error("Frequencies are differnt??")
end

sample1 = (max(fix(freq*timespan(1)),1)):(fix(freq*timespan(2)));
sample2 = (max(fix(freq*timespan(2)),1)):(fix(freq*timespan(3)));


%% Calculate distance, speed, and acceleration %%%%%%%%

timeseries = [FZdata(:), CZdata(:)];

distance = vecnorm(cumsum(timeseries(:, [1,2]), 1)/freq, 2, 2);
speed = vecnorm(timeseries(:, [1,2]), 2, 2);
accel = vecnorm(diff(timeseries(:, [1,2]), 1)*freq, 2, 2);


% save data to mat files
dataName = strcat(filename(1:end-4), '_', num2str(timespan(1)), '.mat');

dataDir = strcat(outputDir, 'data/');
if ~exist(dataDir, 'dir')
    mkdir(dataDir)
end
save(...
    strcat(dataDir, dataName),...
    'filename', 'FZdata', 'CZdata',...
    'freq', 'sample1', 'sample2',...
    'distance', 'speed', 'accel'...
);



%% Plot data %%%%%%%%

h = figure(1);
clf

plotx      = 50;   % Screen position
ploty      = 50;   % Screen position
plotwidth  = 1800; % Width of figure
plotheight = 700; % Height of figure (by default in pixels)
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
titlestr = strcat(filename, ' freq = ', num2str(freq));
title(titlestr, 'Interpreter', 'none');
xlabel("Fz-ref (\muV)");
ylabel("Cz-ref (\muV)");
% write legend
legendstr1 = strcat(num2str(timespan(1)), 's -- ', num2str(timespan(2)), 's');
legendstr2 = strcat(num2str(timespan(2)), 's -- ', num2str(timespan(3)), 's');
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
plot(seconds(sample1/CZfreq), CZdata(sample1), 'b','DurationTickFormat','hh:mm:ss');
plot(seconds(sample2/CZfreq), CZdata(sample2), 'r','DurationTickFormat','hh:mm:ss');
hold off;
% write title and axis labels
grid on
xlabel("Time");
ylabel("Cz-ref (\muV)");


% save to disk
plotName = strcat(filename(1:end-4), '_', num2str(timespan(1)), '.png');
plotDir = strcat(outputDir, 'phase/');
if ~exist(plotDir, 'dir')
    mkdir(plotDir)
end
saveas(gcf,strcat(plotDir, plotName));


%% Plot acceleration %%%%%%%%

figure(2); clf;
plotx      = 50;   % Screen position
ploty      = 50;   % Screen position
plotwidth  = 900; % Width of figure
plotheight = 1200; % Height of figure (by default in pixels)
set(gcf, 'Position', [plotx ploty plotwidth plotheight]);

subplot(3, 1, 1);
hold on
plot(seconds(sample1/CZfreq), distance(sample1), 'b');
plot(seconds(sample2/CZfreq), distance(sample2), 'r');
hold off
title("``dist''"); xlabel("Time"); ylabel("\muV s");

subplot(3, 1, 2);
hold on
plot(seconds(sample1/CZfreq), speed(sample1), 'b');
plot(seconds(sample2/CZfreq), speed(sample2), 'r');
hold off
title("``speed''"); xlabel("Time"); ylabel("\muV");

subplot(3, 1, 3);
hold on
plot(seconds(sample1/CZfreq), accel(sample1), 'b');
plot(seconds(sample2(1:end-1)/CZfreq), accel(sample2(1:end-1)), 'r');
hold off
title("``accel''"); xlabel("Time"); ylabel("\muV s^{-1}");

% save to disk
plotName = strcat(filename(1:end-4), '_', num2str(timespan(1)), '.png');
plotDir = strcat(outputDir, 'accel/');
if ~exist(plotDir, 'dir')
    mkdir(plotDir)
end
saveas(gcf,strcat(plotDir, plotName));


end




function ch = findChannel(hdr, chstr)
    labels = hdr.label;
    for ind = 1:length(labels)
        label = labels{ind};
        if ~isempty(regexp(label, chstr, "once"))
            ch = ind;
            break
        end
    end
end
