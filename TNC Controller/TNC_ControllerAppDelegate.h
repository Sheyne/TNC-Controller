//
//  TNC_ControllerAppDelegate.h
//  TNC Controller
//
//  Created by Sheyne Anderson on 8/3/11.
//  Copyright 2011 Sheyne Anderson. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "AsyncSocket.h"

@class Telescope;

@interface TNC_ControllerAppDelegate : NSObject <NSApplicationDelegate, AsyncSocketDelegate> {
	NSWindow *window;
	AsyncSocket *socket;
	NSString *_address,*_callsigns;
	NSMutableArray *_telescopes;
}

@property (assign) IBOutlet NSWindow *window;
@property (retain) NSString *address, *callsigns;;
@property (retain)NSMutableArray *telescopes;

-(IBAction)showTelescopeWindow:(id)sender;

-(IBAction)connectToServer:(id)sender;
-(void)receivedPacketFromCallsign:(NSString *)callsign withBody:(NSDictionary *)dict;
-(void)receivedSelfPosition:(NSDictionary *)dict;

@end
