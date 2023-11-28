#include <stdio.h>
#include <stdlib.h>

#include "osnova.h"
#include "window.h"

int main(void) {

	[Osnova init];
	OsnovaWindow* window = [[OsnovaWindow alloc] initTitle:"Osnova Test"
												 initWidth:800
												initHeight:600];

	while (![window shouldClose]) {
		OsnovaEvent ev;
		while ((ev = [Osnova pollEvents]) != OSNOVA_EV_NONE) {
			switch (ev) {
				case OSNOVA_EV_KEYBOARD: {
					[System debug:"Keyboard event!"];
				} break;
				case OSNOVA_EV_MOUSE: {
					[System debug:"Mouse event!"];
				} break;
				default: {
					[System fatal:"Unknown Osnova event: '%i'", ev];
				}
			}
		}

		[window swapBuffers];
	}

	[window dealloc];
	[Osnova term];

	return 0;
}
