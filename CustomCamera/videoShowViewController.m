//
//  videoShowViewController.m
//  CustomCamera
//
//  Created by Tawhid Joarder on 4/24/19.
//  Copyright © 2019 Tawhid Joarder. All rights reserved.
//

#import "videoShowViewController.h"
#import <AVFoundation/AVFoundation.h>

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
@interface videoShowViewController ()
@property (nonatomic, strong) PHVideoRequestOptions *requestOptions;
@end

@implementation videoShowViewController
{
    
    AVPlayer *player;
    BOOL isPlaying;
    AVPlayerLayer *playerLayer;
    
    float startTime;
    float endTime;
    
    // Timer
    int fps;
    NSTimer *timer;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.05 green:0.05 blue:0.05 alpha:1];
    
    [self initializations:^(AVAsset *asset) {
        if (asset) {
    
            AVAssetTrack *clipVideoTrack;
            clipVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
            
            self->_rangeSliderView = [[BCRangeSliderView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-164, SCREEN_WIDTH, 100) andAsset:asset   assetTrack:clipVideoTrack];
            [self.view addSubview:self->_rangeSliderView];
            self->_rangeSliderView.delegate = self;
            
            // Add Player Layer to a UIView
            UIView *videoPlayerView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 300)];
            
            // Player
            self->player = [AVPlayer playerWithPlayerItem:[AVPlayerItem playerItemWithAsset:asset]];
            
            // Player Layer
            self->playerLayer = [AVPlayerLayer playerLayerWithPlayer:self->player];
            [self->playerLayer setVideoGravity:kCAGravityResize];
            self->playerLayer.frame = videoPlayerView.bounds;
            
            [self.view addSubview:videoPlayerView];
            [videoPlayerView.layer addSublayer:self->playerLayer];
            
            self->isPlaying = false;
            //    [player play];
            
            // Call Timer
            self->fps = 30;
            self->timer = [[NSTimer alloc] init];
            [self callTimerWith: 1.0/self->fps];
        }
    }];

    
}

- (void)viewDidLayoutSubviews {
    
}

- (void) initializations:(void (^) (AVAsset *asset))asset {
    
    // Video Asset Horse Riding

    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc]init];
    options.version = PHVideoRequestOptionsVersionOriginal;
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    options.networkAccessAllowed = YES;
    __block AVAsset *resultAsset;
    
    [[PHImageManager defaultManager] requestAVAssetForVideo:_asset options:options resultHandler:^(AVAsset * avasset, AVAudioMix * audioMix, NSDictionary * info) {
        resultAsset = avasset;
        dispatch_async(dispatch_get_main_queue(), ^{
            asset(avasset);
        });
       // dispatch_semaphore_signal(semaphore);
    }];
    
    NSLog(@"-----------------");
    
    
}

- (void) createInterfaces {
    
//    AVAssetTrack *clipVideoTrack;
//    clipVideoTrack = [[_asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
//
//    _rangeSliderView = [[BCRangeSliderView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-164, SCREEN_WIDTH, 100) andAsset:_asset   assetTrack:clipVideoTrack];
//    [self.view addSubview:_rangeSliderView];
//    _rangeSliderView.delegate = self;
    
}


-(void) bcRangeSliderUpdateBegan {
    [player pause];
    isPlaying = false;
}

-(void) bcRangeSliderUpdateEndedAt_StartTime:(float)startTime andEndTime:(float)endTime {
    //    NSLog(@"Start Time: %f, End Time: %f", startTime, endTime);
    self->startTime = startTime;
    self->endTime = endTime;
    
    // Update Player Position
    [player pause];
    isPlaying = false;
    [player seekToTime:CMTimeMakeWithSeconds(startTime, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
        if (finished) {
            
            // Update Seek Bar
            //            float currentTime = CMTimeGetSeconds(self->player.currentTime);
            //            [self->_rangeSliderView updateSeekBarAt:currentTime];
            [self->_rangeSliderView appearSeekBar];
            [self->player play];
            self->isPlaying = true;
        }
    }];
    
    
}

-(void) callTimerWith: (NSTimeInterval) timeInterval {
    [timer invalidate];
    
    // Scheduled Timer for Seek Bar
    if (@available(iOS 10.0, *)) {
        timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval repeats:true block:^(NSTimer * _Nonnull timer) {
            
            float currentTime = CMTimeGetSeconds(self->player.currentTime);
            if (currentTime > self->endTime) {
                currentTime = self->startTime;
                
                // Update Player Position
                [self->player pause];
                self->isPlaying = false;
                [self->_rangeSliderView disAppearSeekBar];
                
                [self->player seekToTime:CMTimeMakeWithSeconds(currentTime, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
                    if (finished) {
                        
                        // Update Seek Bar
                        float currentTime = CMTimeGetSeconds(self->player.currentTime);
                        [self->_rangeSliderView updateSeekBarAt:currentTime];
                        [self->_rangeSliderView appearSeekBar];
                        [self->player play];
                        self->isPlaying = true;
                    }
                }];
            }
            
            // Update Seek Bar
            if (self->isPlaying) {
                [self->_rangeSliderView updateSeekBarAt:currentTime];
            }
            
        }];
    } else {
        // Fallback on earlier versions
    }
    
}


@end
