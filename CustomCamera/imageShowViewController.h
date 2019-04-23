//
//  imageShowViewController.h
//  CustomCamera
//
//  Created by Tawhid Joarder on 4/23/19.
//  Copyright © 2019 Tawhid Joarder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
NS_ASSUME_NONNULL_BEGIN

@interface imageShowViewController : UIViewController
@property(nonatomic, strong) PHAsset *asset;
@end

NS_ASSUME_NONNULL_END
