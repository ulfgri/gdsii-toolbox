function [olib] = add_struct(ilib, varargin);
%function [olib] = add_struct(ilib, varargin);
%
% Add structures to gds_library objects
%
% ilib :      a gds_library object
% varargin :  a list of gds_structure objects and/or a cell arrays of 
%             gds_structure objects
% olib :      gds_library containing old and new structures

    % test arguments
    if nargin < 2
       error('gds_library.add_struct :  must have at least two arguments.');
    end

    % copy input to output
    olib = ilib;

    for k=1:length(varargin)

       S = varargin{k};
       if isa(S, 'gds_structure')
          olib.st{end+1} = S;
       elseif iscell(S)
          if ~all(cellfun(@(x)isa(x,'gds_structure'), S))
             error('gds_library.add_struct :  input cell array member is not a gds_structure.');
          end
          olib.st = [ilib.st, S(:)']; % make row vector 
       else
          error('gds_library.add_struct : arguments must be gds_structures or cell arrays.');
       end 
    end

end
