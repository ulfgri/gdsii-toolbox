function [p] = prop(gelm)
%function [p] = prop(gelm)
%
% returns the property structure(s) of a gds_element object
%
% gelm :  a gds_element object
% p :     a structure array with element properties

    if ~isfield(gelm.data, 'prop')
        error('gds_element.prop :  element has no property data.');
    end
    
    p = gelm.data.prop;

end
