//
//  thumbnailScrollView.m
//  CameraProject
//
//  Created by Tawhid Joarder on 4/24/19.
//  Copyright © 2019 BrainCraft LTD. All rights reserved.
//

#import "thumbnailScrollView.h"

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

@implementation thumbnailScrollView
- (id)initWithFrame:(CGRect)frame withDelegate:(id<canvasViewDelegate>) delegate andAsset:(AVAsset *)asset  frameView:(UIView *) frameGenerateView{
    self = [super initWithFrame:frame];
    self.backgroundColor = [ UIColor clearColor ];
    
     imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    //self.scrollEnabled = FALSE;
    ///scroll view container size calculation
    
    duration = asset.duration;
    flag = false ;
    totalTime = CMTimeGetSeconds(duration);
    NSLog(@"total time here %f %f",totalTime,ceil(totalTime*(3))*100);
    NSLog(@"hhhh %f %f",frameGenerateView.frame.size.height,frameGenerateView.frame.size.width);
    totalFrame = frameGenerateView.frame.size.width/frameGenerateView.frame.size.height;
    oneframeTakeTime = totalTime/totalFrame;
    if ( oneframeTakeTime < 1){
        flag = true ;
        framePerSec = totalFrame/totalTime;
        if(framePerSec*totalTime < totalFrame){
            framePerSec += 1;
        }
    }
    NSLog(@"fram %d %d",framePerSec,oneframeTakeTime);
    self.contentSize= CGSizeMake(totalFrame*frameGenerateView.frame.size.height, frameGenerateView.frame.size.height);
    
   // NSLog(@"aaaaaaaaaa %f",totalTime*(5)*100);
    NSLog(@"ok aise");
    self.delegator = delegate;
    [self.delegator updateTotalTime:totalTime];
    //seekbar initialization
    [self generateFramefromvideo:asset];
    


    
    
    return self ;
}
// Get Image From Asset with CMTime
- (UIImage*) getImageFromAsset:(AVAsset*)asset atTime:(CMTime)cmTime {
    
    // Image Generator
    imageGenerator.maximumSize = CGSizeMake(300, 300);
    
    CMTime actualTime;
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:cmTime actualTime:&actualTime error:nil];
    UIImage *image = [UIImage imageWithCGImage: imageRef scale: 1.0 orientation: [self orientTheFrame:asset]];
    CGImageRelease(imageRef);
    
    return image;
}

// Get Video Orientation
- (UIImageOrientation) orientTheFrame : (AVAsset *) asset{
    if([self getVideoOrientationFromAsset:asset] == UIImageOrientationUp)
        return UIImageOrientationRight;
    if([self getVideoOrientationFromAsset:asset] == UIImageOrientationLeft)
        return UIImageOrientationDown;
    return UIImageOrientationUp;
}
- (UIImageOrientation)getVideoOrientationFromAsset:(AVAsset *)asset
{
    AVAssetTrack *videoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    CGSize size = [videoTrack naturalSize];
    CGAffineTransform txf = [videoTrack preferredTransform];
    
    if (size.width == txf.tx && size.height == txf.ty)
        return UIImageOrientationLeft; //return UIInterfaceOrientationLandscapeLeft;
    else if (txf.tx == 0 && txf.ty == 0)
        return UIImageOrientationRight; //return UIInterfaceOrientationLandscapeRight;
    else if (txf.tx == 0 && txf.ty == size.width)
        return UIImageOrientationDown; //return UIInterfaceOrientationPortraitUpsideDown;
    else
        return UIImageOrientationUp;  //return UIInterfaceOrientationPortrait;
}

-(void) generateFramefromvideo: (AVAsset *) movieAsset{
//    __block int j = 0 ;
//    float imgWidth = self.frame.size.height;
//    float imgHeight = self.frame.size.height;
//    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:movieAsset];
//    generator.requestedTimeToleranceAfter =  kCMTimeZero;
//    generator.requestedTimeToleranceBefore =  kCMTimeZero;
//    __block UIImage *generatedImage;
//    __block UIImageView *imgV ;
    AVMutableComposition *com = [AVMutableComposition composition];
   AVMutableCompositionTrack *videoCompositionTrack = [com addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [videoCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, movieAsset.duration) ofTrack:[[movieAsset tracksWithMediaType:AVMediaTypeVideo] firstObject] atTime:kCMTimeZero error:nil];
//
//    float frameDifference = CMTimeGetSeconds(movieAsset.duration) * videoCompositionTrack.nominalFrameRate / totalFrame ;
//    __block float frame = 0;
//    for (Float64 i = 0; i < CMTimeGetSeconds(movieAsset.duration) * videoCompositionTrack.nominalFrameRate   ; i++){
//
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//             @autoreleasepool {
//                 CMTime time ;
//
//            time= CMTimeMake(i+20,videoCompositionTrack.nominalFrameRate);
//                 frame += frameDifference;
//            NSError *err;
//            CMTime actualTime;
//            CGImageRef image = [generator copyCGImageAtTime:time actualTime:&actualTime error:&err];
//            generatedImage = [[UIImage alloc] initWithCGImage:image];
//
//            dispatch_async(dispatch_get_main_queue(), ^{
//
//                imgV = [[UIImageView alloc] initWithImage:generatedImage];
//
//                NSLog(@"frame number: %f",i);
//
//                imgV.frame = CGRectMake(imgWidth * j++ , 0, imgWidth, imgHeight);
//                // NSLog(@"ff %f",imgWidth *j);
//                [imgV setContentMode:UIViewContentModeScaleAspectFill];
//                [self addSubview:imgV];
//
//
//            });
//            CGImageRelease(image);
//             }
//
//        });
//
//
//
//    }

    
    // Image Width from height with ratio
    float imgHeight = self.frame.size.height;
    float imgWidth = imgHeight;
    
    // Time distance per frame
    float frameRate = videoCompositionTrack.nominalFrameRate;
    int totalFrames = CMTimeGetSeconds(movieAsset.duration) * videoCompositionTrack.nominalFrameRate ;
    NSLog(@"tota %f %d",totalTime,totalFrames);
    Float64 timePerFrame = totalTime/totalFrames;
    __block Float64 timePerFrameInThatBound =(totalTime/totalFrame)-(totalTime/totalFrame)/2;
    NSLog(@"bounr time %f",timePerFrameInThatBound);
    __block Float64 timeStart = 0 ;
    
    dispatch_queue_t queueHigh = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0);
    dispatch_async(queueHigh, ^{
        
        
        //Step through the frames
        for (int counter = 0; counter < (ceil(totalFrame))+4; counter++){
//            if( counter == (ceil(totalFrame)) - 1){
//                timeStart = totalTime ;
//            }
             NSLog(@"bhbh %f %f",timeStart,totalTime);
            UIImage *img = [self getImageFromAsset:movieAsset atTime:CMTimeMakeWithSeconds(timeStart , 600)];
            
            timeStart += timePerFrameInThatBound;
            
            NSLog(@"time stat %f",timeStart);
           
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                UIImageView *imgV = [[UIImageView alloc] initWithImage:img];
                [self addSubview:imgV];
                imgV.frame = CGRectMake(imgWidth*counter , 0, imgWidth, imgHeight);
                [imgV setContentMode:UIViewContentModeScaleAspectFill];
                [imgV setClipsToBounds:YES];
            });
            
            //            NSLog(@"Frame created  %d", counter);
           
        }
    });
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
