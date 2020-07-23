function plotSpects(fileName, timeSpan, outputDir)

dataName = strcat(fileName(1:end-4), '_', num2str(timeSpan(1)), '.mat');
dataDir = strcat(outputDir, 'data/');
load(strcat(dataDir, dataName));


h = figure(4); clf;
plotName = strcat(fileName(1:end-4), '_', num2str(timeSpan(1)), '.png');
plotDir = strcat(outputDir, 'spect/');
plotx      = 50;   % Screen position
ploty      = 50;   % Screen position
plotwidth  = 900;  % Width of figure
plotheight = 700;  % Height of figure (by default in pixels)
set(h, 'Position', [plotx ploty plotwidth plotheight]);

% Plot Fz spectrum
subplot(2,1,1);
semilogx(FZfq1(find(FZfq1<30)), FZspect1(find(FZfq1<30)), 'b');
hold on;
semilogx(FZfq2(find(FZfq2<30)), FZspect2(find(FZfq2<30)), 'r');
hold off;
title("Spectrum")
xlabel("Frequency (Hz)");
ylabel("Amplitude");

% plot Cz spectrum
subplot(2,1,2);
semilogx(CZfq1(find(CZfq1<30)), CZspect1(find(CZfq1<30)), 'b');
hold on;
semilogx(CZfq2(find(CZfq2<30)), CZspect2(find(CZfq2<30)), 'r');
hold off;
title("Spectrum")
xlabel("Frequency (Hz)");
ylabel("Amplitude");

% save to disk
if ~exist(plotDir, 'dir')
    mkdir(plotDir)
end
saveas(gcf,strcat(plotDir, plotName));



end
