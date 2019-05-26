//
//  canvasView.m
//  CustomCamera
//
//  Created by Tawhid Joarder on 5/23/19.
//  Copyright © 2019 Tawhid Joarder. All rights reserved.
//

#import "trimCutSplitView.h"
#import "ViewController.h"
#import "PlayerDisplayVCViewController.h"

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
@interface trimCutSplitView ()<UITabBarDelegate>{
id observer;
AVAsset *asset;
    UIButton *playPause;
// IBOutlet UIView *framGenerateView;
////// range bar start and end

IBOutlet UIImageView *endBound;
    PlayerDisplayVCViewController *playerViewCon;
IBOutlet UIImageView *startBound;
}
///////
@end

@implementation trimCutSplitView



- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    return self;
}

- (void)initView:(AVAsset *)asset andButton:(UIButton *)playPause player:(AVPlayer *) playerMain{
    playerViewCon =[[PlayerDisplayVCViewController alloc]init];
    playPause = playPause;
    player = playerMain;
    asset = asset;
    NSLog(@"FF %f %f %f %f",self.frameGenerateView.frame.origin.x,_frameGenerateView.frame.origin.y,_frameGenerateView.frame.size.width,_frameGenerateView.frame.size.height);
    self->_scrollView = [[thumbnailScrollView alloc] initWithFrame:CGRectMake(0,0,_frameGenerateView.frame.size.width, _frameGenerateView.frame.size
                                                                              .height) withDelegate:self andAsset:asset  frameView:_frameGenerateView];
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
    
    UIPanGestureRecognizer *startPanGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleStartPan:)];
    [self->startBound addGestureRecognizer:startPanGR];
    self->startBound.userInteractionEnabled = YES;
    UIView *tempView = [[UIView alloc]initWithFrame:(CGRect)CGRectMake(0, SCREEN_HEIGHT-200, 0.5, 0.5)];
   // [self.view addSubview:tempView];
    UIPanGestureRecognizer *endPanGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleEndPan:)];
    [self->endBound addGestureRecognizer:endPanGR];
    self->endBound.userInteractionEnabled = YES ;
    
    
    UIPanGestureRecognizer *splitBatPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSplitPan:)];
    [self->_splitBar addGestureRecognizer:splitBatPan];
    self->_splitBar.userInteractionEnabled = YES ;
    
    
    
    UIPanGestureRecognizer *seekBarTouch = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSeekBarPan:)];
    [self->_seekBar addGestureRecognizer:seekBarTouch];
    self->_seekBar.userInteractionEnabled = YES;
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
         NSLog(@"cut");
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
//    AVMutableVideoComposition *vidcom = [self CustomVideoComposition:asset];
//    CGSize originalSize = CGSizeMake( _viewPlayer.frame.size.width ,  _viewPlayer.frame.size.height);
//    vidcom.renderSize = originalSize;
    //exportSession.videoComposition =vidcom;
    
    exportSession.shouldOptimizeForNetworkUse = YES;
    
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    
    AVAssetExportSession *exportSession2 = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetHighestQuality];
    
    NSURL *outputVideoURL2 =dataFilePath(@"tmpPost2.mp4"); //url of exportedVideo
    
    exportSession2.outputURL = outputVideoURL2;
    
    //exportSession2.videoComposition =vidcom;
    
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
//    AVMutableVideoComposition *vidcom = [self CustomVideoComposition:asset];
//    CGSize originalSize = CGSizeMake( _viewPlayer.frame.size.width ,  _viewPlayer.frame.size.height);
//    vidcom.renderSize = originalSize;
//    exportSession.videoComposition =vidcom;
    
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
//    AVMutableVideoComposition *vidcom = [self CustomVideoComposition:asset];
//    CGSize originalSize = CGSizeMake( _viewPlayer.frame.size.width ,  _viewPlayer.frame.size.height);
//    vidcom.renderSize = originalSize;
//    exportSession.videoComposition =vidcom;
//
    
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
           // PlayerDisplayVCViewController *play = [[PlayerDisplayVCViewController alloc]init];
            [self PlayerSetPlayPause:playPause withPlayingStatus:1];
           
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

    _toast.text =[self timeFormatted:(int)time];
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
        [self PlayerSetPlayPause:playPause withPlayingStatus:1];
        //    _toast.text = @"";
        [_seekBar setCenter:CGPointMake( starBoundVal.origin.x+ (starBoundVal.size.width) ,_seekBar.center.y)];
        //    [_toast setCenter:CGPointMake( seekbarAtXPosition +xPosForExtraTime,_toast.center.y)];
        [player seekToTime:CMTimeMakeWithSeconds((videoTotalTime/(_frameGenerateView.frame.size.width))*(starBoundVal.origin.x+starBoundVal.size.width-xPosForExtraTime), NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
        //[self PlayerSetPlayPause:playPause withPlayingStatus:0];
        
    }
    
    if( _seekBar.frame.origin.x < startBound.frame.origin.x){
        CGRect starBoundVal = startBound.frame;
        [_seekBar setCenter:CGPointMake( starBoundVal.origin.x+ (starBoundVal.size.width) ,_seekBar.center.y)];
        //    [_toast setCenter:CGPointMake( seekbarAtXPosition +xPosForExtraTime,_toast.center.y)];
        [player seekToTime:CMTimeMakeWithSeconds((videoTotalTime/(_frameGenerateView.frame.size.width))*(starBoundVal.origin.x+starBoundVal.size.width-xPosForExtraTime), NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
       
        
    }
    
    
    
    
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
#pragma  mark -back

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
//- (IBAction)crossButtonPress:(id)sender {
//    NSLog(@"cross button pressed");
//    [self PlayerSetPlayPause:playPause withPlayingStatus:1];
//    [[self navigationController] popViewControllerAnimated:YES];
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//}




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
