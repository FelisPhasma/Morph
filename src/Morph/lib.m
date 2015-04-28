// Copyright (c) 2015 FelisPhasma. All rights reserved.

#import "lib.h"

@implementation lib

+(double) doubleRand:(double)low :(double)high {
	return (((float)arc4random()/0x100000000)*(high-low)+low);
};

@end