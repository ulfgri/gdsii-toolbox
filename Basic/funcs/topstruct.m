function [ts] = topstruct(cas)
%function [ts] = topstruct(cas)
%
% topstruct :  return the name(s) of the top structure(s)
%              in a cell array of gds_structure objects
%              or display the top structures.
%
% cas :   a cell array of gds_structure objects
% ts :    a cell array with names of top level structures

% Initial version, Ulf Griesmann, December 2012

    % calculate the adjacency matrix of the structure tree
    [A,N] = adjmatrix(cas);

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
