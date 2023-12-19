function [meanCmplx, totalCmplx] = TEMPO_LFP_complex(correlation)

    for j = 1:numel(correlation)
        tmp = cell2mat(correlation{j});
        [lags, ave_corr, n_corr, max_corr, bins] = TEMPO_LFP_phaselags(tmp, 12);
        theta = deg2rad(lags);
        clear cmplx
        for i=1:size(theta,2)
            cmplx(i) = max_corr(i) * complex(cos(theta(i)), sin(theta(i)));
        end
        meanReal(j) = mean(real(cmplx));
        meanImag(j) = mean(imag(cmplx));
        meanCmplx(j) = complex(meanReal(j), meanImag(j));
    end
    
    totalCmplx = complex(mean(real(meanCmplx)), mean(imag(meanCmplx)));

end