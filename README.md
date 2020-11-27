
Octave / MATLAB Toolbox for GDSII Stream Format
===============================================

Ulf Griesmann, 2008 - 2020
ulf.griesmann@nist.gov, ulfgri@gmail.com

The GDSII library, or database, format has become an important
industry standard for the description of nano-structure designs that
are fabricated with either photo- or electron lithography - despite
being poorly documented. GDSII library files are used to define the
layout of integrated circuits, MEMS devices, nano-structured optics,
and so on. This toolbox of functions for MATLAB or
[Octave](https://octave.org) can be used to create, read, and modify
files in GDSII library format. The toolbox is particularly useful when
a layout is the result of numerical modeling as is often the case,
e.g., for nano-structured optics, photonic devices, or micro-fluidic
devices. MATLAB or Octave are efficient tools for post-processing of
modeling results and for creating a lithographic layout as input to
the fabrication process. The toolbox can also be used to modify GDSII
layout files using scripts, e.g. for merging of several layout
files. Layouts can be inspected with the excellent free layout viewer
[KLayout](https://klayout.de).

Most functions in this toolbox are in the Public Domain (see
Notice_and_Disclaimer.pdf), with the following exceptions:

- The library that is used by the toolbox for Boolean polygon algebra,
  [Clipper](https://sourceforge.net/projects/polyclipping/), is written by
  Angus Johnson (see:  Boolean/clipper.hpp and Boolean/clipper.cpp), and is subject
  to the [Boost Software license 1.0](http://www.boost.org/LICENSE_1_0.txt).

- The functionality for creating Datamatrix codes in Structures/private/datamatrixmex.c
  is subject the [GNU Public License version 2](http://www.gnu.org/licenses/gpl-2.0.html).

- The function for the conversion of floating point numbers to the format
  used in GDSII files, Basic/gdsio/convert_float_gcc.h, is subject to the [GNU Public
  License version 3](http://www.gnu.org/copyleft/gpl.html). Note that this file is
  only used when the toolbox is compiled with GCC. Otherwise, a generic conversion
  function 'convert_float_generic.h' is used instead, which is in the Public Domain.


New releases of the toolbox can also be downloaded from:

https://sites.google.com/site/ulfgri/numerical/gdsii-toolbox


Documentation
-------------
Additional documentation is available on:

https://sites.google.com/site/ulfgri/numerical/gdsii-toolbox

in a tutorial: GDSII_for_the_Rest_of_Us-<date>.pdf
The file gdsii_docs-<nn>.zip contains definitions of the GDSII file
format and example scripts for the toolbox. 


Functions
---------
Toolbox functions are grouped into the following directories:

**Basic:**
    Contains the low level functions for reading and writing
    of files in GDSII stream format and defines objects and
    methods for working with GDSII layouts.

**Elements:**
    Contains functions that return gds_element objects.

**Structures:**
    Contains functions that return gds_structure objects

**Boolean:**
    The GDSII toolbox contains a method that performs boolean
    set operations on boundary elements. This is described in more
    detail in the file: README-Boolean / README-Boolean.pdf

**Misc:**
    Functions that don't return gds_* objects.
    
**Scripts:**
    Command line scripts for Octave that can be run directly
    from the shell prompt in a Linux / Unix environment.


Compiling
---------
This software contains several MEX functions, which must be compiled
with a C compiler before the library can be used, or a C++ compiler
for the Clipper library. The C compiler must be sufficiently C99
conformant; the LCC compiler that is included with earlier versions of
MATLAB will not compile many of the mex functions (see the MATLAB
documentation for compiling external functions).

For Octave on Linux, the mex functions are compiled by executing 

$ ./makemex-octave

at the shell prompt. In MATLAB or Octave on Windows the mex functions are 
compiled by changing to the ./gds2-toolbox directory and running

>> makemex

at the MATLAB/Octave command prompt. 


Useful Stuff
------------
[KLayout](http://www.klayout.de) is an excellent viewer and editor for GDSII files.


Help
----
If you find a bug in the software, please send a message to 
ulf.griesmann@nist.gov or ulfgri@gmail.com and I will try to fix it.
