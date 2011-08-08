//
//  TNC_ControllerAppDelegate.m
//  TNC Controller
//
//  Created by Sheyne Anderson on 8/3/11.
//  Copyright 2011 Sheyne Anderson. All rights reserved.
//

#import "TNC_ControllerAppDelegate.h"
#import "Telescope.h"
#import <TCP/TCP.h>
#import "JSONKit.h"
#import "TNC Listener.h"

@implementation TNC_ControllerAppDelegate

@synthesize callsigns=_callsigns;
@synthesize window;
@synthesize telescopes=_telescopes;
@synthesize address=_address;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	self.address=@"localhost:54730";
	self.callsigns=@"KE7ROS";
	self.telescopes=[NSMutableArray arrayWithCapacity:1];
	tcp=[[TCP alloc]init];
	tcp.delegate=self;
}
-(void)receivedMessage:(NSData *)message socket:(CFSocketRef)socket{
	NSDictionary * dict=[message objectFromJSONData];
	NSArray *calls=[self.callsigns componentsSeparatedByString:@","];
	[dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		if ([key isEqualToString:@"D710"])
			[self receivedSelfPosition:obj];
		else
			[calls enumerateObjectsUsingBlock:^(id posibleGoodKey, NSUInteger idx, BOOL *stop) {
				if ([key hasPrefix:posibleGoodKey]) {
					[self receivedPacketFromCallsign:key withBody:obj];
				}
			}];
	}];
}
-(void)receivedSelfPosition:(NSDictionary *)dict{
	for (id<TNC_Listener> aDevice in self.telescopes){
		[aDevice receivedSelfPosition:dict];
	}	
}
-(void)receivedPacketFromCallsign:(NSString *)callsign withBody:(NSDictionary *)dict{
	for (id<TNC_Listener> aDevice in self.telescopes){
		[aDevice receivedPacketFromCallsign:callsign withBody:dict];
	}
}

-(IBAction)showTelescopeWindow:(id)sender{
	Telescope *telescope=[[[Telescope alloc] init] autorelease];
	[self.telescopes addObject:telescope];
	[telescope makeFocus];
}
-(IBAction)showBearingRangeWindow:(id)sender{
	/*BearingRange *telescope=[[[BearingRange alloc] init] autorelease];
	[self.telescopes addObject:telescope];
	[telescope makeFocus];*/
}

-(IBAction)connectToServer:(id)sender{
	NSArray *parts=[self.address componentsSeparatedByString:@":"];
	if (parts.count==2) {
		[[sender window] performClose:sender];
		[tcp connectToServer:[parts objectAtIndex:0] onPort:[[parts objectAtIndex:1] intValue]];	
		[self.window makeKeyAndOrderFront:nil];
	}
}
@end
