function [cohgram, t, f] = coherogram_window(x, y, startPoints, window, params, fs)

% script that returns a coherogram that is centered around a behavioral/lfp
% timepoint

starts = startPoints - (window*fs);
ends = startPoints + (window*fs);

starts = starts(ends < numel(x));
ends = ends(ends < numel(x));

ends = ends(starts > 1);
starts = starts(starts > 1);


for i = 1:numel(starts)
    [cohgram(:,:,i),~,~,~,~,t,f]=cohgramc(x(starts(i):ends(i)),y(starts(i):ends(i)),[1 0.5],params);
end