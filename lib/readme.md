#Library files.

flashwritelib.asx is the main lib with procedures to handle various flash protocols.
there is proc inside that automatically fills the flash interface with proper functions.

#Plug-ins
* lib_28sf0x0.asm - handles protocol unlock/write
* lib_39sf0x0.asm handles protocol 5555/AA;2aaa/55
* lib_29f0x0.asm handles protocol 555/AA;2aa/55
