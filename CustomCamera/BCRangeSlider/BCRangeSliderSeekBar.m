//
//  BCRangeSliderSeekBar.m
//  BCRangeSlider
//
//  Created by Brain Craft Ltd. on 12/4/18.
//  Copyright © 2018 Brain Craft Ltd. All rights reserved.
//

#import "BCRangeSliderSeekBar.h"

@implementation BCRangeSliderSeekBar

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    
    // Start Toast
    _toast = [[BCRangeSliderSeekBarToast alloc] initWithFrame:CGRectMake(self.frame.size.width/2-20, -20, 40, 20)];
    [self addSubview:_toast];
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    // Draw Outer Rect
    UIBezierPath *outerPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, rect.size.width, rect.size.height) cornerRadius:rect.size.height/8];
    [[UIColor colorWithDisplayP3Red:1.0 green:1.0 blue:1.0 alpha:1.0] setFill];
    [outerPath fill];
    
    // Draw Inner Rect
    UIBezierPath *innerPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(rect.size.width/4, 0, rect.size.width/2, rect.size.height) cornerRadius:rect.size.height/8];
    [[UIColor colorWithDisplayP3Red:0.0 green:167/256.0 blue:1.0 alpha:1.0] setFill];
    [innerPath fill];
}

@end
