function plotQuadVar(fileName, timeSpan)

outputDir = './output/';
dataDir = strcat(outputDir, 'data/');
dataName = strcat(fileName(1:end-4), '_', num2str(timeSpan(1)), '.mat');
load(strcat(dataDir, dataName), 'tdata', 'qVarxx', 'qVaryy', 'qVarxy');

h = figure(2); clf;
plotName = strcat(fileName(1:end-4), '_', num2str(timeSpan(1)), '.png');
plotDir = strcat(outputDir, 'quadvar/');
plotx      = 50;   % Screen position
ploty      = 50;   % Screen position
plotwidth  = 1000;  % Width of figure
plotheight = 1050;  % Height of figure (by default in pixels)
set(h, 'Position', [plotx ploty plotwidth plotheight]);


plotCell{1,1} = qVarxx; plotCell{1,2} = "[X,X]/f^2";
plotCell{2,1} = qVaryy; plotCell{2,2} = "[Y,Y]/f^2";
plotCell{3,1} = qVarxy; plotCell{3,2} = "[X,Y]/f^2";
for i = 1:3
    subplot(3, 1, i);
    plotqvars(plotCell{i,1},tdata,timeSpan);
    grid on
    xlabel("Time");
    ylabel(plotCell{i,2});
end

% save to disk
if ~exist(plotDir, 'dir')
    mkdir(plotDir)
end
saveas(h,strcat(plotDir, plotName));

end

function plotqvars(qvar,tdata,timeSpan)

    freq = 1/diff(tdata(1:2));
    subsample1 = find(tdata < timeSpan(2));
    subsample2 = find(tdata >= timeSpan(2));
    plotStr = {'b-s', 'r-s'; 'b:', 'r:'; 'b-o', 'r-o'};
    
    hold on;
    for iter = 1:size(qvar, 1)
        if iter == 1
            mode = 1;
        elseif iter == size(FZquadvar,1)
            mode = 3;
        else
            mode = 2;
        end
        
        x1 = seconds(qvar{iter,2}(subsample1));
        y1 = qvar{iter,1}(subsample1)/(freq^2);
        plot(x1, y1, plotStr{mode, 1},'durationtickformat','hh:mm:ss');
        
        x2 = seconds(qvar{iter,2}(subsample2));
        y2 = qvar{iter,1}(subsample2)/(freq^2);
        plot(x2, y2, plotStr{mode, 2},'durationtickformat','hh:mm:ss');
        
    end
    hold off;
end



