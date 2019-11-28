/*
 * Part of the GDSII toolbox for Octave & MATLAB
 * Copyright (c) 2012, Ulf Griesmann
 *
 * Description:
 * Writes a structure header to a GDSII library file.
 * 
 * gds_beginstruct(gf, sname, cdate);
 *
 * Input
 * gf :     a file handle returned by gds_open.
 * sname :  a string with the structure name
 * 
 */

#include <string.h>

#include "gdsio.h"
#include "mex.h"
#include "mexfuncs.h"

/*-----------------------------------------------------------------*/

void 
mexFunction(int nlhs, mxArray *plhs[], 
	    int nrhs, const mxArray *prhs[])
{
   FILE *fob;     /* file object pointer */
   date_t cdate;  /* creation date */
   date_t mdate;  /* modification date */
   char *sname;   /* structure name */
   int snlen;     /* structure name length */

   /* check argument number */
   if (nrhs != 3) {
      mexErrMsgTxt("3 input arguments expected.");
   }
   
   /* get file handle argument */
   fob = get_file_ptr((mxArray *)prhs[0]);

   /* BGNSTR record */
   if ( write_record_hdr(fob, BGNSTR, 2*sizeof(date_t)) )
      mexErrMsgTxt("failed to write BGNSTR record.");

   /* BGNSTR creation date */
   now(cdate);
   if ( write_word_n(fob, cdate, 6) ) /* NOTE: changes byte order in cdate */
      mexErrMsgTxt("failed to write BGNSTR record (cdate).");

   /* BGNSTR modification date */
   now(mdate);
   if ( write_word_n(fob, mdate, 6) ) /* same as cdate */
      mexErrMsgTxt("failed to write BGNSTR record (mdate).");
   
   /* STRNAME record */
   sname = mxArrayToString(prhs[1]);  /* copy structure name */
   if ( !sname )
      mexErrMsgTxt("failed to allocate buffer for structure name.");     
   if ( write_record_hdr(fob, STRNAME, strlen(sname)) )
      mexErrMsgTxt("failed to write STRNAME record header.");
   if ( write_string(fob, sname, strlen(sname)) )
      mexErrMsgTxt("failed to write STRNAME record (sname).");
}

/*-----------------------------------------------------------------*/
