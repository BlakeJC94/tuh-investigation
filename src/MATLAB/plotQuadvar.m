function plotQuadvar(fileName, timeSpan, outputDir)

dataName = strcat(fileName(1:end-4), '_', num2str(timeSpan(1)), '.mat');
dataDir = strcat(outputDir, 'data/');
load(strcat(dataDir, dataName));

h = figure(5); clf;
plotName = strcat(fileName(1:end-4), '_', num2str(timeSpan(1)), '.png');
plotDir = strcat(outputDir, 'quadvar/');
plotx      = 50;   % Screen position
ploty      = 50;   % Screen position
plotwidth  = 900;  % Width of figure
plotheight = 700;  % Height of figure (by default in pixels)
set(h, 'Position', [plotx ploty plotwidth plotheight]);


% Fz QV
subplot(2, 1, 1);

hold on;
for iter = 1:size(FZquadvar, 1)

    sample = FZquadvar{iter, 2};

    subsample1 = (sample <= freq*fix(timeSpan(2)));
    subsample2 = (sample >= freq*fix(timeSpan(2)));


    if iter == 1
        plot( ...
            seconds(sample(subsample1)/freq), FZquadvar{iter,1}(subsample1), ...
            'b-s','durationtickformat','hh:mm:ss' ...
        );
        plot( ...
            seconds(sample(subsample2)/freq), FZquadvar{iter,1}(subsample2), ...
            'r-s','durationtickformat','hh:mm:ss' ...
        );
    elseif iter == size(FZquadvar,1)

        plot( ...
            seconds(sample(subsample1)/freq), FZquadvar{iter,1}(subsample1), ...
            'b-o','durationtickformat','hh:mm:ss' ...
        );
        plot( ...
            seconds(sample(subsample2)/freq), FZquadvar{iter,1}(subsample2), ...
            'r-o','durationtickformat','hh:mm:ss' ...
        );

    else

        plot( ...
            seconds(sample(subsample1)/freq), FZquadvar{iter,1}(subsample1), ...
            'b:','durationtickformat','hh:mm:ss' ...
        );
        plot( ...
            seconds(sample(subsample2)/freq), FZquadvar{iter,1}(subsample2), ...
            'r:','durationtickformat','hh:mm:ss' ...
        );
    end

end

% write title and axis labels
grid on
xlabel("Time");
ylabel("Fz-ref Quadratic variation (\muV^2)");


% Cz QV
subplot(2, 1, 2);

hold on;
for iter = 1:size(CZquadvar, 1)

    sample = CZquadvar{iter,2};

    subsample1 = (sample <= freq*fix(timeSpan(2)));
    subsample2 = (sample >= freq*fix(timeSpan(2)));

    if iter == 1
        plot( ...
            seconds(sample(subsample1)/freq), CZquadvar{iter,1}(subsample1), ...
            'b-s','durationtickformat','hh:mm:ss' ...
        );
        plot( ...
            seconds(sample(subsample2)/freq), CZquadvar{iter,1}(subsample2), ...
            'r-s','durationtickformat','hh:mm:ss' ...
        );
    elseif iter == size(CZquadvar,1)

        plot( ...
            seconds(sample(subsample1)/freq), CZquadvar{iter,1}(subsample1), ...
            'b-o','durationtickformat','hh:mm:ss' ...
        );
        plot( ...
            seconds(sample(subsample2)/freq), CZquadvar{iter,1}(subsample2), ...
            'r-o','durationtickformat','hh:mm:ss' ...
        );

    else

        plot( ...
            seconds(sample(subsample1)/freq), CZquadvar{iter,1}(subsample1), ...
            'b:','durationtickformat','hh:mm:ss' ...
        );
        plot( ...
            seconds(sample(subsample2)/freq), CZquadvar{iter,1}(subsample2), ...
            'r:','durationtickformat','hh:mm:ss' ...
        );
    end

end
hold off;

% write title and axis labels
grid on
xlabel("Time");
ylabel("Cz-ref Quadratic variation (\muV^2)");

% save to disk
if ~exist(plotDir, 'dir')
    mkdir(plotDir)
end
saveas(h,strcat(plotDir, plotName));



end
