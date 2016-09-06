function [ostruc] = refremove(istruc, rsname)
%function [ostruc] = refremove(istruc, rsname)
%
% refremove :  removes all reference elements that contain
%              a reference to a specified structure.
%
% istruc :  input gds_structure object
% rsname :  referenced structure name
% ostruc :  output gds_structure object

% initial version, September 2016, Ulf Griesmann

    ostruc = istruc;

    % look for reference elements
    rel = logical( cellfun(@(x)is_ref(x)&&strcmp(rsname,sname(x)), ostruc.el) );
    
    % remove them
    if any(rel)
        ostruc.el = ostruc.el(~rel);
    end
    
end
