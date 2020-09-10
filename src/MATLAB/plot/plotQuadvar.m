function plotQuadvar(fileName, timeSpan, outputDir)

dataName = strcat(fileName(1:end-4), '_', num2str(timeSpan(1)), '.mat');
dataDir = strcat(outputDir, 'data/');
load(strcat(dataDir, dataName));

h = figure(5); clf;
plotName = strcat(fileName(1:end-4), '_', num2str(timeSpan(1)), '.png');
plotDir = strcat(outputDir, 'quadvar/');
plotx      = 50;   % Screen position
ploty      = 50;   % Screen position
plotwidth  = 1000;  % Width of figure
plotheight = 1050;  % Height of figure (by default in pixels)
set(h, 'Position', [plotx ploty plotwidth plotheight]);



% Fz QV %%%%%%%%
subplot(3, 1, 1);
plotqvars(qvarxx,tdata,timeSpan,freq);
% write title and axis labels
grid on
xlabel("Time");
ylabel("Fz-ref Quadratic variation (div by freq^2)");




% Cz QV %%%%%%%%
subplot(3, 1, 2);
plotqvars(qvaryy,tdata,timeSpan,freq);
% write title and axis labels
grid on
xlabel("Time");
ylabel("Cz-ref Quadratic variation (div by freq^2)");



% FzCz QV %%%%%%%%
subplot(3, 1, 3);
plotqvars(qvarxy,tdata,timeSpan,freq);
% write title and axis labels
grid on
xlabel("Time");
ylabel("Fz-Cz Quadratic covariation (div by freq^2)");



% save to disk
if ~exist(plotDir, 'dir')
    mkdir(plotDir)
end
saveas(h,strcat(plotDir, plotName));



end

function plotqvars(qvar,tdata,timeSpan,freq)

    subsample1 = find(tdata <= timeSpan(2));
    subsample2 = find(tdata >  timeSpan(2));

    hold on;
    for iter = 1:size(qvar, 1)
        if iter == 1
            plot( ...
                seconds(qvar{1,2}(subsample1)), qvar{1,1}(subsample1)/(freq^2), ...
                'b-s','durationtickformat','hh:mm:ss' ...
            );
            plot( ...
                seconds(qvar{1,2}(subsample2)), qvar{1,1}(subsample2)/(freq^2), ...
                'r-s','durationtickformat','hh:mm:ss' ...
            );
        elseif iter == size(FZquadvar,1)
            plot( ...
                seconds(qvar{iter,2}(subsample1)), qvar{iter,1}(subsample1)/(freq^2), ...
                'b-o','durationtickformat','hh:mm:ss' ...
            );
            plot( ...
                seconds(qvar{iter,2}(subsample2)), qvar{iter,1}(subsample2)/(freq^2), ...
                'r-o','durationtickformat','hh:mm:ss' ...
            );
        else
            plot( ...
                seconds(qvar{end,2}(subsample1)), qvar{end,1}(subsample1)/(freq^2), ...
                'b:','durationtickformat','hh:mm:ss' ...
            );
            plot( ...
                seconds(qvar{end,2}(subsample2)), qvar{end,1}(subsample2)/(freq^2), ...
                'r:','durationtickformat','hh:mm:ss' ...
            );
        end
    end
    hold off;
end



