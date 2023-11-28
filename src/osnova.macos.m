#include "osnova.h"
#include "base/string.h"
#include "window.h"

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
}
- (void)createMenuBar;
@end

@implementation AppDelegate
- (void)createMenuBar {
	NSMenu* menubar = [[NSMenu alloc] init];
	NSMenuItem* menuBarItem = [[NSMenuItem alloc] init];
	[menubar addItem:menuBarItem];
	[NSApp setMainMenu:menubar];
	NSMenu* myMenu = [[NSMenu alloc] init];
	NSString* quitTitle = @"Quit";
	NSMenuItem* quitMenuItem =
		[[NSMenuItem alloc] initWithTitle:quitTitle
								   action:@selector(terminate:)
							keyEquivalent:@"q"];
	[myMenu addItem:quitMenuItem];
	[menuBarItem setSubmenu:myMenu];
}
@end

static AppDelegate* appDelegate;
static NSAutoreleasePool* pool;
static Array<OsnovaWindow*>* windows;

@implementation Osnova

// @private

// @public

+ (void)init {
	windows = [[Array alloc] init];
	pool = [[NSAutoreleasePool alloc] init];
	appDelegate = [[AppDelegate alloc] init];
}

+ (void)term {
	[windows dealloc];
	// [appDelegate dealloc];
	[pool drain];
}

+ (OsnovaEvent)pollEvents {
	return OSNOVA_EV_NONE;
}

+ (void)createWindow:(OsnovaWindow*)window {
	if (window == nil)
		@throw [[Exception alloc] initWithFormat:"Window is not defined!"];
	OsnovaWindow* win = [windows push:window];
	NSRect viewRect = NSMakeRect(0.0, 0.0, [window width], [window height]);

	NSUInteger windowStyle = NSWindowStyleMaskTitled | NSWindowStyleMaskClosable
							 | NSWindowStyleMaskResizable;
	NSWindow* data =
		[[NSWindow alloc] initWithContentRect:viewRect
									styleMask:windowStyle
									  backing:NSBackingStoreBuffered
										defer:YES];
	// NSString* title = [NSString stringWithUTF8String:[[win title] buffer]];
	// [data setTitle:title];
	[data setTitle:@"This is a Teeee..."];
	[data setAcceptsMouseMovedEvents:YES];
	[data setOpaque:YES];
	[data makeKeyAndOrderFront:NSApp];

	// Center Window
	const CGFloat w = NSWidth([data frame]);
	const CGFloat h = NSHeight([data frame]);
	const CGFloat x = NSWidth([[data screen] frame]) / 2 - w / 2;
	const CGFloat y = NSHeight([[data screen] frame]) / 2 - h / 2;
	[data setFrame:NSMakeRect(x, y, w, h) display:YES];

	[data orderFrontRegardless];
	[win setData:data];
}

+ (void)window:(OsnovaWindow*)window setTitle:(const char*)newTitle {
	[[window data] setTitle:[NSString stringWithUTF8String:newTitle]];
}

+ (void)window:(OsnovaWindow*)window setWidth:(int)newWidth {
	[System fatal:"Unimplemented method '%s'", "window setWidth"];
}

+ (void)window:(OsnovaWindow*)window setHeight:(int)newHeight {
	[System fatal:"Unimplemented method '%s'", "window setHeight"];
}

@end
