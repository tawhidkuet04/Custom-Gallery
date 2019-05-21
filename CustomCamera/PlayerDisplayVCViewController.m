//
//  PlayerDisplayVCViewController.m
//  CameraProject
//
//  Created by Tawhid Joarder on 4/15/19.
//  Copyright © 2019 BrainCraft LTD. All rights reserved.
//

#import "PlayerDisplayVCViewController.h"
#import "ViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
@interface PlayerDisplayVCViewController ()<playerDisplayVCViewControllerDelegate>{
    AVPlayer *player;
    
    AVMutableComposition *mutableComposition ;
    // UIView *seekBar;
    IBOutlet UIButton *playPause;
    AVPlayerItem *playerItem ;
    AVAsset *audioAsset;
    AVAsset *asset;
    AVAsset *asset2;
    NSURL *blurUrl;
    AVAsset *blurAsset;
    AVAssetTrack *videoTrack;
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
    AVAsset *videoAssetHorseRide;
    NSString *videoFilePathHorseRiding = [[NSBundle mainBundle] pathForResource:@"BoyHorseRide.mp4" ofType:nil];
    if (videoFilePathHorseRiding != nil) {
        NSURL *videoUrl = [NSURL fileURLWithPath:videoFilePathHorseRiding];
        videoAssetHorseRide = [[AVURLAsset alloc]initWithURL:videoUrl options:nil];

    }
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
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self->asset = avasset;
                        
                        
                        AVMutableComposition *mainComposition = [[AVMutableComposition alloc] init];
                        
                        
                       
                        AVMutableCompositionTrack *compositionVideoTrack = [mainComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
                        AVMutableCompositionTrack *compositionAudioTrack = [mainComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
                      
                        NSError *audioError;
                        NSError *videoError;
                        CMTime insertTime=kCMTimeZero;
                        
                        videoTrack = [ avasset tracksWithMediaType:AVMediaTypeVideo].firstObject;
                        AVAssetTrack *audioTrack = [avasset tracksWithMediaType:AVMediaTypeAudio].firstObject;
                        [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, avasset.duration) ofTrack: videoTrack atTime:insertTime error:&videoError];
                        [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, avasset.duration) ofTrack: audioTrack atTime:insertTime error:&audioError];
                        insertTime = avasset.duration;
                     
                      
                
                        
                        if (videoError) {
                            NSLog(@"Error - %@", videoError.debugDescription);
                        }
                        if (audioError) {
                            NSLog(@"Error - %@", audioError.debugDescription);
                        }
                
                     
                        NSLog(@"time in mute %f",CMTimeGetSeconds(self->mutableComposition.duration));
                        //    if (CMTimeGetSeconds(audioAsset.duration) < CMTimeGetSeconds(asset.duration)) {
                        //        duration = audioAsset.duration;
                        //    } else
                        {
                            // duration = self->asset.duration;
                        }
                        
                        //            double x = self->_scrollViewFake.frame.origin.x , y = _scrollViewFake.frame.origin.y , height = _scrollViewFake.frame.size.height
                        //            ,width = self->_scrollViewFake.frame.size.width;
                        //            NSLog(@"checking %f %f %f %f",x,y,width,height);
                        NSLog(@"FF %f %f %f %f",self->_frameGenerateView.frame.origin.x,_frameGenerateView.frame.origin.y,_frameGenerateView.frame.size.width,_frameGenerateView.frame.size.height);
                        self->_scrollView = [[thumbnailScrollView alloc] initWithFrame:CGRectMake(0,0,_frameGenerateView.frame.size.width, _frameGenerateView.frame.size
                                                                                                  .height) withDelegate:self andAsset:mainComposition  frameView:_frameGenerateView];
                        [self->_frameGenerateView addSubview:self->_scrollView];
                        // temporary view
                        
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
                        
                        
                        UIPanGestureRecognizer *splitBatPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSplitPan:)];
                        [self->_splitBar addGestureRecognizer:splitBatPan];
                        self->_splitBar.userInteractionEnabled = YES ;
                        
                        
                        
                        UIPanGestureRecognizer *seekBarTouch = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSeekBarPan:)];
                        [self->_seekBar addGestureRecognizer:seekBarTouch];
                        self->_seekBar.userInteractionEnabled = YES;
                        /////// play time show view initialization
                        //[self->_toast setCenter:CGPointMake( self->seekBar.frame.origin.x+15 ,self->_toast.center.y)];
                        
                        // [seekBar setCenter:CGPointMake(25,seekBar.center.y)];
                        //[seekBar removeFromSuperview];
                        
                        self->playerItem = [AVPlayerItem playerItemWithAsset:mainComposition];
                        AVMutableVideoComposition *vidcom = [self CustomVideoComposition:mainComposition];
                               CGSize originalSize = CGSizeMake( _viewPlayer.frame.size.width ,  _viewPlayer.frame.size.height);
                        vidcom.renderSize = originalSize;
                        self->playerItem.videoComposition = [self CustomVideoComposition:mainComposition];
                        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:self->playerItem];
                        self->player = [AVPlayer playerWithPlayerItem:self->playerItem];
                        [self->player seekToTime:CMTimeMakeWithSeconds((self->videoTotalTime/(self->_scrollView.contentSize.width)), NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
                        //  player.frame = self.playerView.bounds;
                        // __weak NSObject *weakSelf = self;
                        
                        //     [_toastStartBound setCenter:CGPointMake(-100,seekBar.center.y)];
                        // _playerView.player = player;
                     //   [self.playerView setOk:self->playerViewBound.bounds];
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
                        self->selectOption = 0;
                        self->_cutView.layer.zPosition = 0 ;
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
                        startBoundYpos = startBound.center.y;
                        endBoundYpos = endBound.center.y;
                    });
                    
                    //dispatch_semaphore_signal(semaphore);
                }];
    
           


   
    //  dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    
    
    
}

- (IBAction)chooseTrimCutSplit:(id)sender {
    
    UISegmentedControl *s = (UISegmentedControl *) sender ;
    if(s.selectedSegmentIndex == 0 ){
        //  NSLog(@"trim");;
        [_splitBar setCenter:CGPointMake(-1000, 0)];
        [startBound setCenter:CGPointMake(startBound.frame.size.width, startBoundYpos)];
        [endBound setCenter:CGPointMake(_frameGenerateView.frame.size.width-3*endBound.frame.size.width, endBoundYpos)];
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
        [startBound setCenter:CGPointMake(startBound.frame.size.width, startBoundYpos)];
        [endBound setCenter:CGPointMake(_frameGenerateView.frame.size.width-3*endBound.frame.size.width, endBoundYpos)];
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
        [startBound setCenter:CGPointMake(startBound.frame.size.width/2, -1000)];
        [endBound setCenter:CGPointMake(_frameGenerateView.frame.size.width+xPosForExtraTime, -1000)];
        _splitViewStart.layer.zPosition = 0 ;
        _splitViewEnd.layer.zPosition = 0 ;
        _cutView.layer.zPosition = 0 ;
        _splitBar.layer.zPosition =  1;
        //   _seekBar.layer.zPosition = 1 ;
        
        //[_seekBar setCenter:CGPointMake(30, _seekBar.center.y)];seekToTime:CMTimeMakeWithSeconds((videoTotalTime/(_frameGenerateView.frame.size.width))*(_frameGenerateView.frame.origin.x), NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
        
        // [player seekToTime:CMTimeMakeWithSeconds((videoTotalTime/_frameGenerateView.frame.size.width)*(20-xPosForExtraTime), NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
        
        NSLog(@"Split");
    }
}
//
//- (AVMutableVideoComposition*)CustomVideoComposition:(AVMutableComposition*)composition{
//    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
//    return [AVMutableVideoComposition videoCompositionWithAsset: composition applyingCIFiltersWithHandler:^(AVAsynchronousCIImageFilteringRequest *request){
//
//        // Clamp to avoid blurring transparent pixels at the image edges
//        CIImage *source = [request.sourceImage imageByClampingToExtent];
//        UIImage *test =[[UIImage alloc]initWithCIImage:source];
//
//
//
//        CGSize originalSize = CGSizeMake( _viewPlayer.frame.size.width ,  _viewPlayer.frame.size.height);
//
//        CGSize videoSize = CGSizeApplyAffineTransform(videoTrack.naturalSize,videoTrack.preferredTransform);
//        videoSize = CGSizeMake(fabs(test.size.width), fabs(test.size.height));
////        CGAffineTransform scale ;
//        CGAffineTransform translate;
////        if(videoSize.width>videoSize.height){
////            scale = CGAffineTransformMakeScale(fabs(originalSize.height/videoSize.width)*4, fabs(originalSize.height/videoSize.width)*4);
////            double height = fabs(originalSize.width/videoSize.width)*videoSize.height;
////
////            translate = CGAffineTransformMakeTranslation(0, (originalSize.height-height)/2);
////        }else {
////            scale = CGAffineTransformMakeScale(fabs(originalSize.height/videoSize.height), fabs(originalSize.height/videoSize.height));
////            double width = fabs(originalSize.height/videoSize.height)*videoSize.width;
////            translate = CGAffineTransformMakeTranslation((originalSize.width-width)/2, 0);
////
////        }
//
////       // CIImage* scaleImage = [output imageByApplyingTransform:scale];
////
////        //CGAffineTransform translate = CGAffineTransformMakeTranslation(0,0);
////        CIImage* translateImage = [scaleImage imageByApplyingTransform:translate];
////
////
////        //        CGAffineTransform origTrans = videoTrack.preferredTransform ;
//
//
//
//        // Vary filter parameters based on video timing
//        Float64 seconds = CMTimeGetSeconds(request.compositionTime);
//        [filter setValue:@(1.0) forKey:kCIInputRadiusKey];
//
//        // Crop the blurred output to the bounds of the original image
//        // Provide the filter output to the composition
//       [filter setValue:source forKey:kCIInputImageKey];
//        CIImage *output = [filter.outputImage imageByCroppingToRect:CGRectMake(0, 0, test.size.width, test.size.height)];
//        CIImage* inputImage; // assume this exists
//
//        float factor = 1;
//        CGAffineTransform scale = CGAffineTransformMakeScale(factor,factor);
//        //CGAffineTransform ok = CGAffineTransformConcat(scale, translate);
//        //        ;
//        CIImage *final = [output imageByApplyingTransform:scale] ;
//        [request finishWithImage:final context:nil];
//    }];
//}
- (AVMutableVideoComposition*)CustomVideoComposition:(AVMutableComposition*)composition{
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    CIFilter *filter2 = [CIFilter filterWithName:@"CIGaussianBlur"];
    CIFilter *filter3 = [CIFilter filterWithName:@"CISourceOverCompositing"];
    return [AVMutableVideoComposition videoCompositionWithAsset: composition applyingCIFiltersWithHandler:^(AVAsynchronousCIImageFilteringRequest *request){

        // Clamp to avoid blurring transparent pixels at the image edges
        CIImage *output = [request.sourceImage imageByClampingToExtent];
       output = [output imageByCroppingToRect:request.sourceImage.extent];
      //  CGSize videoSize = CGSizeApplyAffineTransform(videoTrack.naturalSize,videoTrack.preferredTransform);
        CGSize videoSize = CGSizeMake(fabs(request.sourceImage.extent.size.width), fabs(request.sourceImage.extent.size.height));
   //     UIImage *test =[[UIImage alloc]initWithCIImage:source];
        NSLog(@"sisisisi %f %f",videoSize.width,videoSize.height);
        //[filter setValue:source forKey:kCIInputImageKey];


        // Vary filter parameters based on video timing
       // Float64 seconds = CMTimeGetSeconds(request.compositionTime);
       // [filter setValue:@(2.0) forKey:kCIInputRadiusKey];
        float factor = 0.5;
        CGSize originalSize = CGSizeMake( _viewPlayer.frame.size.width ,  _viewPlayer.frame.size.height);
        NSLog(@"asdasdasd %f %f",request.sourceImage.extent.size.width,request.sourceImage.extent.size.height);

//        //CIImage *output = [filter.outputImage imageByCroppingToRect:request.sourceImage.extent];
//        float scaleXY = (originalSize.width/request.sourceImage.extent.size.width);
        double canvasX = ((request.sourceImage.extent.size.width)/(SCREEN_WIDTH))*(originalSize.width);
         double canvasY = ((request.sourceImage.extent.size.height)/(SCREEN_WIDTH))*(originalSize.width);
//        NSLog(@"aaaa %f %f",canvasX,canvasY);
        CGAffineTransform scale ;
                CGAffineTransform translate;
                if(videoSize.width>videoSize.height){
                    scale = CGAffineTransformMakeScale(1, output.extent.size.height/output.extent.size.width);
                    double height = videoSize.height-(videoSize.height*(output.extent.size.height/output.extent.size.width));

                    translate = CGAffineTransformMakeTranslation(0, (height)/2);
                }else {
                    scale = CGAffineTransformMakeScale(request.sourceImage.extent.size.width/request.sourceImage.extent.size.height, 1);
                    double width = videoSize.width-(videoSize.width*(request.sourceImage.extent.size.width/request.sourceImage.extent.size.height));
                    translate = CGAffineTransformMakeTranslation((width)/2, 0);

                }
        CGAffineTransform ok = CGAffineTransformConcat(scale, translate);
        CIImage *p = [output imageByApplyingTransform:ok] ;
        [filter2 setValue:output forKey:kCIInputImageKey];
        [filter setValue:p forKey:kCIInputImageKey];
        
        
        
        // Vary filter parameters based on video timing
       // Float64 seconds = CMTimeGetSeconds(request.compositionTime);
        [filter setValue:@(0.0) forKey:kCIInputRadiusKey];
        [filter2 setValue:@(20.0) forKey:kCIInputRadiusKey];
        
        
        [filter3 setValue:filter2.outputImage forKey:kCIInputBackgroundImageKey];
        [filter3 setValue:filter.outputImage forKey:kCIInputImageKey];
        [request finishWithImage:filter3.outputImage context:nil];
    }];
}


//- (AVMutableVideoComposition*)CustomVideoComposition:(AVMutableComposition*)composition{
//    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
//    CIFilter *filter1 =[CIFilter filterWithName:@"CIGaussianBlur"];
//    return [AVMutableVideoComposition videoCompositionWithAsset: composition applyingCIFiltersWithHandler:^(AVAsynchronousCIImageFilteringRequest *request){
//
//
//        //Background Image
//        CIImage *source = request.sourceImage;
//
//        //smaller Image
//        CIImage *backSource = request.sourceImage;
//        float scaleXY = (source.extent.size.height/source.extent.size.width);
//        //AVAssetTrack *sourceVideoTrack = [[resultAsset1 tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
//        CGSize temp = CGSizeApplyAffineTransform(videoTrack.naturalSize, videoTrack.preferredTransform);
//        CGSize size = CGSizeMake(fabs(temp.width), fabs(temp.height));
//        float height1=temp.height-(temp.height*scaleXY);
//        CIImage *backsource = [backSource imageByApplyingTransform:CGAffineTransformMakeScale(1,scaleXY)];
//        backsource = [ backsource imageByApplyingTransform:CGAffineTransformMakeTranslation(0, height1/2)];
//
//
//        //Background Image
//        //        [source ]
//
//        //
//        //        [blend setValue:backsource forKey:@"inputImage"];
//        //        [blend setValue:source forKey:@"outputImage"];
//
//
//        //        ble
//
//        //         CIFilter *blend = [ CIFilter filterWithName:@"CIBlendWithMask" keysAndValues:kCIInputImageKey,backsource,source, nil];
//        //
//        //        CIImage *outputImage = [ blend outputImage];
//
//        [filter1 setValue:source forKey:kCIInputImageKey];
//        [filter setValue:backsource forKey:kCIInputImageKey];
//
//
//        // Vary filter parameters based on video timing
//        Float64 seconds = CMTimeGetSeconds(request.compositionTime);
//        [filter setValue:@(0.0) forKey:kCIInputRadiusKey];
//        [filter1 setValue:@(10.0) forKey:kCIInputRadiusKey];
//        // Crop the blurred output to the bounds of the original image
//        //        CIImage *output = [filter.outputImage imageByCroppingToRect:backsource.extent];
//
//        // Provide the filter output to the composition
//        [request finishWithImage:filter.outputImage context:nil];
//    }];
//}
//





NSURL * dataFilePath(NSString *path){
    //creating a path for file and checking if it already exist if exist then delete it
    NSString *outputPath = [[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), path];
    
    BOOL success;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //check if file exist at outputPath
    success = [fileManager fileExistsAtPath:outputPath];
    
    if (success) {
        //delete if file exist at outputPath
        NSLog(@"deleted file");
        success=[fileManager removeItemAtPath:outputPath error:nil];
    }
    
    return [NSURL fileURLWithPath:outputPath];
    
}
- (IBAction)saveButtoPressed:(id)sender {
    
    NSLog(@"Save Button Pressed");
    
    
    
    if(selectOption == 0 ){
        [self trimVideo];
    }else if ( selectOption == 1 ){
        [self cropVideo];
    }else {
        [self splitVideo];
    }
    
}


- (void)splitVideo{
    
    
    int splitTime = (videoTotalTime/(_frameGenerateView.frame.size.width))*(_splitBar.center.x-xPosForExtraTime);
    //create exportSession and exportVideo Quality
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetHighestQuality];
    
    NSURL *outputVideoURL=dataFilePath(@"tmpPost.mp4"); //url of exportedVideo
    
    exportSession.outputURL = outputVideoURL;
    
    exportSession.shouldOptimizeForNetworkUse = YES;
    
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    
    AVAssetExportSession *exportSession2 = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetHighestQuality];
    
    NSURL *outputVideoURL2 =dataFilePath(@"tmpPost2.mp4"); //url of exportedVideo
    
    exportSession2.outputURL = outputVideoURL2;
    
    exportSession2.shouldOptimizeForNetworkUse = YES;
    
    exportSession2.outputFileType = AVFileTypeQuickTimeMovie;
    /**
     
     
     
     creating the time range i.e. make startTime and endTime.
     
     startTime should be the first frame time at which your exportedVideo should start.
     
     endTime is the time of last frame at which your exportedVideo should stop. OR it should be the duration of the         excpected exportedVideo length
     
     **/
    CMTime start = CMTimeMakeWithSeconds(0, 600);
    CMTime split = CMTimeMakeWithSeconds(splitTime, 600);
    CMTime end = CMTimeMakeWithSeconds(videoTotalTime-splitTime, 600);
    
    CMTimeRange range1= CMTimeRangeMake(start,split);
    CMTimeRange range2= CMTimeRangeMake(split,end);
    
    exportSession.timeRange = range1;
    exportSession2.timeRange = range2 ;
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    __block i = 0 , j = 0 ;
    dispatch_sync(aQueue,^{
        //NSLog(@"%s",dispatch_queue_get_label(aQueue));
        //  NSLog(@"This is the global Dispatch Queue");
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void){
            
            switch (exportSession.status)
            
            {
                    
                case
                AVAssetExportSessionStatusCompleted:
                    
                {
                    
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        NSURL *finalUrl=dataFilePath(@"trimmedVideo.mp4");
                        
                        NSData *urlData = [NSData dataWithContentsOfURL:outputVideoURL];
                        
                        NSError *writeError;
                        
                        //write exportedVideo to path/trimmedVideo.mp4
                        
                        [urlData writeToURL:finalUrl options:NSAtomicWrite error:&writeError];
                        
                        if (!writeError) {
                            
                            //update Original URL
                            
                            // originalURL=finalUrl;
                            NSLog(@"saving");
                            dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                            dispatch_async(q, ^{
                                
                                NSData *videoData = [NSData dataWithContentsOfURL:finalUrl];
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    // Write it to cache directory
                                    NSString *videoPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"file.mov"];
                                    [videoData writeToFile:videoPath atomically:YES];
                                    
                                    // After that use this path to save it to PhotoLibrary
                                    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                                    [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:videoPath] completionBlock:^(NSURL *assetURL, NSError *error)
                                     {
                                         if (error)
                                         {
                                             NSLog(@"Error");
                                         }
                                         else
                                         {
                                             NSLog(@"F");
                                             
                                             if ( i == 2 && j== 0 ){
                                                 j = 1 ;
                                                 NSString *message = @"Video split Done";
                                                 UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                                                                 message:message
                                                                                                delegate:nil
                                                                                       cancelButtonTitle:nil
                                                                                       otherButtonTitles:nil, nil];
                                                 [toast show];
                                                 
                                                 int duration = 1; // duration in seconds
                                                 
                                                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                                     [toast dismissWithClickedButtonIndex:0 animated:YES];
                                                 });
                                                 NSLog(@"Success");
                                             }
                                             i = 1 ;
                                         }
                                         
                                     }];
                                });
                            });
                            
                            //update video Properties
                            
                            // [self updateParameters];
                            
                        }
                        
                        NSLog(@"split Done %ld %@", (long)exportSession.status, exportSession.error);
                        
                    });
                    
                    
                }
                    
                    break;
                    
                case AVAssetExportSessionStatusFailed:
                    
                    NSLog(@"split failed with error ===>>> %@",exportSession.error);
                    
                    break;
                    
                case AVAssetExportSessionStatusCancelled:
                    
                    NSLog(@"Canceled:%@",exportSession.error);
                    
                    break;
                    
                default:
                    
                    break;
                    
            }
            
        }];
        
    });
    
    dispatch_sync(aQueue,^{
        //        NSLog(@"%s",dispatch_queue_get_label(aQueue));
        //        for (int i =0; i<5;i++)
        //        {
        //            NSLog(@"i %d",i);
        //            sleep(1);
        //        }
        
        [exportSession2 exportAsynchronouslyWithCompletionHandler:^(void){
            
            switch (exportSession2.status)
            
            {
                    
                case
                AVAssetExportSessionStatusCompleted:
                    
                {
                    
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        NSURL *finalUrl=dataFilePath(@"trimmedVideo2.mp4");
                        
                        NSData *urlData = [NSData dataWithContentsOfURL:outputVideoURL2];
                        
                        NSError *writeError;
                        
                        //write exportedVideo to path/trimmedVideo.mp4
                        
                        [urlData writeToURL:finalUrl options:NSAtomicWrite error:&writeError];
                        
                        if (!writeError) {
                            
                            //update Original URL
                            
                            // originalURL=finalUrl;
                            NSLog(@"saving");
                            dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                            dispatch_async(q, ^{
                                
                                NSData *videoData = [NSData dataWithContentsOfURL:finalUrl];
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    // Write it to cache directory
                                    NSString *videoPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"file.mov"];
                                    [videoData writeToFile:videoPath atomically:YES];
                                    
                                    // After that use this path to save it to PhotoLibrary
                                    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                                    [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:videoPath] completionBlock:^(NSURL *assetURL, NSError *error)
                                     {
                                         if (error)
                                         {
                                             NSLog(@"Error");
                                         }
                                         else
                                         {
                                             NSLog(@"S");
                                             
                                             if ( i == 1 && j == 0  ){
                                                 j = 1 ;
                                                 NSString *message = @"Video split Done";
                                                 UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                                                                 message:message
                                                                                                delegate:nil
                                                                                       cancelButtonTitle:nil
                                                                                       otherButtonTitles:nil, nil];
                                                 [toast show];
                                                 
                                                 int duration = 1; // duration in seconds
                                                 
                                                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                                     [toast dismissWithClickedButtonIndex:0 animated:YES];
                                                 });
                                                 NSLog(@"Success");
                                             }
                                             i = 2 ;
                                             
                                         }
                                         
                                     }];
                                });
                            });
                            
                            //update video Properties
                            
                            // [self updateParameters];
                            
                        }
                        
                        NSLog(@"Trim Done %ld %@", (long)exportSession.status, exportSession.error);
                        
                    });
                    
                    
                }
                    
                    break;
                    
                case AVAssetExportSessionStatusFailed:
                    
                    NSLog(@"split failed with error ===>>> %@",exportSession.error);
                    
                    break;
                    
                case AVAssetExportSessionStatusCancelled:
                    
                    NSLog(@"Canceled:%@",exportSession.error);
                    
                    break;
                    
                default:
                    
                    break;
                    
            }
            
        }];
    });
    
    
    
    
    
    
}
-(void)trimVideo{
    
    int startTime = (videoTotalTime/(_frameGenerateView.frame.size.width))*(startBound.frame.origin.x+startBound.frame.size.width/2-xPosForExtraTime+startBound.frame.size.width/2.5) ;
    int endTime = (videoTotalTime/(_frameGenerateView.frame.size.width))*(endBound.frame.origin.x+_seekBar.frame.size.width/8-xPosForExtraTime);
    //create exportSession and exportVideo Quality
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetHighestQuality];
    
    NSURL *outputVideoURL=dataFilePath(@"tmpPost.mp4"); //url of exportedVideo
    
    exportSession.outputURL = outputVideoURL;
    
    exportSession.shouldOptimizeForNetworkUse = YES;
    
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    
    /**
     
     creating the time range i.e. make startTime and endTime.
     
     startTime should be the first frame time at which your exportedVideo should start.
     
     endTime is the time of last frame at which your exportedVideo should stop. OR it should be the duration of the         excpected exportedVideo length
     
     **/
    CMTime st = CMTimeMakeWithSeconds(startTime, 600);
    CMTime en = CMTimeMakeWithSeconds(endTime-startTime, 600);
    CMTimeRange range = CMTimeRangeMake(st,en );
    
    exportSession.timeRange = range;
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void){
        
        switch (exportSession.status)
        
        {
                
            case
            AVAssetExportSessionStatusCompleted:
                
            {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSURL *finalUrl=dataFilePath(@"trimmedVideo.mp4");
                    
                    NSData *urlData = [NSData dataWithContentsOfURL:outputVideoURL];
                    
                    NSError *writeError;
                    
                    //write exportedVideo to path/trimmedVideo.mp4
                    
                    [urlData writeToURL:finalUrl options:NSAtomicWrite error:&writeError];
                    
                    if (!writeError) {
                        
                        //update Original URL
                        
                        // originalURL=finalUrl;
                        NSLog(@"saving");
                        dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                        dispatch_async(q, ^{
                            
                            NSData *videoData = [NSData dataWithContentsOfURL:finalUrl];
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                // Write it to cache directory
                                NSString *videoPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"file.mov"];
                                [videoData writeToFile:videoPath atomically:YES];
                                
                                // After that use this path to save it to PhotoLibrary
                                ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                                [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:videoPath] completionBlock:^(NSURL *assetURL, NSError *error)
                                 {
                                     if (error)
                                     {
                                         NSLog(@"Error");
                                     }
                                     else
                                     {
                                         NSString *message = @"Video Trim Done";
                                         UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                                                         message:message
                                                                                        delegate:nil
                                                                               cancelButtonTitle:nil
                                                                               otherButtonTitles:nil, nil];
                                         [toast show];
                                         
                                         int duration = 1; // duration in seconds
                                         
                                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                             [toast dismissWithClickedButtonIndex:0 animated:YES];
                                         });
                                         NSLog(@"Success");
                                     }
                                     
                                 }];
                            });
                        });
                        
                        //update video Properties
                        
                        // [self updateParameters];
                        
                    }
                    
                    NSLog(@"Trim Done %ld %@", (long)exportSession.status, exportSession.error);
                    
                });
                
                
            }
                
                break;
                
            case AVAssetExportSessionStatusFailed:
                
                NSLog(@"Trim failed with error ===>>> %@",exportSession.error);
                
                break;
                
            case AVAssetExportSessionStatusCancelled:
                
                NSLog(@"Canceled:%@",exportSession.error);
                
                break;
                
            default:
                
                break;
                
        }
        
    }];
    
}
-(void)cropVideo{
    
    
    int startTime = (videoTotalTime/(_frameGenerateView.frame.size.width))*(startBound.frame.origin.x+startBound.frame.size.width/2-xPosForExtraTime+startBound.frame.size.width/2.5) ;
    int endTime = (videoTotalTime/(_frameGenerateView.frame.size.width))*(endBound.frame.origin.x+_seekBar.frame.size.width/8-xPosForExtraTime);
    
    CMTime st = CMTimeMakeWithSeconds(startTime, 600);
    CMTime en = CMTimeMakeWithSeconds(endTime-startTime, 600);
    CMTimeRange range = CMTimeRangeMake(st,en );
    AVMutableComposition *mutableComposition = [AVMutableComposition composition];
    AVMutableCompositionTrack *videoCompositionTrack = [mutableComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVAssetTrack *videoAssetTrack = [asset tracksWithMediaType:AVMediaTypeVideo].firstObject;
    AVMutableCompositionTrack *audioCompositionTrack = [mutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    AVAssetTrack *audioAssetTrack = [asset tracksWithMediaType:AVMediaTypeAudio].firstObject;
    CMTime time = kCMTimeZero;
    NSError *videoError;
    [videoCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAssetTrack.timeRange.duration)
                                   ofTrack:videoAssetTrack
                                    atTime:time
                                     error:&videoError];
    [audioCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAssetTrack.timeRange.duration)
                                   ofTrack:audioAssetTrack
                                    atTime:time
                                     error:&videoError];
    [videoCompositionTrack removeTimeRange:range];
    [audioCompositionTrack removeTimeRange:range];
    if (videoError) {
        NSLog(@"Error - %@", videoError.debugDescription);
    }
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:mutableComposition presetName:AVAssetExportPresetHighestQuality];
    
    NSURL *outputVideoURL=dataFilePath(@"tmpPost.mp4"); //url of exportedVideo
    
    exportSession.outputURL = outputVideoURL;
    
    exportSession.shouldOptimizeForNetworkUse = YES;
    
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    
    /**
     
     creating the time range i.e. make startTime and endTime.
     
     startTime should be the first frame time at which your exportedVideo should start.
     
     endTime is the time of last frame at which your exportedVideo should stop. OR it should be the duration of the         excpected exportedVideo length
     
     **/
    
    
    exportSession.timeRange = videoCompositionTrack.timeRange;
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void){
        
        switch (exportSession.status)
        
        {
                
            case
            AVAssetExportSessionStatusCompleted:
                
            {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSURL *finalUrl=dataFilePath(@"trimmedVideo.mp4");
                    
                    NSData *urlData = [NSData dataWithContentsOfURL:outputVideoURL];
                    
                    NSError *writeError;
                    
                    //write exportedVideo to path/trimmedVideo.mp4
                    
                    [urlData writeToURL:finalUrl options:NSAtomicWrite error:&writeError];
                    
                    if (!writeError) {
                        
                        //update Original URL
                        
                        // originalURL=finalUrl;
                        NSLog(@"saving");
                        dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                        dispatch_async(q, ^{
                            
                            NSData *videoData = [NSData dataWithContentsOfURL:finalUrl];
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                // Write it to cache directory
                                NSString *videoPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"file.mov"];
                                [videoData writeToFile:videoPath atomically:YES];
                                
                                // After that use this path to save it to PhotoLibrary
                                ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                                [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:videoPath] completionBlock:^(NSURL *assetURL, NSError *error)
                                 {
                                     if (error)
                                     {
                                         NSLog(@"Error");
                                     }
                                     else
                                     {
                                         NSString *message = @"Video Cut Done";
                                         UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                                                         message:message
                                                                                        delegate:nil
                                                                               cancelButtonTitle:nil
                                                                               otherButtonTitles:nil, nil];
                                         [toast show];
                                         
                                         int duration = 1; // duration in seconds
                                         
                                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                             [toast dismissWithClickedButtonIndex:0 animated:YES];
                                         });
                                         
                                         NSLog(@"Success");
                                     }
                                     
                                 }];
                            });
                        });
                        
                        //update video Properties
                        
                        // [self updateParameters];
                        
                    }
                    
                    NSLog(@"Cut Done %ld %@", (long)exportSession.status, exportSession.error);
                    
                });
                
                
            }
                
                break;
                
            case AVAssetExportSessionStatusFailed:
                
                NSLog(@"Cut failed with error ===>>> %@",exportSession.error);
                
                break;
                
            case AVAssetExportSessionStatusCancelled:
                
                NSLog(@"Canceled:%@",exportSession.error);
                
                break;
                
            default:
                
                break;
                
        }
        
    }];
    
}
-(void)handleScrollPan:(UIPanGestureRecognizer *)recognizer{
    
    //   NSLog(@"asdasdasdasd");
    //   [seekBar setCenter:CGPointMake(-1000,seekBar.center.y)];
    
}
-(void)handleSplitPan:(UIPanGestureRecognizer *)recognizer{
    
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
    }else if(pannedView.center.x + translation.x < (_splitBar.frame.size.width/2) ){
        point = CGPointMake((_splitBar.frame.size.width/2), pannedView.center.y);
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
    _toast.text =[self timeFormatted:(videoTotalTime/(_frameGenerateView.frame.size.width))*(point.x-xPosForExtraTime)];
    [player seekToTime:CMTimeMakeWithSeconds((videoTotalTime/(_frameGenerateView.frame.size.width))*(point.x-xPosForExtraTime), NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    
}


-(void)handleSeekBarPan:(UIPanGestureRecognizer *)recognizer{
    
    //  NSLog(@"asdasdasdasd");
    //   [seekBar setCenter:CGPointMake(-1000,seekBar.center.y)];
    
    if(recognizer.state == UIGestureRecognizerStateBegan)
    {
        [self PlayerSetPlayPause:playPause withPlayingStatus:1];
        //   _toast.text = @"";
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
    NSLog(@"seekbar time %f",(videoTotalTime/(_frameGenerateView.frame.size.width))*(point.x-xPosForExtraTime));
    _toast.text =[self timeFormatted:(videoTotalTime/(_frameGenerateView.frame.size.width))*(point.x-xPosForExtraTime)];
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
    
    int startTime = (videoTotalTime/(_frameGenerateView.frame.size.width))*(startBound.frame.origin.x+startBound.frame.size.width/2-xPosForExtraTime+startBound.frame.size.width/2.5) ;
    int endTime = (videoTotalTime/(_frameGenerateView.frame.size.width))*(endBound.frame.origin.x+_seekBar.frame.size.width/8-xPosForExtraTime);
    NSString *timeString = @" TOTAL" ;
    
    _toastStartBound.text = [self timeFormatted:startTime];
    _toastEndBound.text = [self timeFormatted:endTime];
    if(selectOption == 0 ){
        self->_totalTimeShowLable.text = [NSString stringWithFormat:@"%@  %@",timeString, [self timeFormatted:(int)(endTime-startTime)] ];
        _splitViewStart.frame =  CGRectMake(_frameGenerateView.frame.origin.x-startBound.frame.size.width,_cutView.frame.origin.y, startBound.frame.origin.x, _frameGenerateView.frame.size.height);
    }else if ( selectOption == 1 ){
        self->_totalTimeShowLable.text = [NSString stringWithFormat:@"%@  %@",timeString, [self timeFormatted:(int)(videoTotalTime- (endTime-startTime) ) ] ];
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
    if(!player.rate){
        [self PlayerSetPlayPause:playPause withPlayingStatus:0];
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
    
    _toastStartBound.text = [self timeFormatted:startTime];
    _toastEndBound.text = [self timeFormatted:endTime];
    if(selectOption == 0 ){
        // _splitViewStart.frame =  CGRectMake(_frameGenerateView.frame.origin.x,_cutView.frame.origin.y, startBound.frame.origin.x-_frameGenerateView.frame.origin.x, _frameGenerateView.frame.size.height);
        self->_totalTimeShowLable.text = [NSString stringWithFormat:@"%@  %@",timeString, [self timeFormatted:(int)(endTime-startTime)] ];
        _splitViewEnd.frame =  CGRectMake( endBound.frame.origin.x,_cutView.frame.origin.y, _frameGenerateView.frame.size.width - endBound.frame.origin.x
                                          , _frameGenerateView.frame.size.height);
    }else if ( selectOption == 1 ){
        self->_totalTimeShowLable.text = [NSString stringWithFormat:@"%@  %@",timeString, [self timeFormatted:(int)(videoTotalTime- (endTime-startTime) ) ] ];
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


