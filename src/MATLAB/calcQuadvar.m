function [quadvars samples] = calcQuadvar(data, sample)
% Calculates quadratic variation process for a variety of sample rates
% Plot results with
%   plot(seconds(sample{iter}/freq), quadvars{iter})

sRatefactors = [1/16 1/8 1/4 1/2 1];

for iter = 1:length(sRates)

    sfact = sRatefactors(iter);

    % downsample the data
    downsample = 1:round(1/sfact):length(sample);
    samples{iter} = sample(downsample);

    tmpdata = data(downsample);

    result = zeros(size(tmpdata));
    result(1) = (tmpdata(2) - tmpdata(1)).^2;
    for ind = 2:length(tmpdata)
        result(ind) = result(ind-1) + (tmpdata(ind) - tmpdata(ind-1)).^2;
    end


    quadvar{iter} = result;

end


end
