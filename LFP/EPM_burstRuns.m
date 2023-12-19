function [pre_speed post_speed speed pre_burstNumber post_burstNumber pre_burstDensity post_burstDensity burstProb burstProbZ] = EPM_burstRuns(burstIndex, burstStart, markers, speedTracking, preWin, nshuffles, analysisStep, fps, fs)

preWin = fps*preWin;
analysisStep = floor(fps*analysisStep);

markers = floor((markers/fs)*fps);

markers = markers((markers+preWin)<=numel(burstIndex));   % Check that analysis window does not exceed data length
markers = markers((markers+preWin)<=numel(burstIndex));   % Check that analysis window does not exceed data length
markers = markers((markers-preWin)>=1);   % Check that analysis window does not exceed data length


index = floor([-preWin:analysisStep:preWin]);

probWindow = floor(numel(burstIndex)/analysisStep);
temp_burstIndex = burstIndex(1:probWindow*analysisStep);

burstProb_mean = mean(mean(reshape(temp_burstIndex, [analysisStep probWindow])));
burstProb_std = std(mean(reshape(temp_burstIndex, [analysisStep probWindow])));



for ii = 1:numel(markers)

    pre_speed(ii) = nanmean(speedTracking(markers(ii)-preWin:markers(ii)));
    post_speed(ii) = nanmean(speedTracking(markers(ii):markers(ii)+preWin));
    
    speed(:,ii) = speedTracking(markers(ii)-preWin:markers(ii)+preWin);
    
    pre_speed(ii)=nan;
    post_speed(ii)=nan;
    speed(ii)=nan;
    
    pre_burstNumber(ii) =  sum(burstStart >= markers(ii)-preWin & burstStart <= markers(ii));
    post_burstNumber(ii) =  sum(burstStart >= markers(ii) & burstStart <= markers(ii)+preWin);
    
    pre_burstDensity(ii) = nanmean(burstIndex(markers(ii)-preWin:markers(ii)));
    post_burstDensity(ii) = nanmean(burstIndex(markers(ii):markers(ii)+preWin));
    
    for kk = 1:numel(index)
        burstProb(kk,ii) = nanmean(burstIndex(markers(ii)+index(kk):markers(ii)+index(kk)+analysisStep));
        burstProbZ(kk,ii) = (burstProb(kk,ii) - burstProb_mean)/burstProb_std;
    end
     
end

end