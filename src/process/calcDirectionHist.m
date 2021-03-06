function [binEdges, binCounts1, binCounts2, times1, times2] = calcDirectionHist(xdata, ydata, tdata, timeSpan, dirThreshold)

% patition tdata
subsample1 = (tdata < timeSpan(2));
tdata1 = tdata(subsample1);
xdata1 = xdata(subsample1);
ydata1 = ydata(subsample1);

subsample2 = (tdata >= timeSpan(2));
tdata2 = tdata(subsample2);
xdata2 = xdata(subsample2);
ydata2 = ydata(subsample2);


% calculate angle of each step
theta1 = atan2(diff(ydata1), diff(xdata1));
theta2 = atan2(diff(ydata2), diff(xdata2));

% find differnce in angles between steps
dtheta1 = wrapToPi(diff(theta1));
dtheta2 = wrapToPi(diff(theta2));

% find when angle difference exceeds threshold 
ind1 = (abs(dtheta1) > dirThreshold);
ind2 = (abs(dtheta2) > dirThreshold);

% record inter-interval durations
times1 = diff(tdata1(ind1));
times2 = diff(tdata2(ind2));

% remove interval times that are too small
freq = 1/diff(tdata(1:2));
times1 = times1(times1 > 4/freq);
times2 = times2(times2 > 4/freq);



% smooth trajectories with MA filter
xdata1sm = smooth(xdata1);
ydata1sm = smooth(ydata1);
xdata2sm = smooth(xdata2);
ydata2sm = smooth(ydata2);

% Calculate angle of each smoothened step
theta1 = atan2(diff(ydata1sm), diff(xdata1sm));
theta2 = atan2(diff(ydata2sm), diff(xdata2sm));

% weight each measurement by length of step
lengths1 = sqrt(diff(xdata1sm).^2 + diff(ydata1sm).^2);
lengths2 = sqrt(diff(xdata2sm).^2 + diff(ydata2sm).^2);

binEdges = (pi/180).*(-180:6:180);
binCounts1 = zeros(1, length(binEdges)-1);
binCounts2 = zeros(1, length(binEdges)-1);

for i = 1:(length(binEdges)-1)
    ind1 = (theta1 >= binEdges(i)) & (theta1 < binEdges(i+1));
    ind2 = (theta2 >= binEdges(i)) & (theta2 < binEdges(i+1));
    
    binCounts1(i) = sum(lengths1(ind1));
    binCounts2(i) = sum(lengths2(ind2));

end


end


