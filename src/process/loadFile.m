function [xdata, ydata, tdata] = loadFile(fileName, timeSpan, chx, chy)
% Function that identifies fileName and loads EDF snippet

% load dependencies
addpath('./src/process/edf-tools/');

if fileName(end-2:end) == 'edf'  % tuh_data case

    % find directory
    allfiles = struct2cell(dir('./data/edf/dev/**/*.edf'));
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
    filePath = strcat(fileDir, '/', fileName);
    [hdr, record] = edfread(filePath);
    
    % extract channels of interest
    nchx = findChannel(hdr, chx);
    nchy = findChannel(hdr, chy);
    
    % get frequency
    freq = hdr.frequency(nchx);
    % get start/endpoints of time series
    sampleStart = max(fix(freq*timeSpan(1)),1);
    sampleEnd = fix(freq*timeSpan(3));
    sample = sampleStart:sampleEnd;

    % pull sample
    xdata = record(nchx, sample);
    ydata = record(nchy, sample);
    tdata = sample/freq;
    
elseif fileName(end-2:end) == 'mat'  % nv_seizures case
    
    % load file
    fileDir = './data/nv_seizures';
    filePath = strcat(fileDir, '/', fileName);
    load(filePath, 'Seizure');
    
    % declare tmp vars
    freq = 400;
    nchx = 1; nchy = 2;
    
    % get start/endpoints of time series
    sampleStart = max(fix(freq*timeSpan(1)),1);
    sampleEnd = fix(freq*timeSpan(3));
    sample = sampleStart:sampleEnd;
    
    % pull sample
    xdata = Seizure(sample, nchx);
    ydata = Seizure(sample, nchy);
    tdata = sample/freq;
    
end

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
