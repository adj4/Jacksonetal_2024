% Gives average speed for each frame of the video and at each index in
% ephys data

function [speed_frame, speed_index] = speed_tracker(tracking, fps, fs)


%%% Correct and smooth tracking data

% temp = pointDistance < maxDiff;
% temp = double(temp);
% temp(temp==0) = nan;
% temp = vertcat(1,temp(1:end-1));
% temp = horzcat(temp, temp);
% tracking = tracking .* temp; 
% tracking = fillmissing(tracking,'linear');
% tracking = movmean(tracking, fps/2);

tracking = fillmissing(tracking,'linear');
tracking = movmean(tracking, fps/2);
Diff   = [diff(tracking, 1); tracking(end, :)-tracking(1, :)];              % Calculates the first derivative
pointDistance   = sqrt(sum(Diff .* Diff, 2));                

%%% Find Speed

[video_filename video_fileroot] = uigetfile('*.avi','Load trial videos', 'MultiSelect', 'ON');  % Select video
videoObj = VideoReader([video_fileroot video_filename]);                % Load in video if not provided
videoObj.CurrentTime = 60;                                              % Jump to 1 min in video
firstFrame = readFrame(videoObj); 

figure
imshow(firstFrame)
title('Click on 2 points of known distance')                            % Requests user to select two points of known distance eg length of open arm
ruler = ginput(2);
scale = inputdlg({'Enter known distance in mm:'});                          % Enter distance between the two points in mm
close
pixelLength = str2num(scale{:})/pdist(ruler);                               % Calculates length of one pixel in frame
        
speed_frame = ((pointDistance * pixelLength)*fps)/10;                             % speed in cm

%%% Find speed data for each ephys/tempo Index

duration = numel(speed_frame)/fps;
originalTimebase = [1/fps:1/fps:duration];                        % create timebase for video frames
newTimebase = [1/fs:1/fs:duration]; % create timebase for ephys/tempo data
speed_index = nan(numel(newTimebase),1);
% 
for ii = 1:numel(newTimebase)                                               % Runs through new timebase and finds animals speed in the frame data
     temp = find(newTimebase(ii)<=originalTimebase,1, 'first');
     if temp <= numel(speed_frame)
         speed_index(ii) = speed_frame(temp);
     end
end

end