/*
        RC5-B.C
        RC5 Reference Implementation.
        
        Copyright (c) J.S.A.Kapp 1994 - 1995.
        
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define debug_key_sched1

/*
RC5-32/12/16 examples:

1. key = 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
         plaintext 00000000 00000000  --->  ciphertext EEDBA521 6D8F4B15

2. key = 91 5F 46 19 BE 41 B2 51 63 55 A5 01 10 A9 CE 91
         plaintext EEDBA521 6D8F4B15  --->  ciphertext AC13C0F7 52892B5B

3. key = 78 33 48 E7 5A EB 0F 2F D7 B1 69 BB 8D C1 67 87
         plaintext AC13C0F7 52892B5B  --->  ciphertext B7B3422F 92FC6903

4. key = DC 49 DB 13 75 A5 58 4F 64 85 B4 13 B5 F1 2B AF
         plaintext B7B3422F 92FC6903  --->  ciphertext B278C165 CC97D184

5. key = 52 69 F1 49 D4 1B A0 15 24 97 57 4D 7F 15 31 25
         plaintext B278C165 CC97D184  --->  ciphertext 15E444EB 249831DA

*/

        /* rotate functions */
#define ROTL(x,s) ((x)<<(s) | (x)>>(32-(s)))
#define ROTR(x,s) ((x)>>(s) | (x)<<(32-(s)))

        /* Magic Contants */
#define P 0xb7e15163
#define Q 0x9e3779b9

#define ANDVAL 31

#define KR(x) (2*((x)+1))
#define MAX(x, y) (((x) > (y)) ? (x) : (y))

int rounds = 0;
int t = 0;

typedef unsigned int word32;

/*
        RC5encrypt - Encrypts RC5 input Block using subkeys
*/

void RC5encrypt(word32 const *in, word32 *out, word32 *key)
{
        register word32 a, b;
        int i;

        a = *in;
        b = *(in+1);

        a += *key++;
        b += *key++;

//fprintf(stderr,"a=%X, b=%X\n",a,b);
        for (i = 0; i < rounds; i++) {
                a ^= b;
                a = ROTL(a, b&ANDVAL) + *key++;

                b ^= a;
                b = ROTL(b, a&ANDVAL);
                b += *key++;
//fprintf(stderr,"a=%X, b=%X\n",a,b);
        }

        *out = a;
        *(out+1) = b;
}

/*
        RC5decrypt - Decrypts RC5 input Block using subkeys
*/

void RC5decrypt(word32 const *in, word32 *out, word32 *key)
{
        register word32 a, b;
        int i;

        a = *in;
        b = *(in+1);

        key += KR(rounds);

//fprintf(stderr,"a=%X, b=%X\n",a,b);
        for (i = 0; i < rounds; i++) {
                b -= *--key;
                //fprintf(stderr, "b_res = %X\n", b);
                b = ROTR(b, a&ANDVAL) ^ a;
                //fprintf(stderr, "b_rot = %X\n", b);
                //b = b ^ a;
                //fprintf(stderr, "b_xor = %X\n\n", b);
                a -= *--key;
                fprintf(stderr, "a_res = %X\n", a);
                a = ROTR(a, b&ANDVAL) ^ b;
                fprintf(stderr, "a_rot = %X\n\n", a);
//fprintf(stderr,"a=%X, b=%X\n",a,b);
        }

        b -= *--key;
        a -= *--key;

        *out = a;
        *(out+1) = b;
}

/*
        RC5key - Generates subkeys from user key
*/

void RC5key(unsigned char *key, int b, word32 *ky)
{
        int i, j;
        int x = ((b-1)/sizeof(word32))+1, y = 0;
        int mix = 3 * (MAX(t,x));
        word32 *L;
        word32 A = 0, B = 0;

    fprintf(stderr,"x = %d\n",x);
    fprintf(stderr,"mix = %d\n",mix);
        L = (word32 *) calloc((x+1), sizeof(word32));

                /* put char array key into word32 array */

        memcpy((unsigned char *)L, key, 16);
#ifdef debug_key_sched
    //fprintf(stderr,"L = [");
    for(i=0; i<4;i++)
    {
      fprintf(stderr, "L[%d] = %X\n",i,L[i]);
    }
    //fprintf(stderr," ]\n");
#endif

        *ky = P;
                /* Prep subkeys with magic Constants */
        for(i = 1; i <= t; i++)
                *(ky+i) = *(ky+(i-1)) + Q;

#ifdef debug_key_sched
    fprintf(stderr,"ky=[ \n");
    for(i=0; i<=t; i++)
    {
      fprintf(stderr,"%X\n",ky[i]);
    }
    fprintf(stderr,"]\n");
#endif

        i = j = 0;
                /* Mix in user key */
        while(mix != y) {
#ifdef debug_key_sched
fprintf(stderr,"------------------------------calc A\n");
fprintf(stderr, "A = %X, B = %X\n", A, B);
fprintf(stderr, "i=%X, ky[i]=%X\n",i,ky[i]);
fprintf(stderr, "ky[i]+A+B = %X\n", ky[i] + A + B);
#endif

                A = *(ky+i) = ROTL((*(ky+i) + A + B), 3&ANDVAL);
#ifdef debug_key_sched
fprintf(stderr, "A --> %X\n",A);
//fprintf(stderr, "ky[%X] --> %X\n", i, ky[i]);
#endif

#ifdef debug_key_sched
fprintf(stderr,"------------------------------calc B\n");
fprintf(stderr, "A = %X, B = %X\n", A, B);
fprintf(stderr,"j=%X, L[j]=%X\n",j, L[j]);
fprintf(stderr,"L[j]+A+B = %X\n",*(L+j)+A+B);
fprintf(stderr,"A+B = %X\n",A+B);
#endif
                B = *(L+j) = ROTL((*(L+j) + A + B), ((A + B)&ANDVAL));
#ifdef debug_key_sched
fprintf(stderr, "B --> %X\n\n",B);
//fprintf(stderr, "L[%X] --> %X\n", j, L[j]);
#endif
                i++;
                j++;
                i %= t;
                j %= x;
                y++;
        }


#ifdef debug_key_sched
    for(i=0; i<4;i++)
    {
      fprintf(stderr, "L[%d] = %X\n",i,L[i]);
    }
    printf("\n");
    fprintf(stderr,"ky=[ \n");
    for(i=0; i<=t; i++)
    {
      fprintf(stderr,"%X\n",ky[i]);
    }
    fprintf(stderr,"]\n");
#endif

}

int main(int argc, char*argv[])
{
        word32 dat[2], enc[2], dec[2], *ky;

        int i;
        unsigned char key[] = { 0x91, 0x5f, 0x46, 0x19, 0xbe, 0x41, 0xb2, 0x51,
                                        0x63, 0x55, 0xa5, 0x01, 0x10, 0xa9, 
0xce, 0x91};

        *dat = 0xEEDBA521;
        *(dat+1) = 0x6D8F4B15;

    rounds = atoi(argv[1]);
/*        printf("Enter Rounds: ");
        scanf("%d", &rounds);
*/
        t = KR(rounds);
    fprintf( stderr,"t = %d\nrounds = %d\n",t, rounds );
        ky = (word32 *) calloc(t, sizeof(word32));

        RC5key(key, sizeof(key), ky);

        RC5encrypt(dat, enc, ky);
        RC5decrypt(enc, dec, ky);

        printf("Dat: %x %x\n", dat[0], dat[1]);
        printf("Enc: %x %x\n", enc[0], enc[1]);
        printf("Dec: %x %x\n", dec[0], dec[1]);

        return 0;

}       /* End */