
% [jointIndices(6) jointIndices(26) -> left elbow
% [jointIndices(7) jointIndices(27) -> left wrist
% [jointIndices(8) jointIndices(28) -> left palm
 
% [jointIndices(10) jointIndices(30) -> Right elbow
% [jointIndices(11) jointIndices(31) -> Right wrist
% [jointIndices(12) jointIndices(32) -> Right Palm
%  closepreview(vid1);
%  closepreview(vid2);
%  stop(vid1);
%  stop(vid2);

 delete(instrfind({'PORT'},{'COM11'}));
 clear Ardu;
 clear
 clc;
a=arduino('COM11','uno');
s1 = servo(a,'D2','MinPulseDuration',7.00e-4,'MaxPulseDuration',2.3e-3);
s2=servo(a,'D3','MinPulseDuration',7.00e-4,'MaxPulseDuration',2.3e-3);
s3=servo(a,'D4','MinPulseDuration',7.00e-4,'MaxPulseDuration',2.3e-3);
s4=servo(a,'D5','MinPulseDuration',7.00e-4,'MaxPulseDuration',2.3e-3);
s5=servo(a,'D6','MinPulseDuration',7.00e-4,'MaxPulseDuration',2.3e-3);
writePosition(s1, 0);
writePosition(s2, 0);
writePosition(s3, 0);
writePosition(s4, 0);
writePosition(s5, 0.5);  

utilpath = fullfile(matlabroot, 'toolbox', 'imaq', 'imaqdemos', ...
'html', 'KinectForWindows');
addpath(utilpath);
yellow = uint8([255 0 0]); % [R G B]; class of yellow must match class of I
 
shapeInserter = vision.ShapeInserter('Shape','Circles','BorderColor','Custom','CustomBorderColor',yellow);
 
vid1 = videoinput('kinect',1); % RGB camera
vid2 = videoinput('kinect',2); % Depth camera
srcColor = getselectedsource(vid1);
srcDepth = getselectedsource(vid2);
% Turn on skeletal tracking.
set(srcDepth, 'TrackingMode', 'Skeleton')
% You can get the upper body only if you want to record seated person's data
% set(srcDepth, 'BodyPosture', 'Seated')
set(srcDepth, 'BodyPosture', 'Seated')
 
fnum=10000;%number of frames per run
 
vid1.FramesPerTrigger = 1;
vid2.FramesPerTrigger = 1;
vid1.TriggerRepeat = fnum;
vid2.TriggerRepeat = fnum;
triggerconfig([vid1 vid2],'manual');
start([vid1 vid2]);
skl=[];
 
AtrainData={};
 
% open(vidObj);
 
% Trigger 400 times to get 400 frames. then stop
for i = 1:fnum+1
% Trigger both objects.
trigger([vid1 vid2])
 
% Get the acquired frames and metadata.
[imgColorAll, ts_colorAll, metaData_ColorAll] = getdata(vid1);
[imgDepthAll, ts_depthAll, metaData_DepthAll ] = getdata(vid2);
 
imgColor=imgColorAll(:,:,:,1);
imgDepth=imgDepthAll(:,:,:,1);
% ts_color=ts_colorAll(1);
% ts_depth=ts_colorAll(1);
metaData_Color=metaData_ColorAll(1);
metaData_Depth=metaData_DepthAll(1);
 
if any(metaData_Depth.IsPositionTracked)==0
imshow(imgColor);
else
skl=find(metaData_Depth.IsPositionTracked);
 
% representations of skeleton positions on image
jointIndices = metaData_Depth.JointImageIndices(:, :, skl(1));
 
% 3D skeleton joint positions
jointCoordinates = metaData_Depth.JointWorldCoordinates(:, :, skl(1));
 
% Find number of Skeletons tracked
nSkeleton = length(1);
 
% util_skeletonViewer(jointIndices, imgColor, nSkeleton); % this line draws skeleton on rgb
% just for showing them in the same image
 
circles = int32([jointIndices(11) jointIndices(31) 50]); % [x1 y1 radius1;x2 y2 radius2]
 
J = step(shapeInserter, imgColor, circles);
 
 
RGB = insertShape(J, 'circle', [jointIndices(11) jointIndices(31) 35], 'Color', 'green');
RGB = insertShape(RGB, 'circle', [jointIndices(11) jointIndices(31) 25], 'Color', 'yellow');
right_rest=jointIndices(11)%for debugging

right_rest31=jointIndices(31)%for debugging
RGB = insertShape(RGB, 'circle', [jointIndices(7) jointIndices(27) 35], 'Color', 'cyan');
RGB = insertShape(RGB, 'circle', [jointIndices(7) jointIndices(27) 25], 'Color', 'magenta');
 
imshow(RGB);

 
if(jointIndices(31)>250)
writePosition(s1, 0.5);
writePosition(s2, 0.5);
writePosition(s3, 0.5);
writePosition(s4, 0.5);
writePosition(s5, 0.5);
 %should er
else
writePosition(s1, 0);
writePosition(s2, 0);
writePosition(s3, 0);
writePosition(s4, 0);
writePosition(s5, 0);  

end
%
if(jointIndices(11)<450)
end
 
 
end
 
% Writing the rgb frame with skeleton drawn on it to video file
% writeVideo(vidObj, getframe(gcf));
end

% If you don't stop you can't start video acquisition again. it will give
% error when you try to start again. in this case call fnc below
%delete(a);
%stop([vid1 vid2]);
% close(vidObj);
