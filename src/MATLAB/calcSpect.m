function [F, P1] = calcSpect(Y, freq)
    L = length(Y);
    S = fft(Y);
    % Compute 2-sided spectrum P2 and 1-sided spectrum P1
    P2 = abs(S/L);
    P1 = P2(1:floor(L/2)+1);
    P1(2:end-1) = 2*P1(2:end-1);
    % Frequency domain
    F = freq*(0:floor(L/2))/L;
end
