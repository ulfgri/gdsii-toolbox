function rnam = find_ref(gstruct)
%function rnam = find_ref(gstruct)
%
% A method that finds and returns the names of all structures
% referenced in a structure
%
% gstruct :  a gds_structure object
% rnam :     a cell array of structure names referenced by gstruct 
%

% Ulf Griesmann, NIST, November 2011

   % max. length of output cell array
   nel = length(gstruct.el);
   rnam = cell(1,nel);
   
   m = 0;
   for k = 1:nel
       E = gstruct.el{k};
       if is_ref(E)
           m = m + 1;
           rnam{m} = sname(E);
       end
   end
   
   % truncate output array
   rnam = rnam(1:m);
   
end
