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
#import "PlayerDisplayVCViewController.h"

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControllChoosePhotoOrVideo;
@property(nonatomic ,strong) NSArray *assets;
@property(nonatomic ,strong) NSArray *VideoAssets;
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
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:31.0f/255.0f
                                                                             green:31.0f/255.0f
                                                                              blue:31.0f/255.0f
                                                                             alpha:1.0f]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
    flag = false ;
    // Do any additional setup after loading the view, typically from a nib.
    _assets = [@[]mutableCopy];  // NSArray *array = @[]; ---> NSArray *array [[NSArray alloc] init];
    _VideoAssets =[@[]mutableCopy];
    __block NSMutableArray *tmpAssets = [@[] mutableCopy];
    __block NSMutableArray *tmpVideoAssets = [@[] mutableCopy];
    PHFetchResult *imagesResults =
    [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:nil];
    PHFetchResult *videoResults =
    [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:nil];
    
 // NSMutableArray *images = [NSMutableArray arrayWithCapacity:[imagesResults count]];
    for (PHAsset *asset in imagesResults) {
        // Do something with the asset
          [tmpAssets addObject:asset];
    }
    for (PHAsset *asset in videoResults) {
        // Do something with the asset
        [tmpVideoAssets addObject:asset];
    }
    self.assets = tmpAssets;
    self.VideoAssets = tmpVideoAssets;
    self.navigationItem.titleView = _segmentControllChoosePhotoOrVideo;
    [self.collectionView reloadData];
    
    
}
- (IBAction)photosOrVideo:(id)sender {
    UISegmentedControl *s = (UISegmentedControl *) sender ;
    if(s.selectedSegmentIndex == 1 ){
        //video
        flag = true ;
        [self.collectionView reloadData];
    }else {
        //photo
        flag = false ;
        [self.collectionView reloadData];
    }
}

#pragma mark - collection view data source

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(flag){
        return self.VideoAssets.count;
    }else {
        return self.assets.count;
    }
    
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
    if(flag){
        PHAsset *asset = self.VideoAssets[indexPath.row];
        cell.asset = asset;
       
    }else {
        PHAsset *asset = self.assets[indexPath.row];
        cell.asset = asset;
    }

 //   cell.backgroundColor = [UIColor redColor];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(flag){
        
        PlayerDisplayVCViewController *playerViewController = (PlayerDisplayVCViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"PlayerDisplayVCViewController"];
        playerViewController.passet =self.VideoAssets[indexPath.row];;
        [self.navigationController pushViewController:playerViewController animated:YES];
    }else {
        imageShowViewController *imageShowController = [[imageShowViewController alloc] init];
        imageShowController.asset =self.assets[indexPath.row];
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController pushViewController:imageShowController animated:YES];
    }
    
    
}
@end
