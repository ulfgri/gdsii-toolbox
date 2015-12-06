function [ts] = topstruct(glib)
%function [ts] = topstruct(glib)
%
% topstruct :  return the name(s) of the top structure(s)
%              in a gds_library object or display the structure
%              names if no output argument is present.
%
% glib : a gds_library object
% ts :   cell array with names of top level structures

% Initial version, Ulf Griesmann, December 2011

    % calculate the adjacency matrix of the structure tree
    [A,N] = adjmatrix(glib.st);

    % find top level structure name(s)
    tops = N(find(sum(A)==0));

    % display or return the structure names
    if nargout
        ts = tops;
    else
        fprintf('\n');
        for k = 1:length(tops)
            fprintf('   %s\n', tops{k});
        end
        fprintf('\n');
    end

end
