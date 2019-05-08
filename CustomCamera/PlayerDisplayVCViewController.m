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

 
   // UIView *seekBar;
    IBOutlet UIButton *playPause;
    AVPlayerItem *playerItem ;
    AVAsset *audioAsset;
    AVAsset *asset;
    id observer;
    IBOutlet UIView *playerViewBound;
    IBOutlet UISlider *sliderScroll;
    
   // IBOutlet UIView *framGenerateView;
    ////// range bar start and end
  
    IBOutlet UIImageView *endBound;
    
    IBOutlet UIImageView *startBound;
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
            NSLog(@"FF %f %f %f %f",self->_frameGenerateView.frame.origin.x,_frameGenerateView.frame.origin.y,_frameGenerateView.frame.size.width,_frameGenerateView.frame.size.height);
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
//            self->seekBar = [[UIView alloc] initWithFrame:CGRectMake(60,-2,6*([UIScreen mainScreen].bounds.size.width/414), self->_frameGenerateView.frame.size
//                                                                     .height+4)];
//            self->seekBar.backgroundColor = [UIColor whiteColor];
//            self->seekBar.layer.cornerRadius = 3;
//            //seekBar.layer.masksToBounds = true;
//            self->seekBar.layer.shadowColor = [UIColor blackColor].CGColor;
//            self->seekBar.layer.shadowOpacity = 100;
//            self->seekBar.layer.shadowRadius = 6;// blur effect
            //seekBar.layer.shadowPath = shadowPath.CGPath;
            
            self->_frameGenerateView.layer.cornerRadius = 4 ;
            self->_frameGenerateView.layer.masksToBounds = true ;
           
            //[tempView addSubview:slider];//
        //   [self.outsideOfFrameGenerateView addSubview:self->seekBar];

            ///// bound view drawing

            //self->startBound.backgroundColor = [ UIColor blueColor ];

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
            [self->_seekBar addGestureRecognizer:seekBarTouch];
            self->_seekBar.userInteractionEnabled = YES;
            /////// play time show view initialization
            //[self->_toast setCenter:CGPointMake( self->seekBar.frame.origin.x+15 ,self->_toast.center.y)];
            
           // [seekBar setCenter:CGPointMake(25,seekBar.center.y)];
            //[seekBar removeFromSuperview];
            self->playerItem = [AVPlayerItem playerItemWithAsset:self->asset];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:self->playerItem];
            self->player = [AVPlayer playerWithPlayerItem:self->playerItem];
            [self->player seekToTime:CMTimeMakeWithSeconds((self->videoTotalTime/(self->_scrollView.contentSize.width)), NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
            //  player.frame = self.playerView.bounds;
            // __weak NSObject *weakSelf = self;
            
       //     [_toastStartBound setCenter:CGPointMake(-100,seekBar.center.y)];
            // _playerView.player = player;
            [self.playerView setOk:self->playerViewBound.bounds];
            [self.playerView setNeedsDisplay];
            [self.playerView setPlayer:self->player];
//            NSDateComponentsFormatter *dateComponentsFormatter = [[NSDateComponentsFormatter alloc] init];
//            dateComponentsFormatter.zeroFormattingBehavior = NSDateComponentsFormatterZeroFormattingBehaviorPad;
//            dateComponentsFormatter.allowedUnits = (NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond);
//            NSString *timeString = @" TOTAL" ;
//            self->_totalTimeShowLable.text = [NSString stringWithFormat:@"%@  %@",timeString, [dateComponentsFormatter stringFromTimeInterval:self->videoTotalTime] ];
            NSString *timeString = @" TOTAL" ;
            self->_totalTimeShowLable.text = [NSString stringWithFormat:@"%@  %@",timeString, [self timeFormatted:(int)videoTotalTime] ];
            timeNeededForExtraOutsideFrameGenerate = ((videoTotalTime/SCREEN_WIDTH)*(SCREEN_WIDTH-_frameGenerateView.frame.size.width))/2;
            xPosForExtraTime = (_frameGenerateView.frame.size.width/videoTotalTime)*timeNeededForExtraOutsideFrameGenerate;
            [_toastStartBound setCenter:CGPointMake(-1000,_toast.center.y)];
            [_toastEndBound setCenter:CGPointMake(-1000,_toast.center.y)];
           
            /////// split view initialization
            selectOption = 0;
            _cutView.layer.zPosition = 0 ;
            _splitViewStart.layer.zPosition = 1;
            _splitViewStart.layer.opacity = 0.92;
            _splitViewStart.frame =  CGRectMake(_frameGenerateView.frame.origin.x-startBound.frame.size.width,_cutView.frame.origin.y, startBound.frame.origin.x, _frameGenerateView.frame.size.height);
            _splitViewEnd.layer.zPosition = 1 ;
            _splitViewEnd.layer.opacity = 0.92 ;
            _splitViewEnd.frame =  CGRectMake( endBound.frame.origin.x,_cutView.frame.origin.y, _frameGenerateView.frame.size.width - endBound.frame.origin.x
                                              , _frameGenerateView.frame.size.height);
            startBound.image = [UIImage imageNamed:@"Group 639"];
            endBound.image = [UIImage imageNamed:@"Group 640"];
            _splitBar.layer.zPosition=-10;
            
        });
        // dispatch_semaphore_signal(semaphore);
    }];
    
    
}
- (IBAction)chooseTrimCutSplit:(id)sender {
    
     UISegmentedControl *s = (UISegmentedControl *) sender ;
    if(s.selectedSegmentIndex == 0 ){
        //  NSLog(@"trim");;
        [_splitBar setCenter:CGPointMake(-1000, 0)];
        [startBound setCenter:CGPointMake(3*startBound.frame.size.width, startBound.center.y)];
        [endBound setCenter:CGPointMake(_frameGenerateView.frame.size.width-3*endBound.frame.size.width, endBound.center.y)];
        startBound.image = [UIImage imageNamed:@"Group 639"];
        endBound.image = [UIImage imageNamed:@"Group 640"];
         selectOption = 0;
          _splitBar.layer.zPosition = 0 ;
        _cutView.layer.zPosition = 0 ;
         _splitViewStart.layer.zPosition = 1;
        _splitViewStart.layer.opacity = 0.92;
        _splitViewStart.frame =  CGRectMake(_frameGenerateView.frame.origin.x-startBound.frame.size.width,_cutView.frame.origin.y, startBound.frame.origin.x, _frameGenerateView.frame.size.height);
        _splitViewEnd.layer.zPosition = 1 ;
        _splitViewEnd.layer.opacity = 0.92 ;
        _splitViewEnd.frame =  CGRectMake( endBound.frame.origin.x,_cutView.frame.origin.y, _frameGenerateView.frame.size.width - endBound.frame.origin.x
                                          , _frameGenerateView.frame.size.height);

        
    }else if(s.selectedSegmentIndex == 1 ){
     //  NSLog(@"cut");
        [_splitBar setCenter:CGPointMake(-1000, 0)];
        [startBound setCenter:CGPointMake(3*startBound.frame.size.width, startBound.center.y)];
        [endBound setCenter:CGPointMake(_frameGenerateView.frame.size.width-3*endBound.frame.size.width, endBound.center.y)];
        endBound.image = [UIImage imageNamed:@"Group 639"];
        startBound.image = [UIImage imageNamed:@"Group 640"];
        selectOption = 1 ;
        _splitBar.layer.zPosition = 0 ;
         _splitViewStart.layer.zPosition = 0 ;
        _splitViewEnd.layer.zPosition = 0 ;
        _cutView.layer.zPosition = 1;
        _cutView.layer.opacity = 0.92;
        _cutView.frame =  CGRectMake(startBound.frame.origin.x,_cutView.frame.origin.y, endBound.frame.origin.x-(startBound.frame.origin.x), _frameGenerateView.frame.size.height);
       
    }else {
        selectOption = 2 ;
        [_splitBar setCenter:CGPointMake(_frameGenerateView.center.x, startBound.center.y)];
        [startBound setCenter:CGPointMake(-1000, startBound.center.y)];
        [endBound setCenter:CGPointMake(-1000, endBound.center.y)];
        _splitViewStart.layer.zPosition = 0 ;
        _splitViewEnd.layer.zPosition = 0 ;
        _cutView.layer.zPosition = 0 ;
        _splitBar.layer.zPosition =  1;
        NSLog(@"Split");
    }
}


-(void)handleScrollPan:(UIPanGestureRecognizer *)recognizer{
    
   //   NSLog(@"asdasdasdasd");
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
        // [_toast setCenter:CGPointMake(-100 ,_toast.center.y)];
        
        //All fingers are lifted.
    }
    UIView *pannedView = recognizer.view ;
    CGPoint translation = [recognizer translationInView:pannedView.superview];
    CGPoint point;
    // NSLog(@"pan %f",pannedView.center.x + translation.x);
    double extraSpace =(SCREEN_WIDTH-_frameGenerateView.frame.size.width)/2;
    if(pannedView.center.x + translation.x > SCREEN_WIDTH-extraSpace){
        point = CGPointMake(SCREEN_WIDTH-extraSpace, pannedView.center.y);
    }else if(pannedView.center.x + translation.x < (_seekBar.frame.size.width/2) ){
        point = CGPointMake((_seekBar.frame.size.width/2), pannedView.center.y);
    }else {
        point = CGPointMake(pannedView.center.x + translation.x , pannedView.center.y);
    }

    if(point.x < extraSpace ){
        point.x=  extraSpace;
    }
    pannedView.center = point;
 //   NSLog(@"start touch %f seekbar %f ",point.x-10,_seekBar.center.x-5);
    [recognizer setTranslation:CGPointZero inView:pannedView.superview];
    
  //  [seekBar setCenter:CGPointMake(-1000,seekBar.center.y)];
   
    if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        
       // _toast.text = @"";
        
       
       // [_toast setCenter:CGPointMake( seekBar.frame.origin.x ,_toast.center.y)];
        
        //All fingers are lifted.
    }
    [player seekToTime:CMTimeMakeWithSeconds((videoTotalTime/(_frameGenerateView.frame.size.width))*(point.x-xPosForExtraTime), NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    
}



-(void)handleStartPan:(UIPanGestureRecognizer *)recognizer{
    
  //  NSLog(@"asdasdasdasd");
 //   [seekBar setCenter:CGPointMake(-1000,seekBar.center.y)];
    
    if(recognizer.state == UIGestureRecognizerStateBegan)
    {
        if(player.rate){
            [self PlayerSetPlayPause:playPause withPlayingStatus:1];
        }
        
        // NSLog(@"start");
    //    _toast.text = @"";
         [_toastStartBound setCenter:CGPointMake(startBound.frame.origin.x+startBound.frame.size.width/2,_toast.center.y)];
         [_toastEndBound setCenter:CGPointMake(endBound.frame.origin.x+endBound.frame.size.width/2,_toast.center.y)];
       // [seekBar setCenter:CGPointMake(-100,seekBar.center.y)];
      //  [_toast setCenter:CGPointMake(-100 ,_toast.center.y)];
        
        //All fingers are lifted.
    }
    
    if(_toastStartBound.frame.origin.x + _toastEndBound.frame.size.width > _toastEndBound.frame.origin.x){
       // [[UIApplication sharedApplication].keyWindow bringSubviewToFront:_toastStartBound];
        //[self.view bringSubviewToFront:_toastStartBound];
        _toastEndBound.layer.zPosition = 0;
        _toastStartBound.layer.zPosition = 1;
        NSLog(@"start oevrplap end");
    }
    
    UIView *pannedView = recognizer.view ;
    CGPoint translation = [recognizer translationInView:pannedView.superview];
    CGPoint point;
   // NSLog(@"pan %f",pannedView.center.x + translation.x);
    if(pannedView.center.x + translation.x > SCREEN_WIDTH-(endBound.frame.size.width/2)){
        point = CGPointMake(SCREEN_WIDTH-(endBound.frame.size.width/2), pannedView.center.y);
    }else if(pannedView.center.x + translation.x < (endBound.frame.size.width/2) ){
        point = CGPointMake((endBound.frame.size.width/2), pannedView.center.y);
    }else {
        point = CGPointMake(pannedView.center.x + translation.x , pannedView.center.y);
       
    }
    CGRect endBoundVal = endBound.frame;
    if (point.x > endBoundVal.origin.x-(_seekBar.frame.size.width/2)){
        point.x = endBoundVal.origin.x-(_seekBar.frame.size.width/2);
    }
    if(point.x < startBound.frame.size.width/2){
        point.x=  startBound.frame.size.width/2;
    }
    pannedView.center = point;
   // NSLog(@"start touch %f seekbar %f ",point.x-10,_seekBar.center.x-5);
    [recognizer setTranslation:CGPointZero inView:pannedView.superview];
//    NSDateComponentsFormatter *dateComponentsFormatter = [[NSDateComponentsFormatter alloc] init];
//    dateComponentsFormatter.zeroFormattingBehavior = NSDateComponentsFormatterZeroFormattingBehaviorPad;
//    dateComponentsFormatter.allowedUnits = (NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond);
//    _toastStartBound.text =[dateComponentsFormatter stringFromTimeInterval:(videoTotalTime/(_frameGenerateView.frame.size.width))*(point.x-xPosForExtraTime+startBound.frame.size.width/2.5)];
   
    [_toastStartBound setCenter:CGPointMake(startBound.frame.origin.x+startBound.frame.size.width/2,_toast.center.y)];
    
//
//    dateComponentsFormatter = [[NSDateComponentsFormatter alloc] init];
//    dateComponentsFormatter.zeroFormattingBehavior = NSDateComponentsFormatterZeroFormattingBehaviorPad;
//    dateComponentsFormatter.allowedUnits = (NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond);
//    _toastEndBound.text =[dateComponentsFormatter stringFromTimeInterval:(videoTotalTime/(_frameGenerateView.frame.size.width))*(endBound.frame.origin.x+_seekBar.frame.size.width/2.5-xPosForExtraTime)];
    
    double endValue = endBound.frame.origin.x+endBound.frame.size.width/2 ;
    if ( endValue > SCREEN_WIDTH - _toastEndBound.frame.size.width/2){
        endValue = SCREEN_WIDTH - _toastEndBound.frame.size.width/2;
    }
    [_toastEndBound setCenter:CGPointMake(endValue,_toast.center.y)];
    
    int startTime = (videoTotalTime/(_frameGenerateView.frame.size.width))*(point.x-xPosForExtraTime+startBound.frame.size.width/2.5) ;
    int endTime = (videoTotalTime/(_frameGenerateView.frame.size.width))*(endBound.frame.origin.x+_seekBar.frame.size.width/2.5-xPosForExtraTime);
    NSString *timeString = @" TOTAL" ;
    self->_totalTimeShowLable.text = [NSString stringWithFormat:@"%@  %@",timeString, [self timeFormatted:(int)(endTime-startTime)] ];
    _toastStartBound.text = [self timeFormatted:startTime];
    _toastEndBound.text = [self timeFormatted:endTime];
    if(selectOption == 0 ){
       _splitViewStart.frame =  CGRectMake(_frameGenerateView.frame.origin.x-startBound.frame.size.width,_cutView.frame.origin.y, startBound.frame.origin.x, _frameGenerateView.frame.size.height);
    }else if ( selectOption == 1 ){
        _cutView.frame =  CGRectMake(startBound.frame.origin.x,_cutView.frame.origin.y, endBound.frame.origin.x-(startBound.frame.origin.x), _frameGenerateView.frame.size.height);
    }else {
        
        
    }
    
    
    if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        
        if(!player.rate){
            [self PlayerSetPlayPause:playPause withPlayingStatus:0];
        }
        
     
        //  _toast.text = @"";
          [_toastEndBound setCenter:CGPointMake(-1000,_toast.center.y)];
          [_toastStartBound setCenter:CGPointMake(-1000,_toast.center.y)];
      //    [seekBar setCenter:CGPointMake(point.x+ startBound.frame.size.width/2+ seekBar.frame.size.width/2,seekBar.center.y)];
     //     [_toast setCenter:CGPointMake( point.x+ startBound.frame.size.width/2+ seekBar.frame.size.width/2 ,_toast.center.y)];
       
        //All fingers are lifted.
    }
    [player seekToTime:CMTimeMakeWithSeconds((videoTotalTime/(_frameGenerateView.frame.size.width))*(point.x-xPosForExtraTime+startBound.frame.size.width/2.5), NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
  
}

-(void)handleEndPan:(UIPanGestureRecognizer *)recognizer{
    
    //  NSLog(@"asdasdasdasd");
    if(recognizer.state == UIGestureRecognizerStateBegan)
    {
        if(player.rate){
             [self PlayerSetPlayPause:playPause withPlayingStatus:1];
        }
        
       
        
       //_toast.text = @"";
        [_toastStartBound setCenter:CGPointMake(startBound.frame.origin.x+startBound.frame.size.width/2,_toast.center.y)];
        [_toastEndBound setCenter:CGPointMake(endBound.frame.origin.x+endBound.frame.size.width/2,_toast.center.y)];
        //[seekBar setCenter:CGPointMake(-100,seekBar.center.y)];
        //[_toast setCenter:CGPointMake(-100 ,_toast.center.y)];
        
        //All fingers are lifted.
    }
    
    if(_toastEndBound.frame.origin.x  < _toastStartBound.frame.origin.x+_toastStartBound.frame.size
       .width){
        // [[UIApplication sharedApplication].keyWindow bringSubviewToFront:_toastStartBound];
        //[self.view bringSubviewToFront:_toastStartBound];
        _toastStartBound.layer.zPosition = 0;
        _toastEndBound.layer.zPosition = 1;
        NSLog(@"start oevrplap end");
    }
    UIView *pannedView = recognizer.view ;
    CGPoint translation = [recognizer translationInView:pannedView.superview];
    CGPoint point;
   // NSLog(@"pan %f",pannedView.center.x + translation.x);
    if(pannedView.center.x + translation.x > SCREEN_WIDTH-(endBound.frame.size.width/2)){
        point = CGPointMake(SCREEN_WIDTH-(endBound.frame.size.width/2), pannedView.center.y);
    }else if(pannedView.center.x + translation.x < (endBound.frame.size.width/2) ){
        point = CGPointMake((endBound.frame.size.width/2), pannedView.center.y);
    }else {
        point = CGPointMake(pannedView.center.x + translation.x , pannedView.center.y);
    }
    CGRect starBoundVal = startBound.frame;
    if (point.x < starBoundVal.origin.x+_seekBar.frame.size.width+endBound.frame.size.width/2){
        point.x = starBoundVal.origin.x+_seekBar.frame.size.width+endBound.frame.size.width/2;
    }
    if(point.x > SCREEN_WIDTH- endBound.frame.size.width/2){
        point.x=  SCREEN_WIDTH- endBound.frame.size.width/2;
    }
  
   // NSLog(@"start point %f end oint %f",starBoundVal.origin.x,point.x);
    pannedView.center = point;
    [recognizer setTranslation:CGPointZero inView:pannedView.superview];
   
//    NSDateComponentsFormatter *dateComponentsFormatter = [[NSDateComponentsFormatter alloc] init];
//    dateComponentsFormatter.zeroFormattingBehavior = NSDateComponentsFormatterZeroFormattingBehaviorPad;
//    dateComponentsFormatter.allowedUnits = (NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond);
//    _toastStartBound.text =[dateComponentsFormatter stringFromTimeInterval:(videoTotalTime/(_frameGenerateView.frame.size.width))*(startBound.frame.origin.x+startBound.frame.size.width/2-xPosForExtraTime+startBound.frame.size.width/2.5)];
    
    [_toastStartBound setCenter:CGPointMake(startBound.frame.origin.x+startBound.frame.size.width/2,_toast.center.y)];
    
    
//    dateComponentsFormatter = [[NSDateComponentsFormatter alloc] init];
//    dateComponentsFormatter.zeroFormattingBehavior = NSDateComponentsFormatterZeroFormattingBehaviorPad;
//    dateComponentsFormatter.allowedUnits = (NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond);
//    _toastEndBound.text =[dateComponentsFormatter stringFromTimeInterval:(videoTotalTime/(_frameGenerateView.frame.size.width))*(endBound.frame.origin.x+_seekBar.frame.size.width/8-xPosForExtraTime)];
    
    double endValue = endBound.frame.origin.x+endBound.frame.size.width/2 ;
    if ( endValue > SCREEN_WIDTH - _toastEndBound.frame.size.width/2){
        endValue = SCREEN_WIDTH - _toastEndBound.frame.size.width/2;
    }
    [_toastEndBound setCenter:CGPointMake(endValue,_toast.center.y)];
    int startTime = (videoTotalTime/(_frameGenerateView.frame.size.width))*(startBound.frame.origin.x+startBound.frame.size.width/2-xPosForExtraTime+startBound.frame.size.width/2.5) ;
    int endTime = (videoTotalTime/(_frameGenerateView.frame.size.width))*(endBound.frame.origin.x+_seekBar.frame.size.width/8-xPosForExtraTime);
    NSString *timeString = @" TOTAL" ;
    self->_totalTimeShowLable.text = [NSString stringWithFormat:@"%@  %@",timeString, [self timeFormatted:(int)(endTime-startTime)] ];
    _toastStartBound.text = [self timeFormatted:startTime];
    _toastEndBound.text = [self timeFormatted:endTime];
    if(selectOption == 0 ){
       // _splitViewStart.frame =  CGRectMake(_frameGenerateView.frame.origin.x,_cutView.frame.origin.y, startBound.frame.origin.x-_frameGenerateView.frame.origin.x, _frameGenerateView.frame.size.height);
        _splitViewEnd.frame =  CGRectMake( endBound.frame.origin.x,_cutView.frame.origin.y, _frameGenerateView.frame.size.width - endBound.frame.origin.x
                                          , _frameGenerateView.frame.size.height);
    }else if ( selectOption == 1 ){
        _cutView.frame =  CGRectMake(startBound.frame.origin.x,_cutView.frame.origin.y, endBound.frame.origin.x-(startBound.frame.origin.x), _frameGenerateView.frame.size.height);
    }else {
        
        
    }
    
    
    if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        if(!player.rate){
            [self PlayerSetPlayPause:playPause withPlayingStatus:0];
        }
        
        
        [_toastEndBound setCenter:CGPointMake(-1000,_toast.center.y)];
        [_toastStartBound setCenter:CGPointMake(-1000,_toast.center.y)];
        // _toast.text = @"";
        //[seekBar setCenter:CGPointMake(startBound.frame.origin.x+ startBound.frame.size.width+ seekBar.frame.size.width/2,seekBar.center.y)];
        //[_toast setCenter:CGPointMake(startBound.frame.origin.x+ startBound.frame.size.width+ seekBar.frame.size.width/2 ,_toast.center.y)];
      
    }
    // [player seekToTime:CMTimeMakeWithSeconds((videoTotalTime/(_frameGenerateView.frame.size.width))*(startBound.frame.origin.x+startBound.frame.size.width/2-xPosForExtraTime+startBound.frame.size.width/2.5), NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
  
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
//    NSDateComponentsFormatter *dateComponentsFormatter = [[NSDateComponentsFormatter alloc] init];
//    dateComponentsFormatter.zeroFormattingBehavior = NSDateComponentsFormatterZeroFormattingBehaviorPad;
//    dateComponentsFormatter.allowedUnits = (NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond);
    _toast.text =[self timeFormatted:(int)time];
    
//    CGRect trackRect = [self->slider trackRectForBounds:self->slider.bounds];
//    CGRect thumbRect = [self->slider thumbRectForBounds:self->slider.bounds
//                                              trackRect:trackRect
//                                                  value:self->slider.value];
    //NSLog(@"x--- %f y--- %f",thumbRect.origin.x,thumbRect.origin.y);

    double x = ((_frameGenerateView.frame.size.width)/videoTotalTime)* time;
    double seekbarAtXPosition = (_frameGenerateView.frame.size.width/videoTotalTime)*(time);
    //NSLog(@"x--- %f y--- %f",x,thumbRect.origin.y);
   // _scrollView.contentOffset= CGPointMake( x,thumbRect.origin.y + 2);
     //NSLog(@"start %f end %f x %f",st.origin.x-10,x);
    [_seekBar setCenter:CGPointMake( seekbarAtXPosition+xPosForExtraTime  ,_seekBar.center.y)];
    // [_toast setCenter:CGPointMake( seekbarAtXPosition +xPosForExtraTime,_toast.center.y)];
    
    //  NSLog(@"cur %f",slider.value);
    //     NSLog(@"min %f max %f time %f dur %f",minValue,maxValue,time,duration);
     CGRect endBoundVal = endBound.frame;

    if(x+xPosForExtraTime >endBoundVal.origin.x){
          CGRect starBoundVal = startBound.frame;
          //[self PlayerSetPlayPause:playPause withPlayingStatus:1];
     //    _toast.text = @"";
          [_seekBar setCenter:CGPointMake( starBoundVal.origin.x+ (starBoundVal.size.width) ,_seekBar.center.y)];
      //    [_toast setCenter:CGPointMake( seekbarAtXPosition +xPosForExtraTime,_toast.center.y)];
          [player seekToTime:CMTimeMakeWithSeconds((videoTotalTime/(_frameGenerateView.frame.size.width))*(starBoundVal.origin.x+starBoundVal.size.width-xPosForExtraTime), NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
        
    }
    
    if( _seekBar.frame.origin.x < startBound.frame.origin.x){
        CGRect starBoundVal = startBound.frame;
        [_seekBar setCenter:CGPointMake( starBoundVal.origin.x+ (starBoundVal.size.width) ,_seekBar.center.y)];
        //    [_toast setCenter:CGPointMake( seekbarAtXPosition +xPosForExtraTime,_toast.center.y)];
        [player seekToTime:CMTimeMakeWithSeconds((videoTotalTime/(_frameGenerateView.frame.size.width))*(starBoundVal.origin.x+starBoundVal.size.width-xPosForExtraTime), NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
        
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
    [_seekBar setCenter:CGPointMake( starBoundVal.origin.x+23 ,_seekBar.center.y)];
     _toast.text = @"";
    [_toast setCenter:CGPointMake( _seekBar.frame.origin.x+15 ,_toast.center.y)];
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




- (NSString *)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    NSString *totalTime;
    if(hours < 1 ){
           totalTime = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    }else {
            totalTime = [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
    }

    
    return totalTime;
}
@end


