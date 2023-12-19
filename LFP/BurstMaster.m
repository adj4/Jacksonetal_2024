%behaviourDuration = 30*60;
fps = 30;

params.tapers = [3 5];
params.Fs = 2000;
params.fpass = [13 30];
burst_threshold = 0.8;

ch1_name = 'BLA';
ch2_name = 'VHC';

[filenames fileroot] = uigetfile('pick', 'MultiSelect', 'ON');

if ~iscell(filenames)
   filenames = {filenames};
end 

for mm = 1:numel(filenames)
       load(filenames{mm})

    fprintf('Running %s ...\n', filenames{mm})

[burstStart, burstEnd, burstIndex, burstDensityFull, burstFreqFull, startIndex, endIndex, durationIndex] = burstIdentifier(fileInfo, ch1_name, ch2_name, params, fps, burst_threshold);

save(filenames{mm})

end

clearvars params ch1_name ch2_name burst_threshold

function [burstStart, burstEnd, burstIndex, burstDensityFull, burstFreqFull, startIndex, endIndex, durationIndex] = burstIdentifier(fileInfo, ch1_name, ch2_name, params, fps, burst_threshold)

ch1 = find(contains(fileInfo.channels, ch1_name)); % select channel 1
ch2 = find(contains(fileInfo.channels, ch2_name)); % select channel 2
     
[C,phi,S12,S1,S2,t,f]=cohgramc(fileInfo.rawdata(:,ch1),fileInfo.rawdata(:,ch2),[1 0.05],params);
K = 0.023*ones(7);
smoothC = conv2(C',K,'same');
idx= smoothC > burst_threshold;

clusters = regionprops(idx, 'Area', 'BoundingBox', 'PixelIdxList');
  
if numel(clusters) == 0
else
for kk = 1:numel(clusters)
    timeLow(kk) = t(floor(clusters(kk).BoundingBox(1)));
    timeHigh(kk) = t(ceil(clusters(kk).BoundingBox(1)) + (clusters(kk).BoundingBox(3) - 1));
    timeDuration(kk) = timeHigh(kk) - timeLow(kk);
    if timeDuration(kk) == 0
       timeDuration(kk) = t(2)-t(1);
    end
    burstStart(kk) = round(timeLow(kk)*30);
    burstEnd(kk) = round(burstStart(kk) + (timeDuration(kk)*30));
    startIndex(kk) = round(timeLow(kk)*2000);
    endIndex(kk) = round(timeHigh(kk)*2000);
    durationIndex(kk) = endIndex(kk) - startIndex(kk);
end
end

burstIndex = zeros(floor((size(fileInfo.rawdata,1)/2000)*fps),1);
 
for ii = 1:numel(burstStart)
    burstIndex(burstStart(ii):burstEnd(ii)) = 1;
end

burstDensityFull = mean(burstIndex);

burstFreqFull = numel(clusters) / (size(fileInfo.rawdata,1)/2000);


end