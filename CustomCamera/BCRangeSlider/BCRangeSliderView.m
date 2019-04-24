//
//  BCRangeSliderView.m
//  BCRangeSlider
//
//  Created by Brain Craft Ltd. on 11/15/18.
//  Copyright © 2018 Brain Craft Ltd. All rights reserved.
//

#import "BCRangeSliderView.h"

@implementation BCRangeSliderView {
    
    // Duration Of Asset
    Float64 duration;

    // Selector Width
    float selectorWidth;
    
}


// Init with frame
- (id)initWithFrame:(CGRect)frame andAsset:(AVAsset *)asset assetTrack:( AVAssetTrack *)clipVideoTrack {
    
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor colorWithDisplayP3Red:0.07 green:0.07 blue:0.07 alpha:0.9];
//    self.backgroundColor = [UIColor clearColor];
    
    if (asset == nil) {
        NSLog(@"Asset is nil");
        return self;
    }
    
    // Asset Duration
    duration = CMTimeGetSeconds(asset.duration);
    NSLog(@"Duration: %f",duration);
    
    // Selector Width
    selectorWidth = self.frame.size.height*0.24;
    
    // Create Slider
    _sliderScrollView = [[BCRangeSliderScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height*0.6) padding:selectorWidth andAsset:asset  assetTrack:clipVideoTrack];
    [self addSubview:_sliderScrollView];
    _sliderScrollView.delegate = self;
    _sliderScrollView.sliderDelegate = self;
    
    return self;
}


// Delegate From Slider
- (void)frameGenerationDone {
    
    // Create Seek Bar
    [self createSeekBar];
    
    // Create Selector
    [self createSelectorView];
    
    // Update Toast Label
    [self updateStartAndEndTime];
    
    // Create Scroll Bar
    [self createScrollBar];
    
    // Call Delegate
    [self callDelegate_UpdateEnded];
    
}


// Create Selector View
-(void) createSelectorView {
    
    // Start Selector ***************
    _startSelectorView = [[BCRangeSliderSelectorView alloc] initWithFrame:CGRectMake(_sliderScrollView.frame.size.width*0.25, _sliderScrollView.frame.origin.y-4, selectorWidth*2.0, _sliderScrollView.frame.size.height+8) SelectorType:SelectorTypeStart];
    [self addSubview:_startSelectorView];
    
    // Create a Pan Gesture
    UIPanGestureRecognizer *startPanGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleStartPan:)];
    [_startSelectorView addGestureRecognizer:startPanGR];
    _startSelectorView.userInteractionEnabled = YES;
    
    // Left Shadow
    _leftShadow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _startSelectorView.frame.origin.x + selectorWidth*0.75, _sliderScrollView.frame.size.height)];
    _leftShadow.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    [self addSubview:_leftShadow];
    _leftShadow.userInteractionEnabled = NO;
    
//    // Start Toast
//    _startSelectorToast = [[BCRangeSliderToast alloc] initWithFrame:CGRectMake(0,0, 40, 20)];
//    [self addSubview:_startSelectorToast];
    
    
    // End Selector ***************
    _endSelectorView = [[BCRangeSliderSelectorView alloc] initWithFrame:CGRectMake(_sliderScrollView.frame.size.width*0.75, _sliderScrollView.frame.origin.y-4, selectorWidth*2.0, _sliderScrollView.frame.size.height+8) SelectorType:SelectorTypeEnd];
    [self addSubview:_endSelectorView];
    
    // Create a Pan Gesture
    UIPanGestureRecognizer *endPanGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleEndPan:)];
    [_endSelectorView addGestureRecognizer:endPanGR];
    _endSelectorView.userInteractionEnabled = YES;
    
    // Right Shadow
    _rightShadow = [[UIView alloc] initWithFrame:CGRectMake(_endSelectorView.frame.origin.x+selectorWidth*1.25, 0, _sliderScrollView.frame.size.width, _sliderScrollView.frame.size.height)];
    _rightShadow.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    [self addSubview:_rightShadow];
    _rightShadow.userInteractionEnabled = NO;
    
    // End Toast
    _endSelectorToast = [[BCRangeSliderToast alloc] initWithFrame:CGRectMake(-500, -500, 40, 20)];
    [self addSubview:_endSelectorToast];
}

- (void) handleStartPan:(UIPanGestureRecognizer*) gr {
    
    // Call Begin Delegate
    if (gr.state == UIGestureRecognizerStateBegan) {
        [self callDelegate_UpdateBegan];
    }
    
    [self bringSubviewToFront:_startSelectorView];
    
    CGPoint translation = [gr translationInView:_startSelectorView];
    [_startSelectorView setCenter:CGPointMake(_startSelectorView.center.x+translation.x, _startSelectorView.center.y)];
    [gr setTranslation:CGPointZero inView:_startSelectorView];
    
    // Left Limit
    if (_startSelectorView.center.x < selectorWidth*0.25) {
        [_startSelectorView setCenter:CGPointMake(selectorWidth*0.25, _startSelectorView.center.y)];
    }
    
    // Right Limit
    if (translation.x > 0 && _startSelectorView.center.x > _endSelectorView.center.x - selectorWidth*1.5) {
        [_startSelectorView setCenter:CGPointMake(_endSelectorView.center.x - selectorWidth*1.5, _startSelectorView.center.y)];
    }
    
    _leftShadow.frame = CGRectMake(0, 0, _startSelectorView.frame.origin.x+selectorWidth*0.75, _sliderScrollView.frame.size.height);
    
    
    // Update Toast Position
    [_startSelectorToast setCenter:CGPointMake(_startSelectorView.center.x+_startSelectorView.frame.size.width*0.125, _startSelectorView.center.y-50)];
    if (_startSelectorToast.center.x < _startSelectorToast.frame.size.width/2) {
        [_startSelectorToast setCenter:CGPointMake(_startSelectorToast.frame.size.width/2, _startSelectorToast.center.y)];
    }
    
    // Update Toast Label
    [self updateStartAndEndTime];
    [_startSelectorToast setMessage:[NSString stringWithFormat:@"%.1f", _startTime]];
    
    if (gr.state == UIGestureRecognizerStateEnded || gr.state == UIGestureRecognizerStateCancelled) {
        [_startSelectorToast setCenter:CGPointMake(-500, -500)];
        
        // Call Delegate
        [self callDelegate_UpdateEnded];
    }
}

- (void) handleEndPan:(UIPanGestureRecognizer*) gr {
    
    // Call Begin Delegate
    if (gr.state == UIGestureRecognizerStateBegan) {
        [self callDelegate_UpdateBegan];
    }
    
    [self bringSubviewToFront:_endSelectorView];
    
    CGPoint translation = [gr translationInView:_endSelectorView];
    [_endSelectorView setCenter:CGPointMake(_endSelectorView.center.x+translation.x, _endSelectorView.center.y)];
    [gr setTranslation:CGPointZero inView:_endSelectorView];
    
    // Right Limit
    if (_endSelectorView.center.x > _sliderScrollView.frame.size.width - selectorWidth*0.25) {
        [_endSelectorView setCenter:CGPointMake(_sliderScrollView.frame.size.width - selectorWidth*0.25, _endSelectorView.center.y)];
    }
    
    // Left Limit
    if (translation.x < 0 && _endSelectorView.center.x < _startSelectorView.center.x + selectorWidth*1.5) {
        [_endSelectorView setCenter:CGPointMake(_startSelectorView.center.x + selectorWidth*1.5, _endSelectorView.center.y)];
    }
    
    // Update Shadow
    _rightShadow.frame = CGRectMake(_endSelectorView.frame.origin.x+selectorWidth*1.25, 0, _sliderScrollView.frame.size.width, _sliderScrollView.frame.size.height);
    
    // Update Toast
    [_endSelectorToast setCenter:CGPointMake(_endSelectorView.center.x-_endSelectorView.frame.size.width*0.125, _endSelectorView.center.y-50)];
    if (_endSelectorToast.center.x > self.frame.size.width - _endSelectorToast.frame.size.width/2) {
        [_endSelectorToast setCenter:CGPointMake(self.frame.size.width - _endSelectorToast.frame.size.width/2, _endSelectorToast.center.y)];
    }
    
    // Update Toast Label
    [self updateStartAndEndTime];
    [_endSelectorToast setMessage:[NSString stringWithFormat:@"%.1f", _endTime]];
    
    if (gr.state == UIGestureRecognizerStateEnded || gr.state == UIGestureRecognizerStateCancelled) {
        [_endSelectorToast setCenter:CGPointMake(-500, -500)];
        
        // Call Delegate
        [self callDelegate_UpdateEnded];
    }
}

// Create Scrool Bar
-(void) createScrollBar {
    
    float knobIsToBarRatio = _sliderScrollView.frame.size.width / _sliderScrollView.contentSize.width;
    NSLog(@"knobIsToBarRatio: %f", knobIsToBarRatio);
    
    // Scroll Bar
    _scrollBar = [[BCRangeSliderScrollBar alloc] initWithFrame:CGRectMake(0, self.frame.size.height*0.7, self.frame.size.width, self.frame.size.height*0.3) andKnobIsToBarRatio:knobIsToBarRatio];
    [self addSubview:_scrollBar];
    _scrollBar.delegate = self;
}

- (void)bcScrollBarMoveBegan {
    if (_delegate != nil) {
        [self hideSeekBar];
        [_delegate bcRangeSliderUpdateBegan];
    }
}

- (void)bcScrollBarMovingAt:(float)position {
    
    // Update Slider Offset
    float maxOffset = _sliderScrollView.contentSize.width - _sliderScrollView.frame.size.width;
    _sliderScrollView.contentOffset = CGPointMake(maxOffset*position, 0);
}

- (void)bcScrollBarMoveEndedAt:(float)position {
    
    [_startSelectorToast setCenter:CGPointMake(-500, -500)];
    [_endSelectorToast setCenter:CGPointMake(-500, -500)];
    
    // Call Delegate
    [self callDelegate_UpdateEnded];
}

- (void) createSeekBar {
    
    // Seek Bar
    _seekBar = [[BCRangeSliderSeekBar alloc] initWithFrame:CGRectMake(_sliderScrollView.frame.size.width*0.5, _sliderScrollView.frame.origin.y-6, selectorWidth*0.15, _sliderScrollView.frame.size.height+12)];
    [self addSubview:_seekBar];
//    _seekBar.delegate = self;
    
}

#pragma mark - ScrolViewDelegates
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // Call Begin Delegate
    [self callDelegate_UpdateBegan];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {

    //    NSLog(@"X: %f", scrollView.contentOffset.x);
    float maxOffset = _sliderScrollView.contentSize.width - _sliderScrollView.frame.size.width;
    [_scrollBar updateKnobPositionAt:scrollView.contentOffset.x/maxOffset];
    
    [self updateStartAndEndTime];

    // Update Start Toast's Position
    [_startSelectorToast setCenter:CGPointMake(_startSelectorView.center.x+_startSelectorView.frame.size.width*0.125, _startSelectorView.center.y-50)];
    
    // Left Limit of Start Toast
    if (_startSelectorToast.center.x < _startSelectorToast.frame.size.width/2) {
        [_startSelectorToast setCenter:CGPointMake(_startSelectorToast.frame.size.width/2, _startSelectorToast.center.y)];
    }
    
    // Update End Toast's Position
    [_endSelectorToast setCenter:CGPointMake(_endSelectorView.center.x-_endSelectorView.frame.size.width*0.125, _endSelectorView.center.y-50)];
    
    // Right Limit of End Toast
    if (_endSelectorToast.center.x > self.frame.size.width - _endSelectorToast.frame.size.width/2) {
        [_endSelectorToast setCenter:CGPointMake(self.frame.size.width - _endSelectorToast.frame.size.width/2, _endSelectorToast.center.y)];
    }
    
    // Handle Positin When Toasts are overlaped
    if (_startSelectorToast.center.x +  _startSelectorToast.frame.size.width/2 > _endSelectorToast.center.x - _endSelectorToast.frame.size.width/2) {
        float distance = _startSelectorToast.frame.size.width - (_endSelectorToast.center.x - _startSelectorToast.center.x);
        [_startSelectorToast setCenter:CGPointMake(_startSelectorToast.center.x-distance/2, _startSelectorToast.center.y)];
        [_endSelectorToast setCenter:CGPointMake(_endSelectorToast.center.x+distance/2, _endSelectorToast.center.y)];
    }
    
}

- (void) updateStartAndEndTime {
    
    // Update Start Toast Label
    float selectorPos = _startSelectorView.frame.origin.x+selectorWidth*0.75 + _sliderScrollView.contentOffset.x;
    _startTime = selectorPos/_sliderScrollView.pixelPerSecond;
    
    // Update Start Toast Label
    [_startSelectorToast setMessage:[NSString stringWithFormat:@"%.1f", _startTime]];
    
    
    // Update End Toast Label
    selectorPos = _endSelectorView.frame.origin.x-selectorWidth*0.75 + _sliderScrollView.contentOffset.x;
    _endTime = selectorPos/_sliderScrollView.pixelPerSecond;
    
    // Update End Toast Label
    [_endSelectorToast setMessage:[NSString stringWithFormat:@"%.1f", _endTime]];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    NSLog(@"scrollViewDidEndDragging");
    [_startSelectorToast setCenter:CGPointMake(-500, -500)];
    [_endSelectorToast setCenter:CGPointMake(-500, -500)];
    
    // Call Delegate
    [self callDelegate_UpdateEnded];
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
//    NSLog(@"scrollViewWillBeginDecelerating");
    // Call Begin Delegate
    [self callDelegate_UpdateBegan];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    NSLog(@"scrollViewDidEndDecelerating");
    [_startSelectorToast setCenter:CGPointMake(-500, -500)];
    [_endSelectorToast setCenter:CGPointMake(-500, -500)];
    
    // Call Delegate
    [self callDelegate_UpdateEnded];
}

-(void) callDelegate_UpdateBegan {
    if (_delegate != nil) {
        [self hideSeekBar];
        [_delegate bcRangeSliderUpdateBegan];
    }
}

-(void) callDelegate_UpdateEnded {
    if (_delegate != nil) {
        [_delegate bcRangeSliderUpdateEndedAt_StartTime:_startTime andEndTime:_endTime];
    }
}

- (void) updateSeekBarAt:(float)time {
    
    float posX = time * _sliderScrollView.pixelPerSecond-_sliderScrollView.contentOffset.x+_startSelectorView.frame.size.width*0.5-_seekBar.frame.size.width*0.4;
    [_seekBar setCenter:CGPointMake(posX, _seekBar.center.y)];
    [_seekBar.toast setMessage:[NSString stringWithFormat:@"%.1f", time]];
}

- (void) hideSeekBar {
    [_seekBar setCenter:CGPointMake(-2000, _seekBar.center.y)];
    _seekBar.alpha = 0.0;
}

- (void) disAppearSeekBar {
    [UIView animateWithDuration:0.2f animations:^{
        self->_seekBar.alpha = 0.0;
    }];
}

- (void) appearSeekBar {
    [self performSelector:@selector(fadeInSeekBar) withObject:nil afterDelay:0.2];
}

- (void) fadeInSeekBar {
    [UIView animateWithDuration:0.3f animations:^{
        self->_seekBar.alpha = 1.0;
    }];
}

@end
