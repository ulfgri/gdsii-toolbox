function [s] = sname(gelm)
%function [s] = sname(gelm)
%
% returns the structure name referenced in a reference element
%
% gelm :   a gds_element object
% s :      a string with the referenced structure name

    if ~isref(gelm.data.internal)
        error('gds_element.sname :  element is not a reference element.');
    end

    s = gelm.data.sname;

end
