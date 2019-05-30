//
//  PlayerBC.m
//  CameraProject
//
//  Created by Tawhid Joarder on 4/15/19.
//  Copyright © 2019 BrainCraft LTD. All rights reserved.
//

#import "PlayerBC.h"
#define degreeToRadian(x) (M_PI * x / 180.0)
#define radianToDegree(x) (180.0 * x / M_PI)
@implementation PlayerBC

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (IBAction)playPause:(id)sender {
}

- (IBAction)asas:(UIButton *)sender {
}

- (AVPlayer *)player {
    return [(AVPlayerLayer *)[self layer] player];
}

- (void)setPlayer:(AVPlayer *)player {
     NSLog(@"pppppppp");
     [(AVPlayerLayer *)[self layer] setPlayer:player];
  
    ((AVPlayerLayer *)[self layer]).videoGravity = AVLayerVideoGravityResizeAspectFill;
 //   [((AVPlayerLayer *)[self layer]) setAffineTransform:CGAffineTransformMakeRotation(degreeToRadian(90))];
   
}
- (void)setFrame:(CGRect)frame{
    NSLog(@"aa okok okok");
    [super setFrame:frame];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

//- (void)setOk:(CGRect )framee {
//    //((AVPlayerLayer *)[self layer]).videoGravity = AVLayerVideoGravityResizeAspect;
//    [((AVPlayerLayer *)[self layer]) setFrame:framee];  //  [(AVPlayerLayer *)[self layer] setPlayer:player];
//}
@end
