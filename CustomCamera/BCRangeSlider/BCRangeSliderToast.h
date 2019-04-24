//
//  BCToast.h
//  BCSpeedController-ObjectiveC
//
//  Created by Rashed Nizam on 11/9/18.
//  Copyright © 2018 BrainCraft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCRangeSliderToast : UIView

//- (id) initWithFrame:(CGRect)frame;

@property (nonatomic) UILabel *textLabel;

- (void) setMessage:(NSString*) string;

@end
