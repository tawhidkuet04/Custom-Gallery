//
//  BCScrollBar.h
//  BCRangeSlider
//
//  Created by Brain Craft Ltd. on 11/29/18.
//  Copyright © 2018 Brain Craft Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCRangeSliderKnob.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BCRangeSliderScrollBarDelegate <NSObject>
-(void) bcScrollBarMoveBegan;
-(void) bcScrollBarMovingAt:(float)position;
-(void) bcScrollBarMoveEndedAt:(float)position;
@end

@interface BCRangeSliderScrollBar : UIView

@property (nonatomic, strong) id <BCRangeSliderScrollBarDelegate> delegate;

@property (nonatomic) float knobOffset;

@property (nonatomic, strong) BCRangeSliderKnob *knob;
@property (nonatomic, strong) UIView *knobOverlay;

- (id) initWithFrame:(CGRect)frame andKnobIsToBarRatio:(float) knobRatio;
- (void) updateKnobPositionAt:(float)position;

@end

NS_ASSUME_NONNULL_END
