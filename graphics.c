#include "graphics.h"

/*
 * init_renderer initializes a renderer state with the information provided
 * by the VESA BIOS mode information.
 */
void init_renderer(struct Renderer *renderer, struct VBEModeInfoBlock *vbe)
{
    renderer->screen_width = vbe->width;
    renderer->screen_height = vbe->height;
    renderer->bpp = vbe->bpp / 8;
    renderer->pitch = vbe->pitch;
    renderer->framebuffer = (uint32 *)vbe->framebuffer;
    renderer->framebuffer_len = vbe->width * vbe->width * renderer->bpp;
    // renderer->backbuffer = NULL;
}

/*
 * init_rect initializes a Rectangle struct.
 */
void init_rect(struct Rectangle *rect, int32 x, int32 y, int32 w, int32 h, int32 color)
{
    rect->x = x;
    rect->y = y;
    rect->width = w;
    rect->height = h;
    rect->color = color;
}

/*
 * fillrect draws a rectange directly to the framebuffer. This function assumes
 * the usage of a 32-bit linear framebuffer. This may not always be the case, but
 * the existence of this function is just to test plotting pixels.
 */
void fillrect(struct Renderer *renderer, struct Rectangle *rect) {
    uint32 *where = renderer->framebuffer;

    for (uint32 i = 0; i < rect->height; i++) {
        for (uint32 j = 0; j < rect->width; j++) {
            where[j] = rect->color;
        }

        // compensate for 32-bit integer.
        where += renderer->pitch / renderer->bpp;
    }
}
