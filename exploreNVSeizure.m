function exploreNVSeizure()

addpath('./src/plot/')
t = @(hour, min, sec) hour*60*60 + min*60 + sec;
tspn = @(t) [max(t - 30, 0) , t, t + 30];

SeizureName = 'Seizure_003.mat';
tSpan = [t(0,4,0), t(0,6,0), t(0,6,0)];

plotNVSeizure(SeizureName, tSpan);

end

