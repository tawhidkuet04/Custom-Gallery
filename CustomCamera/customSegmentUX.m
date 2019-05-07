//
//  customSegmentUX.m
//  CustomCamera
//
//  Created by Tawhid Joarder on 5/2/19.
//  Copyright © 2019 Tawhid Joarder. All rights reserved.
//

#import "customSegmentUX.h"

@implementation customSegmentUX

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setUP];
    }
    return self;
}
-(void)setUP{
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont boldSystemFontOfSize:14*([UIScreen mainScreen].bounds.size.width/414)] , NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName,
                                nil];
    [self setTitleTextAttributes:attributes forState:UIControlStateNormal];
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [self  setTitleTextAttributes:highlightedAttributes forState:UIControlStateSelected];
    self.layer.cornerRadius = 2 ;
    self.layer.borderColor = [UIColor colorWithRed:77.0f/255.0f
                                             green:77.0f/255.0f
                                              blue:77.0f/255.0f
                                             alpha:1.0f].CGColor;
    self.layer.borderWidth =1.3f;
//    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
//                                                                  attribute:NSLayoutAttributeHeight
//                                                                  relatedBy:NSLayoutRelationEqual
//                                                                     toItem:nil
//                                                                  attribute:NSLayoutAttributeNotAnAttribute
//                                                                 multiplier:1
//                                                            constant:32*([UIScreen mainScreen].bounds.size.height/414)];
//    [self addConstraint:constraint];    //self.layer.masksToBounds = YES;
    //self.clipsToBounds = true ;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
