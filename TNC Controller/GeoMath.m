//
//  GeoMath.m
//  Geo
//
//  Created by Sheyne Anderson on 3/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GeoMath.h"


@implementation GeoMath
//convenience method for the law of cosines
+(double)lawOfCosinesA:(double)a b:(double)b opp:(double)opp{
	return sqrt(a*a+b*b-2*a*b*cos(opp));
}
//convenience method for the law of sines
+(double)lawOfSinesOpp:(double)opp other:(double)other oppOther:(double)oppOther{
	return asin(sin(oppOther)*opp/other);
}
@end
