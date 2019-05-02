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
- (id)initWithFrame:(CGRect)frame withDelegate:(id<playerDisplayVCViewControllerDelegate>) delegate andAsset:(AVAsset *)asset  frameView:(UIView *) frameGenerateView{
    self = [super initWithFrame:frame];
    self.backgroundColor = [ UIColor clearColor ];
    //self.scrollEnabled = FALSE;
    ///scroll view container size calculation
    CMTime duration;
    duration = asset.duration;
    flag = false ;
    float totalTime = CMTimeGetSeconds(duration);
    //NSLog(@"total time here %f %f",totalTime,ceil(totalTime*(3))*100);
    totalFrame = frameGenerateView.frame.size.width/frameGenerateView.frame.size.height;
    oneframeTakeTime = totalTime/totalFrame;
    if ( oneframeTakeTime < 1){
        flag = true ;
        framePerSec = totalFrame/totalTime;
        if(framePerSec*totalTime < totalFrame){
            framePerSec += 1;
        }
    }
    self.contentSize= CGSizeMake(totalFrame*frameGenerateView.frame.size.height, frameGenerateView.frame.size.height);
    
   // NSLog(@"aaaaaaaaaa %f",totalTime*(5)*100);
    NSLog(@"ok aise");
    self.delegator = delegate;
    [self.delegator updateTotalTime:totalTime];
    //seekbar initialization
    [self generateFramefromvideo:asset];
    


    
    
    return self ;
}

-(void) generateFramefromvideo: (AVAsset *) movieAsset
{
    
    
    NSLog(@"I am here");
    
    AVAssetTrack *videoAssetTrack= [[movieAsset tracksWithMediaType:AVMediaTypeVideo] lastObject];
    NSError *error;
    __block int i = 0,j=0;
    AVMutableComposition *com = [AVMutableComposition composition];
    AVMutableCompositionTrack *videoCompositionTrack = [com addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [videoCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, movieAsset.duration) ofTrack:[[movieAsset tracksWithMediaType:AVMediaTypeVideo] firstObject] atTime:kCMTimeZero error:nil];
    
    //Video asset er
    videoCompositionTrack.preferredTransform = videoAssetTrack.preferredTransform;
    AVAssetReader *reader = [[AVAssetReader alloc] initWithAsset:com error:&error];
    CGSize size = videoCompositionTrack.naturalSize;
    float imgHeight = self.frame.size.height;
    float imgWidth =self.frame.size.height ;
    //imgHeight * (size.width/size.height);
    size = CGSizeMake(imgWidth * [UIScreen mainScreen].scale *1.5, imgHeight * [UIScreen mainScreen].scale*1.5 );

    //    size = CGSizeMake(imgWidth, imgHeight);
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, com.duration);
    
    AVMutableVideoCompositionLayerInstruction* transformer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoCompositionTrack];
    
    

    CGSize originalSize = CGSizeApplyAffineTransform(videoCompositionTrack.naturalSize, videoCompositionTrack.preferredTransform);
    originalSize = CGSizeMake(fabs(originalSize.width), fabs(originalSize.height));
    
    
    CGFloat scaleX = (size.width / originalSize.width)*2;
    CGFloat scaleY = size.height /originalSize.height;

    CGAffineTransform origTrans = videoCompositionTrack.preferredTransform;
    CGAffineTransform scaleTrans;
    if(originalSize.height < originalSize.width){
             scaleTrans = CGAffineTransformConcat(origTrans, CGAffineTransformMakeScale(scaleX, scaleY));
    }else{
             scaleTrans = CGAffineTransformConcat(origTrans, CGAffineTransformMakeScale(scaleX/2, scaleX/2));
    }

    
    [transformer setTransform:scaleTrans atTime:kCMTimeZero];
    
    
    instruction.layerInstructions = [NSArray arrayWithObject:transformer];

    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    if(flag){
        videoComposition.frameDuration = CMTimeMake( 1,framePerSec);
    }else {
        videoComposition.frameDuration = CMTimeMake( oneframeTakeTime,1);
    }
    
    videoComposition.renderSize = size ;
    videoComposition.instructions = [NSArray arrayWithObject:instruction];
    
    AVAssetReaderVideoCompositionOutput *assetReaderVideoCompositionOutput = [[AVAssetReaderVideoCompositionOutput alloc] initWithVideoTracks:[com tracksWithMediaType:AVMediaTypeVideo] videoSettings:@{(id)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA),
                                                                                                                                                                                                         (id)kCVPixelBufferWidthKey : [NSNumber numberWithFloat:size.width],
                                                                                                                                                                                                         (id)kCVPixelBufferHeightKey: [NSNumber numberWithFloat:size.height]
                                                                                                                                                                                                         }];
    assetReaderVideoCompositionOutput.videoComposition = videoComposition;
    assetReaderVideoCompositionOutput.alwaysCopiesSampleData = NO;
    [reader addOutput:assetReaderVideoCompositionOutput];
    
    [reader startReading];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSLog(@"%ld",(long)reader.status);
        
        while (reader.status == AVAssetReaderStatusReading) {
            CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(assetReaderVideoCompositionOutput.copyNextSampleBuffer);
            CVPixelBufferLockBaseAddress(imageBuffer,0);        // Lock the image buffer
            
            uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0);   // Get information of the image
            size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
            size_t width = CVPixelBufferGetWidth(imageBuffer);
            size_t height = CVPixelBufferGetHeight(imageBuffer);
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            
            CGContextRef newContext = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
            CGImageRef newImage = CGBitmapContextCreateImage(newContext);
            CGContextRelease(newContext);
            
            CGColorSpaceRelease(colorSpace);
            CVPixelBufferUnlockBaseAddress(imageBuffer,0);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:newImage]];
                
                NSLog(@"frame number: %d",i);
                
                j = i ;
                imgV.frame = CGRectMake(imgWidth * i++ , 0, imgWidth, imgHeight);
               // NSLog(@"ff %f",imgWidth *j);
                [imgV setContentMode:UIViewContentModeScaleAspectFill];
                [self addSubview:imgV];
                
            });
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
