function [ostruc] = add_element(istruc, varargin)
%function [ostruc] = add_element(istruc, varargin)
%
% Add elements or other structures to structures
%
% istruc :    a gds_structure object
% varargin :  a list of gds_element objects and/or a cell arrays of gds_element
%             objects
% ostruc :    gds_structure containing the new elements or structure
%

% Initial version, Ulf Griesmann, December 2011

    % test arguments
    if nargin < 2
       error('gds_structure.add_element :  must have at least two arguments.');
    end

   % copy input to output
   ostruc = istruc;

   for k=1:length(varargin)

       E = varargin{k};
       if isa(E, 'gds_element')
           ostruc.el{end+1} = E;
       elseif iscell(E)
          if ~all(cellfun(@(x)isa(x,'gds_element'), E))
             error('gds_structure.add_element :  cell array member is not a gds_element.');
          end
          ostruc.el = [istruc.el, E(:)']; % make row vector 
       else
          error('gds_structure.add_element : arguments must be gds_elements or cell arrays.');
       end 
    end

end
