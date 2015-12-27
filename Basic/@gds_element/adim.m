function [a] = adim(gelm)
%function [a] = adim(gelm)
%
% returns the structure with the arrady dimensions of a reference element
%
% gelm :   a gds_element object
% a :      a structure with array dimensions a.col, a.row 

    a = get_element_data(gelm.data.internal, 'adim');

end
