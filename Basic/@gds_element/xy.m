function [pos] = xy(gelm)
%function [pos] = xy(gelm)
%
% returns the position information in a reference element
%
% gelm :   a gds_element object
% pos :    a cell array containing one or more nx2 matrices 
%          with reference positions

    if ~isfield(gelm.data, 'xy')
        error('gds_element.xy :  element has no position data.');
    end

    pos = gelm.data.xy;

end
