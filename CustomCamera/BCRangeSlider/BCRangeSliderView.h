//
//  BCRangeSliderView.h
//  BCRangeSlider
//
//  Created by Brain Craft Ltd. on 11/15/18.
//  Copyright © 2018 Brain Craft Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "BCRangeSliderSelectorView.h"
#import "BCRangeSliderScrollView.h"
#import "BCRangeSliderScrollBar.h"
#import "BCRangeSliderToast.h"
#import "BCRangeSliderSeekBar.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BCRangeSliderViewDelegate <NSObject>
-(void) bcRangeSliderUpdateBegan;
-(void) bcRangeSliderUpdateEndedAt_StartTime:(float)startTime andEndTime:(float)endTime;
@end

@interface BCRangeSliderView : UIView <UIScrollViewDelegate, BCRangeSliderScrollViewDelegate, BCRangeSliderScrollBarDelegate>

// Delegate
@property (nonatomic, strong) id <BCRangeSliderViewDelegate> delegate;


// Asset
@property (strong, nonatomic) AVAsset *asset;

// Scroll View
@property (nonatomic,strong) BCRangeSliderScrollView *sliderScrollView;

// Scroll Bar
@property (nonatomic,strong) BCRangeSliderScrollBar *scrollBar;

// Seek Bar
@property (nonatomic,strong) BCRangeSliderSeekBar *seekBar;
- (void) appearSeekBar;
- (void) disAppearSeekBar;

// Selector Views
@property (nonatomic, strong) BCRangeSliderSelectorView *startSelectorView;
@property (nonatomic, strong) BCRangeSliderSelectorView *endSelectorView;

// Toasts
@property (nonatomic, strong) BCRangeSliderToast *startSelectorToast;
@property (nonatomic, strong) BCRangeSliderToast *endSelectorToast;

@property (nonatomic,strong) UIView *leftShadow;
@property (nonatomic,strong) UIView *rightShadow;

@property (nonatomic) float startTime;
@property (nonatomic) float endTime;


- (id)initWithFrame:(CGRect)frame andAsset:(AVAsset *)asset assetTrack:( AVAssetTrack *)clipVideoTrack;
- (void) updateSeekBarAt:(float)time;

@end

NS_ASSUME_NONNULL_END
