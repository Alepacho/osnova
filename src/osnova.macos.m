#include "osnova.h"
#include "base/string.h"
#include "window.h"

#import <Cocoa/Cocoa.h>

// this category is used to change internal data without calling Osnova methods
@interface OsnovaWindow (Internal)
- (void)updTitle:(const char*)value;
- (void)updX:(int)value;
- (void)updX:(int)X updY:(int)Y;
- (void)updY:(int)value;
- (void)updWidth:(int)value;
- (void)updWidth:(int)newWidth updHeight:(int)newHeight;
- (void)updHeight:(int)value;
- (void)updResizable:(BOOL)flag;
- (void)updFocus:(BOOL)flag;
- (void)updData:(OsnovaWindowData)value;

- (void)updClosed:(BOOL)flag;
@end

@implementation OsnovaWindow (Internal)
- (void)updTitle:(const char*)value {
	[self->title setBuffer:value];
}
- (void)updX:(int)value {
	self->x = value;
}
- (void)updX:(int)X updY:(int)Y {
	self->x = X;
	self->y = Y;
}
- (void)updY:(int)value {
	self->y = value;
}
- (void)updWidth:(int)value {
	self->width = value;
}
- (void)updWidth:(int)newWidth updHeight:(int)newHeight {
	self->width = newWidth;
	self->height = newHeight;
}
- (void)updHeight:(int)value {
	self->height = value;
}
- (void)updResizable:(BOOL)flag {
	self->resizable = flag;
}
- (void)updFocus:(BOOL)flag {
	self->focus = flag;
}
- (void)updData:(OsnovaWindowData)value {
	self->data = value;
}

- (void)updClosed:(BOOL)flag {
	self->closed = flag;
}
@end

// === Interfaces ==============================================================

@interface Osnova (Internal)

+ (void)window:(OsnovaWindow*)window getX:(int*)x getY:(int*)y;

@end

@interface OsnovaAppDelegate : NSObject <NSApplicationDelegate> {
}
- (void)createMenuBar;

// @redefinition
- (NSApplicationTerminateReply)applicationShouldTerminate:
	(NSApplication*)sender;
// - (void)applicationDidChangeScreenParameters:(NSNotification*)notification;
- (void)applicationWillFinishLaunching:(NSNotification*)notification;
- (void)applicationDidFinishLaunching:(NSNotification*)notification;
- (void)applicationDidHide:(NSNotification*)notification;
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication*)sender;
@end

@interface OsnovaWindowDelegate : NSObject <NSWindowDelegate> {
	OsnovaWindow* window;
}
- (void)dealloc;
- (id)initWithOsnovaWindow:(OsnovaWindow*)window;

// @redefinition
- (BOOL)windowShouldClose:(NSWindow*)sender;
- (void)windowDidResize:(NSNotification*)notification;
- (void)windowDidMove:(NSNotification*)notification;
- (void)windowDidMiniaturize:(NSNotification*)notification;
- (void)windowDidDeminiaturize:(NSNotification*)notification;
- (void)windowDidBecomeKey:(NSNotification*)notification;
- (void)windowDidResignKey:(NSNotification*)notification;
- (void)windowDidChangeOcclusionState:(NSNotification*)notification;
@end

static NSApplication* app;
static OsnovaAppDelegate* appDelegate;
static NSAutoreleasePool* pool;
static Array<OsnovaWindow*>* windowArray;

//

@implementation Osnova (Internal)

+ (void)window:(OsnovaWindow*)window getX:(int*)x getY:(int*)y {
	OsnovaWindowData w = [window data];
	const NSRect rect = [w.object contentRectForFrameRect:[w.object frame]];

	if (x != nil) *x = rect.origin.x;
	if (y != nil) *y = rect.origin.y;
}

@end

// === Application Delegate ====================================================

@implementation OsnovaAppDelegate

- (void)createMenuBar {
	NSString* appName = [[NSProcessInfo processInfo] processName];

	// This is a main menu bar (that the first with process name)
	NSMenu* mainMenu = [[NSMenu alloc] init];
	NSMenuItem* mainMenuItem = [[NSMenuItem alloc] init];
	[mainMenu addItem:mainMenuItem];
	[app setMainMenu:mainMenu];

	// This is a submenu of the main menu
	NSMenu* mainSubmenu = [[NSMenu alloc] init];

	// This is an 'About' button
	NSMenuItem* mainItemAbout = [[NSMenuItem alloc]
		initWithTitle:[@"About " stringByAppendingString:appName]
			   action:@selector(orderFrontStandardAboutPanel:)
		keyEquivalent:@""];
	[mainSubmenu addItem:mainItemAbout];

	[mainSubmenu addItem:[NSMenuItem separatorItem]];

	// This is the 'Hide' buttons
	NSMenuItem* mainItemHide = [[NSMenuItem alloc]
		initWithTitle:[@"Hide " stringByAppendingString:appName]
			   action:@selector(hide:)
		keyEquivalent:@"h"];
	[mainSubmenu addItem:mainItemHide];

	NSMenuItem* mainItemHideOthers =
		[[NSMenuItem alloc] initWithTitle:@"Hide Others"
								   action:@selector(hideOtherApplications:)
							keyEquivalent:@"h"];

	// clang-format off
	[mainItemHideOthers setKeyEquivalentModifierMask
		: NSEventModifierFlagOption 
		| NSEventModifierFlagCommand
	];
	// clang-format on

	[mainSubmenu addItem:mainItemHideOthers];

	[mainSubmenu addItem:[NSMenuItem separatorItem]];

	// This is a 'Quit' button
	NSMenuItem* mainItemQuit = [[NSMenuItem alloc]
		initWithTitle:[@"Quit " stringByAppendingString:appName]
			   action:@selector(terminate:)
		keyEquivalent:@"q"];
	// Now we add quit button to submenu
	[mainSubmenu addItem:mainItemQuit];

	// And then add submenu to main menu
	[mainMenuItem setSubmenu:mainSubmenu];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:
	(NSApplication*)sender {
	// [System fatal:"Unimplemented method '%s'", __func__];
	[System debug:__func__];

	while ([windowArray count] != 0) {
		OsnovaWindow* ow = [windowArray getFirst];
		[ow close];
	}

	return NSTerminateCancel;
}

// - (void)applicationDidChangeScreenParameters:(NSNotification*)notification {
// 	[System fatal:"Unimplemented method '%s'", __func__];
// }

- (void)applicationWillFinishLaunching:(NSNotification*)notification {
	[self createMenuBar];
}

- (void)applicationDidFinishLaunching:(NSNotification*)notification {
	// Placed it here to make menu bar work
	[app setActivationPolicy:NSApplicationActivationPolicyRegular];
	[app activateIgnoringOtherApps:YES];
}

- (void)applicationDidHide:(NSNotification*)notification {
	[System fatal:"Unimplemented method '%s'", __func__];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication*)sender {
	if ([windowArray count] != 0) {
		[System fatal:"window array is not empty!"];
	}
	return YES;
}

@end

// === Window Delegate =========================================================

@implementation OsnovaWindowDelegate
- (void)dealloc {
	[self->window release];
	[super dealloc];
}

- (id)initWithOsnovaWindow:(OsnovaWindow*)newWindow {
	self = [super init];

	if (self) {
		self->window = [newWindow retain];
	}

	return self;
}

- (BOOL)windowShouldClose:(NSWindow*)sender {
	[window updClosed:YES];

	for (size_t i = 0; i < [windowArray count]; i++) {
		OsnovaWindow* ow = [windowArray getByIndex:i];
		if ([ow data].object == sender) {
			[windowArray remove:i];
			break;
		}
	}

	// [sender close];
	return YES;
}

- (void)windowDidResize:(NSNotification*)notification {
	// [System fatal:"Unimplemented method '%s'", __func__];
	OsnovaWindowData wd = [window data];
	const NSRect frame = [wd.view frame];
	[window updWidth:frame.size.width updHeight:frame.size.height];
}

- (void)windowDidMove:(NSNotification*)notification {
	// [System fatal:"Unimplemented method '%s'", __func__];
	int x, y;
	[Osnova window:window getX:&x getY:&y];
	[window updX:x updY:y];
}

- (void)windowDidMiniaturize:(NSNotification*)notification {
	[System fatal:"Unimplemented method '%s'", __func__];
}

- (void)windowDidDeminiaturize:(NSNotification*)notification {
	[System fatal:"Unimplemented method '%s'", __func__];
}

- (void)windowDidBecomeKey:(NSNotification*)notification {
	[window updFocus:YES];
}

- (void)windowDidResignKey:(NSNotification*)notification {
	[window updFocus:NO];
}

- (void)windowDidChangeOcclusionState:(NSNotification*)notification {
	OsnovaWindowData wd = [window data];
	wd.occluded = !([wd.object occlusionState] & NSWindowOcclusionStateVisible);
	[window updData:wd];
}

@end

// Osnova

@implementation Osnova

+ (void)begin {
	windowArray = [Array new];
	pool = [NSAutoreleasePool new];
	app = [NSApplication sharedApplication]; // TODO: change back to NSApp

	appDelegate = [OsnovaAppDelegate new];
	if (appDelegate == nil)
		@throw [[Exception alloc]
			initWithFormat:"Unable to init %s", "application delegate"];

	[app setDelegate:appDelegate];
	[app finishLaunching];
}

+ (void)end {
	// [appDelegate dealloc]; will cause seg fault
	[windowArray release];
	[pool drain];
}

+ (void)createWindow:(OsnovaWindow*)window {
	if (window == nil)
		@throw [[Exception alloc] initWithFormat:"Window is not defined!"];

	OsnovaWindowData wd = [window data];
	wd.occluded = NO;
	wd.delegate = [[OsnovaWindowDelegate alloc] initWithOsnovaWindow:window];

	if (wd.delegate == nil)
		@throw [[Exception alloc]
			initWithFormat:"Unable to create %s", "window delegate"];

	int x = [window x];
	int y = [window y];

	BOOL centerX = NO;
	BOOL centerY = NO;

	if (x < 0) {
		x = 0;
		centerX = YES;
	}

	if (y < 0) {
		y = 0;
		centerY = YES;
	}

	NSRect viewRect = NSMakeRect(x, y, [window width], [window height]);

	// clang-format off
	NSUInteger windowStyle 
		= NSWindowStyleMaskTitled 
		| NSWindowStyleMaskMiniaturizable
		| NSWindowStyleMaskClosable
		;
	// clang-format on

	if ([window resizable]) {
		windowStyle |= NSWindowStyleMaskResizable;
	}

	wd.object = [[NSWindow alloc] initWithContentRect:viewRect
											styleMask:windowStyle
											  backing:NSBackingStoreBuffered
												defer:NO];

	if (wd.object == nil)
		@throw [[Exception alloc]
			initWithFormat:"Unable to create %s", "window object"];

	NSString* title = [NSString stringWithUTF8String:[[window title] buffer]];
	[wd.object setTitle:title];

	// [wd.object setContentView:wd.view];
	// [wd.object makeFirstResponder:wd.view];
	[wd.object setDelegate:wd.delegate];
	[wd.object setAcceptsMouseMovedEvents:YES];
	[wd.object setIgnoresMouseEvents:NO];
	[wd.object setRestorable:NO];
	[wd.object setOpaque:YES];
	// [wd.object setAutodisplay:YES]; // derecated

	wd.view = [wd.object contentView];
	// if ([wd.object respondsToSelector:@selector(setTabbingMode:)])
	// 	[wd.object setTabbingMode:NSWindowTabbingModeDisallowed];

	// // Center Window
	const CGFloat w = NSWidth([wd.object frame]);
	const CGFloat h = NSHeight([wd.object frame]);
	if (centerX) x = NSWidth([[wd.object screen] frame]) / 2 - w / 2;
	if (centerY)
		y = NSHeight([[wd.object screen] frame]) / 2 - h / 2;
	else {
		y = h - y; // they use 0 as bottom for some reason
	}
	[wd.object setFrame:NSMakeRect(x, y, w, h) display:YES];
	[wd.object makeKeyAndOrderFront:nil];

	[window updData:wd];
	[windowArray push:window];
}

+ (void)closeWindow:(OsnovaWindow*)window {
	[[window data].object performClose:[window data].object];
}

+ (void)window:(OsnovaWindow*)window setTitle:(const char*)value {
	[[window data].object setTitle:[NSString stringWithUTF8String:value]];
}

+ (void)window:(OsnovaWindow*)window setX:(int)value {
	[window updX:value];
}

+ (void)window:(OsnovaWindow*)window setX:(int)X setY:(int)Y {
	[System fatal:"Unimplemented method '%s'", __func__];
}

+ (void)window:(OsnovaWindow*)window setY:(int)value {
	[System fatal:"Unimplemented method '%s'", __func__];
}

+ (void)window:(OsnovaWindow*)window setWidth:(int)value {
	[System fatal:"Unimplemented method '%s'", __func__];
}

+ (void)window:(OsnovaWindow*)window setHeight:(int)value {
	[System fatal:"Unimplemented method '%s'", __func__];
}

+ (void)window:(OsnovaWindow*)window setFocus:(BOOL)flag {
	if (flag == YES) {
		// [[window data].object orderFront:nil];
		[app activateIgnoringOtherApps:YES];
		[[window data].object makeKeyAndOrderFront:nil];
	} else
		[System fatal:"Unimplemented method '%s'", __func__];
}

+ (void)window:(OsnovaWindow*)window setResizable:(BOOL)flag {
	[System fatal:"Unimplemented method '%s'", __func__];
}

+ (void)window:(OsnovaWindow*)window setData:(OsnovaWindowData)data {
	// [System fatal:"Unimplemented method '%s'", __func__];
	[window updData:data];
}

+ (size_t)windowCount {
	return [windowArray count];
}

+ (OsnovaEvent*)pollEvents:(OsnovaWindow*)window {
	NSEvent* event;
	event = [app nextEventMatchingMask:NSUIntegerMax
							 untilDate:[NSDate distantFuture]
								inMode:NSDefaultRunLoopMode
							   dequeue:YES];
	if (event != nil) {
		// NSEventType type = [event type];
		// NSLog(@"Got event: %lu", (unsigned long)type);
		[app sendEvent:event];
	}

	[app updateWindows];
	return nil;
}

+ (void)swapBuffers:(OsnovaWindow*)window {
}

@end
