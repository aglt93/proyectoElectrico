#include <stdint.h>
#include <stdio.h>

// encryption routine
void encrypt (uint32_t* v, uint32_t* k) {

	uint32_t v0=v[0], v1=v[1], sum=0, i;
	uint32_t delta=0x9e3779b9;
	uint32_t k0=k[0], k1=k[1], k2=k[2], k3=k[3];

	for (i=0; i < 32; i++) {
		sum += delta;
		v0 += ((v1<<4) + k0) ^ (v1 + sum) ^ ((v1>>5) + k1);
		v1 += ((v0<<4) + k2) ^ (v0 + sum) ^ ((v0>>5) + k3);
	}
		v[0]=v0; v[1]=v1;
}

// decryption routine
void decrypt (uint32_t* v, uint32_t* k) {
	
	uint32_t v0=v[0], v1=v[1], sum=0xC6EF3720, i;
	uint32_t delta=0x9e3779b9;
	uint32_t k0=k[0], k1=k[1], k2=k[2], k3=k[3];
	
	for (i=0; i<32; i++) {
		v1 -= ((v0<<4) + k2) ^ (v0 + sum) ^ ((v0>>5) + k3);
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

	printf ("%x, %x \n", input[0], input[1]);

	V = input;

	K = key;

	encrypt(V,K);

	printf ("%x, %x \n", input[0], input[1]);

	decrypt(V,K);

	printf ("%x, %x \n", input[0], input[1]);
	
	
   return 0;
}