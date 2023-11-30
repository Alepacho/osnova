#pragma once
#ifndef OSNOVA_WINDOW_H
#define OSNOVA_WINDOW_H

#include "base/all.h"

// typedef enum OsnovaWindowFlags {
// 	OSNOVA_WN_RESIZABLE,
// } OsnovaWindowFlags;

@class OsnovaEvent;

typedef struct OsnovaWindowData {
#if OS_WINDOWS
#elif OS_MACOS
	id object;	   // NSObject*
	id delegate;   // OsnovaWindowDelegate*
	id view;	   // OsnovaView*
	id layer;	   // OsnovaLayer*
	BOOL occluded; // window is not visible (for vsync)
#elif OS_LINUX
#endif
} OsnovaWindowData;

// This is basically just a struct with Osnova methods
@interface OsnovaWindow : BaseObject {
	OsnovaWindowData data;
	String* title;
	int x, y, width, height;

	BOOL resizable;
	BOOL focus;
	BOOL closed;
}

// @property(setter=updX:) int x;

- (id)init;
- (id)initTitle:(const char*)newTitle
	  initWidth:(int)newWidth
	 initHeight:(int)newHeight;
- (id)initTitle:(const char*)newTitle
		  initX:(int)newX
		  initY:(int)newY
	  initWidth:(int)newWidth
	 initHeight:(int)newHeight;
- (void)dealloc;
- (void)close;

- (String*)title;
- (int)x;
- (int)y;
- (int)width;
- (int)height;
- (BOOL)resizable;
- (BOOL)focus;
- (OsnovaWindowData)data;

- (void)setTitle:(const char*)value;
- (void)setX:(int)value;
- (void)setX:(int)X setY:(int)Y;
- (void)setY:(int)value;
- (void)setWidth:(int)value;
- (void)setHeight:(int)value;
- (void)setResizable:(BOOL)flag;
- (void)setFocus:(BOOL)flag;
// - (void)setData:(OsnovaWindowData)value;

- (OsnovaEvent*)pollEvents;
- (BOOL)isClosed;
- (void)swapBuffers;
@end

#endif // OSNOVA_WINDOW_H
