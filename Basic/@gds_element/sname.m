function [s] = sname(gelm);
%function [s] = sname(gelm);
%
% returns the structure name referenced in a reference element
%
% gelm :   a gds_element object
% s :      a string with the referenced structure name

    s = get_element_data(gelm.data.internal, 'sname');

end
