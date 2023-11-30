#include "window.h"
#include "osnova.h"

@implementation OsnovaWindow
- (id)init {
	self = [super init];

	if (self) {
		self->title = [[String alloc] initWithBuffer:"Osnova!"];
		self->width = 800;
		self->height = 600;
		self->resizable = NO;
		self->focus = NO;
		self->closed = NO;
		[Osnova createWindow:self];
	}

	return self;
}

- (id)initTitle:(const char*)newTitle
	  initWidth:(int)newWidth
	 initHeight:(int)newHeight {
	return [self initTitle:newTitle
					 initX:-1
					 initY:-1
				 initWidth:newWidth
				initHeight:newHeight];
}

- (id)initTitle:(const char*)newTitle
		  initX:(int)newX
		  initY:(int)newY
	  initWidth:(int)newWidth
	 initHeight:(int)newHeight {
	self = [self init];

	[self->title setBuffer:newTitle];
	self->x = newX;
	self->y = newY;
	self->width = newWidth;
	self->height = newHeight;

	return self;
}

- (void)dealloc {
	if (self->title != nil) {
		[self->title dealloc];
		self->title = nil;
	}
	[super dealloc];
}

- (String*)title {
	return self->title;
}

- (int)x {
	return self->x;
}

- (int)y {
	return self->y;
}

- (int)width {
	return self->width;
}

- (int)height {
	return self->height;
}

- (BOOL)resizable {
	return self->resizable;
}

- (BOOL)focus {
	return self->focus;
}

- (OsnovaWindowData)data {
	return self->data;
}

- (void)setTitle:(const char*)value {
	[Osnova window:self setTitle:value];
}

- (void)setX:(int)value {
	[Osnova window:self setX:value];
}

- (void)setX:(int)X setY:(int)Y {
	[Osnova window:self setX:X setY:Y];
}

- (void)setY:(int)value {
	[Osnova window:self setY:value];
}

- (void)setWidth:(int)value {
	[Osnova window:self setWidth:value];
}

- (void)setHeight:(int)value {
	[Osnova window:self setHeight:value];
}

- (void)setResizable:(BOOL)flag {
	[Osnova window:self setResizable:flag];
}

- (void)setFocus:(BOOL)flag {
	[Osnova window:self setFocus:flag];
}

- (void)setData:(OsnovaWindowData)value {
	[Osnova window:self setData:value];
}

- (OsnovaEvent*)pollEvents {
	return [Osnova pollEvents:self];
}

- (BOOL)isClosed {
	return closed;
}

- (void)swapBuffers {
	[Osnova swapBuffers:self];
}

@end
