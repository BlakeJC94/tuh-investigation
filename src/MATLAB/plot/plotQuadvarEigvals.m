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
plotheight = 800;  % Height of figure (by default in pixels)
set(h, 'Position', [plotx ploty plotwidth plotheight]);

subsample1 = find(tdata <= timeSpan(2));
subsample2 = find(tdata >  timeSpan(2));

% % Plot eigenvalues
%
subplot(2,2,[1,2])
plot(seconds(tdata(subsample1)), eigvals(subsample1,:)/(freq^2), 'bx', 'durationtickformat','hh:mm:ss');
hold on;
plot(seconds(tdata(subsample2)), eigvals(subsample2,:)/(freq^2), 'rx', 'durationtickformat','hh:mm:ss');
hold off;
% write title and axis labels
grid on
title("Eigenvalues of quadratic covariate matrix (div by freq^2)")
xlabel("Time");
ylabel("Eigenvalues");


% % Plot eigenvectors
%
subplot(2,2,3);
plot(eigvecs(1,1,1), eigvecs(1,2,1), 'bs');
hold on;
plot(eigvecs(subsample1,1,1), eigvecs(subsample1,2,1), 'bo:');
plot(eigvecs(subsample1(end),1,1), eigvecs(subsample1(end),2,1), 'bx');
plot(eigvecs(subsample2,1,1), eigvecs(subsample2,2,1), 'ro:');
plot(eigvecs(end,1,1), eigvecs(end,2,1), 'rx');
hold off;
% write title and axis labels
grid on
axis square
xlim([-1,1]);
ylim([-1,1]);
title("1st eigenvector of quadratic covariate matrix")
xlabel("x");
ylabel("y");

subplot(2,2,4);
plot(eigvecs(1,1,2), eigvecs(1,2,2), 'bs');
hold on;
plot(eigvecs(subsample1,1,2), eigvecs(subsample1,2,2), 'bo:');
plot(eigvecs(subsample1(end),1,2), eigvecs(subsample1(end),2,2), 'bx');
plot(eigvecs(subsample2,1,2), eigvecs(subsample2,2,2), 'ro:');
plot(eigvecs(end,1,2), eigvecs(end,2,2), 'rx');
hold off;
% write title and axis labels
grid on
axis square
xlim([-1,1]);
ylim([-1,1]);
title("2nd eigenvector of quadratic covariate matrix")
xlabel("x");
ylabel("y");


% save to disk
if ~exist(plotDir, 'dir')
    mkdir(plotDir)
end
saveas(h,strcat(plotDir, plotName));

end
