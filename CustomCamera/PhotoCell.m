//
//  PhotoCell.m
//  CustomCamera
//
//  Created by Tawhid Joarder on 4/23/19.
//  Copyright © 2019 Tawhid Joarder. All rights reserved.
//

#import "PhotoCell.h"
@interface PhotoCell()
@property(nonatomic,weak) IBOutlet UIImageView *photoImageView;
@property (nonatomic, strong) PHImageRequestOptions *requestOptions;
@end
@implementation PhotoCell
-(void)setAsset:(PHAsset *)asset{
    _asset = asset;
     __block UIImage *ima;
    PHImageManager *manager = [ PHImageManager defaultManager];
    self.requestOptions = [[PHImageRequestOptions alloc] init];
    self.requestOptions.resizeMode   = PHImageRequestOptionsResizeModeExact;
    self.requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    self.requestOptions.networkAccessAllowed = YES;
    // this one is key
    self.requestOptions.synchronous = YES;
    self.photoImageView.image = nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //Run your loop here
        [manager requestImageForAsset:asset
                           targetSize: CGSizeMake(500, 500)
                          contentMode:PHImageContentModeDefault
                              options:self.requestOptions
                        resultHandler:^void(UIImage *image, NSDictionary *info) {
                            ima = image;
                        }];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            self.photoImageView.image = ima;
            
        });
    });
        // Perform async operation
        // Call your method/function here
        // Example:
    
    
    
   
    
}

@end
