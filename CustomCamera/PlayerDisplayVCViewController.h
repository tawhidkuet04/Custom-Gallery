//
//  PlayerDisplayVCViewController.h
//  CameraProject
//
//  Created by Tawhid Joarder on 4/15/19.
//  Copyright © 2019 BrainCraft LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerBC.h"
#import "thumbnailScrollView.h"
#import <Photos/Photos.h>
NS_ASSUME_NONNULL_BEGIN

@interface PlayerDisplayVCViewController : UIViewController{
    double videoTotalTime;
    bool playOrPause;
    double timeNeededForExtraOutsideFrameGenerate , xPosForExtraTime ;
}
@property (strong, nonatomic) IBOutlet PlayerBC *playerView;
@property (nonatomic, strong) NSURL *videoURL;
@property (strong, nonatomic) NSTimer *timer;
@property (strong , nonatomic ) thumbnailScrollView *scrollView;
@property( strong , nonatomic ) PHAsset *passet;
@property (strong, nonatomic) IBOutlet UIView *frameGenerateView;

@property (strong, nonatomic) IBOutlet UIView *outsideOfFrameGenerateView;
@property (strong, nonatomic) IBOutlet UILabel *totalTimeShowLable;
@property (strong, nonatomic) IBOutlet UILabel *toast;
@property (strong, nonatomic) IBOutlet UILabel *toastStartBound;
@property (strong, nonatomic) IBOutlet UILabel *toastEndBound;


- (void)updateSlider;
@end

NS_ASSUME_NONNULL_END
