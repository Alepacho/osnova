#pragma once
#ifndef OSNOVA_H
#define OSNOVA_H

#include "base/all.h"

typedef enum OsnovaEvent {
	OSNOVA_EV_NONE,
	OSNOVA_EV_MOUSE,
	OSNOVA_EV_KEYBOARD,
} OsnovaEvent;

@class OsnovaWindow;

@interface Osnova : BaseObject

+ (void)init;
+ (void)term;
+ (OsnovaEvent)pollEvents;

+ (void)createWindow:(OsnovaWindow*)window;

+ (void)window:(OsnovaWindow*)window setTitle:(const char*)newTitle;
+ (void)window:(OsnovaWindow*)window setWidth:(int)newWidth;
+ (void)window:(OsnovaWindow*)window setHeight:(int)newHeight;

@end

#endif // OSNOVA_H
