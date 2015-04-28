// Copyright (c) 2015 FelisPhasma. All rights reserved.

#import <ScreenSaver/ScreenSaver.h>

@interface MorphView : ScreenSaverView

@property (weak) IBOutlet NSPanel *optionsPanel;
@property (weak) IBOutlet NSButton *option_multiColor;
@property (weak) IBOutlet NSSlider *option_minConnectionDistance;
@property (weak) IBOutlet NSTextField *minConnectionSliderValue;

@end