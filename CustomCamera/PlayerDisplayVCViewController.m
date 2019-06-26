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
#import "trimCutSplitView.h"
#import "CropView.h"
#import "canvasView.h"
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
@interface PlayerDisplayVCViewController ()<UITabBarDelegate,UITabBarControllerDelegate>{

    __weak IBOutlet NSLayoutConstraint *playerHeight;
    __weak IBOutlet NSLayoutConstraint *playerWidth;
    AVMutableComposition *mutableComposition ;
    // UIView *seekBar;
    AVMutableComposition *mainComposition ;
    IBOutlet UIButton *playPause;
    AVPlayerItem *playerItem ;
    AVAsset *audioAsset;
    AVAsset *asset;
    AVAsset *asset2;
    NSURL *blurUrl;
    AVAsset *blurAsset;
    AVAssetTrack *videoTrack;
    trimCutSplitView *canvasTrimCutSplit;
    UIView *presentedView;
    CropView *mCropView;
    canvasView *mCanvasView;
    trimCutSplitView *trimCutSplit;
     id observer;
    AVMutableVideoComposition *vidcom;
    float permanentCanvasWidth,permanentCanvasHeight;
}

@end

@implementation NSLayoutConstraint (Multiplier)
-(NSLayoutConstraint *)constraintWithMultiplier:(CGFloat)multiplier
{
    return [NSLayoutConstraint
     constraintWithItem:self.firstItem
     attribute:NSLayoutAttributeHeight
     relatedBy:NSLayoutRelationEqual
     toItem:self.firstItem
     attribute:NSLayoutAttributeWidth
     multiplier:multiplier
     constant:0];
    NSLayoutConstraint *newConstraint = [NSLayoutConstraint constraintWithItem:self.firstItem attribute:self.firstAttribute relatedBy:self.relation toItem:self.secondItem attribute:self.secondAttribute multiplier:multiplier constant:self.constant];
    [newConstraint setPriority:self.priority];
    newConstraint.shouldBeArchived = self.shouldBeArchived;
    newConstraint.identifier = self.identifier;
    newConstraint.active = true;
    return newConstraint;
}
@end

@implementation PlayerDisplayVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    playerHeight.constant = 436 ;
    playerWidth.constant = 414 ;
////
    permanentCanvasWidth = playerWidth.constant;
    permanentCanvasHeight = playerHeight.constant ;
    
   // presentedView = _containerView;
    //[_playerView setFrame:CGRectMake(0, 0, 375, 200)];
  //  [_playerView initWithFrame:CGRectMake(0, 0, 375, 200)];
    //[self.PlayerBC addconstr ]
//    playerWidth.constant = 414 ;
//    playerHeight.constant = 200;
    //[playerWidth setConstant:0.03f];
//   aspectRationPlayer.multiplier = 1.f;
    //aspectRationPlayer.constant = SCREEN_WIDTH * (16.f/9.f);
  //  playerHeight.constant = (436/SCREEN_WIDTH)*SCREEN_WIDTH;
//    playerWidth.constant = 70;
   // [self.playerView setNeedsUpdateConstraints];
 //   NSLog(@"pp sdpsd %f %f",playerWidth,_playerView.frame.size.width);
   // playerHeight.constant = 100;
    AVAsset *videoAssetHorseRide;
    NSString *videoFilePathHorseRiding = [[NSBundle mainBundle] pathForResource:@"BoyHorseRide.mp4" ofType:nil];
    if (videoFilePathHorseRiding != nil) {
        NSURL *videoUrl = [NSURL fileURLWithPath:videoFilePathHorseRiding];
        videoAssetHorseRide = [[AVURLAsset alloc]initWithURL:videoUrl options:nil];

    }
  //  _//viewPlayer.frame.size.height = 200 ;
    ///// navigatiob slide off
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    //NSLog(@"slide %f",sliderScroll.maximumValue);
    // asset = [AVAsset assetWithURL:_videoURL];
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc]init];
    options.version = PHVideoRequestOptionsVersionOriginal;
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    options.networkAccessAllowed = YES;
    __block AVAsset *resultAsset;
    trimCutSplit = [[trimCutSplitView alloc] init];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self LoadView];
    });
    [[PHImageManager defaultManager] requestAVAssetForVideo:_passet options:options resultHandler:^(AVAsset * avasset, AVAudioMix * audioMix, NSDictionary * info) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self->asset = avasset;
                        
                       
                        //[trimCutSplit initView:asset andButton:playPause];
                        mainComposition = [[AVMutableComposition alloc] init];
                        
                        
                       
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

                        self->playerItem = [AVPlayerItem playerItemWithAsset:mainComposition];
                        vidcom = [self CustomVideoComposition:mainComposition];
                        CGSize originalSize = CGSizeMake( _viewPlayer.frame.size.width ,  _viewPlayer.frame.size.height);
                        self->vidcom.renderSize = originalSize;
                        self->playerItem.videoComposition = vidcom;
                        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:self->playerItem];
                        self.player = [AVPlayer playerWithPlayerItem:self->playerItem];
                       
                       // [self.playerView setNeedsDisplay];
                        [self.playerView setPlayer:self.player];
                    });
                    
                    //dispatch_semaphore_signal(semaphore);
                }];
    
    
  
}

- (AVMutableVideoComposition*)CustomVideoComposition:(AVMutableComposition*)composition{
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    CIFilter *filter2 = [CIFilter filterWithName:@"CIGaussianBlur"];
    CIFilter *filter3 = [CIFilter filterWithName:@"CISourceOverCompositing"];
    return [AVMutableVideoComposition videoCompositionWithAsset: composition applyingCIFiltersWithHandler:^(AVAsynchronousCIImageFilteringRequest *request){
        
        CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
        CIFilter *filter2 = [CIFilter filterWithName:@"CIGaussianBlur"];
        CIFilter *filter3 = [CIFilter filterWithName:@"CISourceOverCompositing"];
        CIImage *output = [request.sourceImage imageByClampingToExtent];
        output = [output imageByCroppingToRect:request.sourceImage.extent];
        CGSize videoSize = CGSizeApplyAffineTransform(videoTrack.naturalSize,videoTrack.preferredTransform);
        videoSize = CGSizeMake(fabs(videoSize.width), fabs(videoSize.height));
        CGSize originalSize = CGSizeMake( _playerView.frame.size.width ,   _playerView.frame.size.height );
//        originalSize.width = permanentCanvasWidth;
//        originalSize.height = permanentCanvasHeight;
        NSLog(@"asdasdasd %f %f %f %f %f %f",originalSize.width,originalSize.height,videoSize.width,videoSize.height,output.extent.size.width,output.extent.size.height);
   
        CGAffineTransform scale ;
        CGAffineTransform translate;
        CGAffineTransform origTrans = videoTrack.preferredTransform ;
        if(videoSize.width>videoSize.height){
            scale = CGAffineTransformMakeScale(originalSize.width/videoSize.width, originalSize.width/videoSize.width);
            origTrans = CGAffineTransformConcat(origTrans, scale);
            double height = fabs(originalSize.width/videoSize.width)*videoSize.height;
            translate = CGAffineTransformMakeTranslation((permanentCanvasWidth-originalSize.width)/2, (permanentCanvasHeight-height)/2);
            origTrans=  CGAffineTransformConcat(origTrans,translate) ;
            
        }else {
            scale = CGAffineTransformMakeScale((originalSize.height/videoSize.height),(originalSize.height/videoSize.height));
            origTrans = CGAffineTransformConcat(origTrans, scale);
            double width = fabs(originalSize.height/videoSize.height)*videoSize.width;
            double height =(originalSize.height/originalSize.height)*videoSize.height;
            NSLog(@"width %f %f",width,height);
            translate = CGAffineTransformMakeTranslation(((permanentCanvasWidth)-width)/2, (permanentCanvasHeight-originalSize.height)/2);
            origTrans=  CGAffineTransformConcat(origTrans,translate) ;
        }
        
        CGAffineTransform scale2 ;
        CGAffineTransform translate2;
        CGAffineTransform origTrans2 = videoTrack.preferredTransform ;
        if(videoSize.width>videoSize.height){
            scale2 = CGAffineTransformMakeScale(fabs(originalSize.width/videoSize.width), fabs(originalSize.height/videoSize.height));
            origTrans2 = CGAffineTransformConcat(origTrans2, scale2);
            double height = fabs(originalSize.width/videoSize.width)*videoSize.height;
            translate2 = CGAffineTransformMakeTranslation((permanentCanvasWidth-originalSize.width)/2,  (permanentCanvasHeight-originalSize.height)/2);
            origTrans2=  CGAffineTransformConcat(origTrans2,translate2) ;
        }else {
            scale2 = CGAffineTransformMakeScale(fabs(originalSize.width/videoSize.width), fabs(originalSize.height/videoSize.height));
            origTrans2 = CGAffineTransformConcat(origTrans2, scale2);
            double width = fabs(originalSize.height/videoSize.height)*videoSize.width;
            translate2 = CGAffineTransformMakeTranslation(((permanentCanvasWidth)-originalSize.width)/2, (permanentCanvasHeight-originalSize.height)/2);
            origTrans2=  CGAffineTransformConcat(origTrans2,translate2) ;
        }
//              NSLog(@"%@",origTrans);
        CGAffineTransform ok = CGAffineTransformConcat(scale, translate);
        CIImage *p = [output imageByApplyingTransform:origTrans] ;
        [filter2 setValue:[output imageByApplyingTransform:origTrans2] forKey:kCIInputImageKey];
        [filter setValue:p forKey:kCIInputImageKey];

        [filter setValue:@(0.0) forKey:kCIInputRadiusKey];
        [filter2 setValue:@(0.0) forKey:kCIInputRadiusKey];


        [filter3 setValue:filter2.outputImage forKey:kCIInputBackgroundImageKey];
        [filter3 setValue:filter.outputImage forKey:kCIInputImageKey];
        [request finishWithImage:filter3.outputImage context:nil];
    }];
}



- (IBAction)backButtonPressed:(id)sender {
    [self PlayerSetPlayPause:playPause withPlayingStatus:1];
    self.player= nil;
    playerItem = nil;
    
    // [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
    // [self presentViewController:cameraWindow  animated:YES completion:nil];
}
#pragma  mark -play/pause
- (IBAction)playPauseAction:(id)sender {
    UIButton *btn = (UIButton*)sender;
    [self PlayerSetPlayPause:btn withPlayingStatus:self.player.rate];
}

- (void) PlayerSetPlayPause : (UIButton*)btn withPlayingStatus:(float)rate{
    if (rate) {
        [self.player pause];
        //   [btn setTitle:@"Play" forState:UIControlStateNormal];
        if (observer) {
            [self.player removeTimeObserver:observer];
            observer = nil;
        }
        
        // [self.timer invalidate];
    }else{
        
        //  [btn setTitle:@"Pause" forState:UIControlStateNormal];
        
        observer = [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1/ 60.0, NSEC_PER_SEC)
                                                        queue:NULL
                                                   usingBlock:^(CMTime time){
                                                      //[self updateSlider];
                                                   }];
        [self.player play];
        //  self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
    }
}
- (void) LoadView{
    canvasTrimCutSplit = [self loadFromNib:@"trimCutSplitView" classToLoad:[trimCutSplitView class]];
    canvasTrimCutSplit.frame = CGRectMake(0, SCREEN_HEIGHT, _containerView.frame.size.width, _containerView.frame.size.height);
    [[self.view viewWithTag:3223] addSubview:canvasTrimCutSplit];
    [canvasTrimCutSplit updateConstraintsIfNeeded];
    
    mCanvasView = [self loadFromNib:@"canvasView" classToLoad:[canvasView class]];
    mCanvasView.frame = CGRectMake(0, SCREEN_HEIGHT, _containerView.frame.size.width, _containerView.frame.size.height);
    [[self.view viewWithTag:3223] addSubview:mCanvasView];
    [mCanvasView updateConstraintsIfNeeded];
    
    
    
    
}

- (id)loadFromNib:(NSString *)name classToLoad:(Class)classToLoad {
    NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:name owner:self options:nil];
    for (id object in bundle) {
        if ([object isKindOfClass:classToLoad]) {
            return object;
        }
    }
    return nil;
}



- (void) AnimateView:(UIView*)view{
    [UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^{
        [self->presentedView setFrame:CGRectMake(0, SCREEN_HEIGHT, self->presentedView.frame.size.width, self->presentedView.frame.size.height)];
        [view setFrame:self->_containerView.frame];
    } completion:^(BOOL finished) {
        if (finished) {
            self->presentedView = view;
            
        }
    }];
}
-(void)call{
    CGSize originalSize = CGSizeMake( _viewPlayer.frame.size.width ,  _viewPlayer.frame.size.height);
    
    playerWidth.constant = 200 ;
    playerHeight.constant = 200;
    [self.playerView setNeedsUpdateConstraints];
    self->playerItem.videoComposition = vidcom;
    vidcom = [self CustomVideoComposition:mainComposition];
    vidcom.renderSize = originalSize;
    self->playerItem.videoComposition = vidcom;
   
}
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    if(item.tag == 0 ){
        NSLog(@"1 pressed");
        [self AnimateView:canvasTrimCutSplit];
        
//        playerHeight.constant = 210 ;
//        playerWidth.constant = 375 ;
//
//        playerHeight.constant = 232.875 ;
//        playerWidth.constant = 414 ;
//
        
        [UIView animateWithDuration:1
                                      animations:^{
                                         
                                          playerHeight.constant = 232.875 ;
                                          playerWidth.constant = 414 ;

                                          [self.playerView layoutIfNeeded];
                                      }
                                      completion:^(BOOL finished){
                                          
                                          
                                          NSLog(@"The animation has now stopped!");
                                      }];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [canvasTrimCutSplit initView:asset andButton:playPause player:_player];
           
        });
        
    }else if(item.tag == 1 ){
        NSLog(@"pressed dddddddd");
        
        [UIView animateWithDuration:0.02
                         animations:^{
                             // _viewPlayer.frame = CGRectMake(100 , 100, 200, 200);
                            
                             playerHeight.constant = 436     ;
                             playerWidth.constant = 348.8;
                           
                             [self.playerView layoutIfNeeded];
                         }
                         completion:^(BOOL finished){
                             
//                             CGSize originalSize = CGSizeMake( _viewPlayer.frame.size.width ,  _viewPlayer.frame.size.height);
//
//
//                             vidcom = [self CustomVideoComposition:mainComposition];
//                             vidcom.renderSize = originalSize;
//                             self->playerItem.videoComposition = vidcom;

                             NSLog(@"The animation has now stopped!");
                         }];
        [self AnimateView:mCanvasView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           // [mCanvasView initView:asset andButton: player:_player];
        });
    }else if(item.tag == 2 ){
        NSLog(@"pressed dddddddd");
        [UIView animateWithDuration:1
                         animations:^{
                             // _viewPlayer.frame = CGRectMake(100 , 100, 200, 200);
                             
//                             for( int i = 375; i <= (375-250) ; i ++ ){
//                                 playerHeight.constant = i ;
//                             }
                             playerHeight.constant = 436;
                             playerWidth.constant = 218;
                             [self.playerView layoutIfNeeded];
                         }
                         completion:^(BOOL finished){
                             //                             CGSize originalSize = CGSizeMake( _viewPlayer.frame.size.width ,  _viewPlayer.frame.size.height);
                             //
                             //
                             //                             vidcom = [self CustomVideoComposition:mainComposition];
                             //                             vidcom.renderSize = originalSize;
                             //                             self->playerItem.videoComposition = vidcom;
                             
                             NSLog(@"The animation has now stopped!");
                         }];
        [self AnimateView:mCanvasView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // [mCanvasView initView:asset andButton: player:_player];
        });
    }else if(item.tag == 3 ){
        NSLog(@"pressed dddddddd");
        [UIView animateWithDuration:1
                         animations:^{
                             // _viewPlayer.frame = CGRectMake(100 , 100, 200, 200);
                             playerHeight.constant = 200 ;
                             playerWidth.constant = 250;
                             [self.playerView layoutIfNeeded];
                         }
                         completion:^(BOOL finished){
                             //                             CGSize originalSize = CGSizeMake( _viewPlayer.frame.size.width ,  _viewPlayer.frame.size.height);
                             //
                             //
                             //                             vidcom = [self CustomVideoComposition:mainComposition];
                             //                             vidcom.renderSize = originalSize;
                             //                             self->playerItem.videoComposition = vidcom;
                             
                             NSLog(@"The animation has now stopped!");
                         }];
        [self AnimateView:mCanvasView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // [mCanvasView initView:asset andButton: player:_player];
        });
    }
    //NSLog(@" pressed");
}
@end


