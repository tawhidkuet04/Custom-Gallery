//
//  videoShowViewController.h
//  CustomCamera
//
//  Created by Tawhid Joarder on 4/24/19.
//  Copyright © 2019 Tawhid Joarder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCRangeSlider/BCRangeSliderView.h"
#import <Photos/Photos.h>
NS_ASSUME_NONNULL_BEGIN

@interface videoShowViewController : UIViewController<BCRangeSliderViewDelegate>


@property (nonatomic,strong) BCRangeSliderView *rangeSliderView;

@property(nonatomic, strong) PHAsset *asset;

@end

NS_ASSUME_NONNULL_END
