function [bbx] = bbox_tree(cas)
%function [bbx] = bbox_tree(cas)
%
% bbox_tree: calculate the boundary box of a GDSII structure tree
%
% Input:
% cas :  a cell array of gds_structure objects
%
% Output:
% bbx :   a vector [llx,lly,urx,ury] with the coordinates of the
%         lower left and upper right corners of the bounding box. 

% Initial version, Ulf Griesmann, November 2015
    
    % calculate boundary boxes before resolving the hierarchy
    % to minimize computations especially for leaf nodes 
    caslen = length(cas);
    bbdata = repmat(struct('bbox',[Inf,Inf,-Inf,-Inf], ...
                           'sref',[]), caslen,1);
    for k = 1:caslen
        [bbdata(k).bbox, bbdata(k).sref] = bbox(cas{k});
    end

    % find top level structure(s) - they have no parents
    A = adjmatrix(cas);
    T = find(sum(A)==0);    % array with top parent indices
    
    % calculate bounding boxes of all top level structures
    bbst = zeros(length(T),4);
    for k=1:length(T)
        bbst(k,:) = bbox_struct(A, bbdata, T(k)); 
    end
    
    bbx = [min(bbst(:,1:2),[],1),max(bbst(:,3:4),[],1)];
    
end


function [bbst] = bbox_struct(A, bbdata, sidx)
%
% function that is called recursively to apply strans
% transformations to the pre-computed boundary boxes and to
% calculate the boundary boxes for the resolved structure
% hierarchy.
%
    
    % indices of child structures referenced by structure sidx
    chi = find(A(sidx,:));
        
    % check if we have reached a leaf structure
    if isempty(chi)   
        bbst = bbdata(sidx).bbox;
        return
    end
    
    % prepare array for bounding boxes
    B = zeros(length(chi)+1,4);
    
    % follow the references (also handles compound sref's)
    for k = 1:length(chi)
       
        % get the boundary box of the referenced structures
        bbr = bbox_struct(A, bbdata, chi(k));
        
        % apply any transformations to the boundary box
        if isempty(bbdata(sidx).sref(k).adim)  % sref
            B(k,:) = bbox_strans(bbr, bbdata(sidx).sref(k).strans);
            B(k,:) = B(k,:) + ...
                     [bbdata(sidx).sref(k).xy, bbdata(sidx).sref(k).xy];
        else                                   % aref
            bba = bbdata(sidx).sref(k).xy;
            bba(end+1,:) = bba(2,:) + bba(3,:) - bba(1,:);
            B(k,:) = [min(bba),max(bba)];
        end
        
    end
    
    % calculate the final boundary box
    B(k+1,:) = bbdata(sidx).bbox;
    bbst = [min(B(:,1:2),[],1), max(B(:,3:4),[],1)];
    
end


function [bbt] = bbox_strans(bb, strans)
% 
% apply transformations defined in an strans record to a boundary box
%

    % make sure strans is not empty
    if isempty(strans)
        bbt = bb;
        return
    end
    
    % re-arrange coordinates
    bb = reshape(bb,2,2)';
    
    % reflection comes first
    if isfield(strans,'reflect') && strans.reflect
        bb(:,1) = -bb(:,1);
    end
    
    % magnification
    if isfield(strans,'mag') && ~isempty(strans.mag)
        bb = strans.mag * bb;
    end
    
    % angle
    if isfield(strans,'angle') && ~isempty(strans.angle) && strans.angle~=0
        bb = poly_rotzd(bb, strans.angle);
    end
    
    % return to bbox format
    bbt = reshape(bb',1,4);
    
end
