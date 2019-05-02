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
                                [UIFont boldSystemFontOfSize:12] , NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName,
                                nil];
    [self setTitleTextAttributes:attributes forState:UIControlStateNormal];
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [self  setTitleTextAttributes:highlightedAttributes forState:UIControlStateSelected];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
