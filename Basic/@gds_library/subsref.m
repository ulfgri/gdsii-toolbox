function gstrs = subsref(glib, ins)
%function gstrs = subsref(glib, ins)
%
% subscript reference method for the gds_library class
%
% glib  :   a gds_structure object
% ins   :   an array index reference structure
% gstrs :   a gds_structure object or a 
%           cell array of the indexed gds_structure objects

% Ulf Griesmann, NIST, June 2011

    gstrs = [];
    
    % first indexing operator
    idx = ins(1).subs;
    
    switch ins(1).type
 
      case '()'
                
        if iscell(idx)
            idx = idx{:};
        end
        
        if ischar(idx) && idx == ':'
            gstrs = glib.st;
        elseif length(idx) == 1      % return one structure
            gstrs = glib.st{idx};
        else
            gstrs = glib.st(idx);
        end
        
      case '.'                        % look up structure name
        
        for k = 1:length(glib.st)
            if strcmp(idx, sname(glib.st{k})) 
                gstrs = glib.st{k};
                break;
            end
        end 
    
        if isempty(gstrs)
            error(sprintf('gds_library.subsref :  structure >> %s << not found', ins.subs));   
        end
        
      otherwise
        error('gds_library.subsref :  invalid indexing type.');
        
    end

    % pass additional structure indexing to structure subsref method
    if length(ins) > 1
        if iscell(gstrs)
            gstrs = cellfun(@(x)subsref(x, ins(2:end)), gstrs, 'Un',0); 
        else
            gstrs = subsref(gstrs, ins(2:end)); 
        end
    end
  
end  
