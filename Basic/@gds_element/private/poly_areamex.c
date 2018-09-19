/*
 * A mex function to compute the area of a polygon
 * 
 * [ar] = polyarea(pa);
 *
 * pa :  cell array of polygons (nx2 matrices)
 * ar :  array of polygon areas with same shape as 'pa'
 *
 * Reference:
 * mathworld.wolfram.com/PolygonArea.html
 *
 * This software is in the Public Domain
 * Ulf Griesmann, NIST, November 2016
 */

#include <math.h>
#include <string.h>
#include <mex.h>

#ifdef __GNUC__
   #define RESTRICT __restrict
#else
   #define RESTRICT
#endif


/*-- local prototypes -----------------------------------------*/

static double
polygon_area(double * RESTRICT p, int M, int isopen);


/*-------------------------------------------------------------*/

void 
mexFunction(int nlhs, mxArray *plhs[], 
	    int nrhs, const mxArray *prhs[])
{
   mxArray *par;     /* pointer to array structure */
   double *pda;      /* polygon data */
   double *pout;     /* pointer to output data */
   int k, M, Nc, isopen;

   /* check argument pa */
   if ( !mxIsCell(prhs[0]) ) {
      mexErrMsgTxt("argument must be a cell array.");
   }

   Nc = mxGetNumberOfElements(prhs[0]);
   if (!Nc) {
      mexErrMsgTxt("polyarea: no input polygons pa.");
   }

   /* create output array */
   plhs[0] = mxCreateDoubleMatrix(Nc, 1, mxREAL);
   pout = (double *)mxGetData(plhs[0]);

   /* calculate polygon areas */
   for (k=0; k<Nc; k++) {

      /* get the next polygon from the cell array */ 
      par = mxGetCell(prhs[0], k); /* ptr to mxArray */
      pda = mxGetData(par);        /* ptr to a data */     
      M = mxGetM(par);             /* rows = vertex number */

      /* check if enough vertices */
      if (M < 3) {
	  mexErrMsgTxt("polyarea: polygons must have 3 or more vertices.");
      }

      /* check if the polygon is closed or open */
      if ((pda[0] != pda[M-1]) || (pda[M] != pda[2*M-1])) {
	isopen = 1;
      }
      else {
	isopen = 0;
      }

      /* calculate area */
      pout[k] = polygon_area(pda, M, isopen);
   }
}


/*
 * calculate the area of a simple polygon
 * Note: polygons are in column-major order
 */
static double
polygon_area(double * RESTRICT p, int M, int isopen)
{
    int k;
    double A = 0.0;

    for (k=0; k<M-1; k++) {
        A += p[k]*p[M+k+1] - p[k+1]*p[M+k];
    }
    if (isopen) {
        A += p[M-1]*p[M] - p[0]*p[2*M-1]; 
    }
    A *= 0.5;

    return A;    
}
