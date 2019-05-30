//
//  PlayerDisplayVCViewController.h
//  CameraProject
//
//  Created by Tawhid Joarder on 4/15/19.
//  Copyright © 2019 BrainCraft LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerBC.h"
#import "thumbnailScrollView.h"
#import <Photos/Photos.h>
NS_ASSUME_NONNULL_BEGIN

@interface PlayerDisplayVCViewController : UIViewController{

    bool playOrPause;
    
}
@property (strong, nonatomic) IBOutlet PlayerBC *playerView;
@property (nonatomic, strong) NSURL *videoURL;
@property (strong,nonatomic) AVPlayer *player;
@property( strong , nonatomic ) PHAsset *passet;
@property( strong , nonatomic ) PHAsset *qasset;

@property (strong, nonatomic) IBOutlet PlayerBC *viewPlayer;
@property (strong, nonatomic) IBOutlet UIView *containerView;
-(void)call;
- (void) PlayerSetPlayPause : (UIButton*)btn withPlayingStatus:(float)rate;
@end

NS_ASSUME_NONNULL_END
