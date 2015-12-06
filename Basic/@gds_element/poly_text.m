function belm = poly_text(telm, height, type, width, ptype)
%function belm = poly_text(telm, height, type, width, ptype)
%
% renders a text element as a boundary element with
% the text defined as polygons.
%
% INPUT:
% telm :    input text element
% height :  (Optional) text height in user units.
%           Default is 10;
% type :    (Optional) output element type; either 'boundary' or 'path'.
%           Default is 'boundary'.
% width :   (Optional) path width; needed only when text is rendered as 
%           path elements. Default is height / 10;
% ptype :   (Optional) path type; needed only when text is rendered as 
%           paths. Default is 0;
%
% OUTPUT:
% belm :    output element (boundary or path)
%
% NOTE:
% -----
% GDSII text elements are not designed to be rendered as polygons.
% They appear to have originally been intended for drawning by a
% plotter device. The height property of text elements (not in the
% GDS definition !) is used to size the text elements for rendering
% with polygons. The default height is 10 user units (see:
% gds_element.m).
%
% * This function is not very efficient because it renders each string twice;
% first to determine the length in user units, then to render it at the correct
% location in the desired orientation. This is acceptable because there are only
% few text elements in any given layout.
%
% * the magnification factor of the optional strans record is ignored.

% Initial version, Ulf Griesmann, December 2011

    % input defaults
    if nargin < 5, ptype = []; end
    if nargin < 4, width = []; end
    if nargin < 3, type = []; end
    if nargin < 2, height = []; end

    if isempty(height), height = 10; end
    if isempty(type), type = 'boundary'; end
    if isempty(width), width = height/10; end
    if isempty(ptype), ptype = 0; end
        
    % check if input is a text
    if ~strcmp(get_etype(telm.internal), 'text')
        error('gds_element.poly_text :  input must be text element.');
    end

    % create new internal structure and copy relevant properties
    data.internal = new_internal('boundary');
    layer = get_element_data(telm.data.internal,'layer');
    plist = {'layer',layer, ...
             'dtype',get_element_data(telm.data.internal,'ttype')};
    if has_property(data.internal, 'elflags')
        plist = [plist, {'elflags',get_element_data(telm.data.internal,'elflags')}];
    end
    if has_property(data.internal, 'plex')
        plist = [plist, {'plex',get_element_data(telm.data.internal,'plex')}];
    end
    data.internal = set_element_data(data.internal, plist);

    % render text string to get width
    switch type
     case 'boundary'
         [tchars, twidth] = gdsii_boundarytext(telm.data.text, [0,0], height, 0, 1, 0);
     case 'path'
         [tchars, twidth] = gdsii_pathtext(telm.data.text, [0,0], height, 0, width, ptype, [], 1, 0);
     otherwise
         error('gds_element.poly_text: unknown element type argument.');
    end
    
    % determine origin depending on justification
    XY = telm.data.xy;  % text location
    switch get_element_data(telm.data.internal, 'horj')
     case 1
         XY(1) = XY(1) - twidth/2;
     case 2
         XY(1) = XY(1) - twidth;
    end
    switch get_element_data(telm.data.internal, 'verj')
     case 0
         XY(2) = XY(2) - height;
     case 1
         XY(2) = XY(2) - height/2;
    end

    % get angle from strans
    ang = 0;
    if has_property(telm.data.internal, 'angle') 
        ang = get_element_data(telm.data.internal, 'angle'); 
    end

    % render the string at the correct place
    switch type
     case 'boundary'
         tchars = gdsii_boundarytext(telm.data.text, [0,0], height, ang, 1, 0);
     case 'path'
         tchars = gdsii_pathtext(telm.data.text, [0,0], height, ang, width, ptype, [], 1, 0);
    end
    data.xy = tchars.xy;

    % create output element
    belm = gds_elmement([], data);

end
