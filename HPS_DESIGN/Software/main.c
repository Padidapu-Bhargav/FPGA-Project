#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>

typedef unsigned int uint32_t;

#define AXI_SOC_2_FPGA_BASE_ADDRESS 0x80000000
#define AXI_SOC_2_FPGA_BASE_ADDRESS_SPAN 0x1

unsigned int *h2p_virtual_base_A;
unsigned int *h2p_virtual_base_B;
unsigned int *h2p_virtual_base_sel;
unsigned int *h2p_virtual_base_C;
unsigned int *h2p_virtual_base_rem;

int fd, fd_A, fd_B, fd_sel, fd_C, fd_rem;

int main() {

    // Open /dev/mem

    // A port
    if ((fd_A = open("/dev/mem", (O_RDWR | O_SYNC))) == -1) {
        perror("ERROR: could not open \"/dev/mem\"");
        return 1;
    }


    h2p_virtual_base_A = mmap(NULL, 0x100, PROT_READ | PROT_WRITE, MAP_SHARED, fd_A, 0x80000000);
    if (h2p_virtual_base_A == MAP_FAILED) {
        perror("ERROR: mmap() failed for A");
        close(fd_A);
        return 1;
    }

    //B port

    h2p_virtual_base_B = mmap(NULL, 0x100, PROT_READ | PROT_WRITE, MAP_SHARED, fd_A, 0x80010000);
    if (h2p_virtual_base_B == MAP_FAILED) {
        perror("ERROR: mmap() failed for B");
        close(fd_A);
        return 1;
    }

    // sel port

    h2p_virtual_base_sel = mmap(NULL, 0x100, PROT_READ | PROT_WRITE, MAP_SHARED, fd_A, 0x80020000);
    if (h2p_virtual_base_sel == MAP_FAILED) {
        perror("ERROR: mmap() failed for sel");
        close(fd_A);
        return 1;
    }


    // Input hexadecimal values
    unsigned int hexValue_A, hexValue_B, hexValue_sel;

    printf("Enter a hexadecimal value for A: ");
    scanf("%x", &hexValue_A);

    printf("Enter a hexadecimal value for B: ");
    scanf("%x", &hexValue_B);

    printf("Enter a hexadecimal value for sel: ");
    scanf("%x", &hexValue_sel);

    // Write to mapped memory
    h2p_virtual_base_A[0] = hexValue_A;
    h2p_virtual_base_B[0x10/4] = hexValue_B;

    h2p_virtual_base_sel[0x20/4] = hexValue_sel;

    close(fd_A);
    return 0;
}
