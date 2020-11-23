function [directions1, directions2] = calcDirectionHist(xdata, ydata, tdata, timeSpan, windowLength)

if nargin < 5
    windowLength = 3;
end

% patition tdata
subsample1 = find(tdata < timeSpan(2));
xdata1 = xdata(subsample1);
ydata1 = ydata(subsample1);
subsample2 = find(tdata >= timeSpan(2));
xdata2 = xdata(subsample2);
ydata2 = ydata(subsample2);

% smooth data
data1sm = smoothData(xdata1, ydata1, windowLength);
data2sm = smoothData(xdata2, ydata2, windowLength);

directions1 = atan2(diff(data1sm(2,:)), diff(data1sm(1,:)));
directions2 = atan2(diff(data2sm(2,:)), diff(data2sm(1,:)));


end

function dataSm = smoothData(xdata, ydata, windowLength)

downSample = max([floor(length(xdata)/windowLength),1]);
dataSm = zeros(2,downSample);
for i = 1:downSample
    beginInd = (i-1)*windowLength+1;
    endInd = min(i*windowLength, length(xdata));
    dataSm(1,i) = mean(xdata(beginInd:endInd));
    dataSm(2,i) = mean(ydata(beginInd:endInd));
end

end
