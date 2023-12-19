preWin = 5;
analysisStep = 0.5;
fps = 30;
fs = 2000;
nshuffles = 100;
params.tapers = [3 5];
params.Fs = 2000;
params.fpass = [0.1 80];
ch1_name = 'VHC';
ch2_name = 'BLA';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load data

[filenames fileroot] = uigetfile('pick', 'MultiSelect', 'ON');

if ~iscell(filenames)
   filenames = {filenames};
end 

for mm = 1:numel(filenames)
    
    load(filenames{mm})

    fprintf('Running %s ...\n', filenames{mm})

% 
% % center 2 closed
[cen2c_pre_speed{mm} cen2c_post_speed{mm} cen2c_speed{mm} cen2c_pre_burstNumber{mm} cen2c_post_burstNumber{mm} cen2c_pre_burstDensity{mm} cen2c_post_burstDensity{mm} cen2c_burstProb{mm} cen2c_burstProbZ{mm}] = EPM_burstRuns(burstIndex, burstStart, closedStarts, speedFrame, preWin, nshuffles, analysisStep, fps, fileInfo.sampleRate);
% 
% % center 2 open
[cen2o_pre_speed{mm} cen2o_post_speed{mm} cen2o_speed{mm} cen2o_pre_burstNumber{mm} cen2o_post_burstNumber{mm} cen2o_pre_burstDensity{mm} cen2o_post_burstDensity{mm} cen2o_burstProb{mm} cen2o_burstProbZ{mm}] = EPM_burstRuns(burstIndex, burstStart, openStarts, speedFrame, preWin, nshuffles, analysisStep, fps, fileInfo.sampleRate);
% 
% % Zones
[closedDensity(mm), openDensity(mm), centerDensity(mm), center2closedDensity(mm), center2openDensity(mm), closed_burstNumber{mm}, open_burstNumber{mm}, center_burstNumber{mm}, center2closed_burstNumber{mm}, center2open_burstNumber{mm}, closed_freq(mm), center_freq(mm), open_freq(mm)] = EPM_zones(burstIndex, burstStart, fs, fps, closedStarts, closedEnds, openStarts, openEnds, centerStarts, centerEnds, cen2c_cenExit, cen2o_cenExit);

% coherogram
 ch1 = find(contains(fileInfo.channels, ch1_name)); % select channel 1
 ch2 = find(contains(fileInfo.channels, ch2_name)); % select channel 2
% 
[cen2c_cohgram{mm}, t,f] = coherogram_window(fileInfo.rawdata(:,ch1), fileInfo.rawdata(:,ch2), closedEnds, preWin, params, fs);
[cen2o_cohgram{mm}, t,f] = coherogram_window(fileInfo.rawdata(:,ch1), fileInfo.rawdata(:,ch2), openEnds, preWin, params, fs);

% spectrogram

[ch1_cen2c_P{mm}, Pf, Pt]= spectrogram_window(fileInfo.rawdata(:,ch1), closedStarts, preWin, fs, params);
[ch2_cen2c_P{mm}, Pf, Pt]= spectrogram_window(fileInfo.rawdata(:,ch2), closedStarts, preWin, fs, params);

[ch1_cen2o_P{mm}, Pf, Pt]= spectrogram_window(fileInfo.rawdata(:,ch1), openStarts, preWin, fs, params);
[ch2_cen2o_P{mm}, Pf, Pt]= spectrogram_window(fileInfo.rawdata(:,ch2), openStarts, preWin, fs, params);


end