function [mpos] = poly_rotzd(mp, angd)
%function [mpos] = poly_rotzd(mp, angd)
%
% poly_rotz : transformation of points by rotation around the z-axis
%
% mpos : points to be transformed; one per row
% angd : angle around the z-axis in degrees

% Taken from the NIST Optics Toolbox

    ang = pi * angd / 180;
    mpos = zeros(size(mp));
    mpos(:,1) = cos(ang)*mp(:,1) - sin(ang)*mp(:,2);
    mpos(:,2) = sin(ang)*mp(:,1) + cos(ang)*mp(:,2);
  
end
