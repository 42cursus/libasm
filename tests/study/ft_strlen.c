#include <stdint.h>
#include <stddef.h>
#include "libasm.h"

#define WORD_SIZE       (sizeof(uint32_t))
#define UNALIGNED(p)	((uintptr_t)(p) & (WORD_SIZE - 1))

/**
 * ((X) - 0x01010101u) (The Underflow Generator)
 *   - Subtracting 1 from every individual byte forces a binary "underflow" only if the byte was originally 0x00.
 *   - When 0x00 - 0x01 occurs, the bit value wraps around to 0xFF.
 *     This forces the highest bit (the 8th bit, or sign bit) of that specific byte to flip to 1.
 *   - `-16843009 = 0xFEFEFEFF = -0x01010101` => modulo 2^32
 *      `echo $(( 0 - 0x01010101 ))`
 *          or
 *      `perl <<< 'printf "%d\n", unpack("l>", pack("L>", (-0x01010101) & 0xffffffff))'`
 *          or
 *      `python3 -c 'import struct; print(struct.unpack("<i", struct.pack("<I", (-0x01010101) & 0xffffffff))[0])'`
 *      => -16843009
 * ~(X) (The High-Bit Enforcer)
 *   - This bitwise NOT operation acts as a shield against false positives.
 *   - If a byte in X already has its highest bit set to 1 (such as values from 0x80 to 0xFF),
 *     subtracting 1 might leave that highest bit set to 1.
 *   - Inverting X ensures that any byte originally containing a 1 in its highest bit gets forced to 0.
 *     Consequently, a true signal will only emerge if the highest bit of a byte changes from 0 to 1
 *     during the subtraction phase.
 * & 0x80808080u (The Bit Isolator)
 *   - This acts as a mask to filter out everything except the highest bit (the sign bit)
 *     of each of the 4 bytes.
 *     `echo $(( (0x80808080 ^ 0x80000000) - 0x80000000 ))`
 *          or
 *     `perl <<< 'printf "%d\n", unpack("l>", pack("L>", 0x80808080));'`
 *          or
 *     `python3 -c 'import struct; print(struct.unpack("<i", struct.pack("<I", 0x80808080))[0])'`
 *     => -2139062144
 *
 * Links:
 *   - How to determine if a byte is null in a word:
 *       https://stackoverflow.com/questions/27322182/
 *       https://graphics.stanford.edu/~seander/bithacks.html#ZeroInWord
 *   - How the glibc strlen() implementation works
 *       https://stackoverflow.com/questions/20021066/
 *   - The glibc implementation uses technique called SWAR (SIMD Within A Register)
 *       https://qr.ae/pFUuRB
 *       https://qr.ae/pFUu8q
 */
static inline uint32_t	null_byte_mask(uint32_t X)
{
    return ((X - 0x01010101u) & ~X & 0x80808080u);
}

size_t ft_strlen_c(const char *str)
{
    /* preserve the original string start */
    const char      *start = str;
    const uint32_t  *aligned_addr = (void *)0x00;

    /* Align the pointer, so we can search 4-bytes at a time. */
    while (UNALIGNED(str)) {
        if (!*str) goto done;
        str++;
    }

    /* If the string is dword-aligned, we can check for the presence of
       a null in each dword-sized (4-byte) block.  */

    aligned_addr = (const uint32_t *) str;
/*
    while (!DETECTNULL(*aligned_addr)) {
        aligned_addr++;
    }
    __asm__ __volatile__("nop");
*/

    uint32_t mask = null_byte_mask(*aligned_addr);
    while (mask == 0u) {
        ++aligned_addr;
        mask = null_byte_mask(*aligned_addr);
    }

    /*
     * DETECTNULL leaves only bit 7, 15, 23, and/or 31 set: one high bit
     * per NUL byte. On little-endian x86, the least significant set bit is
     * the first NUL in address order. __builtin_ctz(mask) returns that bit
     * index; dividing it by 8 gives the byte offset in this dword.
     *
     * __builtin_ctz(0) is undefined, so the loop above must establish that
     * mask is nonzero.
     */
    uint32_t bit_index = __builtin_ctz(mask);
    str = (const char *)aligned_addr + bit_index / 8u;

    /* Once a null is detected, we check each byte in that block for a
       precise position of the null.  */

/*
    str = (const char *)aligned_addr;
    while (*str)
        str++;
*/
    ASM_L(.done);
done:
    return str - start;
}
