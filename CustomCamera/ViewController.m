//
//  ViewController.m
//  CustomCamera
//
//  Created by Tawhid Joarder on 4/23/19.
//  Copyright © 2019 Tawhid Joarder. All rights reserved.
//

#import "ViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "PhotoCell.h"
#import "imageShowViewController.h"
@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property(nonatomic ,strong) NSArray *assets;
@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) PHImageRequestOptions *requestOptions;
@end

@implementation ViewController
//+ (PHPhotoLibrary *)defaultAssetsLibrary
//{
//    static dispatch_once_t pred ;
//    static PHPhotoLibrary *library = nil;
//    dispatch_once(&pred, ^{
//        library = [[PHPhotoLibrary alloc] init];
//    });
//    return library;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _assets = [@[]mutableCopy];
    __block NSMutableArray *tmpAssets = [@[] mutableCopy];
  
    PHFetchResult *imagesResults =
    [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:nil];
   
    
 // NSMutableArray *images = [NSMutableArray arrayWithCapacity:[imagesResults count]];
    for (PHAsset *asset in imagesResults) {
        // Do something with the asset
          [tmpAssets addObject:asset];
//        [manager requestImageForAsset:asset
//                           targetSize:PHImageManagerMaximumSize
//                          contentMode:PHImageContentModeDefault
//                              options:self.requestOptions
//                        resultHandler:^void(UIImage *image, NSDictionary *info) {
//                            ima = image;
//
//                           //[images addObject:ima];
//                        }];
        
        
    }
    self.assets = tmpAssets;
    [self.collectionView reloadData];
    
    
}

#pragma mark - collection view data source

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assets.count;
}



- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell *cell = (PhotoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    
    PHAsset *asset = self.assets[indexPath.row];
    cell.asset = asset;
 //   cell.backgroundColor = [UIColor redColor];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    imageShowViewController *imageShowController = [[imageShowViewController alloc] init];
    imageShowController.asset =self.assets[indexPath.row];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController pushViewController:imageShowController animated:YES];
    
}
@end
