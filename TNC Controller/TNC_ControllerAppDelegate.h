//
//  TNC_ControllerAppDelegate.h
//  TNC Controller
//
//  Created by Sheyne Anderson on 8/3/11.
//  Copyright 2011 Sheyne Anderson. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <TCP/TCP.h>

@class Telescope;

@interface TNC_ControllerAppDelegate : NSObject <NSApplicationDelegate, TCPListener> {
	NSWindow *window;
	TCP *tcp;
	NSString *_address,*_callsigns;
	NSMutableArray *_telescopes;
}

@property (assign) IBOutlet NSWindow *window;
@property (retain) NSString *address, *callsigns;;
@property (retain)NSMutableArray *telescopes;

-(IBAction)showTelescopeWindow:(id)sender;

-(IBAction)connectToServer:(id)sender;
-(void)receivedPacketFromCallsign:(NSString *)callsign withBody:(NSDictionary *)dict;

@end
