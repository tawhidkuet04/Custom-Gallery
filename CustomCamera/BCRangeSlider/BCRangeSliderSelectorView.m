//
//  BCSelectorView.m
//  BCRangeSlider
//
//  Created by Brain Craft Ltd. on 12/2/18.
//  Copyright © 2018 Brain Craft Ltd. All rights reserved.
//

#import "BCRangeSliderSelectorView.h"

@implementation BCRangeSliderSelectorView {
    SelectorType selectorType;
}

- (id) initWithFrame:(CGRect)frame SelectorType: (SelectorType) type {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    
    selectorType = type;
    NSLog(@"Selector Type: %d", type);
    
    // Arrow
    if (selectorType == SelectorTypeEnd) {
        float height = frame.size.height*0.3;
        float width = height/2;
        UIImageView *arrowView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width*0.26, frame.size.height*0.35, width, height)];
        arrowView.image = [UIImage imageNamed:@"EndArrow"];
        [self addSubview:arrowView];
    } else {
        float height = frame.size.height*0.3;
        float width = height/2;
        UIImageView *arrowView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width*0.53, frame.size.height*0.35, width, height)];
        arrowView.image = [UIImage imageNamed:@"StartArrow"];
        [self addSubview:arrowView];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    // Draw Rect
    float width = rect.size.width/2;
    float height = rect.size.height;
    float xx = width*0.75;
    if (selectorType == SelectorTypeEnd) {
        xx = width*0.25;
    }
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(xx, 0, width, height) cornerRadius:width/12];
    [[UIColor colorWithDisplayP3Red:0.0 green:167/256.0 blue:1.0 alpha:1.0] setFill];
    [path fill];
}

@end
