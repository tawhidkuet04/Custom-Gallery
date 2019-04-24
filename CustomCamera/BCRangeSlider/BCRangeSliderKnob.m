//
//  BCScrollBarKnob.m
//  BCRangeSlider
//
//  Created by Brain Craft Ltd. on 11/29/18.
//  Copyright © 2018 Brain Craft Ltd. All rights reserved.
//

#import "BCRangeSliderKnob.h"

@implementation BCRangeSliderKnob

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    // Draw Knob
    float knobHeight = rect.size.height*0.5;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, (rect.size.height-knobHeight)/2, rect.size.width, knobHeight) cornerRadius:rect.size.height/2];
    [[UIColor colorWithDisplayP3Red:0.0 green:167/256.0 blue:1.0 alpha:1.0] setFill];
    [path fill];
}

@end
