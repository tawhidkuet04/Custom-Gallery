//
//  BCSliderScrollView.h
//  BCRangeSlider
//
//  Created by Brain Craft Ltd. on 12/2/18.
//  Copyright © 2018 Brain Craft Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BCRangeSliderScrollViewDelegate <NSObject>
-(void) frameGenerationDone;
@end

@interface BCRangeSliderScrollView : UIScrollView

@property (nonatomic, strong) id <BCRangeSliderScrollViewDelegate> sliderDelegate;

// Number of frames to be created
@property (nonatomic) int totalFrames;

// Number of frames to be created
@property (nonatomic) float pixelPerSecond;

// Container Size
@property (nonatomic) CGSize containerSize;

- (id)initWithFrame:(CGRect)frame padding:(float) padding_ andAsset:(AVAsset *)asset assetTrack:( AVAssetTrack *)clipVideoTrack;

@end

NS_ASSUME_NONNULL_END
