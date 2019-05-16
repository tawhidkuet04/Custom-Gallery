//
//  ViewController.h
//  CustomCamera
//
//  Created by Tawhid Joarder on 4/23/19.
//  Copyright © 2019 Tawhid Joarder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
@interface ViewController : UIViewController{
    bool flag ; // false means image otherwise video
    PHAsset *tmp;
    int counter ;
    bool p ;
  
}



@end

