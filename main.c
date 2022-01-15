/* main.c
 * Main driver code for the game.
 */

#include "graphics.h"

void draw()
{
    struct VBEModeInfoBlock *vbe = (struct VBEModeInfoBlock *)0x5c00; 
    uint8 *screen = (uint8 *)vbe->framebuffer;
    uint32 color = 0xff0000;
    uint32 bpp = vbe->bpp / 8;

    for (int y = 0; y < SCREEN_Y; y++) {
        for (int x = 0; x < SCREEN_X; x++) {
            uint32 where = x * bpp + y * vbe->pitch;

            screen[where] = color & 0x255;
            screen[where + 1] = (color >> 8) & 255;
            screen[where + 2] = (color >> 16) & 255;
        }
    }
}

void main(void)
{
    draw();
    for (;;) {}
}
