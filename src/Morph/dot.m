// Copyright (c) 2015 FelisPhasma. All rights reserved.

#import "dot.h"
#import "lib.h"
#include <stdlib.h>

@implementation dot

@synthesize x;
@synthesize vx;
@synthesize y;
@synthesize vy;
@synthesize radius;
@synthesize hue;
@synthesize saturation;
@synthesize brightness;
-(void) initDot:(int) width :(int) height :(int) size {
	// Position and velocity
	self.x = [lib doubleRand:0 :width];
	self.vx = [lib doubleRand:-1 :1];
	self.y = [lib doubleRand:0 :height];
	self.vy = [lib doubleRand:-1 :1];
	// Size
	self.radius = size;
	// Color
	self.hue = (arc4random() % 256 / 256.0);
	self.saturation = (arc4random() % 128 / 256.0) + 0.5;
	self.brightness = (arc4random() % 128 / 256.0) + 0.5;
};
-(void) update:(int) width :(int) height{
	// Position
	self.x += self.vx;
	self.y += self.vy;
	// Off screen detection
	if(self.x + self.radius > width)
		self.x = self.radius;
	else if(self.x - self.radius < 0)
		self.x = width - self.radius;
	if(self.y + self.radius > height)
		self.y = self.radius;
	else if(self.y - self.radius < 0)
		self.y = height - self.radius;
};

@end