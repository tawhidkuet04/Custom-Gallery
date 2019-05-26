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
@protocol canvasViewDelegate <NSObject>
-(void)updateTotalTime:(double)totalTime;

@end
@interface thumbnailScrollView : UIScrollView<UIScrollViewDelegate,UIScrollViewAccessibilityDelegate>{
    double  totalFrame  ;
    int oneframeTakeTime;
    bool flag ;
    int framePerSec;
    AVAssetImageGenerator *imageGenerator ;
    CMTime duration;
    float totalTime ;
    
}
@property(weak,nonatomic) id <canvasViewDelegate> delegator ;
- (id)initWithFrame:(CGRect)frame withDelegate:(id<canvasViewDelegate>) delegate andAsset:(AVAsset *)asset  frameView:(UIView *) frameGenerateView;
-(void) generateFramefromvideo: (AVAsset *) movieAsset;
@end

NS_ASSUME_NONNULL_END
