function [closedCorr, openCorr, centerCorr, center2closedCorr, center2openCorr] = TEMPO_EPMzones(tempo, fs, corrWindow, closedStarts, closedEnds, openStarts, openEnds, centerStarts, centerEnds, center2closed, center2open)
   
    % Concatenate closed arm data
    closed_data = [];
    for jj=1:size(tempo,1)
        tmp = [];
        for ii = 1:numel(closedStarts)
            tmp = horzcat(tmp,tempo(jj,floor(closedStarts(ii)):floor(closedEnds(ii))));
        end
        closed_data(jj,:) = tmp;
    end
    
    % Concatenate open arm data
    open_data = [];
    for jj=1:size(tempo,1)
        tmp = [];
        for ii = 1:numel(openStarts)
            tmp = horzcat(tmp, tempo(jj,floor(openStarts(ii)):floor(openEnds(ii))));
        end
        open_data(jj,:) = tmp;
    end
    
    % Concatenate center zone data
    center_data = [];
    for jj=1:size(tempo,1)
        tmp = [];
        for ii = 1:numel(centerStarts)
            tmp = horzcat(tmp, tempo(jj,floor(centerStarts(ii)):floor(centerEnds(ii))));
        end
        center_data(jj,:) = tmp;
    end
    
    % Concatenate center zone data preceeding closed arm entries
    center2closed_data = [];
    center2closedStarts = centerStarts(center2closed);
    center2closedEnds = centerEnds(center2closed);
    for jj=1:size(tempo,1)
        tmp = [];
        for ii = 1:numel(center2closedStarts)
            tmp = horzcat(tmp, tempo(jj,floor(center2closedStarts(ii)):floor(center2closedEnds(ii))));
        end
        center2closed_data(jj,:) = tmp;
    end
    
    % Concatenate center zone data preceeding open arm entries
    center2open_data = [];
    center2openStarts = centerStarts(center2open);
    center2openEnds = centerEnds(center2open);
    for jj=1:size(tempo,1)
        tmp = [];
        for ii = 1:numel(center2openStarts)
            tmp = horzcat(tmp, tempo(jj,floor(center2openStarts(ii)):floor(center2openEnds(ii))));
        end
        center2open_data(jj,:) = tmp;
    end
    
    % Calculated correlations for each zone
    
    [closedCorr(1,1), closedCorr(2,1), closedCorr(3,1)] = TEMPO_corr(closed_data, fs, corrWindow);

    [openCorr(1,1), openCorr(2,1), openCorr(3,1)] = TEMPO_corr(open_data, fs, corrWindow);

    [centerCorr(1,1), centerCorr(2,1), centerCorr(3,1)] = TEMPO_corr(center_data, fs, corrWindow);

    [center2closedCorr(1,1), center2closedCorr(2,1), center2closedCorr(3,1)] = TEMPO_corr(center2closed_data, fs, corrWindow);

    [center2openCorr(1,1), center2openCorr(2,1), center2openCorr(3,1)] = TEMPO_corr(center2open_data, fs, corrWindow);

end


