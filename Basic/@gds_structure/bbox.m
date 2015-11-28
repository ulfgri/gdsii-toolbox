function [bbx, ref] = bbox(gstruc)
%function [bbx, ref] = bbox(gstruc)
%
% Method returns the bounding box of gds_structure objects.
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
    nel = length(gstruc.el);
    bbel = zeros(nel,4); % max number of elements
    
    % initialize this and that
    ref = [];
    elc = 0;  % element counter
    rec = 0;  % reference counter

    % iterate over all elements
    for k = 1:nel
        if is_ref(gstruc.el{k})
            rec = rec+1;
            E = gstruc.el{k};
            ref(rec).sname  = E.sname;   % structure name
            ref(rec).strans = E.strans;  % transformations
            ref(rec).xy     = E.xy;      % translations
            if is_etype(E,'aref')
                ref(rec).adim = E.adim;
            else
                ref(rec).adim = [];
            end
        else
            elc = elc+1;
            bbel(elc,:) = bbox(gstruc.el{k});
        end
    end
    
    % calculate box
    if elc
        bbx = [min(bbel(1:elc,1:2),[],1), max(bbel(1:elc,3:4),[],1)];
    else
        bbx = [Inf,Inf,-Inf,-Inf]; % only reference elements found
    end
    
end
