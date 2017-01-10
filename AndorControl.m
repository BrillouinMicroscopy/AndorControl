classdef AndorControl < handle
%AndorControl control the Andor Camera
    properties (Access = private)
        handle; % handle to camera
    end
    properties (Transient)
        AOI;
    end
    properties (Dependent)
        SensorCooling;
        SensorTemperatureStatus;
        SensorTemperature;
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
            obj.AOI = Utils.AndorControl.AOI.init(obj.handle);
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
        
        %% Enable and disable sensor cooling, get status
        
        function set.SensorCooling (obj,Cooling)
            [rc] = AT_SetBool(obj.handle,'SensorCooling',Cooling);
            AT_CheckWarning(rc);
        end
        
        function Cooling = get.SensorCooling(obj)
            [rc,Cooling] = AT_GetBool(obj.handle,'SensorCooling');
            AT_CheckWarning(rc);
        end
        
        function status = get.SensorTemperatureStatus(obj)
            status = obj.GetEnumString('TemperatureStatus');
        end
        
        function temp = get.SensorTemperature(obj)
            [rc,temp] = AT_GetFloat(obj.handle,'SensorTemperature');
            AT_CheckWarning(rc);
        end
        
        %% Set and get acquisition parameters
        
        function string = GetEnumString (obj, featurename)
           [rc,index] = AT_GetEnumIndex(obj.handle,featurename);
            AT_CheckWarning(rc);
           [rc,string]=AT_GetEnumStringByIndex(obj.handle,featurename,index,100);
           AT_CheckWarning(rc);
        end
        
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
        function CycleMode = get.CycleMode (obj)
            CycleMode = obj.GetEnumString('CycleMode');
        end
        
        %function sets the trigger mode
        function set.TriggerMode (obj,TriggerMode)
            [rc] = AT_SetEnumString(obj.handle,'TriggerMode',TriggerMode);
            AT_CheckWarning(rc);
        end
        
        %function gets the trigger mode
        function TriggerMode = get.TriggerMode (obj)
            TriggerMode = obj.GetEnumString('TriggerMode');
        end
        
        %function sets the simple PreAmp gain control
        function set.SimplePreAmpGainControl (obj,SimplePreAmpGainControl)
            [rc] = AT_SetEnumString(obj.handle,'SimplePreAmpGainControl',SimplePreAmpGainControl);
            AT_CheckWarning(rc);
        end
        
        %function gets the simple PreAmp gain control
        function SimplePreAmpGainControl = get.SimplePreAmpGainControl (obj)
            SimplePreAmpGainControl = obj.GetEnumString('SimplePreAmpGainControl');
        end
        
        %function sets the pixel encoding
        function set.PixelEncoding (obj,PixelEncoding)
            [rc] = AT_SetEnumString(obj.handle,'PixelEncoding',PixelEncoding);
            AT_CheckWarning(rc);
        end
        
        %function gets the pixel encoding
        function PixelEncoding = get.PixelEncoding (obj)
            PixelEncoding = obj.GetEnumString('PixelEncoding');
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
            if strcmp(obj.TriggerMode, 'Software')
                obj.trigger();
            end
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