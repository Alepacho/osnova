#pragma once
#ifndef OSNOVA_H
#define OSNOVA_H

#include "base/all.h"

typedef struct OsnovaWindowData OsnovaWindowData;
@class OsnovaWindow;

typedef enum OsnovaEventType {
	OSNOVA_EV_NONE,
	OSNOVA_EV_MOUSE,
	OSNOVA_EV_KEYBOARD,
	OSNOVA_EV_CLOSE,
} OsnovaEventType;

@interface OsnovaEvent : BaseObject {
	OsnovaEventType type;
}
- (id)init;
- (id)initType:(OsnovaEventType)type;

- (OsnovaEventType)type;
@end

@interface Osnova : BaseObject

+ (void)begin;
+ (void)end;

+ (void)createWindow:(OsnovaWindow*)window;
+ (void)closeWindow:(OsnovaWindow*)window;

+ (void)window:(OsnovaWindow*)window setTitle:(const char*)value;
+ (void)window:(OsnovaWindow*)window setX:(int)value;
+ (void)window:(OsnovaWindow*)window setX:(int)X setY:(int)Y;
+ (void)window:(OsnovaWindow*)window setY:(int)value;
+ (void)window:(OsnovaWindow*)window setWidth:(int)value;
+ (void)window:(OsnovaWindow*)window setHeight:(int)value;
+ (void)window:(OsnovaWindow*)window setFocus:(BOOL)flag;
+ (void)window:(OsnovaWindow*)window setResizable:(BOOL)flag;
+ (void)window:(OsnovaWindow*)window setData:(OsnovaWindowData)data;

+ (size_t)windowCount;
+ (OsnovaEvent*)pollEvents:(OsnovaWindow*)window;
+ (void)swapBuffers:(OsnovaWindow*)window;

@end

#endif // OSNOVA_H
