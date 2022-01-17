/* main.c
 * Main driver code for the game.
 */

#include "graphics.h"

void main(void)
{
    struct VBEModeInfoBlock *vbe = (struct VBEModeInfoBlock *)0x2000;
    struct Renderer renderer;
    struct Rectangle rect;

    init_renderer(&renderer, vbe);
    init_rect(&rect, 0, 0, renderer.screen_width, renderer.screen_height, 0xffffff);
    fillrect(&renderer, &rect);

    for (;;) {}
}
