//
//  SphericalPoint.h
//  Geo
//
//  Created by Sheyne Anderson on 3/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SphericalPoint : NSObject {
	double phi;
	double theta;
	double rho;
	double angleBetweenVectorsOfSelfAndTarget;
	double distanceBetweenSelfAndTarget;
	double angleFromLevelToTarget;
	double headingFromSelfToTarget;
}
@property (nonatomic,assign)double phi;
@property (nonatomic,assign)double theta;
@property (nonatomic,assign)double rho;
@property (nonatomic,assign)double angleBetweenVectorsOfSelfAndTarget;
@property (nonatomic,assign)double distanceBetweenSelfAndTarget;
@property (nonatomic,assign)double angleFromLevelToTarget;
@property (nonatomic,assign)double headingFromSelfToTarget;
-(void)findTarget:(SphericalPoint*)target;
-(double)haversine:(SphericalPoint*)target;
-(double)azimuth:(SphericalPoint*)target d:(double)d;
-(SphericalPoint*)initWithPhi:(double)phi theta:(double)theta rho:(double)rho;
-(SphericalPoint*)initWithLatitude:(double)latitude longitude:(double)longitude altitude:(double)altitude;
@end
