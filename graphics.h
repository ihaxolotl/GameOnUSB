#ifndef __GRAPHICS_H
#define __GRAPHICS_H

#include "common.h"
#include "vesa.h"

// Rectangle to be drawn to the screen
struct Rectangle {
    uint16 x;
    uint16 y;
    uint16 width;
    uint16 height;
    uint32 color;
};

// Graphics renderer
struct Renderer {
    uint32 *backbuffer;
    uint32 *framebuffer;
    uint32 framebuffer_len;
    uint16 pitch;
    uint16 bpp;
    uint16 screen_width;
    uint16 screen_height;
};

void init_renderer(struct Renderer *renderer, struct VBEModeInfoBlock *vbe);
void init_rect(struct Rectangle *rect, int32 x, int32 y, int32 w, int32 h, int32 color);
void fillrect(struct Renderer *renderer, struct Rectangle *rect);

#endif
