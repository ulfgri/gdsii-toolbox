%
% script to make .mex files
%

% don't run on Linux or unix
if isunix && (exist('OCTAVE_VERSION')==5)
    fprintf('\n>>>\n');
    fprintf('>>> Use makemex-octave shell script to compile mex functions in Linux\n');
    fprintf('>>>\n\n');
    return;
end

% check if we are running on MATLAB
if ~(exist('OCTAVE_VERSION')==5)

    % low level functions
    fprintf('Compiling mex functions for low-level i/o on MATLAB ...\n');

    cd Basic/gdsio
    mex -O gds_open.c mexfuncs.c
    mex -O gds_close.c mexfuncs.c
    mex -O gds_ftell.c mexfuncs.c
    mex -O gds_structdata.c gdsio.c mexfuncs.c 
    mex -O gds_libdata.c gdsio.c mexfuncs.c
    mex -O gds_beginstruct.c gdsio.c mexfuncs.c
    mex -O gds_endstruct.c gdsio.c mexfuncs.c
    mex -O gds_beginlib.c gdsio.c mexfuncs.c
    mex -O gds_endlib.c gdsio.c mexfuncs.c
    mex -O gds_write_element.c gdsio.c mexfuncs.c
    mex -O gds_read_element.c gdsio.c mexfuncs.c mxlist.c
    mex -O gds_record_info.c gdsio.c mexfuncs.c

    cd ../@gds_element/private
    mex -O poly_iscwmex.c
    mex -O poly_areamex.c
    mex -O -I../../gdsio isref.c
    mex -O -I../../gdsio get_etype.c
    mex -O -I../../gdsio is_not_internal.c
    mex -O -I../../gdsio new_internal.c
    mex -O -I../../gdsio has_property.c
    mex -O -I../../gdsio get_element_data.c ../../gdsio/mexfuncs.c
    mex -O -I../../gdsio set_element_data.c ../../gdsio/mexfuncs.c

    cd ../../../Structures/private
    mex -O datamatrixmex.c

    % Boolean functions
    fprintf('Compiling Boolean set algebra functions (Clipper)...\n');

    % for Clipper library
    cd ../../Boolean
    mex -O poly_boolmex.cpp clipper.cpp

    % back up
    cd ..
        
else % we are on Octave with gcc

    % low level functions
    fprintf('Compiling mex functions for low-level i/o on Octave/Windows ...\n');

    setenv('CFLAGS', '-O3 -fomit-frame-pointer -march=native -mtune=native');
    setenv('CXXFLAGS', '-O3 -fomit-frame-pointer -march=native -mtune=native');

    cd Basic/gdsio
    mex gds_open.c mexfuncs.c
    mex gds_close.c mexfuncs.c
    mex gds_ftell.c mexfuncs.c
    mex gds_structdata.c gdsio.c mexfuncs.c 
    mex gds_libdata.c gdsio.c mexfuncs.c
    mex gds_beginstruct.c gdsio.c mexfuncs.c
    mex gds_endstruct.c gdsio.c mexfuncs.c
    mex gds_beginlib.c gdsio.c mexfuncs.c
    mex gds_endlib.c gdsio.c mexfuncs.c
    mex gds_write_element.c gdsio.c mexfuncs.c
    mex gds_read_element.c gdsio.c mexfuncs.c mxlist.c
    mex gds_record_info.c gdsio.c mexfuncs.c

    cd ../@gds_element/private
    mex poly_iscwmex.c
    mex poly_areamex.c
    mex -I../../gdsio isref.c
    mex -I../../gdsio get_etype.c
    mex -I../../gdsio is_not_internal.c
    mex -I../../gdsio new_internal.c
    mex -I../../gdsio has_property.c
    mex -I../../gdsio get_element_data.c ../../gdsio/mexfuncs.c
    mex -I../../gdsio set_element_data.c ../../gdsio/mexfuncs.c

    cd ../../../Structures/private
    mex datamatrixmex.c
    
    % Boolean functions
    fprintf('Compiling Boolean set algebra functions (Clipper)...\n');
    
    % for Clipper library
    cd ../../Boolean
    mex poly_boolmex.cpp clipper.cpp
    
    % back up
    cd ..

end

fprintf('Done.\n');
