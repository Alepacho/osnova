#include <stdio.h>
#include <stdlib.h>

#include "osnova.h"
#include "window.h"

int main(void) {
	// @throw [[Exception alloc] init];

	@try {
		[Osnova begin];
		int* windowCheckPtr = nil;
		OsnovaWindow* window = [[OsnovaWindow alloc] initTitle:"Osnova Test"
													 initWidth:800
													initHeight:600];
		id winfo = [[OsnovaWindow alloc] initTitle:"Osnova Settings"
											 initX:16
											 initY:16
										 initWidth:240
										initHeight:480];

		windowCheckPtr = (int*)window;
		// NSLog(@"first: %d", *windowCheckPtr);

		// [System debug:"%i", [window x]];
		while ([Osnova windowCount] != 0) {
			OsnovaEvent* ev;
			while ((ev = [window pollEvents]) != nil) {
				OsnovaEventType type = [ev type];
				switch (type) {
					case OSNOVA_EV_KEYBOARD: {
						[System debug:"Keyboard event!"];
					} break;
					case OSNOVA_EV_MOUSE: {
						[System debug:"Mouse event!"];
					} break;
					default: {
						[System fatal:"Unknown Osnova event: '%i'", type];
					}
				}
			}

			[window swapBuffers];
		}

		[winfo close];
		[window close];
		[Osnova end];
		[System
			debug:"window is nil? %s", windowCheckPtr == nil ? "YES" : "NO"];
		// NSLog(@"second: %d", *windowCheckPtr);
	} @catch (Exception* ex) {
		[System fatal:"Caught exception: %s", [ex message]];
		[ex release];
	}

	return 0;
}
