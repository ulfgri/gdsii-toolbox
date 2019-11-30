function write_gds_library(glib, fname, varargin)
%function write_gds_library(glib, fname, varargin)
% 
% writes a GDS library object to a file
%
% glib  :     a gds_library object
% fname :     GDS file name. When the file name has the extension .cgds 
%             a compound GDS file is created instead of a standard GDS file.
% varargin :  optional argument/value pairs 
%
%             verbose : when == 1, print out information about the
%                 library. When > 1 also displays the top level structures
%                 (can be very slow). Default is 1 (medium verbose).
%
%             compound : when == 1, a library with file extension
%                 .cgds containing compound elements is created. Compound
%                 elements are stored with multiple XY records per
%                 element. They are not compatible with other software for
%                 processing GDSII layout files.  Default is 0.
%
%             unique : when == 1, the function checks if all
%                 structure names in the library are unique. This
%                 option allows the check to be turned off because
%                 it can be slow. Default is 1 (check uniqueness). 
%

% Ulf Griesmann, NIST, November 2011

    % check argument number
    if nargin < 3, varargin = []; end
    if nargin < 2 
        error('missing file name argument.');
    end
    
    if ~ischar(fname)
        error('second argument must be a character string.');
    end
    
    % defaults
    verbose = 1;
    compound = 0;
    uniq = 1;
    
    % process varargin
    if ~isempty(varargin)
        for idx = 1:2:length(varargin)
            prop = varargin{idx};
            valu = varargin{idx+1};
            switch prop        
              case 'verbose'
                verbose = valu;
              case 'compound'
                compound = valu;
              case 'unique'
                uniq = valu;
              otherwise
                error(sprintf('unknown property --> %s\n', prop));
            end
        end
    end
    
    % extension selects compound flag
    if strcmp(fname(end-4:end),'.cgds')
        compound = 1;
    end
    
    % check if all structure names are unique if option selected
    if uniq
        N = cellfun(@(x)sname(x), glib.st, 'UniformOutput',0); % structure names
        if length(N) ~= length(unique(N))
            error('write_gds_library :  structure names are not unique.');
        end
    end
    
    if verbose
        if fname(1) == '!';
            fprintf('\nLibrary file  : %s\n', fname(2:end));
        else
            fprintf('\nLibrary file  : %s\n', fname);
        end
        fprintf('Library name  : %s\n', glib.lname);
        fprintf('User unit     : %g m\n', glib.uunit);
        fprintf('Database unit : %g m\n', glib.dbunit);
        fprintf('Structures    : %d\n\n', numel(glib.st));
    end
    
    % top level structures
    if verbose > 1
        fprintf('Top level: ');
        tls = topstruct(glib);
        if iscell(tls)
            for k=1:length(tls)
                fprintf('%s  ', tls{k});
            end
        else
            fprintf('%s', tls);
        end
        fprintf('\n\n');
    end
    
    % start time
    t_start = cputime();
    
    % initialize the library file
    gf = gds_initialize(fname, glib.uunit, glib.dbunit, ...
                        glib.lname, glib.reflibs, glib.fonts);
    
    % write all structures in library to file
    cellfun(@(x)write_structure(x,gf,glib.uunit,glib.dbunit,compound), glib.st);
    
    % close file
    gds_endlib(gf);
    gds_close(gf);
    
    % end time
    if verbose
        t_el = (cputime() - t_start) / 86400;  % elapsed time in days
        fprintf('Write time: %s\n\n', datestr(t_el, 'HH:MM:SS.FFF'));
    end
    
end
