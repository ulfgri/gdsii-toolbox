function [pos] = xy(gelm)
%function [pos] = xy(gelm)
%
% returns the positions in a reference element
%
% gelm :   a gds_element object
% pos :    a nx2 matrix with reference positions

    pos = gelm.data.xy;

end
