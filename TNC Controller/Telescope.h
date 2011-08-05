//
//  TelescopeController.h
//  TNC Controller
//
//  Created by Sheyne Anderson on 8/3/11.
//  Copyright 2011 Sheyne Anderson. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <TCP/TCP.h>

@class SphericalPoint;

@interface Telescope : NSObject <TCPListener>
{
	int nButtonState, sButtonState, eButtonState, wButtonState;
	NSString *auxString,*log, *addressString;
	NSString *targetAltitude,*targetAzimuth;
	TCP *_tcpConnection;
	NSWindow *connectionWindow, *window;
	SphericalPoint *_d710point;
	
}
@property (retain) TCP *con;
@property (retain) NSString *targetAltitude, *targetAzimuth;
@property (retain) NSString *log, *auxString, *addressString;
@property (assign) int nButtonState, sButtonState, eButtonState, wButtonState;
@property (assign) IBOutlet NSWindow *connectionWindow, *window;
@property (retain) SphericalPoint *d710point;

-(void)makeFocus;

-(IBAction)stop:(NSButton*)sender;
-(IBAction)pressAuxButton:(NSButton*)sender;

-(IBAction)setAlt_Az:(NSButton*)sender;
-(IBAction)goToTargetA:(NSButton*)sender;
-(IBAction)setAltAzAndGo:(id)sender;

-(void)doGo:(NSString*)directions;
-(void)doStop:(NSString*)directions;
-(void)doState:(int)state on:(NSString*)directions; 
-(void)setButton:(NSString*)button toState:(int)state;

-(void)doSend:(NSString*)command;

-(IBAction)connectToTelescope:(NSButton *)sender;

-(void)receivedPacketFromCallsign:(NSString *)callsign withBody:(NSDictionary *)dict;

@end
