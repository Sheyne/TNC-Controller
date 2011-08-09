//
//  TelescopeController.h
//  TNC Controller
//
//  Created by Sheyne Anderson on 8/3/11.
//  Copyright 2011 Sheyne Anderson. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AsyncSocket.h"
#import "TNC Listener.h"

@class SphericalPoint;

@interface Telescope : NSObject <AsyncSocketDelegate, TNC_Listener>
{
	int nButtonState, sButtonState, eButtonState, wButtonState;
	NSString *auxString,*log, *addressString;
	NSString *targetAltitude,*targetAzimuth;
	AsyncSocket *_tcpConnection;
	NSWindow *connectionWindow, *window;
	SphericalPoint *_d710point;
	SphericalPoint *_targetPoint;
}
@property (retain) AsyncSocket *con;
@property (retain) NSString *targetAltitude, *targetAzimuth;
@property (retain) NSString *log, *auxString, *addressString;
@property (assign) int nButtonState, sButtonState, eButtonState, wButtonState;
@property (assign) IBOutlet NSWindow *connectionWindow, *window;
@property (retain) SphericalPoint *d710point;
@property (retain) SphericalPoint *targetPoint;

-(void)makeFocus;

-(IBAction)stop:(NSButton*)sender;
-(IBAction)pressAuxButton:(NSButton*)sender;


/*
 setting alt/ az send a command to the telescope that
 give it a target altitude/azimuth (it doesn't drive
 the scope)
 
 sending go commands actually drives the scope to the
 set targets
 
 */
-(IBAction)setAlt_Az:(NSButton*)sender;
-(IBAction)goToTargetA:(NSButton*)sender;
-(IBAction)setAltAzAndGo:(id)sender;


/*
 these functions all take a NSString * called directions,
 they iterate over the chars in those strings and run the
 functions on all of them. 
 
 posible directions are as follows:
	n: north, s:south, e:east, w:west
 
 for eaxample doGo:@"nw" drives the scope nw

 doStop:@"nswe#" stops driving the scope in all directions
 and does a "stop slew to target" (:Q#)
 */

-(void)doGo:(NSString*)directions;
-(void)doStop:(NSString*)directions;


/*
 sends a command to the telescope and formats it:
 the lx200 command set dictates that all commands are
 prefixed by a colon and terminated by a hash (:command#)
 
 this ensures that the previous command was terminated by
 sending #:command#
 
 the only command that is not in this format is the ascii
 ack (0x06) which returns the scopes current mode (altaz,
 land, ...) this command is unharmed by :ack#
 */
-(void)doSend:(NSString*)command;

-(IBAction)connectToTelescope:(NSButton *)sender;

@end
