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
	socket=[[AsyncSocket alloc] initWithDelegate:self];
}
-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
	NSLog(@"got msg: %s", data.bytes);
	[socket readDataToData:[AsyncSocket CRLFData] withTimeout:-1 tag:986];
	NSDictionary * dict=[data   objectFromJSONData];
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
		NSError *err=nil;
		[socket connectToHost:[parts objectAtIndex:0] onPort:((NSString *)[parts objectAtIndex:1]).intValue error:&err];
		if(err){
			NSLog(@"Error connecting to socket: %@",err.userInfo);
			return;
		}
		[[sender window] performClose:sender];
		[socket readDataToData:[AsyncSocket CRLFData] withTimeout:-1 tag:986];
		[self.window makeKeyAndOrderFront:nil];
	}
}
@end
