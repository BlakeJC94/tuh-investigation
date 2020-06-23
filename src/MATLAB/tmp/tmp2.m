dataDir = 'edf/dev/02_tcp_le/006/00000675/s001_2003_11_10/';
edfName = '00000675_s001_t001.edf';

[hdr, record] = edfread(strcat(dataDir, edfName));

timespan1 = [4*60+10, 4*60+26];  % (seconds)
timespan2 = [4*60+26, 4*60+42];

% Here we will only look at the centre channels,
% the chosen cahnnels should correspond to Fz and Cz

FZch = findChannel(hdr, "FZ");
CZch = findChannel(hdr, "CZ");

FZdata = record(FZch, :);
CZdata = record(CZch, :);

% Trim data to particular event

FZfreq = hdr.frequency(FZch);
sample1 = (max(fix(FZfreq*timespan1(1)),1)):(fix(FZfreq*timespan1(2)));
sample2 = (max(fix(FZfreq*timespan2(1)),1)):(fix(FZfreq*timespan2(2)));

CZfreq = hdr.frequency(FZch);
sample1 = (max(fix(CZfreq*timespan1(1)),1)):(fix(CZfreq*timespan1(2)));
sample2 = (max(fix(CZfreq*timespan2(1)),1)):(fix(CZfreq*timespan2(2)));

% Plot trace

figure(1);
clf;

hold on;
plot(FZdata(sample1), CZdata(sample1), 'b:');
plot(FZdata(sample2), CZdata(sample2), 'r:');
hold off;

title("Test of eeg diffusion plot");
xlabel("Fz-ref (\mu V)"); ylabel("Cz-ref (\mu V)");






function ch = findChannel(hdr, chstr)
    labels = hdr.label;
    for ind = 1:length(labels)
        label = labels{ind};
        if ~isempty(regexp(label, chstr, "once"))
            ch = ind;
            break
        end
    end
end
