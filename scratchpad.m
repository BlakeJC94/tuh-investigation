% This file is just for quick tests of new ideas on a single snippet of data
%
%
%

% Load dependencies
addpath('./src/MATLAB/')
t = @(hour, min, sec) hour*60*60 + min*60 + sec;

% Set globals
fileName = '00000675_s001_t001.edf';
timeSpan = [t(0,4,10), t(0,4,26), t(0,4,42)];

outputDir = './output/scratchpad/';
if ~exist(outputDir, 'dir')
    mkdir(outputDir)
end



%% Load file %%%%%%%%

[FZdata, CZdata, sample1, sample2, freq, hdr, ~] = loadfile(fileName, timeSpan);

%% Calculate spectrum for each segment

[FZfq1, FZspect1] = calcSpect(FZdata(sample1), freq);
[FZfq2, FZspect2] = calcSpect(FZdata(sample2), freq);



%% Plot data %%%%%%%%

h = figure(1); clf;
plotx      = 50;   % Screen position
ploty      = 50;   % Screen position
plotwidth  = 900; % Width of figure
plotheight = 700;  % Height of figure (by default in pixels)
set(h, 'Position', [plotx ploty plotwidth plotheight]);


% Fz plot
subplot(2, 2, [1 2]);
hold on;
plot(seconds(sample1/freq), FZdata(sample1), 'b','DurationTickFormat','hh:mm:ss');
plot(seconds(sample2/freq), FZdata(sample2), 'r','DurationTickFormat','hh:mm:ss');
hold off;
% write title and axis labels
grid on
xlabel("Time");
ylabel("Fz-ref (\muV)");

subplot(2, 2, [3, 4]);
hold on;
plot(FZfq1(find(FZfq1<30)), FZspect1(find(FZfq1<30)), 'b');
plot(FZfq2(find(FZfq2<30)), FZspect2(find(FZfq2<30)), 'r');
% write title and axis labels
grid on
xlabel("Frequency (Hz)");
ylabel("Amplitude");



% % Cz plot
% subplot(2, 1, 2);
% hold on;
% plot(seconds(sample1/freq), CZdata(sample1), 'b','DurationTickFormat','hh:mm:ss');
% plot(seconds(sample2/freq), CZdata(sample2), 'r','DurationTickFormat','hh:mm:ss');
% hold off;
% % write title and axis labels
% grid on
% xlabel("Time");
% ylabel("Cz-ref (\muV)");


% save to disk
plotName = strcat(fileName(1:end-4), '_', num2str(timeSpan(1)));
plotName = strcat(plotName, '_plot001', '.png');
plotDir = outputDir;
if ~exist(plotDir, 'dir')
    mkdir(plotDir);
end
saveas(gcf,strcat(plotDir, plotName));





function [F, P1] = calcSpect(Y, freq)
    L = length(Y);
    S = fft(Y);
    % Compute 2-sided spectrum P2 and 1-sided spectrum P1
    P2 = abs(S/L);
    P1 = P2(1:floor(L/2)+1);
    P1(2:end-1) = 2*P1(2:end-1);
    % Frequency domain
    F = freq*(0:floor(L/2))/L;
end





