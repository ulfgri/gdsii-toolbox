function gelm = subsasgn(gelm, ins, val)
%function gelm = subsasgn(gelm, ins, val)
%
% Subscript assign method for the gds_element class
% Enables addressing element properties using
% structure field name indexing.
%
% gelm :  gds_element object to be modified
% ins :   index structure
% val :   new value

% Ulf Griesmann, NIST, June 2011, July 2013

    switch ins.type
  
      case '.'
          if is_not_internal(ins.subs)
              gelm.data.(ins.subs) = val;
          else
              gelm.data.internal = set_element_data(gelm.data.internal, {ins.subs,val});
          end

      case '()'
          idx = ins.subs{:};
 
          switch get_etype(gelm.data.internal)
              
            case {'boundary','path'}
                if iscell(val)
                    gelm.data.xy(idx) = val;
                else
                    gelm.data.xy{idx} = val;
                end
            
            case 'sref'
                gelm.data.xy(idx,:) = val;
              
            otherwise
                error('element must be boundary, path, or sref.');
          end

      otherwise
        error('gds_element.subsasgn :  must use structure field name indexing.');
        
    end
    
end
