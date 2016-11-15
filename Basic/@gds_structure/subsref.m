function gelp = subsref(gstruct, ins)
%function gstp = subsref(gstruct, ins)
%
% subscript reference method for the gds_structure class
%
% gstruct :  a gds_structure object
% ins :      an array index reference structure
% gelp :     a gds_element object or 
%            a cell array of the indexed gds_element objects
%            or a structure property when structure name
%            referencing is used

% Ulf Griesmann, NIST, June 2011

    % first indexing operator
    idx = ins(1).subs;

    switch ins(1).type
 
      case '()'
        
        if iscell(idx)
            idx = idx{:};
        end
        
        if ischar(idx) && idx == ':'
            gelp = gstruct.el;
        elseif length(idx) == 1 
            gelp = gstruct.el{idx};  % return element
        else
            gelp = gstruct.el(idx);  % return cell array of elements
        end
        
      case '.'
        
        try
            gelp = gstruct.(ins(1).subs);
        catch
            error('gds_structure.subsref :  invalid structure property.');
        end
        
      otherwise
        error('gds_structure.subsref :  invalid indexing type.');
        
    end
  
    % pass additional element indexing to element subsref method
    if length(ins) > 1
        if iscell(gelp)
            gelp = cellfun(@(x)subsref(x, ins(2:end)), gelp, 'Un',0); 
        else
            gelp = subsref(gelp, ins(2:end)); 
        end
    end
    
end  
