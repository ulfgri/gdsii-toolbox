function [bbx] = bbox(gelm)
%function [bbx] = bbox(gelm)
%
% Method returns the bounding box of gds_element objects.
% 
% Input:
% gelm :  a gds_element object (can be a compound element)
%
% Output: 
% bbx :   a vector [llx,lly,urx,ury] with the coordinates of the
%         lower left and upper right corners of the bounding box. 
%         Reference elements and node and text elements have no 
%         bounding box. The bounding box returned for path elements 
%         may be slightly too large because it can only be
%         calculated exactly after the path element has been
%         rendered.

% Initial version, Ulf Griesmann, November 2015
    
    switch etype(gelm)
        
      case 'boundary'
          bbx = calc_bbox(gelm.data.xy);
        
      case 'path'
          ptype = 0;
          pwidth = 0;
          ext = struct('beg',0,'end',0);

          if has_property(gelm.data.internal, 'width')
              pwidth = get_element_data(gelm.data.internal, 'width');
          else
              error('gds_element.bbox :  path must have width property.');
          end
          if has_property(gelm.data.internal, 'ext')
              ext = get_element_data(gelm.data.internal, 'ext');
          end
          if has_property(gelm.data.internal, 'ptype')
              ptype = get_element_data(gelm.data.internal, 'ptype');
          end
          
          cab = cell(numel(gelm.data.xy),1);
          for k = 1:numel(cab)
              cab{k} = path_to_polygon(gelm.data.xy{k}, pwidth, ptype, ext);
          end
          bbx = calc_bbox(cab);
        
      case 'box'
          bbx = calc_bbox(gelm.data.xy);
        
      otherwise % for sref, aref, node, and text
          bbx = [Inf,Inf,-Inf,-Inf]; % inside any other box
    end
end


function bbx = calc_bbox(xy)
%
% calculate the bounding box of a cell array of nx2 matrices
%
    len = numel(xy);
    if len == 1      % one polygon is a common case; handle it directly 
        bbx = [min(xy{1}),max(xy{1})];
    else
        ll = zeros(len,2); % lower left corner
        ur = zeros(len,2); % upper right corner
        for k = 1:len
            ll(k,:) = min(xy{k});
            ur(k,:) = max(xy{k});
        end
        bbx = [min(ll),max(ur)];
    end
    
end
