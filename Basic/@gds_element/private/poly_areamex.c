/*
 * A mex function to compute the area of polygons
 * 
 * [ar] = poly_areamex(pa);
 *
 * pa :  cell array of polygons (nx2 matrices)
 * ar :  array of polygon areas with same shape as 'pa'
 *
 * This software is in the Public Domain
 * Ulf Griesmann, NIST, November 2016
 */

#include <math.h>
#include <string.h>
#include <mex.h>

#ifdef __GNUC__
   #define RESTRICT __restrict
   #define INLINE __inline__
#else
   #define RESTRICT
   #define INLINE
#endif


/*-- local prototypes -----------------------------------------*/

INLINE double
polygon_area(double * RESTRICT p, int M, int m);


/*-------------------------------------------------------------*/

void 
mexFunction(int nlhs, mxArray *plhs[], 
	    int nrhs, const mxArray *prhs[])
{
   mxArray *par;     /* pointer to array structure */
   double *pda;      /* polygon data */
   double *pout;     /* pointer to output data */
   int m, M;
   int k, Na;

   /* check argument pa */
   if ( !mxIsCell(prhs[0]) ) {
      mexErrMsgTxt("argument must be a cell array.");
   }

   Na = mxGetNumberOfElements(prhs[0]);
   if (!Na) {
      mexErrMsgTxt("no input polygons pa.");
   }

   /* create output array */
   plhs[0] = mxCreateDoubleMatrix(mxGetM(prhs[0]), mxGetN(prhs[0]), mxREAL);
   pout = (double *)mxGetData(plhs[0]);

   /* calculate polygon areas */
   for (k=0; k<Na; k++) {

      /* get the next polygon from the cell array */ 
      par = mxGetCell(prhs[0], k); /* ptr to mxArray */
      pda = mxGetData(par);        /* ptr to a data */     
      M = m = mxGetM(par);         /* rows = vertex number */

      /* check if last vertex is duplicate of first */
      if ( (pda[0] == pda[m-1]) && (pda[m] == pda[2*m-1]) ) {
	       m--;
      }

      /* check if enough vertices */
      if (m <= 2) {
	       mexErrMsgTxt("polygons must have at least 3 vertices.");
      }

      /* calculate area */
      pout[k] = polygon_area(pda, M, m);
   }
}


/*
 * calculate the area of a simple polygon
 * Note: polygons are in row-major order
 */
INLINE double
polygon_area(double * RESTRICT p, int M, int m)
{
    int k;
    double A;

    A = 0.0;

    for (k=0; k<m; k++) {
        A += p[k]*p[M+k+1] - p[k+1]*p[M+k];
    }
    A *= 0.5;

    /* make area independent of polygon orientation */
    if (A < 0.0)
        A = -A;

    return A;    
}
