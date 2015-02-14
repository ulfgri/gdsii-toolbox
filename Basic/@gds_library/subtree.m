function [cas] = subtree(glib, sname);
%function [cas] = subtree(glib, sname);
%
% subtree: a method that returns a cell array of
%             gds_structure objects that form a sub-tree 
%             of structures in a library with a user
%             specified structure as its top level.
%
% Input:
% glib :   input gds_library object
% sname :  name of the subtree top structure
%
% Output:
% cas :    cell array of gds_structure objects 

% Initial version, Ulf Griesmann, February 2015

    % indices of structures in subtree
    subtree_ind = [];

    % compute adjacency matrix of input library
    [A,N] = adjmatrix(glib.st);

    % find index of structure 'sname'
    stri = find(ismember(N,{sname}) > 0);
    if isempty(stri)
        error(sprintf('Structure >>> %s <<< not found in library.', sname));
    end

    % find the indices of all children
    find_children(A, stri);
    cas = glib.st(sort(unique(subtree_ind)));

    function find_children(A, pai);
      %
      % Recursively find all children of node pai.
      %
      for p = pai
  
         % add index to array
         subtree_ind(end+1) = p;
    
         % find the children
         chi = find(A(p,:)>0);
    
         % no more children
         if isempty(chi)
            continue
         end
    
         % look for the next generation
         for c = chi
            find_children(A, c);
         end
         
      end
   end % nested function

end
