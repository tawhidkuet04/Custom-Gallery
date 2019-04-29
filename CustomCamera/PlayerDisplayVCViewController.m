//
//  PlayerDisplayVCViewController.m
//  CameraProject
//
//  Created by Tawhid Joarder on 4/15/19.
//  Copyright © 2019 BrainCraft LTD. All rights reserved.
//

#import "PlayerDisplayVCViewController.h"
#import "ViewController.h"
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
@interface PlayerDisplayVCViewController ()<playerDisplayVCViewControllerDelegate>{
    AVPlayer *player;
    UIView *seekBar;
    IBOutlet UIButton *playPause;
    IBOutlet UISlider *slider;
    AVPlayerItem *playerItem ;
    AVAsset *audioAsset;
    AVAsset *asset;
    id observer;
    IBOutlet UISlider *sliderScroll;
}

@end

@implementation PlayerDisplayVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // asset = [AVAsset assetWithURL:_videoURL];
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc]init];
    options.version = PHVideoRequestOptionsVersionOriginal;
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    options.networkAccessAllowed = YES;
    __block AVAsset *resultAsset;
    
    [[PHImageManager defaultManager] requestAVAssetForVideo:_passet options:options resultHandler:^(AVAsset * avasset, AVAudioMix * audioMix, NSDictionary * info) {
        resultAsset = avasset;
        dispatch_async(dispatch_get_main_queue(), ^{
            self->asset = avasset;
            
            CMTime duration;
            NSLog(@"%f",CMTimeGetSeconds(self->audioAsset.duration));
            //    if (CMTimeGetSeconds(audioAsset.duration) < CMTimeGetSeconds(asset.duration)) {
            //        duration = audioAsset.duration;
            //    } else
            {
                duration = self->asset.duration;
            }
            self->slider.maximumValue = CMTimeGetSeconds(duration);
            self->slider.hidden =  NO;
            //NSError *error;
            [self->slider setValue:0];
            
            self->_scrollView = [[thumbnailScrollView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-200, SCREEN_WIDTH, 100) withDelegate:self andAsset:self->asset ];
            [self.view addSubview:self->_scrollView];
            // temporary view
            NSLog(@"tot %f content %f",self->videoTotalTime,videoTotalTime*3*100);
            
            UIView *tempView = [[UIView alloc]initWithFrame:(CGRect)CGRectMake(0, SCREEN_HEIGHT-200, 0.5, 0.5)];
            tempView.backgroundColor = [UIColor clearColor];
            [self.view addSubview:tempView];
            // seekbar initialiaztion
            //(void)(self->posX = 0) ,self->currentTime = 0 ;
            self->seekBar = [[UIView alloc] initWithFrame:(CGRect)CGRectMake(0,0 ,10, 100)];
            self->seekBar.backgroundColor = [UIColor greenColor];
            
            //[tempView addSubview:slider];
            [tempView addSubview:self->seekBar];
            //[seekBar removeFromSuperview];
            self->playerItem = [AVPlayerItem playerItemWithAsset:self->asset];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:self->playerItem];
            self->player = [AVPlayer playerWithPlayerItem:self->playerItem];
            
            //  player.frame = self.playerView.bounds;
            // __weak NSObject *weakSelf = self;
            
            
            // _playerView.player = player;
            [self.playerView setOk:[UIScreen mainScreen].bounds];
            [self.playerView setNeedsDisplay];
            [self.playerView setPlayer:self->player];
            
        });
        // dispatch_semaphore_signal(semaphore);
    }];
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    //    playerItem = [AVPlayerItem playerItemWithURL:_videoURL];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
    //    player = [AVPlayer playerWithPlayerItem:playerItem];
    //    slider.maximumValue = CMTimeGetSeconds(playerItem.asset.duration);
    //    slider.hidden =  NO;
    //    [slider setValue:0];
    //    // _playerView.player = player;
    //    [self.playerView setPlayer:player];
}
#pragma  mark -play/pause
- (IBAction)playPauseAction:(id)sender {
    UIButton *btn = (UIButton*)sender;
    [self PlayerSetPlayPause:btn withPlayingStatus:player.rate];
}

- (void) PlayerSetPlayPause : (UIButton*)btn withPlayingStatus:(float)rate{
    if (rate) {
        [player pause];
        [btn setTitle:@"Play" forState:UIControlStateNormal];
        if (observer) {
            [player removeTimeObserver:observer];
            observer = nil;
        }
        
        // [self.timer invalidate];
    }else{
        
        [btn setTitle:@"Pause" forState:UIControlStateNormal];
        
        observer = [player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1/ 10000.0, NSEC_PER_SEC)
                                                        queue:NULL
                                                   usingBlock:^(CMTime time){
                                                       [self updateSlider];
                                                   }];
        [player play];
        //  self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
    }
}

-(void)updateTotalTime:(double)totalTime{
    videoTotalTime = totalTime;
}

- (void)itemDidFinishPlaying:(NSNotification *)notification {
    [player seekToTime:kCMTimeZero];
    player.rate = 0 ;
    [playPause setTitle:@"Play" forState:UIControlStateNormal];
    [slider setValue:0];
}
#pragma mark -slider

- (IBAction)slidingBegin:(UISlider *)sender {
    [self PlayerSetPlayPause:playPause withPlayingStatus:1];
}
- (IBAction)slideValueChange:(UISlider *)sender {
    CGRect trackRect = [self->slider trackRectForBounds:self->slider.bounds];
    CGRect thumbRect = [self->slider thumbRectForBounds:self->slider.bounds
                                              trackRect:trackRect
                                                  value:self->slider.value];
    [seekBar setCenter:CGPointMake( thumbRect.origin.x,seekBar.center.y)];
    [player seekToTime:CMTimeMakeWithSeconds(sender.value, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}
- (IBAction)slidingDone:(UISlider *)sender {
    [self PlayerSetPlayPause:playPause withPlayingStatus:0];
}

- (void)updateSlider {
    
    double time = CMTimeGetSeconds([player currentTime]);
    
    CGRect trackRect = [self->slider trackRectForBounds:self->slider.bounds];
    CGRect thumbRect = [self->slider thumbRectForBounds:self->slider.bounds
                                              trackRect:trackRect
                                                  value:self->slider.value];
    //NSLog(@"x--- %f y--- %f",thumbRect.origin.x,thumbRect.origin.y);
    
    double x = ((_scrollView.contentSize.width-SCREEN_WIDTH)/videoTotalTime)* time;
    NSLog(@"x--- %f y--- %f",x,thumbRect.origin.y);
    _scrollView.contentOffset= CGPointMake( x,thumbRect.origin.y + 2);
    [seekBar setCenter:CGPointMake( thumbRect.origin.x,seekBar.center.y)];
    //  NSLog(@"cur %f",slider.value);
    //     NSLog(@"min %f max %f time %f dur %f",minValue,maxValue,time,duration);
    [slider setValue:time];
    
}
#pragma  mark -back
- (IBAction)backButtonPressed:(id)sender {
    player = nil;
    playerItem = nil;
    [slider setValue:0];
    // [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
    // [self presentViewController:cameraWindow  animated:YES completion:nil];
}

- (IBAction)updateScrollSlider:(id)sender {
    NSLog(@"scroll value %f",[sliderScroll value]);
    CGRect trackRect = [self->slider trackRectForBounds:self->slider.bounds];
    CGRect thumbRect = [self->slider thumbRectForBounds:self->slider.bounds
                                              trackRect:trackRect
                                                  value:self->slider.value];
    
    CGRect trackRec = [self->sliderScroll trackRectForBounds: CGRectMake(0, 0, _scrollView.contentSize.width-SCREEN_WIDTH, 100) ];
    CGRect thumbRec = [self->sliderScroll thumbRectForBounds:CGRectMake(0, 0,_scrollView.contentSize.width-SCREEN_WIDTH, 100)
                                                   trackRect:trackRec
                                                       value:self->sliderScroll.value];
    _scrollView.contentOffset= CGPointMake( thumbRec.origin.x
                                           ,thumbRect.origin.y + 2);
    
}

- (IBAction)scrollSliderEnd:(id)sender {
    CGRect trackRec = [self->sliderScroll trackRectForBounds: CGRectMake(0, 0, _scrollView.contentSize.width-SCREEN_WIDTH, 100) ];
    CGRect thumbRec = [self->sliderScroll thumbRectForBounds:CGRectMake(0, 0, _scrollView.contentSize.width-SCREEN_WIDTH, 100)
                                                   trackRect:trackRec
                                                       value:self->sliderScroll.value];
    [player seekToTime:CMTimeMakeWithSeconds((videoTotalTime/(_scrollView.contentSize.width))*thumbRec.origin.x, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

@end


