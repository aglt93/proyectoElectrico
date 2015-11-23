#include <stdint.h>
#include <stdio.h>


int roundNumber = 32;

void code(long* v, long* k) {
	
	unsigned long y=v[0],z=v[1], sum=0,
	/* set up */
	delta=0x9e3779b9,
	/* a key schedule constant */
	n=roundNumber;
	
	while (n-->0) {
		/* basic cycle start */
		sum += delta ;
		y += ((z<<4)+k[0]) ^ (z+sum) ^ ((z>>5)+k[1]) ;
		z += ((y<<4)+k[2]) ^ (y+sum) ^ ((y>>5)+k[3]) ;
	}
	/* end cycle */
	v[0]=y; 
	v[1]=z; 
}



void decode(long* v,long* k) {

	unsigned long n=roundNumber, sum, y=v[0], z=v[1],
	delta=0x9e3779b9 ;
	sum=delta<<5 ;
	/* start cycle */
	while (n-->0) {
		z-= ((y<<4)+k[2]) ^ (y+sum) ^ ((y>>5)+k[3]) ;
		y-= ((z<<4)+k[0]) ^ (z+sum) ^ ((z>>5)+k[1]) ;
		sum-=delta ; 
	}
	/* end cycle */
	v[0]=y;
	v[1]=z;
}


int main(){

	long *V;
	long *K;

	long input[2];
	input[0] = 0x3d45f7a7132acf24;
	input[1] = 0x235fcb213d45f745;

	long key[4];
	key[0] = 0x132acf42132acf42;
	key[1] = 0x234acb45132acf42;
	key[2] = 0x3235acbe132acf42;
	key[3] = 0x4533f235132acf42;

	printf ("%lx%lx \n", input[0], input[1]);

	V = input;

	K = key;

	code(V,K);

	printf ("%lx%lx \n", input[0], input[1]);

	decode(V,K);

	printf ("%lx%lx \n", input[0], input[1]);

	//long hola;

	//printf("%ld",sizeof(hola));

	return 0;
}