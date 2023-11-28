#include "osnova.h"
#include "window.h"

#if OS_MACOS
#include "osnova.macos.m"
#elif OS_WINDOWS
#include "osnova.windows.m"
#elif OS_LINUX
#include "osnova.linux.m"
#else
#error "Unknown OS"
#endif
