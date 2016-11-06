function [lay, dtype] = layer(gelm)
%function [lay, dtype] = layer(gelm)
%
% returns layer and data type properties of an element
% (this method is faster than field indexing)
%
% gelm :   a gds_element object
% lay :    layer property
% dtype :  (Optional) data type property

    if isref(gelm.data.internal)
        error('gds_element: element has no layer/datatype property.');
    end

    lay = get_element_data(gelm.data.internal, 'layer');
    
    if nargout > 1
        dtype = get_element_data(gelm.data.internal, 'dtype');
    end

end
