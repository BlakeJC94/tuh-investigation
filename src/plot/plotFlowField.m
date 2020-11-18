function plotFlowField(fileName, timeSpan)

lineWidth = 1.25;

outputDir = './output/';
dataDir = strcat(outputDir, 'data/');
dataName = strcat(fileName(1:end-4), '_', num2str(timeSpan(1)), '.mat');
load(strcat(dataDir, dataName), 'flowField', 'flowField1', 'flowField2');

h = figure(10); clf;
plotName = strcat(fileName(1:end-4), '_', num2str(timeSpan(1)), '.png');
plotDir = strcat(outputDir, 'flow/');
plotx      = 50;   % Screen position
ploty      = 50;   % Screen position
plotwidth  = 600;  % Width of figure
plotheight = 500;  % Height of figure (by default in pixels)
set(h, 'Position', [plotx ploty plotwidth plotheight]);

x = flowField{1};
y = flowField{2};
u = flowField{3};
v = flowField{4};
axis square;
q = quiver(x,y,u,v, 'k');
q.LineWidth = lineWidth;
% normalise plotting region
plotmin = min(min(x(:)), min(y(:)));
plotmax = max(max(x(:)), max(y(:)));
axis([plotmin,plotmax, plotmin, plotmax]);
grid on;
% write title and axis labels
title(fileName, 'Interpreter', 'none');
xlabel("\muV");
ylabel("\muV");
% save output
if ~exist(plotDir, 'dir')
    mkdir(plotDir)
end
saveas(h,strcat(plotDir, plotName));



h = figure(11); clf;
plotName = strcat(fileName(1:end-4), '_', num2str(timeSpan(1)), '.png');
plotDir = strcat(outputDir, 'flow2/');
plotx      = 50;   % Screen position
ploty      = 50;   % Screen position
plotwidth  = 1200;  % Width of figure
plotheight = 500;  % Height of figure (by default in pixels)
set(h, 'Position', [plotx ploty plotwidth plotheight]);

subplot(1,2,1);
x = flowField1{1};
y = flowField1{2};
u = flowField1{3};
v = flowField1{4};

axis square;
q = quiver(x,y,u,v, 'b');
q.LineWidth = lineWidth;
% normalise plotting region
plotmin = min(min(x(:)), min(y(:)));
plotmax = max(max(x(:)), max(y(:)));
axis([plotmin,plotmax, plotmin, plotmax]);
grid on;
% write title and axis labels
title(fileName, 'Interpreter', 'none');
xlabel("\muV");
ylabel("\muV");

subplot(1,2,2);
x = flowField2{1};
y = flowField2{2};
u = flowField2{3};
v = flowField2{4};

axis square;
q = quiver(x,y,u,v, 'r');
q.LineWidth = lineWidth;
% normalise plotting region
plotmin = min(min(x(:)), min(y(:)));
plotmax = max(max(x(:)), max(y(:)));
axis([plotmin,plotmax, plotmin, plotmax]);
grid on;
% write title and axis labels
title(fileName, 'Interpreter', 'none');
xlabel("\muV");
ylabel("\muV");

if ~exist(plotDir, 'dir')
    mkdir(plotDir)
end
saveas(h,strcat(plotDir, plotName));

end

