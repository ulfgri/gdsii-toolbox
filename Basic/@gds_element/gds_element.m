function gelm = gds_element(etype, varargin)
%function gelm = gds_element(etype, varargin)
%
% gds_element :  Constructor for the GDS element class. It creates the 
%                elements of a GDSII layout: boundary, box, path, text, 
%                node, structure reference (sref), and array reference (aref).
%
% gelm :       element object created by the constructor
% etype :      a string with one of the GDSII elements: boundary,
%              path, box, text, node, sref, aref. 
% varargin :   EITHER a list of property, value pairs
%              OR a structure with ALL element properties - no
%              error checking ! This provides a fast way to create
%              elements that is used internally by the gdsii file
%              read functions.
%
% Example :    be = gds_element('boundary', 'xy',poly, 'layer',5);
%  
%          Properties common to all elements:
%          ==================================
%             elflags : a string with 'T' for template data and/or
%                       'E' for exterior data. 'TE' means both.
%                       This flag is omitted by default.
%             plex :    a number used for grouping of elements. A negative
%                       plex number specifies the plex head. Omitted by default.
%             prop :    a structure array with property number and property 
%                       name (or value) pairs.
%                           prop(k).attr : 1 .. 127
%                           prop(k).name : character string.
%                       The total number of bytes for all properties in the structure
%                       array must not exceed 128, or 512 in the case of sref and aref
%                       elements.
%             layer :   GDS layer for the element (default is 1).
%             dtype :   data type number 0 .. 255. Default is 0. 
%                       layer and dtype for a complete layer specification.
%             NOTE: sref and aref elements have no layer and dtype properties.
%
%           Element specific properties:
%           ============================
%
%             Boundary element:
%             -----------------
%                xy :    a cell array of N x 2 matrices containing one or
%                        more closed polygons with up to 8191 vertices. 
%                nume :  number of polygons in the boundary element
%
%             Path element:
%             -------------
%                xy :    a cell array of N x 2 matrices describing one or 
%                        more paths with up to 8191 vertex coordinates. 
%                ptype : path type 0,1, 2, or 4. Default is 0.
%                width : width of the path in user units
%                        Negative numbers imply absolute widths 
%                        unaffected by scaling.
%                ext :   path extension for type 4 paths.
%                        ext.beg - square extension at path beginning
%                        ext.end - square extension at path end
%                nume :  number of path segements in the path element
%
%             Box element:
%             ------------
%                xy :    5 x N matrix of closed rectangular
%                        polygon.
%                btype : a box type 0 .. 255. Default is 0.
%
%             Node element:
%             -------------
%                ntype : node type, a number 0 .. 255. Default is 0.
%                xy   :  up to 50 node coordinates
%
%             Text element:
%             -------------
%                text :  a text string
%                xy :    text location in user units  
%                ttype : text type, a number 0 .. 63. Default is 0.
%                font :  text font 0 .. 3. Default is 0
%                verj :  vertical justification; 0 = top, 1 =
%                        middle, 2 = bottom. Default is 0.
%                horj :  horizontal justification. 0 = left, 1
%                        = middle, 2 = right. Default is 0.
%                ptype : path type. Default is 1.
%                width : width of line for drawing text in
%                        user units (obsolete).
%                strans: an strans record which describes text
%                        transformations. Omitted by default.
%
%             Sref element(s):
%             ----------------
%                xy :    N x 2 list of coordinates in user
%                        units.
%                sname : Name of the referenced structure
%                strans: strans record for transforming the
%                        structure.
%
%             Aref element:
%             -------------
%                xy :    3 x 2 list of coordinates in user
%                        units.
%                          xy(1,:) :  origin (reference point)
%                          xy(2,:) :  column spacing x number of columns
%                          xy(3,:) :  row spacing x number of rows
%                        These three coordinates are used to
%                        control the orientation and position of the whole
%                        array.
%                sname : Name of the referenced structure
%                strans: strans record for transforming the
%                        structure. This controls the orientation
%                        of the individual instances of the
%                        referenced structure.
%                adim :  number of rows and columns in the array
%                           adim.row : number of rows
%                           adim.col : number of columns
%
%              NOTE:
%              =====
%
%                 strans : structure transformation parameters
%                 --------------------------------------------
%                 strans.reflect : if this is set (=1), the element is
%                                  reflected about the x-axis AFTER a
%                                  possible rotation. Default is 0.
%                 strans.absmag  : if set to 1, specifies absolute
%                                  magnification. Default is 0.
%                 strans.absang  : if set to 1, specifies absolute angle.
%                                  Default is 0.
%                 strans.mag     : magnification factor for structure.
%                                  Default is 1.
%                 strans.angle   : rotation angle for structure in degrees.
%                                  Default is 0.
%

% Initial version, Ulf Griesmann, NIST, June 2011

    if ~ischar(etype)
        error('gds_element constructor: first argument must be element type string.');
    end
    
    % get element properties
    if strcmp(etype, '_file_')  % was called from gds_read_element
  
        data = varargin{1};
   
    else                        % collect all arguments into a structure
        
        data = parse_element_data(etype, varargin);
        
    end
    
    % check critical element properties
    if ~isfield(data, 'xy')
        if isref(data.internal)
            data.xy = [0,0];  % default [0,0] for reference elements
        else
            errmsg = sprintf('gds_element constructor: %s element missing xy data.', ...
                             get_etype(data.internal));
            error(errmsg); 
        end
    end
    
    switch get_etype(data.internal)
        
      case {'boundary', 'path'}
        if ~iscell(data.xy) 
            data.xy = {data.xy}; 
        end
        
      case 'text'
        if ~isfield(data, 'text')
            error('gds_element constructor:  missing text field.'); 
        end
    end

    % create the element object
    % NOTE: each object of a class must have the same fields (old style objects in 
    % Octave/Matlab are essentially thinly veiled structures). Since the structure
    % 'data' has a varying number of fields, e.g. 'text' is only present
    % in text elements, we need to create an object 'elmo' that has 'data' as 
    % its only field.
    elmo.data = data;
    gelm = class(elmo, 'gds_element');
    
end
