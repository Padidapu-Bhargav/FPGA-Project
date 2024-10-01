#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/ipc.h> 
#include <sys/shm.h> 
#include <sys/mman.h>
#include <sys/time.h> 
#include <math.h> 

typedef unsigned int uint32_t;

#define AXI_SOC_2_FPGA_BASE_ADDRESS 0x80000000
#define AXI_SOC_2_FPGA_BASE_ADDRESS_SPAN 0x1

unsigned int *h2p_virtual_base;

unsigned int *h2p_virtual_base_A;
unsigned int *h2p_virtual_base_B;
unsigned int *h2p_virtual_base_sel;
unsigned int *h2p_virtual_base_C;
unsigned int *h2p_virtual_base_rem;

/*A=0-f
B=10-1f
sel=20-2f
C=30-3f
rem=40-4f*/

unsigned int *h2p_lw_virtual_base;
unsigned int *lw_pio_write_ptr ;
int FPGA_PIO_WRITE = 0x300000;
int fd;	
	
int main()
{

	if( ( fd = open( "/dev/mem", ( O_RDWR | O_SYNC ) ) ) == -1 ) 	{
		printf( "ERROR: could not open \"/dev/mem\"...\n" );
		return( 1 );
	}
    
	h2p_virtual_base_A = mmap( NULL, 0x100, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0x80000000);
	h2p_virtual_base_B = mmap( NULL, 0x100, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0x80000010);
	h2p_virtual_base_sel = mmap( NULL, 0x100, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0x80000020);
	h2p_virtual_base_C = mmap( NULL, 0x100, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0x80000030);
	h2p_virtual_base_rem = mmap( NULL, 0x100, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0x80000040);
	if( (h2p_virtual_base_A == MAP_FAILED)| (h2p_virtual_base_B == MAP_FAILED) | (h2p_virtual_base_sel == MAP_FAILED) | (h2p_virtual_base_C == MAP_FAILED) | (h2p_virtual_base_rem == MAP_FAILED)) {
		printf( "ERROR: mmap1() failed...\n" );
		close( fd );
		return(1);
	}

	//h2p_virtual_base[0] = 0x1;
	h2p_virtual_base_A[0] = 0x22;
	h2p_virtual_base_B[0] = 0x32;
	h2p_virtual_base_sel[0] = 0x0;

	/*printf("Address stored in target ptr: %p\n", h2p_virtual_base);
	printf("Value pointed to by ptr: %x\n", h2p_virtual_base[0]);*/
	
	printf("Address stored in target C ptr: %p\n", h2p_virtual_base_C);
	printf("Value pointed to by C ptr: %x\n", h2p_virtual_base_C);

	printf("Address stored in target rem ptr: %p\n", h2p_virtual_base_rem);
	printf("Value pointed to by rem ptr: %x\n", h2p_virtual_base_rem);


	return( 0 );
}
