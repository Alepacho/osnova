#include "window.h"
#include "osnova.h"

@implementation OsnovaWindow
- (id)init {
	self = [super init];

	if (self) {
		self->title = [[String alloc] initWithBuffer:"Osnova!"];
		self->width = 800;
		self->height = 600;

		[Osnova createWindow:self];
	}

	return self;
}

- (id)initTitle:(const char*)newTitle
	  initWidth:(int)newWidth
	 initHeight:(int)newHeight {
	self = [self init];

	[self->title setBuffer:newTitle];
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

- (int)width {
	return self->width;
}

- (int)height {
	return self->height;
}

- (id)data {
	return self->data;
}

- (void)setTitle:(const char*)newTitle {
	[Osnova window:self setTitle:newTitle];
	[self->title setBuffer:newTitle];
}

- (void)setWidth:(int)newWidth {
	[Osnova window:self setWidth:newWidth];
	self->width = newWidth;
}

- (void)setHeight:(int)newHeight {
	[Osnova window:self setHeight:newHeight];
	self->height = newHeight;
}

- (void)setData:(id)newData {
	if (self->data != nil)
		@throw [[Exception alloc] initWithFormat:"Window is already defined!"];
	self->data = newData;
}

- (BOOL)shouldClose {
	return false;
}

- (void)swapBuffers {
}

@end
