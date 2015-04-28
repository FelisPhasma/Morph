// Copyright (c) 2015 FelisPhasma. All rights reserved.

#import <Foundation/Foundation.h>

@interface dot: NSObject

@property double x;
@property double vx;
@property double y;
@property double vy;
@property int radius;
@property CGFloat hue;
@property CGFloat saturation;
@property CGFloat brightness;
-(void) initDot:(int) width :(int) height :(int) size;
-(void) update:(int) width :(int) height;

@end