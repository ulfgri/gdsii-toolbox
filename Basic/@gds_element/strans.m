function [st] = strans(gelm)
%function [st] = strans(gelm)
%
% returns the strans record of a reference element
%
% gelm :   a gds_element object
% st :     structure with strans information

    st = get_element_data(gelm.data.internal, 'strans');

end
