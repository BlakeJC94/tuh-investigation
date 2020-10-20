function plotQuadVarEigVals(fileName, timeSpan)

outputDir = './output/';
dataDir = strcat(outputDir, 'data/');
dataName = strcat(fileName(1:end-4), '_', num2str(timeSpan(1)), '.mat');
load(strcat(dataDir, dataName), 'tdata', 'eigVals', 'eigVecs');

h = figure(3); clf;
plotName = strcat(fileName(1:end-4), '_', num2str(timeSpan(1)), '.png');
plotDir = strcat(outputDir, 'quadvareigval/');
plotx      = 50;   % Screen position
ploty      = 50;   % Screen position
plotwidth  = 1000;  % Width of figure
plotheight = 800;  % Height of figure (by default in pixels)
set(h, 'Position', [plotx ploty plotwidth plotheight]);

subsample1 = find(tdata < timeSpan(2));
subsample2 = find(tdata >=  timeSpan(2));
freq = 1/diff(tdata(1:2));

% % Plot eigenvalues
%
subplot(3,5,1:10)
x1 = seconds(tdata(subsample1));
y1 = eigVals(:, subsample1)/(freq^2);
plot(x1, y1, 'bx', 'durationtickformat','hh:mm:ss');
hold on;
x2 = seconds(tdata(subsample2));
y2 = eigVals(:, subsample2)/(freq^2);
plot(x2, y2, 'rx', 'durationtickformat','hh:mm:ss');
hold off;
% write title and axis labels
grid on
title("Eigenvalues of quadratic covariate matrix (div by freq^2)")
xlabel("Time");
ylabel("Eigenvalues");


% % Plot eigenvectors
%
for i = 1:2
    
    subplot(2,2,2+i);
    
    x1 = eigVecs(i,1,1);
    y1 = eigVecs(i,2,1);
    plot([x1 -x1],[y1, -y1],'bs');
    
    hold on;
    
    x2 = eigVecs(i,1,subsample1); x2 = reshape(x2, [1,length(x2)]);
    y2 = eigVecs(i,2,subsample1); y2 = reshape(y2, [1,length(y2)]);
    plot([x2 -x2],[y2, -y2],'bo:');
    
    x3 = eigVecs(i,1,subsample1(end));
    y3 = eigVecs(i,2,subsample1(end));
    plot([x3 -x3],[y3, -y3],'bx');
    
    x4 = eigVecs(i,1,subsample2); x4 = reshape(x4, [1,length(x4)]);
    y4 = eigVecs(i,2,subsample2); y4 = reshape(y4, [1,length(y4)]);
    plot([x4 -x4],[y4, -y4],'ro:');
    
    x5 = eigVecs(i,1,subsample2(end));
    y5 = eigVecs(i,2,subsample2(end));
    plot([x5 -x5],[y5, -y5],'rx');

    hold off;
    
    % write title and axis labels
    grid on; axis square;
    xlim([-1,1]); ylim([-1,1]);
    titleStr = strcat("eigenvector ", num2str(i), " of QV matrix");
    title(titleStr);
    xlabel("x"); ylabel("y");
    
end

% for i = 1:5
%     
%     subplot(3,5, 10+i);
%     
%     x1 = 
%     y1 = 
% 
% end



% save to disk
if ~exist(plotDir, 'dir')
    mkdir(plotDir)
end
saveas(h,strcat(plotDir, plotName));


end
