
#ifndef _FW_H_
#define _FW_H_

extern "C" {

void baseband_fw__filter_hook(void*, const void*, const int, const int, const int);

// gnat exceptions

void __gnat_last_chance_handler();

} // C

#endif