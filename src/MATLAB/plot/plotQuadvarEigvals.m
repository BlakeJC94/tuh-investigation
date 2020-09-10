function plotQuadvarEigvals(fileName, timeSpan, outputDir);

dataName = strcat(fileName(1:end-4), '_', num2str(timeSpan(1)), '.mat');
dataDir = strcat(outputDir, 'data/');
load(strcat(dataDir, dataName));

h = figure(6); clf;
plotName = strcat(fileName(1:end-4), '_', num2str(timeSpan(1)), '.png');
plotDir = strcat(outputDir, 'quadvareigval/');
plotx      = 50;   % Screen position
ploty      = 50;   % Screen position
plotwidth  = 1000;  % Width of figure
plotheight = 400;  % Height of figure (by default in pixels)
set(h, 'Position', [plotx ploty plotwidth plotheight]);

subsample1 = find(tdata <= timeSpan(2));
subsample2 = find(tdata >  timeSpan(2));

plot(seconds(tdata(subsample1)), eigvals(subsample1,:), 'bx', 'durationtickformat','hh:mm:ss');
hold on;
plot(seconds(tdata(subsample2)), eigvals(subsample2,:), 'rx', 'durationtickformat','hh:mm:ss');
hold off;


% write title and axis labels
grid on
xlabel("Time");
ylabel("Eigenvalues");

% save to disk
if ~exist(plotDir, 'dir')
    mkdir(plotDir)
end
saveas(h,strcat(plotDir, plotName));

end
