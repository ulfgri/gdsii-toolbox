function [S,L] = layerinfo(gstruc)
%function [S,L] = layerinfo(gstruc)
%
% layerinfo :  displays information about the
%              distribution of elements on layers
%              in a gds_structure object.
%
% gstruc : a gds_structure object
% S :      (Optional) structure array with number of element 
%          per layer.
%          S(k).(etype) contains the number of elements of 
%          type 'etype' on layer k. E.g.: S(10).boundary
%          When the output argument is omitted, the layer
%          information is printed on the screen.
% L :      (Optional) a vector with layers that contain elements
%

% initial version, Ulf Griesmann, NIST, August 30, 2016

    % initialize variables for accounting
    numl = 256; % max number of layers
    Si = repmat(struct('boundary',0,'path',0,'box',0,'node',0,'text',0),1,numl);
    Li = zeros(1,numl);
    
    % iterate over all elements
    for s=1:numel(gstruc.el)
        el = gstruc.el{s};
        if ~is_ref(el)            % sref and aref have no layer information
            numl = layer(el) + 1; % gds layer numbers start with 0
            Li(numl) = Li(numl) + 1; 
            Si(numl).(etype(el)) = Si(numl).(etype(el)) + 1;
        end
    end

    %display
    if ~nargout
        fprintf('\n');
        for k = find(Li)
            fprintf('   L %-3d ->  ', k-1); % layers start with 0
            if Si(k).boundary
                fprintf('%8d Bnd ', Si(k).boundary);
            end
            if Si(k).path
                fprintf('%8d Pth ', Si(k).path);
            end
            if Si(k).box
                fprintf('%8d Box ', Si(k).box);
            end
            if Si(k).node
                fprintf('%8d Nde ', Si(k).node);
            end
            if Si(k).text
                fprintf('%8d Txt ', Si(k).text);
            end 
            fprintf('\n');
        end
        fprintf('\n');
    else
    
        % return layer numbers with elements
        L = find(Li) - 1;
        if nargout > 1
            S = Si;
        end
        
    end
    
end
