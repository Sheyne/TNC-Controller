//
//  TelescopeController.h
//  TNC Controller
//
//  Created by Sheyne Anderson on 8/3/11.
//  Copyright 2011 Sheyne Anderson. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <TCP/TCP.h>

@interface Telescope : NSObject <TCPListener>
{
	int nButtonState, sButtonState, eButtonState, wButtonState;
	NSString *auxString,*log, *addressString, *TNCaddressSting;
	NSString *targetAltitude,*targetAzimuth;
	TCP *_tcpConnection;
	
}
@property (retain) TCP *con;
@property (assign) IBOutlet NSWindow *connectionWindow;
@property (retain) NSString *targetAltitude, *targetAzimuth;
@property (retain) NSString *log, *auxString, *addressString, *TNCaddressString;
@property (assign) int nButtonState, sButtonState, eButtonState, wButtonState;


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

@end
