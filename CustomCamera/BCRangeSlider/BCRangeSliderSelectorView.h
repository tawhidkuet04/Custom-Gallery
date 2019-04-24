//
//  BCSelectorView.h
//  BCRangeSlider
//
//  Created by Brain Craft Ltd. on 12/2/18.
//  Copyright © 2018 Brain Craft Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    SelectorTypeStart,
    SelectorTypeEnd
} SelectorType;

@interface BCRangeSliderSelectorView : UIView

- (id) initWithFrame:(CGRect)frame SelectorType: (SelectorType) type;

@end

NS_ASSUME_NONNULL_END
