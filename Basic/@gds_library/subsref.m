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

    % convert cs-lists --> cell arrays
    itype = {ins.type};
    isubs = flatten({ins.subs});
    
    % first indexing operator
    switch itype{1}
 
      case '()'
        
        idx = isubs{1};
        
        if ischar(idx) && idx == ':'
            gstrs = glib.st(1:end);
        elseif length(idx) == 1      % return one structure
            gstrs = glib.st{idx};
        else
            gstrs = glib.st(idx);
        end
        
      case '.'                        % look up structure name
        
        for k = 1:length(glib.st)
            if strcmp(ins.subs, get(glib.st{k}, 'sname')) 
                gstrs = glib.st{k};
                return 
            end
        end 
        
        error(sprintf('gds_library.subsref :  structure >> %s << not found', ins.subs));   
        
      otherwise
        error('gds_library.subsref :  invalid indexing type.');
        
    end

    % pass additional structure indexing to structure subsref method
    if length(itype) > 1
        sins.type = itype{2};
        sins.subs = isubs{2};
        if iscell(gstrs)
            gstrs = cellfun(@(x)subsref(x, sins), gstrs, 'Un',0); 
        else
            gstrs = subsref(gstrs, sins); 
        end
    end
    
    % flatten a cell array
    function fca = flatten(ca)
        
        fca = cell(size(ca));
    
        for k = 1:length(ca)
            if iscell(ca{k})
                ct = ca{k};
                fca{k} = ct{1};
            else
                fca(k) = ca(k);
            end
        end    
    end
  
end  
