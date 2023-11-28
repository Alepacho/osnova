#pragma once
#ifndef OSNOVA_WINDOW_H
#define OSNOVA_WINDOW_H

#include "base/all.h"

@interface OsnovaWindow : BaseObject {
	id data;
	String* title;
	int width, height;
}

- (id)init;
- (id)initTitle:(const char*)newTitle
	  initWidth:(int)newWidth
	 initHeight:(int)newHeight;
- (void)dealloc;

- (String*)title;
- (int)width;
- (int)height;
- (id)data;

- (void)setTitle:(const char*)newTitle;
- (void)setWidth:(int)newWidth;
- (void)setHeight:(int)newHeight;
- (void)setData:(id)newData;

- (BOOL)shouldClose;
- (void)swapBuffers;
@end

#endif // OSNOVA_WINDOW_H
