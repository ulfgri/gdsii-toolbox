function [cas] = gdsii_zonelens(sname,rad,pos,maxpe,ctrblack,papprox,layer,aperture,verbose)
%function [cas] = gdsii_zonelens(sname,rad,pos,maxpe,ctrblack,papprox,layer,aperture,verbose)
%
% Generates the design data (in GDSII format) for a zone plate. A list
% of zone radii and the center coordinate (in GDSII user units) of the
% pattern must be provided by the user.
%
% sname    : name of the top level GDSII structure. Default is ZONE_LENS.
% rad      : a vector with zone radii in GDS user units
% pos      : (OPTIONAL) position of the zone plate on the photomask in GDS
%            user coordinates. Default is [0,0].
% maxpe    : (OPTIONAL) polygon error (or sag) in GDS user units which
%            controls how well the circles are approximated by
%            polygons. Default is 1.
% ctrblack : (OPTIONAL) if set to 1, the central area will be
%            black, otherwise it will be transparent. Default is 0.
% papprox  : (OPTIONAL) method used to approximate circles by
%            polygons. Can have the following values:
%              1 = the polygons approximating circles have the same
%                  area as the circles. (This is the DEFAULT)
%              2 = the polygons approximating circles have a length
%                  equal to the circumference of the circles.
% layer :    (OPTIONAL) layer to which the layout is written. Default is 1.
% aperture : (OPTIONAL) an aperture, defined by a closed polygons in Cartesian
%            coordinates (nx2 matrix, one vertex per row), which clips
%            the generated zone-plate pattern. 
%               aperture.poly :  a cell array of polygons for the
%                                clipping operation.
%               aperture.oper :  one of the clipping operators of
%                                the 'polybool' function: 'and',
%                                'or', 'xor', and 'notb'. 
% verbose  : (OPTIONAL) print progress information if verbose==true.
%            Default is false (no progress info).
% cas      : zone plate layout is returned a cell array of
%            gds_structure objects.
%
% NOTES 
% 1) When an aperture for clipping is passed as an argument, the
% zone plate is created entirely from boundary elements. Otherwise,
% only one octant is created from boundary elements which is then
% replicated with sref elements to reduce the size of the layout
% file.
% 2) Structure names used internally by the function contain a random
% number to ensure that the names are unique even when a layout consist
% of several zone lenses. In the unlikely case of a name collision the
% layout script should be run again to avoid the collision.
% 3) The number of vertices in a zone segment has an upper limit of 800.

% Ulf Griesmann, NIST, Feb. 2008
%   U.G., Aug. 2008: added writing to different layers
%   U.G., Jan. 2011: can return boundary elements instead of
%   writing to file.
%   U.G., May 2011: clean up code
%   U.G., October 2012: return gds_structure object
%   U.G., August 2014, renovated
%   U.G., March 2015, fixed a couple bugs

    % check input parameters
    if nargin < 9, verbose = false; end
    if nargin < 8, aperture = []; end
    if nargin < 7, layer = []; end
    if nargin < 6, papprox = []; end
    if nargin < 5, ctrblack = []; end
    if nargin < 4, maxpe = []; end
    if nargin < 3, pos = []; end
    if nargin < 2
        error('gdsii_zonelens: requires at least two arguments');
    end
    
    if isempty(sname), sname = 'ZONE_LENS'; end
    if isempty(pos), pos = [0,0]; end
    if isempty(maxpe), maxpe = 1; end
    if isempty(ctrblack), ctrblack = 0; end
    if isempty(papprox), papprox = 1; end
    if isempty(verbose), verbose = false; end
    
    if isempty(layer)
        layer = 1;
    end

    % select the start indices for the rings
    if ctrblack == 0
        iidx = 1; % index of inner radius
        oidx = 2; % index of outer radius
    else
        iidx = 0; % center
        oidx = 1;
    end

    % create the top level zone lens structure
    zps = gds_structure(sname);
    
    % initialize variables
    zpid = floor(10000*rand(1));   % unique zone plate id
    tnz = ceil(length(rad)/2);     % total number of zones
    
    % create a cell array with zone information
    zpar = cell(tnz,1);         % pre-allocate array
    nzon = 1;                   % zone index

    % zone parameters that are independent of zone number
    zone.po = pos;              % zone plate position in plane
    zone.id = zpid;             % zone plate id number
    zone.pa = papprox;          % polygon approximation type
    zone.pe = maxpe;            % polygon approximation error
    zone.ap = aperture;         % aperture (or not ...)
    zone.ly = layer;
    zone.vb = verbose;          % verbosity

    while 1
        
        % collect zone information
        if iidx == 0
            zone.ri = 0;
        else
            zone.ri = rad(iidx);
        end
        zone.ro = rad(oidx);    % outer radius
        zone.nz = nzon;         % zone number
        zpar{nzon} = zone;      % store in cell array
        
        % advance indices
        iidx = iidx + 2;
        oidx = oidx + 2;
        if oidx > length(rad)
            break
        end
        
        % next zone
        nzon = nzon + 1;
        
    end

    % trim parameter array if necessary
    if nzon < tnz
        zpar = zpar(1:nzon); 
    end

    % calculate the segments
    if verbose
        fprintf('Processing %d zones ...\n',nzon);
    end
    cas = cellfun(@single_zone, zpar, 'UniformOutput',0);
        
    % add references to main structure & flatten cell array if necessary
    if iscell(cas{1})                  % pairs of structures

        for k=1:numel(cas)
            sp = cas{k};               % a structure pair
            zps = add_ref(zps, sp{1}); % first is zone structure
        end    
        cas = flatten_cells(cas);      % flatten cell array
        
    else                               % only structures with boundaries

        for k=1:numel(cas)
            zps = add_ref(zps, cas{k});
        end    
        
    end

    % add zone plate top level structure to structure list
    cas{end+1} = zps;
    
    if verbose
        fprintf('Generated all zones ...\n',nzon);
    end

end


%---------------------------------------------------------

function [zos] = single_zone(zpar);
%function [zos] = single_zone(zpar);
%
% function to calculate the layout of a single zone plate zone
% called by the 'zone_plate_layout' functions
%
% zpar :  a structure with the following fields:
%         zpar.ri - inner zone radius
%         zpar.ro - outer zone radius
%         zpar.po - zone plate position
%         zpar.id - zone plate id
%         zpar.nz - zone number
%         zpar.pa - zone polygon approximation (1 or 2)
%         zpar.pe - zone polygon error
%         zpar.ap - aperture
%         zpar.vb - verbose flag
%
% zos :   EITHER a cell array of gds_structure objects, one for
%         each zone, OR a cell array of cell arrays each
%         containting a pair of gds_structure objects.

    % calculate number of segments with about 800 vertices
    np = calc_phi(zpar.ro, zpar.pe, pi/2, zpar.pa);
    nseg = max(round(4*np/400),8); % 8 segments || < 800 vertices
        
    % generate boundary data for a segment centered at 0
    xy = generate_segment(zpar.ri, zpar.ro, 2*pi/nseg, zpar.pe, zpar.pa);
    
    if ~isempty(zpar.ap)               % replicate polygon "manually"
        
        % structure that holds the segment boundaries
        zos = gds_structure(sprintf('ZONE_%d_%d', zpar.id, zpar.nz));     
        
        lbl = {bsxfun(@plus,xy,zpar.po)}; % first segment of zone;
        for k = 2:nseg                    % remaining segments 
            lbl{end+1} = bsxfun(@plus,ctra_rotz(xy,(k-1)*2*pi/nseg),zpar.po);
        end
        lbl = polybool(lbl, zpar.ap.poly, zpar.ap.oper);
        be = gds_element('boundary', 'xy',lbl, 'layer',zpar.ly);
        zos = add_element(zos, be);    % add to main zone plate structure
        
    else                               % replicate with sref elements
        
        % structure with segment boundary
        zon = sprintf('ZBND_%d_%d', zpar.id, zpar.nz);
        bs = gds_structure(zon);     
        zbe = gds_element('boundary', 'xy',xy, 'layer',zpar.ly);
        bs = add_element(bs, zbe);
        
        % structure that holds the references for the segment
        elist = cell(1,nseg);
        for k = 1:nseg           % add rotated segments to zone structure
            strans.angle = (k-1)*360/nseg;
            elist{k} = gds_element('sref', 'sname',zon, 'xy',zpar.po, 'strans',strans);
        end
        zs = gds_structure(sprintf('ZONE_%d_%d', zpar.id, zpar.nz),elist);
        zos = {zs, bs};
        
    end

    % progress info
    if zpar.vb && ~mod(zpar.nz,200)
        fprintf('... completed zone %d\n', zpar.nz);
    end
end


%---------------------------------------------------------

function [xy] = generate_segment(r1, r2, sa, pe, pap);
%
% generate the description of 1/8 of a ring in the first
% quadrant using a polygon (or boundary)
%
% r1  : inner radius (r1 == 0 is the center)
% r2  : outer radius
% sa  : segment angle in radians
% pe  : max polygon error (or sag)
% pap : type of polygon approximation (equal area or equal arc length)

    % calculate number of inner points (and correction factor)
    % needed for the desired polygon error
    if r1 > 0
        [np1, cfac1] = calc_phi(r1, pe, sa, pap);
    end

    % calculate number of outer points needed (and correction factor) 
    % for desired polygon error
    [np2, cfac2] = calc_phi(r2, pe, sa, pap);
    
    % generate all points in polar coordinates
    % ra(:,1) is the angle
    % ra(:,2) is the radius
    if r1 > 0
        ra1 = zeros(np1, 2);
        ra1(:,1) = (0 : sa/(np1-1) : sa)'; % angle in first column
        ra1(:,2) = cfac1 * r1;                       % radius in 2nd column
    end
    ra2 = zeros(np2, 2);
    ra2(:,1) = (sa : -sa/(np2-1) : 0)';
    ra2(:,2) = cfac2 * r2;
    
    % assemble the boundary vertices
    if r1 > 0
        ra = vertcat(ra1,ra2,ra1(1,:));
    else
        ra = vertcat(ra2,[0,0],ra2(1,:)); % the whole quadrant
    end
    if length(ra) > 2^15 - 1
        error('too many points in boundary');
    end
    
    % and transform it to cartesian coordinates
    xy = pol_cart(ra(:,1), ra(:,2));

end


%---------------------------------------------------------

function XY = pol_cart(T,R);
% convert from polar to cartesian coordinates
    XY = [R.*cos(T),R.*sin(T)];
end


%---------------------------------------------------------

function [np, cfac] = calc_phi(R, E, A, pap);
% calculate number of vertices on an arc needed for the 
% desired polygon error and the correction factor for the radii
    alpha = 1 + E / R;
    if pap == 1     % equal area
        phi  = sqrt(6) * sqrt((alpha^2-1)/alpha^2); % 3rd order approx.
        np   = 1 + ceil(A / phi);                   % vertices per segemnt
        phi = A / (np - 1);                         % corrected angle
        cfac = sqrt( phi / sin(phi) );
    elseif pap == 2 % equal arc length 
        phi = 2 * sqrt(6 * (alpha-1)/alpha);        % 3rd order approx.
        np   = 1 + ceil(A / phi);                   % vertices per segment
        phi = A / (np - 1);                         % corrected angle
        cfac = 0.5 * phi / sin(phi/2); 
    else
        error('unknown circle approximation method.');
    end
    
end


%---------------------------------------------------------

function data = flatten_cells(data)
%
% flatten_cells :  turns a nested cell array into a flat
%                  cell array.
%
% from the web, June 2013

    try
        data = cellfun(@flatten_cells,data,'un',0);
        if any(cellfun(@iscell,data))
            data = [data{:}];
        end
    catch
        % reached non-cell data, pass through unchanged
    end
end
