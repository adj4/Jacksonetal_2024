function [lags, ave_corr, n_corr, max_corr, bins] = TEMPO_LFP_phaselags(correlation, bin_n)

    corr_hold = correlation;

    n_timebins = size(corr_hold,2);
    lags = [];
    indexes = [-360:720/(size(corr_hold,1)-1):360];     % generates the indexes across two cycles

    for i = 1:n_timebins
        max_corr(i) = max(corr_hold(:,i));          % find max correlation value
        lags(i) = indexes(find(corr_hold(:,i) == max_corr(i),1));   % finds the lag of the max correlation
        if lags(i) == indexes(1) | lags(i) == indexes(end)          % if max was not a true peak i.e. first or last value then correct
            temp = findpeaks(corr_hold(2:end-1,i));                 % finds all peaks that are not at extreme indexes
            lags(i) = indexes(find(corr_hold(:,i) == max(temp)));   % finds lag of new max corr
            max_corr(i) = max(temp);                                % updates max corr
        end 
        if lags(i) < 0                          % corrects negative lags to equivalent positive values 
            lags(i) = lags(i)+360;
        end
    end

    bins = [0:(360/bin_n):360];             % generates freq bins
    lag_bins = discretize(lags,bins);       % assigns each lag to a freq bin

    ave_corr = zeros(bin_n, 1);             
    n_corr = zeros(bin_n, 1);

    for i = 1:numel(lag_bins)
        ave_corr(lag_bins(i)) = ave_corr(lag_bins(i)) + max_corr(i);        % sums each lag value in correct freq bin
        n_corr(lag_bins(i)) = n_corr(lag_bins(i)) + 1;                      % counts instances for each freq bin
    end

    ave_corr = ave_corr./n_corr;            % calculates mean corr at each freq bin

end