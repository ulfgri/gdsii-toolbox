function [bbx, ref] = bbox(gstruc)
%function [bbx, ref] = bbox(gstruc)
%
% Method returns the bounding box of gds_structure objects and
% geometry information for all the reference elements in the 
% gds_structure object.
% 
% Input:
% gstruc :  a gds_structure object
%
% Output: 
% bbx :    a vector [llx,lly,urx,ury] with the coordinates of the
%          lower left and upper right corners of the bounding box. 
% ref :    a structure array with information regarding the reference
%          elements found in the structure:
%            ref.sname :  name of the referenced structure
%            ref.strans:  associated strans record (can be empty)
%            ref.xy:      translation of referenced structure
%            ref.adim:    dimensions for an array reference

% Initial version, Ulf Griesmann, November 2015
    
    % allocate a table for element bounding boxes
    nel = numel(gstruc.el);
    bbel = zeros(nel,4); % max number of elements
    
    % pre-allocate structure array with references
    ref = repmat(struct('sname',[], 'strans',[], ...
                        'xy',[], 'adim',[]), nel, 1);
    
    % initialize this and that
    ref = [];
    elc = 0;  % element counter
    rec = 0;  % reference counter

    % iterate over all elements in the structure
    for k = 1:nel
        elk = gstruc.el{k};                % k-th element
        if is_ref(elk)
            rec = rec+1;
            ref(rec).sname  = sname(elk);  % structure name
            ref(rec).strans = strans(elk); % transformations
            ref(rec).xy     = xy(elk);     % translations
            ref(rec).adim   = adim(elk);   % array dimensions
        else
            elc = elc+1;
            bbel(elc,:) = bbox(elk);
        end
    end
    
    % calculate box
    if elc
        bbx = [min(bbel(1:elc,1:2),[],1), max(bbel(1:elc,3:4),[],1)];
    else
        bbx = [Inf,Inf,-Inf,-Inf]; % only reference elements found
    end
    
    % truncate reference array
    ref = ref(1:rec);
    
end
