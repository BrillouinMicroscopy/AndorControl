classdef init < handle
%AOI.init controls the area of interest
    properties (Access = private)
        handle; % handle to camera
    end
    properties (Dependent)
        width;      % width of the AOI
        binning;    % binning of the image
        left;       % left position of the AOI
        height;     % height of the AOI
        top;        % top position of the AOI
        stride;     %
    end
    
    methods
        %% Constructor
        function obj = init(handle)
            obj.handle = handle;
        end
        
        %% Available methods
        
        %% width
        %function sets the width
        function set.width (obj, width)
            [rc] = AT_SetInt(obj.handle, 'AOIWidth', width);
            AT_CheckWarning(rc);
        end
        
        %function gets the width
        function width = get.width (obj)
            [rc, width] = AT_GetInt(obj.handle, 'AOIWidth');  
            AT_CheckWarning(rc);
        end
        
        %% binning
        %function sets the binning parameter
        function set.binning (obj, binning)
            [rc] = AT_SetEnumString(obj.handle, 'AOIBinning', binning);
            AT_CheckWarning(rc);
        end
        
        %function gets the binning parameter
        function binning = get (obj)
            [rc, binning] = AT_GetEnumString(obj.handle, 'AOIBinning');
            AT_CheckWarning(rc);
        end
        
        %% left position
        %function sets the left position
        function set.left (obj, left)
            [rc] = AT_SetInt(obj.handle, 'AOILeft', left);
            AT_CheckWarning(rc);
        end
        
        %function gets the left position
        function left = get.left (obj)
            [rc, left] = AT_GetInt(obj.handle, 'AOILeft');
            AT_CheckWarning(rc);
        end
        
        %% height
        %function sets the height
        function set.height (obj, height)
            [rc] = AT_SetInt(obj.handle, 'AOIHeight', height);
            AT_CheckWarning(rc);
        end
        
        %function gets the height
        function height = get.height (obj)
            [rc, height] = AT_GetInt(obj.handle, 'AOIHeight');
            AT_CheckWarning(rc);
        end
        
        %% top position
        %function sets the top position
        function set.top (obj, top)
            [rc] = AT_SetInt(obj.handle, 'AOITop', top);
            AT_CheckWarning(rc);
        end
        
        %function sets the top position
        function top = get.top (obj)
            [rc, top] = AT_GetInt(obj.handle, 'AOITop');
            AT_CheckWarning(rc);
        end
        
        %% stride
        %function sets the stride
        function set.stride (obj, stride)
            [rc] = AT_SetInt(obj.handle, 'AOIStride', stride); 
            AT_CheckWarning(rc);
        end
        
        %function gets the stride
        function stride = get.stride (obj)
            [rc, stride] = AT_GetInt(obj.handle, 'AOIStride'); 
            AT_CheckWarning(rc);
        end
    end
end