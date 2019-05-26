//
//  canvasView.h
//  CustomCamera
//
//  Created by Tawhid Joarder on 5/23/19.
//  Copyright © 2019 Tawhid Joarder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerBC.h"
#import "thumbnailScrollView.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface canvasView : UIView{
    double videoTotalTime;
    double timeNeededForExtraOutsideFrameGenerate , xPosForExtraTime ;
    NSMutableArray *captureAllSecondsArray;
    double startBoundYpos ,endBoundYpos;
    int selectOption ; // 0 --> trim , 1 --> cut , 2 --> split
    AVPlayer *player ;

    
}
- (void)initView:(AVAsset *)asset andButton:(UIButton *)playPause player:(AVPlayer *) playerMain;
@property (strong, nonatomic) NSTimer *timer;
@property (strong , nonatomic ) thumbnailScrollView *scrollView;


@property (weak, nonatomic) IBOutlet UIView *frameGenerateView;

@property (strong, nonatomic) IBOutlet UIView *outsideOfFrameGenerateView;
@property (strong, nonatomic) IBOutlet UILabel *totalTimeShowLable;
@property (strong, nonatomic) IBOutlet UILabel *toast;
@property (strong, nonatomic) IBOutlet UILabel *toastStartBound;
@property (strong, nonatomic) IBOutlet UILabel *toastEndBound;


@property (strong, nonatomic) IBOutlet UIImageView *seekBar;
@property (strong, nonatomic) IBOutlet UIView *cutView;
@property (strong, nonatomic) IBOutlet UIView *splitViewStart;
@property (strong, nonatomic) IBOutlet UIView *splitViewEnd;
@property (strong, nonatomic) IBOutlet UIImageView *splitBar;


- (NSString *)timeFormatted:(int)totalSeconds;
- (void)updateSlider;
-(void)trimVideo;
-(void)cropVideo;
-(void)splitVideo;
@end

NS_ASSUME_NONNULL_END
