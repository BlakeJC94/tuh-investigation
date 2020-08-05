function quadvar = calcQuadvar(data, sample)
% Calculates quadratic variation process for a variety of sample rates
% Plot results with
%   sample = quadvar{iter,2}
%   plot(seconds(sample/freq), quadvar{iter,1}(sample))

sRateFactors = linspace(0.05, 1, 30); %[1/16 1/8 1/4 1/2 1];
quadvar = cell(length(sRateFactors),2);

for iter = 1:length(sRateFactors)

    sfact = sRateFactors(iter);

    % downsample the data
    downsample = [1:round(1/sfact):length(sample)];
    quadvar{iter,2} = sample(downsample);

    tmpdata = data(downsample);

    result = zeros(size(tmpdata));
    result(1) = (tmpdata(2) - tmpdata(1)).^2;
    for ind = 2:length(tmpdata)
        result(ind) = result(ind-1) + (tmpdata(ind) - tmpdata(ind-1)).^2;
    end

    quadvar{iter,1} = result;

end


end
