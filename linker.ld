ENTRY(_start)
OUTPUT_FORMAT("binary")

SECTIONS
{
    . = 0x10000;
    .text BLOCK(4K) : ALIGN(4K)
    {
        *(.entry)
        *(.text)
    }
    .bss BLOCK(4K) : ALIGN(4K)
    {
        *(.bss)
    }
}
