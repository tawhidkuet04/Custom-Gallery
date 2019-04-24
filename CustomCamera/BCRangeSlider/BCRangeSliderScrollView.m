//
//  BCSliderScrollView.m
//  BCRangeSlider
//
//  Created by Brain Craft Ltd. on 12/2/18.
//  Copyright © 2018 Brain Craft Ltd. All rights reserved.
//

#import "BCRangeSliderScrollView.h"

@implementation BCRangeSliderScrollView {
    
    // Duration Of Asset
    Float64 duration;
    
    // Padding
    float padding;
    
    // Orientation of Asset
    UIImageOrientation orientation;
    
    // Image Generator
    AVAssetImageGenerator *imageGenerator;
    
    // Time Bar View
    UIView *timeBar;
}

// Init with frame
- (id)initWithFrame:(CGRect)frame padding:(float) padding_ andAsset:(AVAsset *)asset assetTrack:( AVAssetTrack *)clipVideoTrack {
    
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor colorWithDisplayP3Red:0.07 green:0.07 blue:0.07 alpha:0.9];
    //    self.backgroundColor = [UIColor clearColor];
    
    if (asset == nil) {
        NSLog(@"Asset is nil");
        return self;
    }
    
    // Asset Duration
    duration = CMTimeGetSeconds(asset.duration);
    NSLog(@"Duration: %f",duration);
    
    // Total Frames
    [self calculateNoOfFrames: asset];
    
    // Determine Container View Size
    _containerSize = CGSizeMake(self.frame.size.height*_totalFrames, self.frame.size.height);
    NSLog(@"Content Size: %f x %f",_containerSize.width, _containerSize.height);
    
    // Padding
    padding = _containerSize.height*0.4;
    
    // Set Content Size of Scroll View
    self.contentSize = CGSizeMake(_containerSize.width+padding*2, _containerSize.height);
    
    
    // Orientation
    orientation = [self orientTheFrame:asset];
    
    // Image Generator
    imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    // Generate Images
    [self generateFrame:asset  assetTrack:clipVideoTrack];
    
    // Pixel Per Second
    _pixelPerSecond = (self.frame.size.height*_totalFrames)/duration;
    NSLog(@"Pixel Per Second %f", _pixelPerSecond);
    
    return self;
}


- (void) calculateNoOfFrames : (AVAsset *) asset {
    
    // Total Frames
    int noOfMinFrames = (int)ceil(self.frame.size.width/self.frame.size.height);
    //    NSLog(@"Number of Reqired Frames: %d", noOfMinFrames);
    
    if (duration <= noOfMinFrames) {
        _totalFrames = noOfMinFrames;
    } else {
        float d = duration;
        float times = (d-noOfMinFrames)/noOfMinFrames;
        _totalFrames = noOfMinFrames + (d-noOfMinFrames)/(noOfMinFrames+times*0.1);
        // 4-4, 12-5, 25-8, 50-12, 100-19, 200-26, 300-29, 500-34, 700-36, 1000-38, 1200-39, 1500-40
        NSLog(@"Total Frames: %d",_totalFrames);
    }
}


-(void) generateFrame : (AVAsset *) movieAsset  assetTrack:( AVAssetTrack *)clipVideoTrack {
    
    // Image Width from height with ratio
    float imgHeight = _containerSize.height;
    float imgWidth = imgHeight;
    // Time distance per frame
    NSError *error;
    __block int i = 0;
//    AVMutableComposition *com = [AVMutableComposition composition];
//    AVMutableCompositionTrack *videoCompositionTrack = [com addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
//    [videoCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, movieAsset.duration) ofTrack:[[movieAsset tracksWithMediaType:AVMediaTypeVideo] firstObject] atTime:kCMTimeZero error:nil];
//
//    AVAssetReader *reader = [[AVAssetReader alloc] initWithAsset:com error:&error];
//    CGSize size = clipVideoTrack.naturalSize;
//    float imgWidth = imgHeight * (size.width/size.height);
//    size = CGSizeMake(imgWidth * [UIScreen mainScreen].scale, imgHeight * [UIScreen mainScreen].scale);
//    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
//    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, com.duration);
//    AVMutableVideoCompositionLayerInstruction* transformer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoCompositionTrack];
//    [transformer setTransform:[[movieAsset tracksWithMediaType:AVMediaTypeVideo] firstObject].preferredTransform atTime:kCMTimeZero];
//    instruction.layerInstructions = [NSArray arrayWithObject:transformer];
//
//    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
//    videoComposition.frameDuration = CMTimeMake(1, 1);
//    videoComposition.renderSize = size;
//    videoComposition.instructions = [NSArray arrayWithObject:instruction];
//
//    AVAssetReaderVideoCompositionOutput *assetReaderVideoCompositionOutput = [[AVAssetReaderVideoCompositionOutput alloc] initWithVideoTracks:[com tracksWithMediaType:AVMediaTypeVideo] videoSettings:@{(id)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA),
//                                                                                                                                                                                                                (id)kCVPixelBufferWidthKey : [NSNumber numberWithFloat:size.width],
//                                                                                                                                                                                                                (id)kCVPixelBufferHeightKey: [NSNumber numberWithFloat:size.height]
//                                                                                                                                                                                                                }];
//    assetReaderVideoCompositionOutput.videoComposition = videoComposition;
//    assetReaderVideoCompositionOutput.alwaysCopiesSampleData = NO;
//    [reader addOutput:assetReaderVideoCompositionOutput];
//
//    [reader startReading];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//        NSLog(@"%ld",(long)reader.status);
//
//        while (reader.status == AVAssetReaderStatusReading) {
//            CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(assetReaderVideoCompositionOutput.copyNextSampleBuffer);
//            CVPixelBufferLockBaseAddress(imageBuffer,0);        // Lock the image buffer
//
//            uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0);   // Get information of the image
//            size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
//            size_t width = CVPixelBufferGetWidth(imageBuffer);
//            size_t height = CVPixelBufferGetHeight(imageBuffer);
//            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//
//            CGContextRef newContext = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
//            CGImageRef newImage = CGBitmapContextCreateImage(newContext);
//            CGContextRelease(newContext);
//
//            CGColorSpaceRelease(colorSpace);
//            CVPixelBufferUnlockBaseAddress(imageBuffer,0);
//
//            dispatch_async(dispatch_get_main_queue(), ^{
//
//                UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:newImage]];
//                            [self addSubview:imgV];
//                            imgV.frame = CGRectMake(imgWidth * i++ , 0, imgWidth, imgHeight);
//                            [imgV setContentMode:UIViewContentModeScaleToFill];
//                            [self setClipsToBounds:NO];
//
//                UIView *shadow = [[UIView alloc] initWithFrame:CGRectMake(self->padding - imgWidth , 0, imgWidth, imgHeight)];
//                shadow.backgroundColor = [UIColor colorWithDisplayP3Red:1 green:1 blue:1 alpha:0.35];
////                [self addSubview:shadow];
////                // Create View
////                if (self->_sliderDelegate != nil) {
////                    [self performSelectorOnMainThread:@selector(frameGenerationisDone) withObject:nil waitUntilDone:YES];
////                }
////
//            });
//        }
//    });

    Float64 timePerFrame = duration/_totalFrames;

    dispatch_queue_t queueHigh = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0);
    dispatch_async(queueHigh, ^{

        // 0th frame
        dispatch_sync(dispatch_get_main_queue(), ^{

            // Frame
            UIImage *img = [self getImageFromAsset:movieAsset atTime:CMTimeMakeWithSeconds(0, 600) assetTrack:clipVideoTrack];
            UIImageView *imgV = [[UIImageView alloc] initWithImage:img];
            [self addSubview:imgV];
            imgV.frame = CGRectMake(self->padding - imgWidth , 0, imgWidth, imgHeight);
            [imgV setContentMode:UIViewContentModeScaleAspectFill];
            [imgV setClipsToBounds:YES];

            // Shadow
            UIView *shadow = [[UIView alloc] initWithFrame:CGRectMake(self->padding - imgWidth , 0, imgWidth, imgHeight)];
            shadow.backgroundColor = [UIColor colorWithDisplayP3Red:1 green:1 blue:1 alpha:0.35];
            [self addSubview:shadow];
        });

        //Step through the frames
        for (int counter = 0; counter < self->_totalFrames; counter++){

            Float64 secondsIn = timePerFrame/2.0 + timePerFrame*counter;
            UIImage *img = [self getImageFromAsset:movieAsset atTime:CMTimeMakeWithSeconds(secondsIn, 600)  assetTrack:clipVideoTrack];

            dispatch_sync(dispatch_get_main_queue(), ^{

                UIImageView *imgV = [[UIImageView alloc] initWithImage:img];
                [self addSubview:imgV];
                imgV.frame = CGRectMake(self->padding + imgWidth*counter , 0, imgWidth, imgHeight);
                [imgV setContentMode:UIViewContentModeScaleAspectFill];
                [imgV setClipsToBounds:YES];
            });

            //            NSLog(@"Frame created  %d", counter);
            if (counter == self->_totalFrames - 1) {
                dispatch_async(dispatch_get_main_queue(), ^{

                    // (n+1)th frame
                    UIImage *img = [self getImageFromAsset:movieAsset atTime:CMTimeMakeWithSeconds(self->duration, 600) assetTrack:clipVideoTrack];
                    UIImageView *imgV = [[UIImageView alloc] initWithImage:img];
                    [self addSubview:imgV];
                    imgV.frame = CGRectMake(self->padding + imgWidth*(counter+1) , 0, imgWidth, imgHeight);
                    [imgV setContentMode:UIViewContentModeScaleAspectFill];
                    [imgV setClipsToBounds:YES];

                    // Shadow
                    UIView *shadow = [[UIView alloc] initWithFrame:CGRectMake(self->padding + imgWidth*(counter+1) , 0, imgWidth, imgHeight)];
                    shadow.backgroundColor = [UIColor colorWithDisplayP3Red:1 green:1 blue:1 alpha:0.35];
                    [self addSubview:shadow];

                    // Create View
                    if (self->_sliderDelegate != nil) {
                        [self performSelectorOnMainThread:@selector(frameGenerationisDone) withObject:nil waitUntilDone:YES];
                    }
                });
            }
        }
    });
}

/*
 
 + (void)extractFrameFromVideoURL:(AVAsset*)videoAsset videoComposition:(AVMutableVideoComposition*)videoComposition framesPerSecond:(int)framesPerSecond gifSize:(GIFSize)gifSize handler:(void(^)(NSArray*))handler{
 float numberOfFrames = CMTimeGetSeconds(videoAsset.duration) * (int)framesPerSecond;
 AVMutableComposition *com = [AVMutableComposition composition];
 AVMutableCompositionTrack *videoCompositionTrack = [com addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
 [videoCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject] atTime:kCMTimeZero error:nil];
 
 NSError *error = nil;
 AVAssetReader *reader = [[AVAssetReader alloc] initWithAsset:com error:&error];
 
 //get video track
 NSArray *videoTracks = [videoAsset tracksWithMediaType:AVMediaTypeVideo];
 AVAssetTrack *videoTrack = [videoTracks objectAtIndex:0];
 
 CGRect originalRect = CGRectApplyAffineTransform(CGRectMake(0, 0, videoTrack.naturalSize.width, videoTrack.naturalSize.height), videoTrack.preferredTransform);
 CGSize originalSize = CGSizeApplyAffineTransform(videoTrack.naturalSize, videoTrack.preferredTransform);
 originalSize = CGSizeMake(fabs(originalSize.width), fabs(originalSize.height));
 
 CGFloat deviceScale = [[UIScreen mainScreen] scale];
 CGSize size = CGSizeMake(SCREEN_WIDTH deviceScale, SCREEN_WIDTH deviceScale);
 if (originalSize.width > originalSize.height) {
 size.height = (SCREEN_WIDTH deviceScale) (originalSize.height / originalSize.width);
 }else if (originalSize.width < originalSize.height){
 size.width = (SCREEN_WIDTH deviceScale) (originalSize.width / originalSize.height);
 }
 
 size = CGSizeMake(ceil(size.width), ceil(size.height));
 
 NSDictionary *options = @{(id)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA),
 (id)kCVPixelBufferWidthKey : [NSNumber numberWithFloat:size.width],
 (id)kCVPixelBufferHeightKey: [NSNumber numberWithFloat:size.height]
 };
 
 // AVMutableVideoComposition* videoComposition = [AVMutableVideoComposition videoComposition];
 videoComposition.frameDuration = CMTimeMake(1, (int)framesPerSecond);
 NSLog(@"FrameDuration11111: %@", [NSValue valueWithCMTime:videoComposition.frameDuration]);
 
 AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
 instruction.timeRange = CMTimeRangeMake(kCMTimeZero, com.duration); //CMTimeMakeWithSeconds(60, 30));
 
 AVMutableVideoCompositionLayerInstruction* transformer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoCompositionTrack];
 
 videoComposition.renderSize = size;
 
 NSLog(@"%f %f<===",size.width, size.height);
 
 CGFloat scaleX = size.width / originalSize.width;
 
 CGFloat translateX = (originalRect.origin.x/originalRect.size.width) * size.width;
 CGFloat translateY = (originalRect.origin.y/originalRect.size.height) * size.height;
 
 CGAffineTransform origTrans = videoTrack.preferredTransform;
 CGAffineTransform scaleTrans = CGAffineTransformConcat(origTrans, CGAffineTransformMakeScale(scaleX, scaleX));
 CGAffineTransform translateTrans = CGAffineTransformConcat(scaleTrans, CGAffineTransformMakeTranslation(-translateX, -translateY));
 
 [transformer setTransform:translateTrans atTime:kCMTimeZero];
 
 instruction.layerInstructions = [NSArray arrayWithObject:transformer];
 videoComposition.instructions = [NSArray arrayWithObject: instruction];
 
 AVAssetReaderVideoCompositionOutput *asset_reader_output = [[AVAssetReaderVideoCompositionOutput alloc] initWithVideoTracks:[com tracksWithMediaType:AVMediaTypeVideo] videoSettings:options];
 asset_reader_output.videoComposition = videoComposition;
 asset_reader_output.alwaysCopiesSampleData = NO;
 [reader addOutput:asset_reader_output];
 
 [reader startReading];
 
 __block int i = 0;
 NSMutableArray *imgArray = [NSMutableArray new];
 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
 
 while ( [reader status]==AVAssetReaderStatusReading ) {
 NSLog(@"i is %d", i);
 NSString *str;
 @autoreleasepool {
 CMSampleBufferRef sampleBuffer = [asset_reader_output copyNextSampleBuffer];
 if(i % 1 == 0 && sampleBuffer)
 {
 NSLog(@"Copying Frame");
 // if(!sampleBuffer)
 // continue;
 CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
 
 // Lock the base address of the pixel buffer
 CVPixelBufferLockBaseAddress(imageBuffer, 0);
 
 // Get the number of bytes per row for the pixel buffer
 size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
 
 // Get the pixel buffer width and height
 size_t width = CVPixelBufferGetWidth(imageBuffer);
 size_t height = CVPixelBufferGetHeight(imageBuffer);
 
 //Generate image to edit
 unsigned char pixel = (unsigned char )CVPixelBufferGetBaseAddress(imageBuffer);
 CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
 CGContextRef context=CGBitmapContextCreate(pixel, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little|kCGImageAlphaPremultipliedFirst);
 
 CGImageRef image = CGBitmapContextCreateImage(context);
 //CIImage *var = [CIImage imageWithCGImage:imageRef];
 //var = [var imageByApplyingTransform:videoTrack.preferredTransform];
 UIImage* myImage = [[UIImage alloc] initWithCGImage:image];
 
 //initWithCIImage:var scale:1.0 orientation:UIImageOrientationUp];
 
 NSDate *now = [NSDate date];
 NSTimeInterval nowEpochSeconds = [now timeIntervalSince1970];
 str = [[[NSString stringWithFormat:@"%f",nowEpochSeconds] stringByReplacingOccurrencesOfString:@"." withString:@"_"] stringByAppendingString:@".jpg"];
 [UIImage saveImageToDirectoryWithImage:myImage withName:str withCompletionHandler:^(BOOL bCompleted, NSInteger counts) {
 }];
 [imgArray addObject:str];
 //}
 
 CGImageRelease(image);
 CGContextRelease(context);
 CGColorSpaceRelease(colorSpace);
 //sleep(0.01);
 }
 
 if(sampleBuffer)
 {
 CMSampleBufferInvalidate(sampleBuffer);
 CFRelease(sampleBuffer);
 sampleBuffer = nil;
 }
 }
 dispatch_async(dispatch_get_main_queue(), ^{
 [SVProgressHUD showProgress:i++/numberOfFrames status:@"Processing..."];
 });
 
 }
 if ([reader status] == AVAssetReaderStatusCompleted) {
 dispatch_async(dispatch_get_main_queue(), ^{
 [SVProgressHUD showSuccessWithStatus:@"Completed"];
 });
 handler(imgArray.copy);
 }
 
 if ([reader status] == AVAssetReaderStatusFailed) {
 dispatch_async(dispatch_get_main_queue(), ^{
 [SVProgressHUD showErrorWithStatus:@"Failed Please try again!"];
 });
 NSLog(@"%@",reader.error.debugDescription);
 }
 });
 
 }
 
 */


- (void) frameGenerationisDone {
    
//    [self createTimeBar];
    
    // Call Degated Method
    [_sliderDelegate frameGenerationDone];
}

// Create Time Bar
- (void) createTimeBar {
    
    CGSize containerSize = self.contentSize;
    
    // Create Time Bar
    float barHeight = self.frame.size.height/6;
    timeBar = [[UIView alloc] initWithFrame:CGRectMake(padding, 0, containerSize.width, barHeight)];
    timeBar.backgroundColor = [UIColor colorWithDisplayP3Red:1 green:1 blue:1 alpha:0.3];
    [self addSubview:timeBar];
    
    // Bar Label
    for (int i = 0; i <= duration+1; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.pixelPerSecond*i - barHeight/2, barHeight*0.65, barHeight, barHeight/2)];
        label.text = @"|";
        //        label.backgroundColor = [UIColor colorWithDisplayP3Red:1 green:1 blue:1 alpha:0.5];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"Verdana" size:barHeight*0.5];
        [timeBar addSubview:label];
    }
    
    // Time Label
    for (int i = 0; i <= duration+1; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.pixelPerSecond*i - barHeight/2, barHeight*0.1, barHeight, barHeight/2)];
        label.text = [NSString stringWithFormat:@"%d",i];
        //        label.backgroundColor = [UIColor colorWithDisplayP3Red:1 green:1 blue:1 alpha:0.5];
        label.textAlignment = NSTextAlignmentCenter;
        [timeBar addSubview:label];
        
        if (i < 100) {
            label.font = [UIFont fontWithName:@"Verdana" size:barHeight*0.6];
        } else if (i < 1000) {
            label.font = [UIFont fontWithName:@"Verdana" size:barHeight*0.5];
        } else {
            label.font = [UIFont fontWithName:@"Verdana" size:barHeight*0.36];
        }
    }
}


// Instant Methods -------------------------------------------------------------------

// Get Image From Asset with CMTime
- (UIImage*) getImageFromAsset:(AVAsset*)asset atTime:(CMTime)cmTime assetTrack:( AVAssetTrack *)clipVideoTrack {
    
    // Image Generator

    
    imageGenerator.maximumSize = CGSizeMake(_containerSize.height*3, _containerSize.height*3);
    
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

@end
