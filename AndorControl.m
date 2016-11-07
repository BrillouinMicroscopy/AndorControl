classdef AndorControl < handle
%AndorControl control the Andor Camera
    properties (Access = private)
        handle; % handle to camera
    end
    properties (Transient)
        AOI;
    end
    properties (Dependent)
        ExposureTime;
        TriggerMode;
        CycleMode;
        SimplePreAmpGainControl;
        PixelEncoding;
        FrameCount;
        ImageSizeBytes;
    end
    
    methods
        %% Constructor
        function obj = AndorControl()
            [rc] = AT_InitialiseLibrary();
            AT_CheckError(rc);
            [rc,obj.handle] = AT_Open(0);
            AT_CheckError(rc);
            obj.AOI = AOI.init(obj.handle);
        end
        
        %% Destructor
        function delete (obj)
            [rc] = AT_Flush(obj.handle);
            AT_CheckWarning(rc);
            [rc] = AT_Close(obj.handle);
            AT_CheckWarning(rc);
            [rc] = AT_FinaliseLibrary();
            AT_CheckWarning(rc);
        end
        
        %% Set and get acquisition parameters
        
        %function sets the exposure time
        function set.ExposureTime (obj,ExTime)
            [rc] = AT_SetFloat(obj.handle,'ExposureTime',ExTime);
            AT_CheckWarning(rc);
        end
        
        %function gets the exposure time
        function ExTime = get.ExposureTime (obj)
            [rc,ExTime] = AT_GetFloat(obj.handle,'ExposureTime');
            AT_CheckWarning(rc);
        end
        
        %function sets the cycle mode
        function set.CycleMode (obj,CycleMode)
            [rc] = AT_SetEnumString(obj.handle,'CycleMode',CycleMode);
            AT_CheckWarning(rc);
        end
        
        %function gets the cycle mode
        function ExTime = get.CycleMode (obj)
            [rc,ExTime] = AT_GetEnumString(obj.handle,'CycleMode');
            AT_CheckWarning(rc);
        end
        
        %function sets the trigger mode
        function set.TriggerMode (obj,TriggerMode)
            [rc] = AT_SetEnumString(obj.handle,'TriggerMode',TriggerMode);
            AT_CheckWarning(rc);
        end
        
        %function gets the trigger mode
        function ExTime = get.TriggerMode (obj)
            [rc,ExTime] = AT_GetEnumString(obj.handle,'TriggerMode');
            AT_CheckWarning(rc);
        end
        
        %function sets the simple PreAmp gain control
        function set.SimplePreAmpGainControl (obj,SimplePreAmpGainControl)
            [rc] = AT_SetEnumString(obj.handle,'SimplePreAmpGainControl',SimplePreAmpGainControl);
            AT_CheckWarning(rc);
        end
        
        %function gets the simple PreAmp gain control
        function ExTime = get.SimplePreAmpGainControl (obj)
            [rc,ExTime] = AT_GetEnumString(obj.handle,'SimplePreAmpGainControl');
            AT_CheckWarning(rc);
        end
        
        %function sets the pixel encoding
        function set.PixelEncoding (obj,PixelEncoding)
            [rc] = AT_SetEnumString(obj.handle,'PixelEncoding',PixelEncoding);
            AT_CheckWarning(rc);
        end
        
        %function gets the pixel encoding
        function ExTime = get.PixelEncoding (obj)
            [rc,ExTime] = AT_GetEnumString(obj.handle,'PixelEncoding');
            AT_CheckWarning(rc);
        end
        
        %function sets the frame count
        function set.FrameCount (obj,FrameCount)
            [rc] = AT_SetInt(obj.handle,'FrameCount',FrameCount);
            AT_CheckWarning(rc);
        end
        
        %function gets the frame count
        function ExTime = get.FrameCount (obj)
            [rc,ExTime] = AT_GetInt(obj.handle,'FrameCount');
            AT_CheckWarning(rc);
        end
        
        %function gets the ImageSiyeBytes
        function ImageSizeBytes = get.ImageSizeBytes(obj)
            [rc,ImageSizeBytes] = AT_GetInt(obj.handle,'ImageSizeBytes');
            AT_CheckWarning(rc);
        end
        
        %% Control acquisition
        
        %function starts the acquisition
        function startAcquisition(obj)
            [rc] = AT_Command(obj.handle,'AcquisitionStart');
            AT_CheckWarning(rc);
        end
        
        %function stops the acquisition
        function stopAcquisition(obj)
            [rc] = AT_Command(obj.handle,'AcquisitionStop');
            AT_CheckWarning(rc);
        end
        
        %function triggers image acquisition
        function trigger(obj)
            [rc] = AT_Command(obj.handle,'SoftwareTrigger');
            AT_CheckWarning(rc);
        end
        
        %% Handle image buffer
        
        %function return the image buffer
        function buf = getBuffer(obj)
            [rc] = AT_QueueBuffer(obj.handle,obj.ImageSizeBytes);
            AT_CheckWarning(rc);
            % Set timeout dynamically (in milliseconds)
            [rc, buf] = AT_WaitBuffer(obj.handle,obj.ExposureTime*1e3 + 1000);
            AT_CheckWarning(rc);
        end
        
        %function converts image buffer to matrix
        function image = ConvertBuffer(obj, buf)
            [rc,image] = AT_ConvertMono16ToMatrix(buf,obj.AOI.height,obj.AOI.width,obj.AOI.stride);
            AT_CheckWarning(rc);
        end
    end
end