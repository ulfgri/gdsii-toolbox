function [mpos] = poly_rotz(mp, ang)
%function [mpos] = poly_rotz(mp, ang)
%
% poly_rotz : transformation of points by rotation around the z-axis
%
% mpos : points to be transformed; one per row
% ang  : angle around the z-axis in radians

% Taken from the NIST Optics Toolbox

    mpos = zeros(size(mp));
    mpos(:,1) = cos(ang)*mp(:,1) - sin(ang)*mp(:,2);
    mpos(:,2) = sin(ang)*mp(:,1) + cos(ang)*mp(:,2);
  
end
