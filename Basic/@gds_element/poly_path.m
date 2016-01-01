function belm = poly_path(pelm)
%function belm = poly_path(pelm)
%
% converts a path element into an equivalent boundary element.
%
% pelm :  input path element
% belm :  output boundary element
%

% Initial version, Ulf Griesmann, December 2011
% Convert paths with multiple path segments; Ulf Griesmann, August2012
% Convert to new internal data structure; Ulf Griesmann, July 2013

    % check if input is a path
    if ~strcmp(get_etype(pelm.data.internal), 'path')
        error('gds_element.poly_path :  input must be path element.');
    end

    % create new element data structure and copy relevant properties
    data.internal = new_internal('boundary');
    plist = {'layer',get_element_data(pelm.data.internal,'layer'), ...
             'dtype',get_element_data(pelm.data.internal,'dtype')};
    if has_property(pelm.data.internal, 'elflags')
        plist = [plist, {'elflags',get_element_data(pelm.data.internal)}];
    end
    if has_property(pelm.data.internal, 'plex')
        plist = [plist, {'plex',get_element_data(pelm.data.internal)}];
    end
    data.internal = set_element_data(data.internal, plist);

    % convert paths
    ptype = 0;
    width = 0;
    ext = struct('beg',0,'end',0);
    if has_property(pelm.data.internal, 'ptype')
        ptype = get_element_data(pelm.data.internal, 'ptype');
    end
    if has_property(pelm.data.internal, 'width')
        width = get_element_data(pelm.data.internal, 'width');
    else
        error('poly_path :  path must have width property.');
    end
    if has_property(pelm.data.internal, 'ext')
        ext = get_element_data(pelm.data.internal, 'ext');
    end

    data.xy = cell(1,length(pelm.data.xy));
    for k=1:length(pelm.data.xy)
        data.xy{k} = path_to_polygon(pelm.data.xy{k}, width, ptype, ext);
    end
    
    % create new element
    belm = gds_element([], data); 

end
