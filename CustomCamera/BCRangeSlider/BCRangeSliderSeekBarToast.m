//
//  BCToast.m
//  BCSpeedController-ObjectiveC
//
//  Created by Rashed Nizam on 11/9/18.
//  Copyright © 2018 BrainCraft. All rights reserved.
//

#import "BCRangeSliderSeekBarToast.h"

@implementation BCRangeSliderSeekBarToast


- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    
    // Create Label
    _textLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _textLabel.text = @"99.5";
    [self addSubview:_textLabel];
    _textLabel.textColor = UIColor.whiteColor;
    _textLabel.textAlignment = NSTextAlignmentCenter;
    [_textLabel setFont:[UIFont fontWithName:@"Verdana" size:10]];
    
    return self;
}

- (void)setMessage:(NSString *)string {
    _textLabel.text = string;
}

- (void)drawRect:(CGRect)rect {
    // Draw Toast View
//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.bounds.size.height/6];
//    [[UIColor colorWithDisplayP3Red:0.0 green:167/256.0 blue:1.0 alpha:0.2] setFill];
//    [path fill];
}


@end
