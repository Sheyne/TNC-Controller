//
//  SphericalPoint.m
//  Geo
//
//  Created by Sheyne Anderson on 3/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "GeoMath.h"
#import "SphericalPoint.h"


@implementation SphericalPoint
@synthesize theta;
@synthesize phi;
@synthesize rho;
@synthesize angleBetweenVectorsOfSelfAndTarget;
@synthesize distanceBetweenSelfAndTarget;
@synthesize angleFromLevelToTarget;
@synthesize headingFromSelfToTarget;
-(SphericalPoint*)initWithPhi:(double)_phi theta:(double)_theta rho:(double)_rho{
    if (self = [super init])
    {
		self.theta=_theta;
		self.phi=_phi;
		self.rho=_rho;
    }
    return self;	
}
-(SphericalPoint*)initWithLatitude:(double)latitude longitude:(double)longitude altitude:(double)altitude{
	return [self initWithPhi:latitude*M_PI/180 theta:longitude*M_PI/180 rho:altitude+6371008.7714];
}
//Calculate the altitude angle to target
-(void)findTarget:(SphericalPoint *)target{
	angleBetweenVectorsOfSelfAndTarget=[self haversine:target];
	distanceBetweenSelfAndTarget=[GeoMath lawOfCosinesA:self.rho
													  b:target.rho
													opp:angleBetweenVectorsOfSelfAndTarget];
	if (self.rho<target.rho) {
		angleFromLevelToTarget=M_PI-angleBetweenVectorsOfSelfAndTarget
		-[GeoMath lawOfSinesOpp:target.rho
						  other:distanceBetweenSelfAndTarget
					   oppOther:angleBetweenVectorsOfSelfAndTarget];	
	}else {
		angleFromLevelToTarget=[GeoMath lawOfSinesOpp:target.rho
												other:distanceBetweenSelfAndTarget
											 oppOther:angleBetweenVectorsOfSelfAndTarget];	
	}
	angleFromLevelToTarget-=M_PI/2;
	headingFromSelfToTarget=[self azimuth:target d:angleBetweenVectorsOfSelfAndTarget];
}

//Calculate the azimuth to target
-(double)azimuth:(SphericalPoint*)target d:(double)d{
	if(sin(target.theta-self.theta)>0 ){   
		return acos((sin(target.phi)-sin(self.phi)*cos(d))/(sin(d)*cos(self.phi)));
	}
	return 2*M_PI-acos((sin(target.phi)-sin(self.phi)*cos(d))/(sin(d)*cos(self.phi)));
}

//convenience method for haversine formula
-(double)haversine:(SphericalPoint *)target{
	return 2*asin(sqrt(pow(sin((self.phi-target.phi)/2),2) + cos(self.phi)*cos(target.phi)*pow(sin((self.theta-target.theta)/2),2)));
}
@end
