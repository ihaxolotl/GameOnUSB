#ifndef __GRAPHICS_H
#define __GRAPHICS_H

#define SCREEN_X 1024
#define SCREEN_Y 768

typedef unsigned char uint8;
typedef unsigned short uint16;
typedef unsigned int uint32;
typedef char int8;
typedef short int16;
typedef int int32;

// VESA BIOS Extensions Information structure
// A lot of fields here are deprecated.
struct VBEModeInfoBlock {
	uint16 attributes;
	uint8 window_a;
	uint8 window_b;
	uint16 granularity;
	uint16 window_size;
	uint16 segment_a;
	uint16 segment_b;
	uint32 win_func_ptr;
	uint16 pitch;
	uint16 width;
	uint16 height;
	uint8 w_char;
	uint8 y_char;
	uint8 planes;
	uint8 bpp;
	uint8 banks;
	uint8 memory_model;
	uint8 bank_size;
	uint8 image_pages;
	uint8 reserved0;
	uint8 red_mask;
	uint8 red_position;
	uint8 green_mask;
	uint8 green_position;
	uint8 blue_mask;
	uint8 blue_position;
	uint8 reserved_mask;
	uint8 reserved_position;
	uint8 direct_color_attributes;
	uint32 framebuffer;
	uint32 off_screen_mem_off;
	uint16 off_screen_mem_size;
	uint8 reserved1[206];
} __attribute__ ((packed));

#endif
