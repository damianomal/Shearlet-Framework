/*
* SLgetShearlet3DCUDA
*/
__global__ void SLgetShearlet3DCUDA(double2 * pShearlet3D, double * pShearletAbsSqrd,const int pyramid, const double2 * pShearlet2D1, const double2 * pShearlet2D2)  {
	int d1 = blockIdx.x;
	int d2 = blockIdx.y;
	int d3 = threadIdx.x;
	int idx1,idx2,idx3;
	
	idx1 = d1 + (d2 + d3*gridDim.y)*gridDim.x;
	
	if(pyramid == 0  || pyramid == 1){
		idx2 = d1 + d2*gridDim.x;
		idx3 = d3 + d2*blockDim.x;
	}
	else if(pyramid == 2){
		idx2 = d1 + d3*gridDim.x;
		idx3 = d3 + d2*blockDim.x;	
	}
	else{
		idx2 = d1 + d2*gridDim.x;
		idx3 = d1 + d3*gridDim.x;
	}
	
	double re1 = pShearlet2D1[idx2].x;
	double im1 = pShearlet2D1[idx2].y;
	
	double re2 = pShearlet2D2[idx3].x;
	double im2 = pShearlet2D2[idx3].y;
	
	double reSh = re1*re2 - im1*im2;
	double imSh = re1*im2 + re2*im1;
	
	pShearlet3D[idx1].x = reSh;
	pShearlet3D[idx1].y = imSh;
	
	pShearletAbsSqrd[idx1] = reSh*reSh + imSh*imSh;
   
}