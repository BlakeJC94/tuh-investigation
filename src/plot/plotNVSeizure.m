function plotNVSeizure(SeizureName, tSpan)
%PLOTSEIZURE Simple function to plot iEEG after loading MAT file
%
% Parameters
% ----------
% Seizure : array
%     matrix indexed by (timestep, channel)
spacing = 100;
freq = 400;

fileDir = './data/nv_seizures/';
filePath = strcat(fileDir, SeizureName);
load(filePath, 'Seizure');

if nargin == 1 || isempty(tSpan)
    sample = 1:size(Seizure, 1);
else
    sampleStart = max(fix(freq*tSpan(1)),1);
    sampleEnd = fix(freq*tSpan(2));
    sample = sampleStart:sampleEnd;
end

tdata = sample/freq;
xdata = Seizure(sample, :);

figure(1); clf;
hold on
nCh = size(Seizure, 2);
for ch = 1:nCh
    x1 = seconds(tdata);
    y1 = (ch-ceil(nCh/2))*spacing + xdata(:,ch);
    plot(x1, y1,'DurationTickFormat','hh:mm:ss');
end
hold off
xlabel("Time");
grid on;



end

