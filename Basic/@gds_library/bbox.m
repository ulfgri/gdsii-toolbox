function [bbx] = bbox(glib)
%function [bbx] = bbox(glib)
%
% Method returns the bounding box of gds_library objects.
% 
% Input:
% glib :   a gds_library object
%
% Output: 
% bbx :    a vector [llx,lly,urx,ury] with the coordinates of the
%          lower left and upper right corners of the bounding box. 

% Initial version, Ulf Griesmann, November 2015
    
    bbx = bbox_tree(glib.st);
    
end
