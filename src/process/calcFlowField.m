function [flowField, flowField1, flowField2] = calcFlowField(xdata, ydata, tdata, timeSpan, spacing)

flowField = [];
flowField1 = [];
flowField2 = [];

% Construct lattice
xlattice = min(xdata)-2*spacing:spacing:max(xdata)+2*spacing;
ylattice = min(ydata)-2*spacing:spacing:max(ydata)+2*spacing;

% patition tdata
subsample1 = find(tdata < timeSpan(2));
xdata1 = xdata(subsample1);
ydata1 = ydata(subsample1);
subsample2 = find(tdata >= timeSpan(2));
xdata2 = xdata(subsample2);
ydata2 = ydata(subsample2);

% Calculate flow fields
flowField = quiverInput(xdata, ydata, xlattice, ylattice, spacing);
flowField1 = quiverInput(xdata1, ydata1, xlattice, ylattice, spacing);
flowField2 = quiverInput(xdata2, ydata2, xlattice, ylattice, spacing);


end


function flowField = quiverInput(xdata, ydata, xlattice, ylattice, spacing)

flowField = cell(1,4);

[xlattice, ylattice] = meshgrid(xlattice, ylattice);

x = xlattice;
y = ylattice;

u = zeros(size(xlattice));
v = zeros(size(xlattice));

if length(xdata) > 10
 
    udata = diff(xdata);
    vdata = diff(ydata);
    xdata = xdata(1:end-1);
    ydata = ydata(1:end-1);
    
    for i = 1:size(x,1)
        for j = 1:size(x,2)
            
            xord = x(i,j);
            yord = y(i,j);
            
            xtmp = (abs(xdata-xord) <= spacing/2);
            ytmp = (abs(ydata-yord) <= spacing/2);
            tmp = (xtmp & ytmp);
            if max(tmp) == 0
                u(i,j) = 0;
                v(i,j) = 0;
            else
                try
                    u(i,j) = mean(udata(tmp));
                catch E
                    disp(E)
                    keyboard;
                end
                v(i,j) = mean(vdata(tmp));
%                 normlen = sqrt(u(i,j)^2 + v(i,j)^2);
%                 u(i,j) = (spacing/2)*ulattice(i,j)/normlen;
%                 v(i,j) = (spacing/2)*vlattice(i,j)/normlen;
            end
        end
    end
    
end

flowField{1} = x;
flowField{2} = y;
flowField{3} = u;
flowField{4} = v;

end

