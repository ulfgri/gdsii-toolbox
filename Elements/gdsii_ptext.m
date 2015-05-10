function [bl, width] = gdsii_ptext(str, pos, height, layer, ang);
%function [bl, width] = gdsii_ptext(str, pos, height, layer, ang);
%
% gdsii_ptext : draw a text with characters made from boundaries
%               suitable for lithographic reproduction.
%
% str   :  string to be drawn. The string can contain ASCII characters
%          33 to 126 and spaces (ASCII 32). char(127) encodes a lower
%          case Greek mu.
% pos   :  position where the text is drawn in user coordinates
% height:  height of the character box in user coordinates
% layer :  (Optional) layer on which to draw the string. Default is 1.
% ang   :  (Optional) rotate text by angle 'ang' around the bottom
%          left corner of the textbox. 'ang' must be in degrees.
%
% bl    :  a compound gds_element object (boundaries)
% width :  (Optional) Width of the string in the same units as height
%
%
% ------------------------------------------------------------
% NOTE: This function was superseded by 'gdsii_boundarytext.m'
% ------------------------------------------------------------

    [bl,width] = gdsii_boundarytext(str,pos,height,ang,layer,0);

end
