function cas = getstruct(glib, sname)
%function cas = getstruct(glib, sname)
%
% getstruct: copy structures from libraries by name. The method
%            returns a cell array with gds_structure 
%            objects with the specified name(s).
%
% Input:
% glib :   input gds_library object
% sname :  string with name of a structure or cell array
%          of strings
%
% Output:
% cas :    cell array of gds_structure objects

% Initial version, Ulf Griesmann, February 2015

    % check input arguments
    if ~ischar(sname) && ~iscell(sname)
        error('Argument ''sname'' must be string or cell array.');
    end
    if ischar(sname)
        sname = {sname};
    end
    
    % find all structure names from library
    N = cellfun(@sname, glib.st, 'UniformOutput',0);

    % find indices of structures
    stri = find(ismember(N,sname) > 0);
    if length(stri) < length(sname)
        error('One or more structures not found in library.');
    end
    
    % return structures
    cas = glib.st(stri);
    
end
