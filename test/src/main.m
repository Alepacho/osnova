#include <stdio.h>
#include <stdlib.h>

#include "osnova.h"
#include "window.h"

int main(void) {
	// @throw [[Exception alloc] init];

	@try {
		[Osnova begin];
		OsnovaWindow* windowCheckPtr = nil;
		OsnovaWindow* window = [[OsnovaWindow alloc] initTitle:"Osnova Test"
													 initWidth:800
													initHeight:600];

		windowCheckPtr = window;
		// [System debug:"%i", [window x]];
		// [window setX:69];
		// [System debug:"%i", [window x]];
		while (![window isClosed]) {
			OsnovaEvent* ev;
			while ((ev = [window pollEvents]) != nil) {
				OsnovaEventType type = [ev type];
				switch (type) {
					case OSNOVA_EV_KEYBOARD: {
						[System debug:"Keyboard event!"];
					} break;
					case OSNOVA_EV_MOUSE: {
						[System debug:"Mouse event!"];
						// [window setTitle:"What da heeeell"];
					} break;
					default: {
						[System fatal:"Unknown Osnova event: '%i'", type];
					}
				}
			}

			[window swapBuffers];
		}

		// [window dealloc]; it will be automatically released, I guess...
		[Osnova end];
		[System
			debug:"window is nil? %s", windowCheckPtr == nil ? "YES" : "NO"];
	} @catch (Exception* ex) {
		[System fatal:"Caught exception: %s", [ex message]];
	}

	return 0;
}
