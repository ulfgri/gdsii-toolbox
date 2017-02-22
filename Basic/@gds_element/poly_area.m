function A = poly_area(bei)
%function A = poly_area(bei)
%
% poly_area : calculate the area of polygons in a (compound)
%             boundary element.
%
% bei :  input boundary element.
% A :    polygon area in (user unit)^2.
%

% Initial version, Ulf Griesmann, NIST, November 2016

    % check input element type
    if ~strcmp(get_etype(bei.data.internal), 'boundary')
        error('poly_area :  element must be a boundary element.');
    end
    
    % calculate area
    A = sum( abs(poly_areamex(bei.data.xy)) );
    
end
