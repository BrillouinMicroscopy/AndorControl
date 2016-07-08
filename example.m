%% set parameter

ExTime = 0.01;              % [s]   exposure time for a songle image
FrameNumber = 3;            % [ ]   number of frames during the aquisition
filename = 'TestAcquisition';

% area of interest
width = 2048;               % [pix] width of the AOI
height = 2048;              % [pix] height of the AOI
left = 1;                   % [pix] distance of the AOI to the left
top = 1;                    % [pix] distance of the AOI to the top

%% initialising camera
zyla = AndorControl();

%% set camera parameters
zyla.ExposureTime = ExTime;
zyla.CycleMode = 'Fixed';
zyla.TriggerMode = 'Internal';
zyla.SimplePreAmpGainControl = '16-bit (low noise & high well capacity)';
zyla.PixelEncoding = 'Mono16';
zyla.FrameCount = FrameNumber;

%% set area of interest
zyla.AOI.binning = '1x1';
zyla.AOI.width = width;
zyla.AOI.left = left;
zyla.AOI.height = height;
zyla.AOI.top = top;

%% get image size
imagesize = zyla.ImageSizeBytes;
height = zyla.AOI.height;
width = zyla.AOI.width;
stride = zyla.AOI.stride;

%% start aquisition
zyla.startAcquisition();

for n = 1:1:FrameNumber
    
    buf = zyla.getBuffer();
    image = zyla.ConvertBuffer(buf);

    thisFilename = strcat(filename, num2str(n), '.tiff');
    imwrite(image,thisFilename);
    
end

%% end aquisition and shut down camera

zyla.stopAcquisition();
zyla.delete();