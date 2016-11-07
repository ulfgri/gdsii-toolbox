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

    % convert cs-lists --> cell arrays
    itype = {ins.type};
    isubs = {ins.subs};
    
    % first indexing operator
    switch itype{1}
 
      case '()'
        
        idx = isubs{1};
        if iscell(idx)
            idx = idx{1};
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
            gelp = gstruct.(ins.subs);
        catch
            error('gds_structure.subsref :  invalid structure property.');
        end
        
      otherwise
        error('gds_structure.subsref :  invalid indexing type.');
        
    end
  
    % pass additional element indexing to element subsref method
    if length(itype) > 1
        eins.type = itype{2};
        eins.subs = isubs{2};
        if iscell(gelp)
            gelp = cellfun(@(x)subsref(x, eins), gelp, 'Un',0); 
        else
            gelp = subsref(gelp, eins); 
        end
    end
    
end  
