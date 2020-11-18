function [directions1, directions2] = calcDirectionHist(xdata, ydata, tdata, timeSpan)



% patition tdata
subsample1 = find(tdata < timeSpan(2));
xdata1 = xdata(subsample1);
ydata1 = ydata(subsample1);
subsample2 = find(tdata >= timeSpan(2));
xdata2 = xdata(subsample2);
ydata2 = ydata(subsample2);

directions1 = atan2(diff(ydata1), diff(xdata1));
directions2 = atan2(diff(ydata2), diff(xdata2));


end

