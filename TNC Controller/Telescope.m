//
//  TelescopeController.m
//  TNC Controller
//
//  Created by Sheyne Anderson on 8/3/11.
//  Copyright 2011 Sheyne Anderson. All rights reserved.
//

#import "Telescope.h"
#import "SphericalPoint.h"

static void* DirectionChangedContext=(void *)@"TelescopeControllerDirectionChangedContext";
static void* PointChangedContext=(void *)@"TelescopeControllerDirectionChangedContext";

@interface Telescope ()

-(void)doState:(int)state on:(NSString*)directions;
-(void)setButton:(NSString*)button toState:(int)state;

@end

@implementation Telescope

@synthesize d710point=_d710point;
@synthesize targetPoint=_targetPoint;

@synthesize targetAltitude,targetAzimuth;
@synthesize nButtonState, sButtonState, eButtonState, wButtonState;
@synthesize log, auxString, addressString;

@synthesize connectionWindow, window;
@synthesize con=_tcpConnection;



-(id)init{
	if (self=[super init]) {
		[NSBundle loadNibNamed:@"TelescopeDriver" owner:self];
		self.con=[[[AsyncSocket alloc] initWithDelegate:self] autorelease];
		self.addressString=@"harbor-mbp.local:7342";
		[self addObserver:self forKeyPath:@"nButtonState" options:NSKeyValueObservingOptionNew context:&DirectionChangedContext];
		[self addObserver:self forKeyPath:@"sButtonState" options:NSKeyValueObservingOptionNew context:&DirectionChangedContext];
		[self addObserver:self forKeyPath:@"eButtonState" options:NSKeyValueObservingOptionNew context:&DirectionChangedContext];
		[self addObserver:self forKeyPath:@"wButtonState" options:NSKeyValueObservingOptionNew context:&DirectionChangedContext];
		[self addObserver:self forKeyPath:@"d710point" options:NSKeyValueObservingOptionNew context:&PointChangedContext];
		[self addObserver:self forKeyPath:@"targetPoint" options:NSKeyValueObservingOptionNew context:&PointChangedContext];
	}
	return self;
}

-(IBAction)pressAuxButton:(NSButton*)button{
	[self doSend:self.auxString];
	self.auxString=@"";
}

-(void)makeFocus{
	[self.connectionWindow makeKeyAndOrderFront:nil];
}

-(void)computeAndSendTarget:(char)alt_az angle:(double)angle{
	char* seperator;
	switch (alt_az) {
		case 'r':
			//convert from degrees to hours
			angle/=15;
			seperator=":";
			break;
		default:
			seperator="\\xdf";
			break;
	}
	int degrees=(int)angle;
	double minutes=fmod(angle,1)*60;
	int seconds=(int)(fmod(minutes,1)*60);
	[self doSend:[NSString stringWithFormat:@"S%c%d%s%d:%d",alt_az, degrees, seperator, (int) minutes, seconds]];
}

-(void)receivedMessage:(NSData *)message socket:(CFSocketRef)socket{
	char*msg=(char*)[message bytes];
	NSLog(@"received: %s",msg);
	if (strcmp(msg,"\n")!=0) {
		self.log=[NSString stringWithFormat:@"%s%@",msg,self.log];
	}
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
	if (&DirectionChangedContext==context) {
		NSString* strOfState;
		unichar dir=[keyPath characterAtIndex:0];
		if ([[change valueForKey:@"new"] isEqualToNumber:[NSNumber numberWithInt:NSOnState]]) {
			strOfState=@"M";
			switch ((char)dir) {
				case 'n':
					[self doStop:@"s"];
					break;
				case 's':
					[self doStop:@"n"];
					break;
				case 'e':
					[self doStop:@"w"];
					break;
				case 'w':
					[self doStop:@"e"];
					break;
			}
		}else {
			strOfState=@"Q";
		}
		
		[self doSend:[NSString stringWithFormat:@"%@%c",strOfState,dir]];
	}else if(context==&PointChangedContext&&self.targetPoint&&self.d710point){
		NSLog(@"problem is here");
		[self.d710point findTarget:self.targetPoint];
		double distto, angto, heading;
		distto=self.d710point.distanceBetweenSelfAndTarget;
		angto=self.d710point.angleFromLevelToTarget*180/M_PI;
		heading=self.d710point.headingFromSelfToTarget*180/M_PI;
		if (!isnan(distto)&&!isnan(angto)&&!isnan(heading)) {
			self.targetAltitude=[NSString stringWithFormat:@"%f", angto];
			self.targetAzimuth=[NSString stringWithFormat:@"%f", heading];
			[self setAltAzAndGo:nil];
		}
	}
}

-(IBAction)stop:(NSButton*)sender{
	[self doStop:@"n,s,w,e,"];
}



-(void)doGo:(NSString *)directions{
	[self doState:NSOnState on:directions];
}

-(void)doStop:(NSString *)directions{
	[self doState:NSOffState on:directions];
}
-(void)doSend:(NSString *)command{
	[self.con writeData:[[NSString stringWithFormat:@"#:%@#",command] dataUsingEncoding:NSASCIIStringEncoding] withTimeout:-1 tag:2463];
	NSLog(@"I am now sending command: %@",command);
}

-(void)doState:(int)state on:(NSString*)directions{
	for(NSString* str in [directions componentsSeparatedByString:@","]){
		[self setButton:str toState:state];
	}	
}


-(void)setButton:(NSString*)button toState:(int)state{
	@try{
		if (state==NSOnState) {
			if ([button isEqualToString:@"n"])
				self.sButtonState=NSOffState;
		}
		[self setValue:[NSNumber numberWithInt:state] forKey:[NSString stringWithFormat:@"%@ButtonState",button]];
	}
	@catch (NSException*e) {
	}
}

-(IBAction)setAlt_Az:(NSButton*)sender{
	if (sender.tag==4) {
		[self computeAndSendTarget:'a' angle:self.targetAltitude.doubleValue];
	}else if (sender.tag==5) {
		[self computeAndSendTarget:'r' angle:self.targetAzimuth.doubleValue];
	}
	
}
-(IBAction)setAltAzAndGo:(id)sender{
	[self computeAndSendTarget:'a' angle:self.targetAltitude.doubleValue];
	[self computeAndSendTarget:'r' angle:self.targetAzimuth.doubleValue];
	[self goToTargetA:nil];
}

-(IBAction)goToTargetA:(NSButton*)sender{
	[self doSend:@"MA"];
}

-(IBAction)connectToTelescope:(NSButton *)sender{
	NSArray *parts=[self.addressString componentsSeparatedByString:@":"];
	if (parts.count==2) {
		NSLog(@"connecting to %@ on %d",[parts objectAtIndex:0], [[parts objectAtIndex:1] intValue]);
		NSError *err=nil;
		[self.con connectToHost:[parts objectAtIndex:0] onPort:[[parts objectAtIndex:1] intValue] error:&err];	
		if(err){
			NSLog(@"Error connecting to telescope socket: %@",err.userInfo);
			return;
		}
		[self.window makeKeyAndOrderFront:nil];
		[self.connectionWindow close];
	}
}

SphericalPoint *pointForPacket(id packet);
SphericalPoint *pointForPacket(id packet){
	@try {
		return [[[SphericalPoint alloc] initWithPhi:[[packet objectForKey:@"latitude"] doubleValue] theta:[[packet objectForKey:@"longitude"] doubleValue] rho:[[packet objectForKey:@"altitude"] doubleValue]] autorelease];
	}
	@catch (NSException *exception) {
		NSLog(@"Missing Lat/lon/alt");
		return nil;
	}
}

-(void)receivedSelfPosition:(NSDictionary *)dict{
	NSLog(@"got self packet: %@",dict);
	self.d710point=pointForPacket(dict);
}

-(void)receivedPacketFromCallsign:(NSString *)callsign withBody:(NSDictionary *)dict{
	NSLog(@"got from %@ packet: %@",callsign,dict);
	self.targetPoint=pointForPacket(dict);	
}
@end
