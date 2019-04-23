//
//  imageShowViewController.m
//  CustomCamera
//
//  Created by Tawhid Joarder on 4/23/19.
//  Copyright © 2019 Tawhid Joarder. All rights reserved.
//

#import "imageShowViewController.h"
#import <Photos/Photos.h>
@interface imageShowViewController ()
@property(nonatomic,weak) IBOutlet UIImageView *photoImageView;
@property (nonatomic, strong) PHImageRequestOptions *requestOptions;

@end

@implementation imageShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __block UIImage *ima;
    PHImageManager *manager = [ PHImageManager defaultManager];
    self.requestOptions = [[PHImageRequestOptions alloc] init];
    self.requestOptions.resizeMode   = PHImageRequestOptionsResizeModeExact;
    self.requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    self.requestOptions.networkAccessAllowed = YES;
    // this one is key
    self.requestOptions.synchronous = YES;
    self.photoImageView.image = nil;
    // Do any additional setup after loading the view from its nib.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //Run your loop here
        [manager requestImageForAsset:self->_asset
                           targetSize:PHImageManagerMaximumSize
                          contentMode:PHImageContentModeDefault
                              options:self.requestOptions
                        resultHandler:^void(UIImage *image, NSDictionary *info) {
          
                            ima = image;
 
                        }];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            //stop your HUD here
            //This is run on the main thread
            self.photoImageView.image = ima;
            
        });
    });
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
