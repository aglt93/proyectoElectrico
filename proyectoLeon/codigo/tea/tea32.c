#include <stdint.h>
#include <stdio.h>



int roundNumber = 32;

// encryption routine
void encrypt (uint32_t* v, uint32_t* k) {

	uint32_t v0=v[0], v1=v[1], sum=0, i;
	uint32_t delta=0x9e3779b9;
	uint32_t k0=k[0], k1=k[1], k2=k[2], k3=k[3];
	uint32_t aux1, aux2, aux3;
	//printf("%x, %x\n",v0,v1);
	//printf("%x, %x, %x, %x\n",k0,k1,k2,k3);
	for (i=0; i < roundNumber; i++) {
		sum += delta;
		aux1 = (v1<<4) + k0;
		//printf("aux1 = %x\n",aux1);
		aux2 = v1 + sum;
		aux3 = (v1>>5) + k1;
		aux3 = aux1^aux2^aux3;
		v0 += aux3;
		//printf("v0 = %x\n",v0);
		aux1 = (v0<<4) + k2;
		//printf("aux1 = %x\n", aux1);
		aux2 = v0 + sum;
		//printf("aux2 = %x\n", aux2);
		aux3 = (v0>>5) + k3;
		aux3 = aux1^aux2^aux3;
		v1 += aux3;
		//printf("v1 = %x\n", v1);
	}
		v[0]=v0; v[1]=v1;
}

// decryption routine
void decrypt (uint32_t* v, uint32_t* k) {
	
	uint32_t v0=v[0], v1=v[1], sum=0xC6EF3720, i;
	uint32_t delta=0x9e3779b9;
	uint32_t k0=k[0], k1=k[1], k2=k[2], k3=k[3];
	
	for (i=0; i<roundNumber; i++) {
		v1 -= ((v0<<4) + k2) ^ (v0 + sum) ^ ((v0>>5) + k3);
		printf("%x\n", v1);
		v0 -= ((v1<<4) + k0) ^ (v1 + sum) ^ ((v1>>5) + k1);
		sum	-= delta;
	}

	v[0]=v0; v[1]=v1;
}


int main()
{

	uint32_t *V;
	uint32_t *K;

	uint32_t input[2];
	input[0] = 0x3d45f7a7;
	input[1] = 0x235fcb21;

	uint32_t key[4];
	key[0] = 0x132acf42;
	key[1] = 0x234acb45;
	key[2] = 0x3235acbe;
	key[3] = 0x4533f235;

	printf ("%x%x \n", input[0], input[1]);

	V = input;

	K = key;

	encrypt(V,K);

	printf ("%x%x \n", input[0], input[1]);

	decrypt(V,K);

	printf ("%x%x \n", input[0], input[1]);
	
	
   return 0;
}