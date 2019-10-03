function [ostruc] = gdsii_replicate(struc, rstruc, xy, grid, ang)
%function [ostruc] = gdsii_replicate(struc, rstruc, xy, grid, ang)
%
% Convenience function for creating array references
%
% Input:
% struc :   a gds_structure object to which a reference is added 
%           or string with the name of a new structure
% rstruc :  gds_structure object that is referenced or string with
%           name of referenced structure
% xy     :  N x 2 vector with the origin of the replicated structure
% grid   : defines the grid over which the pattern is replicated
%             grid.nr : number of rows
%             grid.nc : number of columns
%             grid.dr : spacing between rows in user units
%             grid.dc : spacing between columns in user units
% ang :    (Optional) angle by which grid is rotated in
%          degrees. Default is 0.
%
% Output:
% ostruc : gds_structure object containing an array reference

% Initial version, Ulf Griesmann, November 2015

    % check arguments
    if nargin < 5, ang = []; end
    if nargin < 4, error('gdsii_replicate :  too few arguments.'); end;

    if isempty(ang), ang = 0; end
    if ischar(struc)
        ostruc = gds_structure(struc);
    elseif isa(struc, 'gds_structure')
        ostruc = struc;
    else
        error('gdsii_replicate: wrong type of input ''struc''.');
    end
    if ischar(rstruc)
        rname = rstruc;
    elseif isa(rstruc, 'gds_structure')
        rname = sname(rstruc);
    else
        error('gdsii_replicate: wrong type of input ''rstruc''.');
    end
    
    % calculate parameters for aref element
    adim.row = grid.nr;
    adim.col = grid.nc;
    X = zeros(3,2);
    X(1,:) = xy;
    X(2,:) = xy + poly_rotzd([grid.nc*grid.dc,0], ang);
    X(3,:) = xy + poly_rotzd([0,grid.nr*grid.dr], ang);
    
    % create the reference
    ostruc = add_element(ostruc, gds_element('aref', 'sname',rname, 'xy',X, 'adim',adim));
    
end
