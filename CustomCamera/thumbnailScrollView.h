//
//  thumbnailScrollView.h
//  CameraProject
//
//  Created by Tawhid Joarder on 4/24/19.
//  Copyright © 2019 BrainCraft LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
NS_ASSUME_NONNULL_BEGIN
@protocol playerDisplayVCViewControllerDelegate <NSObject>
-(void)updateTotalTime:(double)totalTime;

@end
@interface thumbnailScrollView : UIScrollView
@property(weak,nonatomic) id <playerDisplayVCViewControllerDelegate> delegator ;
- (id)initWithFrame:(CGRect)frame withDelegate:(id<playerDisplayVCViewControllerDelegate>) delegate andAsset:(AVAsset *)asset;
-(void) generateFramefromvideo: (AVAsset *) movieAsset;
@end

NS_ASSUME_NONNULL_END
