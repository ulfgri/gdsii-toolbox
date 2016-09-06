function [olib] = sremove(ilib, rsname)
%function [olib] = sremove(ilib, rsname)
%
% sremove :  removes a structure and all references to 
%            the structure from a library.
%
% ilib :    input gds_library object
% rsname :  referenced structure name
% olib :    output gds_library object

% initial version, September 2016, Ulf Griesmann

    olib = ilib;

    % find the structure to remove
    idx =  1;
    while idx <= numel(ilib.st)  
        if strcmp(rsname, sname(ilib.st{idx}))
            break
        end
        idx = idx + 1;
    end
    
    % remove the structure
    olib.st(idx) = [];
    
    % remove all references to the deleted structure
    olib.st = cellfun(@(x)refremove(x,rsname), olib.st, 'UniformOutput',0);
    
end
