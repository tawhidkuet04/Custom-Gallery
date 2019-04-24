//
//  BCScrollBar.m
//  BCRangeSlider
//
//  Created by Brain Craft Ltd. on 11/29/18.
//  Copyright © 2018 Brain Craft Ltd. All rights reserved.
//

#import "BCRangeSliderScrollBar.h"
#import "BCRangeSliderKnob.h"

@implementation BCRangeSliderScrollBar {
    // Padding
    float padding;
}


- (id) initWithFrame:(CGRect)frame andKnobIsToBarRatio:(float) knobRatio {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    
    // Padding
    padding = 24;
    _knobOffset = 0;
    
    // Knob
    float knobWidth = (self.frame.size.width-padding*2)*knobRatio;
    _knob = [[BCRangeSliderKnob alloc] initWithFrame:CGRectMake(0, 0, knobWidth, self.frame.size.height)];
    [self addSubview:_knob];
    
    // Create a Pan Gesture
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [_knob addGestureRecognizer:panGR];
    
    // Knob Overlay
    float knobViewWidth = self.frame.size.height*2.5;
    _knobOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, knobViewWidth, self.frame.size.height)];
    _knobOverlay.center = _knob.center;
    _knobOverlay.backgroundColor = [UIColor clearColor];
    [self addSubview:_knobOverlay];
    
    [self updateKnobPositionAt:0.0];
    
    // Create a Pan Gesture
    UIPanGestureRecognizer *panGRKnobView = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [_knobOverlay addGestureRecognizer:panGRKnobView];
    
    return self;
}

- (void) handlePan:(UIPanGestureRecognizer*) gr {
    
    CGPoint translation = [gr translationInView:_knob];
    [_knob setCenter:CGPointMake(_knob.center.x+translation.x, _knob.center.y)];
    [gr setTranslation:CGPointZero inView:_knob];
    
    // Left Limit
    if (_knob.center.x < padding + _knob.frame.size.width/2) {
        [_knob setCenter:CGPointMake(padding + _knob.frame.size.width/2, _knob.center.y)];
    }
    
    // Right Limit
    if (_knob.center.x > self.frame.size.width - _knob.frame.size.width/2-padding) {
        [_knob setCenter:CGPointMake(self.frame.size.width - _knob.frame.size.width/2-padding, _knob.center.y)];
    }
    
    // Set Overlay Center
    _knobOverlay.center = _knob.center;
    
    // Calculate Knob Offset
    float scrollerWidth = self.frame.size.width-padding*2-_knob.frame.size.width;
    float knobPos = _knob.center.x-_knob.bounds.size.width/2-padding;
    _knobOffset = knobPos / scrollerWidth;
    
    if (gr.state == UIGestureRecognizerStateBegan) {
        if (_delegate != nil) {
            [_delegate bcScrollBarMoveBegan];
        }
    }
    
    // Call Delegate
    if (_delegate != nil) {
        [_delegate bcScrollBarMovingAt:_knobOffset];
    }
    
    if (gr.state == UIGestureRecognizerStateEnded || gr.state == UIGestureRecognizerStateCancelled) {
        if (_delegate != nil) {
            [_delegate bcScrollBarMoveEndedAt:_knobOffset];
        }
    }
}

- (void) updateKnobPositionAt:(float)position {
    float scrollerWidth = self.frame.size.width-padding*2-_knob.frame.size.width;
    float knobPos = scrollerWidth*position;
    [_knob setCenter:CGPointMake(_knob.frame.size.width/2+knobPos+padding, _knob.center.y)];
}


- (void)drawRect:(CGRect)rect {
    
    // Draw Bar
    float height = rect.size.height/12;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(padding, (rect.size.height-height)/2, rect.size.width-padding*2, height) cornerRadius:height/2];
    [[UIColor colorWithDisplayP3Red:0.42 green:0.44 blue:0.46 alpha:1.0] setFill];
    [path fill];
}

@end
