function [disttrav, speed, accel] = calcMotion(data1, data2, freq)
% Calculates "motion" of particle: distance travelled, speed, acceleration

timeSeries = [data1(:), data2(:)];  % indexed by (sample, position)

disttrav = cumsum( ...
    vecnorm( ...
        diff(timeSeries, 1), ...
        2, 2 ...
    ), 1 ...
);

speed = freq.*vecnorm( ...
    diff(timeSeries, 1), ...
    2, 2 ...
);

accel = freq^2 .* diff(speed);

% distance = vecnorm(...
%     cumsum(timeSeries(:, [1,2]), 1)/freq,...
%     2, 2 ...
% );
% speed = vecnorm(...
%     timeSeries(:, [1,2]),...
%     2, 2 ...
% );
% accel = vecnorm(...
%     diff(timeSeries(:, [1,2]), 1)*freq,...
%     2, 2 ...
% );


end
