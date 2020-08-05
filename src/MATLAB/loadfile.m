function [FZdata, CZdata, sample, freq, hdr, record] = loadfile(fileName, timeSpan)
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
FZch = findChannel(hdr, "[Ff][Zz]");
CZch = findChannel(hdr, "[Cc][Zz]");
FZdata = record(FZch, :);
CZdata = record(CZch, :);

% Parse timespans
FZfreq = hdr.frequency(FZch);
CZfreq = hdr.frequency(FZch);
if FZfreq ~= CZfreq
    disp("Fz and Cz frequencies are different?");
end
freq = FZfreq;

% get sample points of requested timeSpan
sample = (...
    max(fix(freq*timeSpan(1)),1)):...
    fix(freq*timeSpan(3)...
);

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
