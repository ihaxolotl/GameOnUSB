%define VESA_OK            0x004F ; return code of a successful SVGA interupt
%define VESA_GET_INFO      0x4f00 ; function code for getting VBE info
%define VESA_GET_MODE_INFO 0x4f01 ; function code for getting VBE mode info
%define VESA_SET_MODE      0x4f02 ; function code for setting the VBE mode
%define VESA_MODE_WIDTH    1024
%define VESA_MODE_HEIGHT   768
%define VESA_MODE_BITS     32
%define VESA_INFO_END      0xFFFF

; 0x1000 is an arbitrary address in free memory which will store the VESA BIOS
; controller information structure.
VBEInfoBlock: equ 0x1000
VBEInfoBlock.VbeSignature equ VBEInfoBlock + 0        ; VBE Signature
VBEInfoBlock.VbeVersion   equ VBEInfoBlock + 4        ; VBE Version
VBEInfoBlock.OemStringPtr equ VBEInfoBlock + 6        ; Pointer to OEM String
VBEInfoBlock.Capabilities equ VBEInfoBlock + 10       ; Capabilities of graphics controller (4 bytes)
VBEInfoBlock.VideoModePtr equ VBEInfoBlock + 14       ; Pointer to VideoModeList
VBEInfoBlock.TotalMemory  equ VBEInfoBlock + 18       ; Number of 64kb memory blocks
; Added for VBE 2.0
VBEInfoBlock.OemSoftwareRev    equ VBEInfoBlock + 20  ; VBE implementation Software revision
VBEInfoBlock.OemVendorNamePtr  equ VBEInfoBlock + 22  ; Pointer to Vendor Name String
VBEInfoBlock.OemProductNamePtr equ VBEInfoBlock + 26  ; Pointer to Product Name String
VBEInfoBlock.OemProductRevPtr  equ VBEInfoBlock + 32  ; Pointer to Product Revision String
VBEInfoBlock.Reserved          equ VBEInfoBlock + 36  ; Reserved for VBE implementation scratch area (222 bytes)
VBEInfoBlock.OemData           equ VBEInfoBlock + 256 ; Data Area for OEM Strings (256 bytes)

; 0x2000 is an arbitrary address in free memory which will store the VESA BIOS
; Extensions mode information structure.
VBEModeInfoBlock: equ 0x2000
VBEModeInfoBlock.ModeAttributes equ VBEModeInfoBlock + 0       ; word  - mode attributes
VBEModeInfoBlock.WinAAttributes equ VBEModeInfoBlock + 2       ; byte  - window A attributes
VBEModeInfoBlock.WinBAttributes equ VBEModeInfoBlock + 3       ; byte  - window B attributes
VBEModeInfoBlock.WinGranularity equ VBEModeInfoBlock + 4       ; word  - window granularity
VBEModeInfoBlock.WinSize        equ VBEModeInfoBlock + 6       ; word  - window size
VBEModeInfoBlock.WinASegment    equ VBEModeInfoBlock + 8       ; word  - window A start segment
VBEModeInfoBlock.WinBSegment    equ VBEModeInfoBlock + 10      ; word  - window B start segment
VBEModeInfoBlock.WinFuncPtr     equ VBEModeInfoBlock + 12      ; dword - pointer to window function
VBEModeInfoBlock.BytesPerScanLine equ VBEModeInfoBlock + 16    ; word  - bytes per scan line
; Mandatory information for VBE 1.2 and above
VBEModeInfoBlock.XResolution    equ VBEModeInfoBlock + 18      ; word  - horizontal resolution in pixels or characters
VBEModeInfoBlock.YResolution   equ VBEModeInfoBlock + 20       ; word  - vertical resolution in pixels or characters
VBEModeInfoBlock.XCharSize      equ VBEModeInfoBlock + 22      ; byte  - character cell width in pixels
VBEModeInfoBlock.YCharSize      equ VBEModeInfoBlock + 23      ; byte  - character cell height in pixels
VBEModeInfoBlock.NumberOfPlanes equ VBEModeInfoBlock + 24      ; byte  - number of memory planes
VBEModeInfoBlock.BitsPerPixel   equ VBEModeInfoBlock + 25      ; byte  - bits per pixel
VBEModeInfoBlock.NumberOfBanks  equ VBEModeInfoBlock + 26      ; byte  - number of banks
VBEModeInfoBlock.MemoryModel    equ VBEModeInfoBlock + 27      ; byte  - memory model type
VBEModeInfoBlock.BankSize       equ VBEModeInfoBlock + 28      ; byte  - bank size in KB
VBEModeInfoBlock.NumberOfImagePages equ VBEModeInfoBlock + 29  ; byte  - number of images
VBEModeInfoBlock.Reserved1      equ VBEModeInfoBlock  + 30     ; byte  - reserved for page function
; Direct Color fields (required for direct/6 and YUV/7 memory models)
VBEModeInfoBlock.RedMaskSize      equ VBEModeInfoBlock + 31    ; byte  - size of direct color red mask in bits
VBEModeInfoBlock.RedFieldPosition equ VBEModeInfoBlock + 32    ; byte  - bit position of lsb of red mask
VBEModeInfoBlock.GreenMaskSize    equ VBEModeInfoBlock + 33    ; byte  - size of direct color green mask in bits
VBEModeInfoBlock.GreenFieldPosition equ VBEModeInfoBlock + 34  ; byte  - bit position of lsb of green mask
VBEModeInfoBlock.BlueMaskSize     equ VBEModeInfoBlock  + 35   ; byte  - size of direct color blue mask in bits
VBEModeInfoBlock.BlueFieldPosition equ VBEModeInfoBlock + 36   ; byte  - bit position of lsb of blue mask
VBEModeInfoBlock.RsvdMaskSize      equ VBEModeInfoBlock + 37   ; byte  - size of direct color reserved mask in bits
VBEModeInfoBlock.RsvdFieldPosition equ VBEModeInfoBlock + 38   ; byte  - bit position of lsb of reserved mask
VBEModeInfoBlock.DirectColorModeInfo equ VBEModeInfoBlock + 39 ; byte  - direct color mode attributes
; Mandatory information for VBE 2.0 and above
VBEModeInfoBlock.PhysBasePtr        equ VBEModeInfoBlock + 40  ; dword - physical address for flat memory frame buffer
VBEModeInfoBlock.OffScreenMemOffset equ VBEModeInfoBlock + 48  ; dword - pointer to start of off screen memory
VBEModeInfoBlock.OffScreenMemSize   equ VBEModeInfoBlock + 56  ; word  - amount of off screen memory in 1k units
VBEModeInfoBlock.Reserved2          equ VBEModeInfoBlock + 58  ; byte  - remainder of ModeInfoBlock (206 bytes)
