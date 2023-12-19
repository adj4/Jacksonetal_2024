function [MvM, MvT, TvT, MvM_95sig, MvT_95sig, TvT_95sig, MvM_5sig, MvT_5sig, TvT_5sig, runIndex] = TEMPO_bursts(tempo, fs, markers, preWin, nshuffles, analysisStep, analysisWin, minSpeed, speedTracking, fps)

preWin = fs*preWin;
analysisStep = fs*analysisStep;
analysisWin = fs*analysisWin;

index = [-preWin:analysisStep:preWin];

markers = markers(markers-preWin >=1);
markers = markers(markers+preWin+analysisWin < size(tempo,2));

%%%%%
%Speed

markerFrames = round((markers/fs)*fps);
windowFrames = ((preWin/fs)*fps);

for ii=1:numel(markers)
    runSpeed(ii) = nanmean(speedTracking(markerFrames(ii)-windowFrames:markerFrames(ii)+windowFrames));
end

markers = markers(runSpeed >= minSpeed);

%%%%%

for ii=1:numel(markers)
    for jj = 1:numel(index)     
        MvM(jj,ii) = xcorr(tempo(1,(markers(ii)+index(jj)):(markers(ii)+index(jj)+analysisWin)),tempo(2,(markers(ii)+index(jj)):(markers(ii)+index(jj)+analysisWin)),0,'normalized'); %Perform cross correlation between both adjusted and filtered mNeons
        MvT(jj,ii) = xcorr(tempo(3,(markers(ii)+index(jj)):(markers(ii)+index(jj)+analysisWin)),tempo(4,(markers(ii)+index(jj)):(markers(ii)+index(jj)+analysisWin)),0,'normalized'); %Perform cross correlation between both adjusted and filtered mNeons
        TvT(jj,ii) = xcorr(tempo(1,(markers(ii)+index(jj)):(markers(ii)+index(jj)+analysisWin)),tempo(3,(markers(ii)+index(jj)):(markers(ii)+index(jj)+analysisWin)),0,'normalized'); %Perform cross correlation between both adjusted and filtered mNeons       
        
         R = ceil((size(tempo,2)*(0.1+(rand(1,nshuffles)*0.8)))); %to randomly choose time segments for shuffled data 
            for kk=1:nshuffles, %perform xcorr on shuffled right signal
                
                MvM_tmp(jj,kk) = xcorr(tempo(1,(markers(ii)+index(jj)):(markers(ii)+index(jj)+analysisWin)),tempo(2,(R(kk)+index(jj)):(R(kk)+index(jj)+analysisWin)),0,'normalized');
                MvT_tmp(jj,kk) = xcorr(tempo(3,(markers(ii)+index(jj)):(markers(ii)+index(jj)+analysisWin)),tempo(4,(R(kk)+index(jj)):(R(kk)+index(jj)+analysisWin)),0,'normalized');
                TvT_tmp(jj,kk) = xcorr(tempo(1,(markers(ii)+index(jj)):(markers(ii)+index(jj)+analysisWin)),tempo(3,(R(kk)+index(jj)):(R(kk)+index(jj)+analysisWin)),0,'normalized');
       
            end
    end

    MvM_95sig(:,ii) = prctile(MvM_tmp,95,2);
    MvT_95sig(:,ii) = prctile(MvT_tmp,95,2);
    TvT_95sig(:,ii) = prctile(TvT_tmp,95,2);
   
    MvM_5sig(:,ii) = prctile(MvM_tmp,5,2);
    MvT_5sig(:,ii) = prctile(MvT_tmp,5,2);
    TvT_5sig(:,ii) = prctile(TvT_tmp,5,2);

end

runIndex = index/fs;

end
