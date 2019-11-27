function [ostruc] = add_ref(istruc, struc, varargin)
%function [ostruc] = add_ref(istruc, struc, varargin)
%
% Adds reference elements to structures
%
% istruc :   a gds_structure object
% struc :    a gds_structure object, a cell array of gds_structure
%            objects, a structure name, or a cell array of structure names
%            to be referenced.
% varargin : variable/property pairs to describe the placement of
%            the gds_structure. The default position 'xy' is [0,0].
% ostruc :   gds_structure containing the input structure with the added
%            reference elements.
%
% Example:
%  sts.angle = 45;
%  sts.mag   = 1.7;
%  struc = add_ref(struc, {beauty,truth} 'xy',[1000,1000], 'strans',sts);
%

% Initial version, Ulf Griesmann, December 2011

   % copy input to output
   ostruc = istruc;

   % get structure name, create cell array S of structure names
   if ischar(struc)
      S = {struc};   
   elseif isa(struc, 'gds_structure')
      S = {struc.sname};
   elseif iscell(struc)
      if all( cellfun(@(x)ischar(x), struc) )
	 S = struc;
      elseif all( cellfun(@(x)isa(x,'gds_structure'), struc) )
         S = cellfun(@(x)sname(x), struc, 'UniformOutput',0);
      else
         error('gds_structure.add_ref: all objects in cell array must be strings or gds_structure objects.');
      end
   else
      error('gds_structure.add_ref:  second argument must be a string | gds_structure | cell array.');
   end

   % 'adim' property present --> create aref elements
   if any( strcmp(varargin(1:2:length(varargin)), 'adim') ) % create aref elements
      rtype = 'aref';
   else
      rtype = 'sref';
   end
   
   % create reference elements
   rel = cellfun(@(x)gds_element(rtype, 'sname',x, varargin{:}), S, 'UniformOutput',0);
   
   % add them to output structure
   ostruc.el = [ostruc.el, rel];

end
