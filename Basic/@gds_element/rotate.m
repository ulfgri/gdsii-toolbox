function [gelmo] = rotate(gelmi, ang)
%function [gelmo] = rotate(gelmi, ang)
%
% Method rotates all polygons in a boundary or path element by
% a specified angle about the coordinate origin. Elements can
% be compound elements.
%
% gelmi :  input boundary or path (compound) element
% gelmo :  (compound) boundary or path element with the same
%          properties as gelmi.

% Ulf Griesmann, NIST, October 2015

    % check arguments
    if nargin < 2
        error('gds_element.rotate: two input arguments required.');
    end

    switch get_etype(gelmi.data.internal) 
  
      case {'boundary', 'path'}
	  gelmo = gelmi;
	  xy = gelmi.data.xy;
          for k=1:length(xy)
	      xy{k} = poly_rotzd(xy{k}, ang);
	  end
	  gelmo.data.xy = xy;
       
      otherwise
	  error('gds_element.rotate :  input must be boundary or path element.');
    end

end


