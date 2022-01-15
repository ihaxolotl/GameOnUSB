#define VGA_LEN (320 * 200)

void draw()
{
   unsigned char *vga = (unsigned char *)0xa0000;
   int len = VGA_LEN;

   for (int i = 0; i < len; i++) {
        vga[i] = (i % 255);
   }
}

void main(void)
{
    draw();
    for (;;) {}
}
