// Copyright (c) 2015 FelisPhasma. All rights reserved.

#import "MorphView.h"
#import "dot.h"

@implementation MorphView

@synthesize optionsPanel;
@synthesize option_multiColor;
@synthesize option_minConnectionDistance;
@synthesize minConnectionSliderValue;

static NSString * const moduleName = @"com.FelisPhasma.Morph";
static int const numDots = 100;
dot *dots[numDots];
double minConnectionDist = 100.0;

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview{
	self = [super initWithFrame:frame isPreview:isPreview];
	if (self) {
		ScreenSaverDefaults *defaults;
		defaults = [ScreenSaverDefaults defaultsForModuleWithName:moduleName];
		[defaults registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
									@"YES", @"multiColor",
									@"100.0", @"minConnectionDistance",
									nil]];
		//[self setAnimationTimeInterval:1/30.0];
		[self setAnimationTimeInterval:1/60.0];
	}
	return self;
}

- (void)startAnimation{
	[super startAnimation];
	ScreenSaverDefaults *defaults;
	defaults = [ScreenSaverDefaults defaultsForModuleWithName:moduleName];
	// Preview handling
	if([self isPreview])
		minConnectionDist = 30.0;
	else
	minConnectionDist = [defaults doubleForKey:@"minConnectionDistance"];
	NSSize size = [self bounds].size;
	// Initialize dots
	for(int i = 0; i < numDots; i++){
		dots[i] = [[dot alloc] init];
		if([self isPreview])
			[dots[i] initDot:size.width:size.height:5];
		else
			[dots[i] initDot:size.width:size.height:10];
	}
}

- (void)stopAnimation{
	[super stopAnimation];
}

- (void)drawRect:(NSRect)rect{
	[super drawRect:rect];
}

-(void) clearScreen {
	NSBezierPath *path;
	NSRect rect;
	NSSize size;
	NSColor *color;
	size = [self bounds].size;
	// Calculate random width and height
	rect.size = NSMakeSize(size.width, size.height);
	// Calculate random origin point
	rect.origin.x = 0;
	rect.origin.y = 0;
	path = [NSBezierPath bezierPathWithRect:rect];
	// Calculate a random color
	color = [NSColor blackColor];
	[color set];
	[path fill];
}
-(void) plasmaConnections:(dot*) p1 :(dot*) p2 {
	double dx = [p1 x] - [p2 x];
	double dy = [p1 y] - [p2 y];
	double dist = sqrt(dx*dx + dy*dy);
	if(dist <= minConnectionDist) {
		NSBezierPath *path;
		NSColor *color;
		NSPoint start = {p1.x, p1.y};
		NSPoint stop = {p2.x, p2.y};
		path = [NSBezierPath bezierPath];
		[path moveToPoint:start];
		[path lineToPoint:stop];
		color = [NSColor colorWithRed:255 green:255 blue:255 alpha:(1.0 - dist/minConnectionDist)];
		[color set];
		[path stroke];
		
		double ax = dx/8000;
		double ay = dy/8000;
		p1.vx -= ax;
		p1.vy -= ay;
		p2.vx += ax;
		p2.vy += ay;
	};
}
-(void) drawConnections:(ScreenSaverDefaults*) defaults {
	for(int i = 0; i < numDots; i++)
		for(int j = i + 1; j < numDots; j++)
			[self plasmaConnections:dots[i]:dots[j]];
};
-(void) drawDots:(ScreenSaverDefaults*) defaults {
	int dotRadius;
	for(int i = 0; i < numDots; i++){
		// Dot
		NSBezierPath *path;
		NSRect rect;
		NSSize size;
		NSColor *color;
		size = [self bounds].size;
		dotRadius = [dots[i] radius];
		rect.size = NSMakeSize(dotRadius, dotRadius);
		rect.origin.x = [dots[i] x] - ([dots[i] radius] / 2);
		rect.origin.y = [dots[i] y] - ([dots[i] radius] / 2);
		path = [NSBezierPath bezierPathWithOvalInRect:rect];
        if([defaults boolForKey:@"multiColor"])
            color = [NSColor colorWithHue: [dots[i] hue] saturation:[dots[i] saturation] brightness:[dots[i] brightness] alpha:1.0];
        else
            color = [NSColor whiteColor];
		[color set];
		[path fill];
		// Update
		[dots[i] update:size.width:size.height];
	}
}

- (void)animateOneFrame{
	ScreenSaverDefaults *defaults;
	defaults = [ScreenSaverDefaults defaultsForModuleWithName:moduleName];
	[self clearScreen];
	[self drawConnections:defaults];
	[self drawDots:defaults];
	/*NSSize size = [self bounds].size;
	 [self drawText:20:80:[NSString stringWithFormat:@"X: %f", size.width]];
	 [self drawText:20:60:[NSString stringWithFormat:@"X: %f", size.height]];
	 [self drawText:20:40:[NSString stringWithFormat:@"X: %f", [singleDot x]]];
	 [self drawText:20:20:[NSString stringWithFormat:@"Y: %f", [singleDot y]]];*/
	//[self drawText:20:20:@"Lol"];
}

- (BOOL)hasConfigureSheet{
	return YES;
}

- (NSWindow*)configureSheet{
	if (!optionsPanel){
		if (![NSBundle loadNibNamed:@"config" owner:self]){
			NSBeep();
		}
	}
	return optionsPanel;
}

- (IBAction)sliderChanged:(id)sender {
	//[minConnectionSliderValue setValue:[option_minConnectionDistance doubleValue]];
	[minConnectionSliderValue setStringValue:[NSString stringWithFormat:@"%.2f", [option_minConnectionDistance doubleValue]]];
}
- (IBAction)restoreToDefaults:(id)sender {
	[option_minConnectionDistance setDoubleValue:100.0];
    [minConnectionSliderValue setStringValue:@"100.00"];
	[option_multiColor setState:1];
}

- (IBAction)closeConfig:(id)sender {
	[[NSApplication sharedApplication] endSheet:self.optionsPanel];
}

- (IBAction)okClick:(id)sender{
	ScreenSaverDefaults *defaults;
	defaults = [ScreenSaverDefaults defaultsForModuleWithName:moduleName];
	// Update defaults
	[defaults setBool:[option_multiColor state] forKey:@"multiColor"];
	[defaults setDouble:[option_minConnectionDistance doubleValue] forKey:@"minConnectionDistance"];
	// Save
	[defaults synchronize];
	// Close
	[[NSApplication sharedApplication] endSheet:self.optionsPanel];
}

@end