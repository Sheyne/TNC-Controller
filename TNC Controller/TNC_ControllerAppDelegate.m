//
//  TNC_ControllerAppDelegate.m
//  TNC Controller
//
//  Created by Sheyne Anderson on 8/3/11.
//  Copyright 2011 Sheyne Anderson. All rights reserved.
//

#import "TNC_ControllerAppDelegate.h"
#import "Telescope.h"


@implementation TNC_ControllerAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	Telescope *t=[[Telescope alloc] init];
}

@end
