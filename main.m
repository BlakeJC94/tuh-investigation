
addpath('./src/MATLAB/')

% qad time format convert
t = @(hour, min, sec)  hour*60*60 + min*60 + sec;

% Files and timespans
opts = containers.Map;

% LE Montages
opts('00000629_s001_t001.edf') = [t(0,1,30), t(0,1,50), t(0,1,50)];
opts('00000675_s001_t001.edf') = [t(0,1,47), t(0,1,57), t(0,2,17)];
opts('00000675_s001_t001.edf') = [t(0,4,10), t(0,4,26), t(0,4,42)];
opts('00000675_s002_t001.edf') = [t(0,3,10), t(0,3,25), t(0,3,30)];
opts('00000795_s001_t002.edf') = [t(0,3,20), t(0,3,31), t(0,3,41)];
opts('00001278_s001_t001.edf') = [t(0,2,33), t(0,2,43), t(0,2,47)];
opts('00001770_s003_t000.edf') = [t(0,1,19), t(0,1,20), t(0,1,30)];
opts('00001981_s004_t000.edf') = [t(0,5,5), t(0,5,20), t(0,5,22)];
opts('00001984_s001_t001.edf') = [t(0,4,53), t(0,5,7), t(0,5,15)];
opts('subject1.edf') = [t(0,0,40), t(0,0,60), t(0,0,60)];


% Construct and save fig for each (filename, timespan) pair
for filenamecell = keys(opts)

    filename = filenamecell{1};  % matlab map iteration is dumb
    timespan = opts(filename);

    eegdiffplot(filename, timespan);

    pause(1.5);

end

disp("Done!");
