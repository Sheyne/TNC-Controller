//
//  TNC Listener.h
//  TNC Controller
//
//  Created by Sheyne Anderson on 8/7/11.
//  Copyright 2011 Sheyne Anderson. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TNC_Listener <NSObject>
-(void)receivedPacketFromCallsign:(NSString *)callsign withBody:(NSDictionary *)dict;
-(void)receivedSelfPosition:(NSDictionary *)dict;

@end
