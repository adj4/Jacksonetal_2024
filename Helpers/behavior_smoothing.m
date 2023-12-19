function [tracking speedFrame] = behavior_smoothing(tracking, dimensions, fps, maxDiff, firstFrame)

    %%% Correct and smooth tracking data

    temp = kmeans(dimensions,2);
    h = figure;
    subplot(2,1,1)
    scatter(tracking(:,1), tracking(:,2), [], temp)
    subplot(2,1,2)
    scatter(dimensions(:,1),dimensions(:,2),[],temp)
    prompt = 'Please enter 1 to remove outliers or 0 to skip:'; % ask
    EXP = input(prompt);
    while (EXP ~= 0 && EXP ~= 1)  % if the user doesnt input 1 or 2
            EXP = input('ERROR. Please enter 1 for EXP1 and 2 for EXP2:'); 
    end
    close(h)
    
    if EXP == 1
        temp(temp==2) = nan;
        temp = horzcat(temp, temp);
        tracking = tracking .* temp; 
        tracking = fillmissing(tracking,'linear');
    end
    
    difference   = [diff(tracking, 1); tracking(end, :)-tracking(1, :)];              % Calculates the first derivative
    pointDistance   = sqrt(sum(difference .* difference, 2));
    temp = pointDistance < maxDiff;
    temp = double(temp);
    temp(temp==0) = nan;
    temp = horzcat(temp, temp);
    tracking = tracking .* temp; 
    tracking = fillmissing(tracking,'linear');
    
    
    tracking = movmean(tracking, fps/2);
    
    %%%%% calculate speed %%%%%
    
    figure
    imshow(firstFrame)
    fprintf('Click on 2 points of known distance\n')                            % Requests user to select two points of known distance eg length of open arm
    ruler = ginput(2);
    scale = inputdlg({'Enter known distance in mm:'});                          % Enter distance between the two points in mm
    pixelLength = str2num(scale{:})/pdist(ruler);                               % Calculates length of one pixel in frame
        
    speedFrame = ((pointDistance * pixelLength)*fps)/10;  
    

end