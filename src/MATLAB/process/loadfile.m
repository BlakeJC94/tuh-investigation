function [xdata, ydata, tdata, freq, hdr, record] = loadfile(fileName, timeSpan, chx, chy)
% Function that identifies fileName and loads EDF snippet
%

% find directory
allfiles = struct2cell(dir('./edf/dev/**/*.edf'));
for ind = 1:size(allfiles,2)
    label = allfiles{1,ind};
    if ~isempty(regexp(label, fileName, "once"))
        fileDir = allfiles{2,ind};
        break
    end
end

% error out if fileName isn't found
if ~exist('fileDir')
    error('B: file not found')
end

% load edf
[hdr, record] = edfread(strcat(fileDir, '/', fileName));



% extract channels of interest
nchx = findChannel(hdr, chx);
nchy = findChannel(hdr, chy);

% get frequency
freq = hdr.frequency(nchx);

% get start/endpoints of time series
sampleStart = max(fix(freq*timeSpan(1)),1));
sampleEnd = fix(freq*timeSpan(3));
sample = sampleStart:sampleEnd;

% pull sample
xdata = record(nchx, sample);
ydata = record(nchy, sample);
tdata = sample/freq;

end


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
