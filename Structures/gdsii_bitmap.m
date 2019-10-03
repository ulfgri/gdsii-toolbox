function [bms] = gdsii_bitmap(bmap, pixel, sname, layer)
%function [bms] = gdsii_bitmap(bmap, pixel, sname, layer)
%
% Creates a GDSII structure containing a bitmap composed of black and
% white pixels.
%
% bmap :   matrix with elements 1 for black pixels and 0 for white
%          pixels. 
% pixel :  A structure variable containing pixel width and height
%          in user units 
%               pixel.width               : width of pixel
%               pixel.height  (Optional)  : height of pixel
%               pixel.psname  (Optional)  : name of gds_structure for pixel
%               pixel.esname  (Optional)  : name of an external structure
%          By default, a pixel is defined by a square boundary
%          and only the width of the pixel needs to be specified. For 
%          rectangular pixels the pixel height must also be specified.
%          The function generates a gds_structure object containing the pixel
%          which has the default name BITMAP_PIXEL. If more than one bitmap is
%          used in a layout, the name can be made unique by specifying pixel.sname.
%          Finally, a pixel can also be defined by an external structure specified
%          in pixel.rsname.
% sname :  (Optional) name of the created structure. Default is 'BITMAP'.
% layer :  (Optional) layer to which the pattern is
%          written. Default is 1.
% bms :    a cell array of gds_structure objects
%         
% initial version: Ulf Griesmann, NIST, Feb 2011
% removed global variable gdsii_layer, Jan 2012, U.G.
%

    % check arguments
    if nargin < 4, layer = []; end;
    if nargin < 3, sname = []; end;
    if nargin < 2
        error('gdsii_bitmap: missing argument(s)');
    end

    if isempty(sname), sname = 'BITMAP'; end;
    if isempty(layer), layer = 1; end; 

    % pixel width must be specified
    if ~isfield(pixel, 'width')
        error('Missing field /width/ in variable /pixel/.');
    end

    % pixel height is optional
    if ~isfield(pixel, 'height')
        pixel.height = pixel.width;
    end

    % create output cell array
    bms = {};

    % create pixel if no external pixel structure is referenced
    if ~isfield(pixel, 'esname')
        if ~isfield(pixel, 'psname')
            pixel.psname = 'BITMAP_PIXEL';
	end
	bm_pixel = [0,0; pixel.width,0; pixel.width,pixel.height; 0,pixel.height; 0,0];
	bms{end+1} = gdsii_pattern(pixel.psname, bm_pixel, layer);
    else
	pixel.psname = pixel.esname;
    end
    
    % create the pixel structure
    
    % replicate the pixel at every position where the bitmap ~= 0
    % also make sure the image has the correct orientation
    [ir,ic] = find(bmap(end:-1:1,:)' ~= 0); % find black pixels
    xy = [pixel.width*(ir-1), pixel.height*(ic-1)];
    repe = gds_element('sref', 'sname',pixel.psname, 'xy',xy);
    reps = gds_structure(sname, repe);
    
    % return structure
    bms{end+1} = reps;

end
