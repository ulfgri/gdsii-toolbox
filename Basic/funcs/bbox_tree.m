function [bbx] = bbox_tree(cas)
% function [bbx] = bbox_tree(cas)
%
% Calculates the boundary box of a GDSII structure tree
%
% Input:
% cas :  a cell array of gds_structure objects
%
% Output:
% bbx :   a vector [llx,lly,urx,ury] with the coordinates of the
%         lower left and upper right corners of the bounding box. 

% Initial version, Ulf Griesmann, December 2015
% major bug fixes, Alexandre Simard, March 2021
    
    % calculate boundary boxes before resolving the hierarchy
    % to minimize computations especially for leaf nodes 
    caslen = numel(cas);
    bbdata = repmat(struct('bbox',[Inf,Inf,-Inf,-Inf], ...
                           'ref',[],'name',[]), caslen,1);
    for k = 1:caslen
        [bbdata(k).bbox, bbdata(k).ref] = bbox(cas{k});
        bbdata(k).name = get(cas{k},'sname');
    end

    % find top level structure(s) - they have no parents
    [A,N] = adjmatrix(cas);
    T = find(sum(A)==0);    % array with top parent indices
    
    % calculate bounding boxes of all top level structures
    bbst = zeros(length(T),4);
    for k=1:length(T)
        bbst(k,:) = bbox_struct(A, bbdata, T(k), N); 
    end
    
    bbx = [min(bbst(:,1:2),[],1),max(bbst(:,3:4),[],1)];
    
end


function [bbst] = bbox_struct(A, bbdata, sidx, N)
%
% This function is called recursively to apply strans
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
    
    % resolve references in each child structure
    for k = 1:length(chi)
       
        % recursively calculate boundary box of the referenced structures
        bbr = bbox_struct(A, bbdata, chi(k), N);
        
        % apply any transformations to the boundary box
        
        % Find the sref of this refrences structured
        refloc = bbdata(sidx).ref;
        ind = arrayfun(@(x)strcmp(N{chi(k)},x.sname), refloc, 'UniformOutput', false);
	ind = horzcat(ind{:});    
        refloc = refloc(ind);
        
        nref = length(refloc);        
        b = zeros(nref,4);
        for m = 1:nref
            if isempty(refloc(m).adim)  % sref
                b(m,:) = bbox_strans(bbr, refloc(m).strans);
                b(m,:) = b(m,:) + ...
                         [refloc(m).xy, refloc(m).xy];
            else                        % aref
                b(m,:) = bbox_aref(bbr, refloc(m).strans, ...
                                        refloc(m).xy, ...
                                        refloc(m).adim);
            end
        end

        B(k,:) = [min(b(:,1:2),[],1), max(b(:,3:4),[],1)];
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

    % matrix with all 4 box corners
    box = [bb(1,1),bb(1,2); ...
           bb(1,3),bb(1,2); ...
           bb(1,3),bb(1,4); ...
           bb(1,1),bb(1,4)];

    box = apply_strans(box, strans);
    
    % return to boundary box format
    bbt = [min(box),max(box)];

end


function [bba] = bbox_aref(bbr, strans, xy, adim)
%
% calculates the bounding box of an aref
%
    % matrix with all 4 box corners of referenced box
    box = [bbr(1,1),bbr(1,2); ...
           bbr(1,3),bbr(1,2); ...
           bbr(1,3),bbr(1,4); ...
           bbr(1,1),bbr(1,4)];

    % apply an strans to the box if one exists
    if ~isempty(strans)
        box = apply_strans(box, strans);
    end
    
    % calculate the boxes in the four corners of the array
    fourbox = zeros(16,2);
    xy1 = xy(1,:);
    xy2 = xy1 + (adim.col-1) * (xy(2,:) - xy1) / adim.col;
    xy3 = xy1 + (adim.row-1) * (xy(3,:) - xy1) / adim.row;
    fourbox = zeros(16,2);
    fourbox(1:4,:)   = bsxfun(@plus, box, xy1);
    fourbox(5:8,:)   = bsxfun(@plus, box, xy2);
    fourbox(9:12,:)  = bsxfun(@plus, box, xy3);
    fourbox(13:16,:) = bsxfun(@plus, box, xy2 + xy3 - xy1);

    % return bounding box
    bba = [min(fourbox), max(fourbox)];
    
end


function [box] = apply_strans(box, strans)
    
    % reflection comes after rotation
    if isfield(strans,'reflect') && strans.reflect
        box(:,2) = -box(:,2);
    end

    % first rotate
    if isfield(strans,'angle') && ~isempty(strans.angle) && strans.angle~=0
        box = poly_rotzd(box, strans.angle); % rotated box
    end

    % magnification
    if isfield(strans,'mag') && ~isempty(strans.mag)
        box = strans.mag * box;
    end
    
    if isfield(strans,'absmag') && strans.absmag
        error('bbox_tree: strans.absmag not suported.');
    end

    if isfield(strans,'absang') && strans.absang
        error('bbox_tree: strans.absang not suported.');
    end

end
