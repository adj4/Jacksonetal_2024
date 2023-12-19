function [MvM, MvT, MvM_95p, MvM_5p, runIndex] = TEMPO_EPMruns(tempo, fs, markers, preWin, nshuffles, analysisStep, analysisWin, minSpeed, speedTracking, fps)

preWin = fs*preWin;         % convert window lengths to indexes
analysisStep = fs*analysisStep;
analysisWin = fs*analysisWin;

index = [-preWin:analysisStep:preWin];

markers = markers(markers-preWin >=1);          % remove any behavior markers that precede first data index
markers = markers(markers+preWin+analysisWin <= size(tempo,2));         % remove any behavior markers that excede final data index

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
         MvM(jj,ii) = xcorr(tempo(1,(markers(ii)+index(jj)):(markers(ii)+index(jj)+analysisWin)),tempo(3,(markers(ii)+index(jj)):(markers(ii)+index(jj)+analysisWin)),0,'normalized'); %Perform cross correlation between both adjusted and filtered mNeons
         MvT(jj,ii) = xcorr(tempo(1,(markers(ii)+index(jj)):(markers(ii)+index(jj)+analysisWin)),tempo(4,(markers(ii)+index(jj)):(markers(ii)+index(jj)+analysisWin)),0,'normalized'); %Perform cross correlation between left mNeon and right tdTomato - for investigating level of tdTomato contamination still present
         TvT(jj,ii) = xcorr(tempo(2,(markers(ii)+index(jj)):(markers(ii)+index(jj)+analysisWin)),tempo(4,(markers(ii)+index(jj)):(markers(ii)+index(jj)+analysisWin)),0,'normalized'); %Perform cross correlation between left mNeon and right tdTomato - for investigating level of tdTomato contamination still present

         R = ceil((size(tempo,2)*(0.1+(rand(1,nshuffles)*0.8)))); %to randomly choose time segments for shuffled data 
            for kk=1:nshuffles, %perform xcorr on shuffled right signal
                tmp(jj,kk) = xcorr(tempo(1,(markers(ii)+index(jj)):(markers(ii)+index(jj)+analysisWin)),tempo(3,(R(kk)+index(jj)):(R(kk)+index(jj)+analysisWin)),0,'normalized');
            end
    end

    MvM_95p(:,ii) = prctile(tmp,95,2);
    MvM_5p(:,ii) = prctile(tmp,5,2);

end

runIndex = index/fs;

end
