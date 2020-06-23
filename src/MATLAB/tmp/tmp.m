dataDir = 'edf/dev/02_tcp_le/006/00000675/s001_2003_11_10/';
edfName = '00000675_s001_t001.edf';

[hdr, record] = edfread(strcat(dataDir, edfName));

timespan = [4*60+10, 4*60+26];  % (seconds)

% Here we will only look at the centre channels,
% the chosen cahnnels should correspond to Fz and Cz

FZch = findChannel(hdr, "FZ");
CZch = findChannel(hdr, "CZ");

FZdata = record(FZch, :);
CZdata = record(CZch, :);

% Trim data to particular event

FZfreq = hdr.frequency(FZch);
sample = (max(fix(FZfreq*timespan(1)),1)):(fix(FZfreq*timespan(2)));
FZdata = FZdata(sample);

CZfreq = hdr.frequency(FZch);
sample = (max(fix(CZfreq*timespan(1)),1)):(fix(CZfreq*timespan(2)));
CZdata = CZdata(sample);

% Plot trace

figure(1);

plot(FZdata, CZdata);

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
