function qvar = calcQuadVar(data1, data2, tdata, sRateFactors, windowLength)
% Calculates quadratic variation process for a variety of sample rates
% Plot results with
%   sample = quadvar{iter,2}
%   plot(seconds(sample/freq), quadvar{iter,1}(sample))

if nargin < 4
    sRateFactors = linspace(0.05, 1, 30);
    % sRateFactors = [1/16 1/8 1/4 1/2 1];
end
qvar = cell(length(sRateFactors), 2);

sample = 1:length(tdata);

for iter = 1:length(sRateFactors)

    sfact = sRateFactors(iter);

    % downsample the data
    downsample = [1:round(1/sfact):length(sample)];
    qvar{iter,2} = tdata(downsample);

    tmpdata1 = data1(downsample);
    tmpdata2 = data2(downsample);

    result = zeros(size(tmpdata1));
    result(1) = (tmpdata1(2) - tmpdata1(1)).*(tmpdata2(2) - tmpdata2(1));
    for ind = 2:length(tmpdata1)
        result(ind) = result(ind-1) + (tmpdata1(ind) - tmpdata1(ind-1)).*(tmpdata2(ind) - tmpdata2(ind-1));
    end

    qvar{iter,1} = result;

end


end
