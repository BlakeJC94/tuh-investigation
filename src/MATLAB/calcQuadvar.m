function quadvar = calcQuadvar(data)
% Calculates quadratic variation process

quadvar = zeros(size(data));
quadvar(1) = (data(2) - data(1)).^2;
for ind = 2:length(data)
    quadvar(ind) = quadvar(ind-1) + (data(ind) - data(ind-1)).^2;
end

end
