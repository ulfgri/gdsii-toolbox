function lpidx = end(gelm, kide, nide)
%function lpidx = end(gelm, kide, nide)
%
% end method for the gds_element class.
% Returns the index of the last polygon in the 
% gds_element object
%
% gelm :  a gds_structure object of boundary, path, or sref type
% kide :  index in expression that uses the end keyword
%         (should be 1)
% nide :  total number of indices in the expression
%         (should be 1)
% lpidx : index of the last polygon or location

    if kide ~= 1 || nide ~= 1
        error('gds_element :  has only one index.');
    end
    
    switch get_etype(gelm.data.internal)

      case {'boundary','path'}
        lpidx = numel(gelm.data.xy);
        
      case 'sref'
        lpidx = size(gelm.data.xy,1);
      
      otherwise
        error('element must be boundary, path, or sref.');
        
    end

end
