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
    AVPlayerItem *playerItem ;
    AVAsset *audioAsset;
    AVAsset *asset;
    id observer;
    IBOutlet UIView *playerViewBound;
    IBOutlet UISlider *sliderScroll;
    
   // IBOutlet UIView *framGenerateView;
    ////// range bar start and end
    UIImageView *startBound;
    UIImageView *endBound;
    
    ///////
    UIImage *timeShow;
}

@end

@implementation PlayerDisplayVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    ///// navigatiob slide off
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    //NSLog(@"slide %f",sliderScroll.maximumValue);
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

//            double x = self->_scrollViewFake.frame.origin.x , y = _scrollViewFake.frame.origin.y , height = _scrollViewFake.frame.size.height
//            ,width = self->_scrollViewFake.frame.size.width;
//            NSLog(@"checking %f %f %f %f",x,y,width,height);
            NSLog(@"FF %f %f %f %f",_frameGenerateView.frame.origin.x,_frameGenerateView.frame.origin.y,_frameGenerateView.frame.size.width,_frameGenerateView.frame.size.height);
            self->_scrollView = [[thumbnailScrollView alloc] initWithFrame:CGRectMake(0,0,_frameGenerateView.frame.size.width, _frameGenerateView.frame.size
                                                                                      .height) withDelegate:self andAsset:self->asset  frameView:_frameGenerateView];
            [self->_frameGenerateView addSubview:self->_scrollView];
            // temporary view
            //NSLog(@"tot %f content %f",self->videoTotalTime,videoTotalTime*3*100);
            
//            UIView *tempView = [[UIView alloc]initWithFrame:(CGRect)CGRectMake(0, SCREEN_HEIGHT-200, 0.5, 0.5)];
//            tempView.backgroundColor = [UIColor clearColor];
//            [self.view addSubview:tempView];
            // seekbar initialiaztion
            //(void)(self->posX = 0) ,self->currentTime = 0 ;
            self->seekBar = [[UIView alloc] initWithFrame:CGRectMake(30,-2,6, self->_frameGenerateView.frame.size
                                                                     .height+4)];
            self->seekBar.backgroundColor = [UIColor whiteColor];
            seekBar.layer.cornerRadius = 3;
            //seekBar.layer.masksToBounds = true;
            seekBar.layer.shadowColor = [UIColor blackColor].CGColor;
            seekBar.layer.shadowOpacity = 100;
            seekBar.layer.shadowRadius = 6;// blur effect
            //seekBar.layer.shadowPath = shadowPath.CGPath;
            
            _frameGenerateView.layer.cornerRadius = 4 ;
            _frameGenerateView.layer.masksToBounds = true ;
           
            //[tempView addSubview:slider];//
           [self.outsideOfFrameGenerateView addSubview:self->seekBar];

            ///// bound view drawing
            self->startBound = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,20, self->_frameGenerateView.frame.size
                                                                             .height)] ;
            self->startBound.image = [UIImage imageNamed:@"Group 640.png"];
            //self->startBound.backgroundColor = [ UIColor blueColor ];
            self->endBound = [[UIImageView alloc] initWithFrame:CGRectMake(50,0,20, self->_frameGenerateView.frame.size
                                                                           .height)];
            self->endBound.image = [UIImage imageNamed:@"Group 639.png"];
            [self->_outsideOfFrameGenerateView addSubview:self->startBound];
            [self->_outsideOfFrameGenerateView addSubview:self->endBound];
            self->sliderScroll.maximumValue = self->_scrollView.contentSize.width;
            NSLog(@"slide %f",self->sliderScroll.maximumValue);
            UIPanGestureRecognizer *startPanGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleStartPan:)];
            [self->startBound addGestureRecognizer:startPanGR];
            self->startBound.userInteractionEnabled = YES;
             UIView *tempView = [[UIView alloc]initWithFrame:(CGRect)CGRectMake(0, SCREEN_HEIGHT-200, 0.5, 0.5)];
            [self.view addSubview:tempView];
            UIPanGestureRecognizer *endPanGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleEndPan:)];
            [self->endBound addGestureRecognizer:endPanGR];
            self->endBound.userInteractionEnabled = YES ;
            
            
            UIPanGestureRecognizer *seekBarTouch = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSeekBarPan:)];
            [self->seekBar addGestureRecognizer:seekBarTouch];
            self->seekBar.userInteractionEnabled = YES;
            /////// play time show view initialization
              [_toast setCenter:CGPointMake( seekBar.frame.origin.x+15 ,_toast.center.y)];
            
           // [seekBar setCenter:CGPointMake(25,seekBar.center.y)];
            //[seekBar removeFromSuperview];
            self->playerItem = [AVPlayerItem playerItemWithAsset:self->asset];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:self->playerItem];
            self->player = [AVPlayer playerWithPlayerItem:self->playerItem];
            [self->player seekToTime:CMTimeMakeWithSeconds((videoTotalTime/(_scrollView.contentSize.width))*(20+_scrollView.contentOffset.x), NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
            //  player.frame = self.playerView.bounds;
            // __weak NSObject *weakSelf = self;
            
            
            // _playerView.player = player;
            [self.playerView setOk:self->playerViewBound.bounds];
            [self.playerView setNeedsDisplay];
            [self.playerView setPlayer:self->player];
            NSDateComponentsFormatter *dateComponentsFormatter = [[NSDateComponentsFormatter alloc] init];
            dateComponentsFormatter.zeroFormattingBehavior = NSDateComponentsFormatterZeroFormattingBehaviorPad;
            dateComponentsFormatter.allowedUnits = (NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond);
            NSString *timeString = @" TOTAL" ;
            _totalTimeShowLable.text = [NSString stringWithFormat:@"%@  %@",timeString, [dateComponentsFormatter stringFromTimeInterval:videoTotalTime] ];
            
        });
        // dispatch_semaphore_signal(semaphore);
    }];
    
    
}
-(void)handleScrollPan:(UIPanGestureRecognizer *)recognizer{
    
      NSLog(@"asdasdasdasd");
    //   [seekBar setCenter:CGPointMake(-1000,seekBar.center.y)];
  
}

-(void)handleSeekBarPan:(UIPanGestureRecognizer *)recognizer{
    
    //  NSLog(@"asdasdasdasd");
    //   [seekBar setCenter:CGPointMake(-1000,seekBar.center.y)];
    
    if(recognizer.state == UIGestureRecognizerStateBegan)
    {
         [self PlayerSetPlayPause:playPause withPlayingStatus:1];
        _toast.text = @"";
       // [seekBar setCenter:CGPointMake(-100,seekBar.center.y)];
        [_toast setCenter:CGPointMake(-100 ,_toast.center.y)];
        
        //All fingers are lifted.
    }
    UIView *pannedView = recognizer.view ;
    CGPoint translation = [recognizer translationInView:pannedView.superview];
    CGPoint point;
    // NSLog(@"pan %f",pannedView.center.x + translation.x);
    if(pannedView.center.x + translation.x > SCREEN_WIDTH-10){
        point = CGPointMake(SCREEN_WIDTH-10, pannedView.center.y);
    }else if(pannedView.center.x + translation.x < 10 ){
        point = CGPointMake(10, pannedView.center.y);
    }else {
        point = CGPointMake(pannedView.center.x + translation.x , pannedView.center.y);
    }
   
    pannedView.center = point;
    NSLog(@"start touch %f seekbar %f ",point.x-10,seekBar.center.x-5);
    [recognizer setTranslation:CGPointZero inView:pannedView.superview];
  //  [seekBar setCenter:CGPointMake(-1000,seekBar.center.y)];
    if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        
        _toast.text = @"";
       
        [_toast setCenter:CGPointMake( seekBar.frame.origin.x+15 ,_toast.center.y)];
        
        //All fingers are lifted.
    }
    [player seekToTime:CMTimeMakeWithSeconds((videoTotalTime/(_scrollView.contentSize.width))*(point.x+_scrollView.contentOffset.x), NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    
}



-(void)handleStartPan:(UIPanGestureRecognizer *)recognizer{
    
  //  NSLog(@"asdasdasdasd");
 //   [seekBar setCenter:CGPointMake(-1000,seekBar.center.y)];
    
    if(recognizer.state == UIGestureRecognizerStateBegan)
    {
        
        _toast.text = @"";
        [seekBar setCenter:CGPointMake(-100,seekBar.center.y)];
        [_toast setCenter:CGPointMake(-100 ,_toast.center.y)];
        
        //All fingers are lifted.
    }
    UIView *pannedView = recognizer.view ;
    CGPoint translation = [recognizer translationInView:pannedView.superview];
    CGPoint point;
   // NSLog(@"pan %f",pannedView.center.x + translation.x);
    if(pannedView.center.x + translation.x > SCREEN_WIDTH-10){
        point = CGPointMake(SCREEN_WIDTH-10, pannedView.center.y);
    }else if(pannedView.center.x + translation.x < 10 ){
        point = CGPointMake(10, pannedView.center.y);
    }else {
        point = CGPointMake(pannedView.center.x + translation.x , pannedView.center.y);
    }
    CGRect endBoundVal = endBound.frame;
    if (point.x > endBoundVal.origin.x-10){
        point.x = endBoundVal.origin.x-10;
    }
    pannedView.center = point;
    NSLog(@"start touch %f seekbar %f ",point.x-10,seekBar.center.x-5);
    [recognizer setTranslation:CGPointZero inView:pannedView.superview];
      [seekBar setCenter:CGPointMake(-1000,seekBar.center.y)];
    if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        
         _toast.text = @"";
          [seekBar setCenter:CGPointMake(point.x+13,seekBar.center.y)];
          [_toast setCenter:CGPointMake( seekBar.frame.origin.x+15 ,_toast.center.y)];
       
        //All fingers are lifted.
    }
    [player seekToTime:CMTimeMakeWithSeconds((videoTotalTime/(_scrollView.contentSize.width))*(point.x+10+_scrollView.contentOffset.x), NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
  
}

-(void)handleEndPan:(UIPanGestureRecognizer *)recognizer{
    
    //  NSLog(@"asdasdasdasd");
    if(recognizer.state == UIGestureRecognizerStateBegan)
    {
        
        _toast.text = @"";
        [seekBar setCenter:CGPointMake(-100,seekBar.center.y)];
        [_toast setCenter:CGPointMake(-100 ,_toast.center.y)];
        
        //All fingers are lifted.
    }
    UIView *pannedView = recognizer.view ;
    CGPoint translation = [recognizer translationInView:pannedView.superview];
    CGPoint point;
   // NSLog(@"pan %f",pannedView.center.x + translation.x);
    if(pannedView.center.x + translation.x > SCREEN_WIDTH-10){
        point = CGPointMake(SCREEN_WIDTH-10, pannedView.center.y);
    }else if(pannedView.center.x + translation.x < 10 ){
        point = CGPointMake(10, pannedView.center.y);
    }else {
        point = CGPointMake(pannedView.center.x + translation.x , pannedView.center.y);
    }
    CGRect starBoundVal = startBound.frame;
    if (point.x < starBoundVal.origin.x+30){
        point.x = starBoundVal.origin.x+30;
    }
  
   // NSLog(@"start point %f end oint %f",starBoundVal.origin.x,point.x);
    pannedView.center = point;
    [recognizer setTranslation:CGPointZero inView:pannedView.superview];
    [seekBar setCenter:CGPointMake(-1000,seekBar.center.y)];
  
    [player seekToTime:CMTimeMakeWithSeconds((videoTotalTime/(_scrollView.contentSize.width))*(starBoundVal.origin.x+20+_scrollView.contentOffset.x), NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    if(recognizer.state == UIGestureRecognizerStateEnded)
    {
         _toast.text = @"";
        [seekBar setCenter:CGPointMake(starBoundVal.origin.x+23,seekBar.center.y)];
        [_toast setCenter:CGPointMake(starBoundVal.origin.x+15 ,_toast.center.y)];
      
    }
  
}
- (void)viewWillAppear:(BOOL)animated{
    ///[[self navigationController] setNavigationBarHidden:YES animated:YES];
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
     //   [btn setTitle:@"Play" forState:UIControlStateNormal];
        if (observer) {
            [player removeTimeObserver:observer];
            observer = nil;
        }
        
        // [self.timer invalidate];
    }else{
        
      //  [btn setTitle:@"Pause" forState:UIControlStateNormal];
        
        observer = [player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1/ 60.0, NSEC_PER_SEC)
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
  //  [playPause setTitle:@"Play" forState:UIControlStateNormal];
}

- (void)updateSlider {
    
    double time = CMTimeGetSeconds([player currentTime]);
    NSDateComponentsFormatter *dateComponentsFormatter = [[NSDateComponentsFormatter alloc] init];
    dateComponentsFormatter.zeroFormattingBehavior = NSDateComponentsFormatterZeroFormattingBehaviorPad;
    dateComponentsFormatter.allowedUnits = (NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond);
    _toast.text =[dateComponentsFormatter stringFromTimeInterval:time];
    
//    CGRect trackRect = [self->slider trackRectForBounds:self->slider.bounds];
//    CGRect thumbRect = [self->slider thumbRectForBounds:self->slider.bounds
//                                              trackRect:trackRect
//                                                  value:self->slider.value];
    //NSLog(@"x--- %f y--- %f",thumbRect.origin.x,thumbRect.origin.y);
    
    double x = ((_scrollView.contentSize.width)/videoTotalTime)* time;
    
    double timeNeededForScreenWidth = (videoTotalTime/_scrollView.contentSize.width)*SCREEN_WIDTH;
    double timeNeededForOffset = (videoTotalTime/_scrollView.contentSize.width)*_scrollView.contentOffset.x;
    double seekbarAtXPosition = (SCREEN_WIDTH/timeNeededForScreenWidth)*(time-timeNeededForOffset);
    //NSLog(@"x--- %f y--- %f",x,thumbRect.origin.y);
   // _scrollView.contentOffset= CGPointMake( x,thumbRect.origin.y + 2);
     //NSLog(@"start %f end %f x %f",st.origin.x-10,x);
     [seekBar setCenter:CGPointMake( seekbarAtXPosition ,seekBar.center.y)];
     [_toast setCenter:CGPointMake( seekbarAtXPosition+15 ,_toast.center.y)];
    
    //  NSLog(@"cur %f",slider.value);
    //     NSLog(@"min %f max %f time %f dur %f",minValue,maxValue,time,duration);
     CGRect endBoundVal = endBound.frame;

    if(x>endBoundVal.origin.x-5+_scrollView.contentOffset.x){
          CGRect starBoundVal = startBound.frame;
          [self PlayerSetPlayPause:playPause withPlayingStatus:1];
         _toast.text = @"";
          [seekBar setCenter:CGPointMake( starBoundVal.origin.x+23  ,seekBar.center.y)];
            [_toast setCenter:CGPointMake( starBoundVal.origin.x+38,_toast.center.y)];
          [player seekToTime:CMTimeMakeWithSeconds((videoTotalTime/(_scrollView.contentSize.width))*(starBoundVal.origin.x+20+_scrollView.contentOffset.x), NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
        
    }

    
    
}
#pragma  mark -back
- (IBAction)backButtonPressed:(id)sender {
    player = nil;
    playerItem = nil;

    // [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
    // [self presentViewController:cameraWindow  animated:YES completion:nil];
}

- (IBAction)updateScrollSlider:(id)sender {
    NSLog(@"scroll value %f",[sliderScroll value]);

    
    CGRect trackRec = [self->sliderScroll trackRectForBounds: CGRectMake(0, 0, _scrollView.contentSize.width-SCREEN_WIDTH, 100) ];
    CGRect thumbRec = [self->sliderScroll thumbRectForBounds:CGRectMake(0, 0,_scrollView.contentSize.width-SCREEN_WIDTH, 100)
                                                   trackRect:trackRec
                                                       value:self->sliderScroll.value];
    _scrollView.contentOffset= CGPointMake( thumbRec.origin.x
                                           ,_scrollView.contentOffset.y);
   
    
}
- (IBAction)scrollSliderEnd:(id)sender {
    CGRect starBoundVal = startBound.frame;
    [seekBar setCenter:CGPointMake( starBoundVal.origin.x+23 ,seekBar.center.y)];
     _toast.text = @"";
    [_toast setCenter:CGPointMake( seekBar.frame.origin.x+15 ,_toast.center.y)];
    [player seekToTime:CMTimeMakeWithSeconds((videoTotalTime/(_scrollView.contentSize.width))*(starBoundVal.origin.x+20+_scrollView.contentOffset.x), NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"touch hoise");
}
- (IBAction)crossButtonPress:(id)sender {
    NSLog(@"cross button pressed");
    [self PlayerSetPlayPause:playPause withPlayingStatus:1];
    [[self navigationController] popViewControllerAnimated:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end


