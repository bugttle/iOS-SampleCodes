//
//  ViewController.m
//  GestureRecognizers
//
//  Created by UQ Times on 12/05/04.
//  Copyright (c) 2012年 Individual. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize allGesturesView = _allGesturesView;
@synthesize panGestureView = _panGestureView;
@synthesize swipeGestureView = _swipeGestureView;
@synthesize gestureNameLabel = _gestureNameLabel;
@synthesize subInformationLabel = _subInformationLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 全てのジェスチャを設定
    [self addTagGestureRecognizer:_allGesturesView];
    [self addPinchGestureRecognizer:_allGesturesView];
    [self addPanGestureRecognizer:_allGesturesView];
    [self addSwipeGestureRecognizer:_allGesturesView];
    [self addRotationGestureRecognizer:_allGesturesView];
    [self addLongPressGestureRecognizer:_allGesturesView];
    
    // スワイプと同じ動作なので、ドラッグジェスチャのみを設定
    [self addPanGestureRecognizer:_panGestureView];
    
    // ドラッグと同じ動作なので、スワイプジェスチャのみを設定
    [self addSwipeGestureRecognizer:_swipeGestureView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.allGesturesView = nil;
    self.panGestureView = nil;
    self.swipeGestureView = nil;
    self.gestureNameLabel = nil;
    self.subInformationLabel = nil;
}

- (void)dealloc
{
    [_allGesturesView release];
    [_panGestureView release];
    [_swipeGestureView release];
    [_gestureNameLabel release];
    [_subInformationLabel release];
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark addGestrueRecognizers

- (void)addTagGestureRecognizer:(UIView *)view
{
    /* 1本指 */
    // 1本指でシングルタップ
    UITapGestureRecognizer *singleFingerSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerSingleTap:)];
    // 1本指でダブルタップ
    UITapGestureRecognizer *singleFingerDoubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerDoubleTap:)];
    [singleFingerDoubleTap setNumberOfTapsRequired:2];    
    // ダブルタップの失敗時のみシングルタップを実行する (シングルタップとダブルタップが同時に認識されてしまうのを回避する)
    // もちろんシングルタップの動作が鈍くなる
    [singleFingerSingleTap requireGestureRecognizerToFail:singleFingerDoubleTap];
    [self.allGesturesView addGestureRecognizer:singleFingerSingleTap];
    [singleFingerSingleTap release];
    [self.allGesturesView addGestureRecognizer:singleFingerDoubleTap];
    [singleFingerDoubleTap release];
    
    /* 2本指 */
    // 2本指でシングルタップ
    UITapGestureRecognizer *twoFingerSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoFingerSingleTap:)];
    [twoFingerSingleTap setNumberOfTouchesRequired:2];    
    // 2本指でダブルタップ
    UITapGestureRecognizer *twoFingerDoubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoFingerDoubleTap:)];
    [twoFingerDoubleTap setNumberOfTouchesRequired:2];
    [twoFingerDoubleTap setNumberOfTapsRequired:2];
    // ダブルタップの失敗時のみシングルタップを実行する (シングルタップとダブルタップが同時に認識されてしまうのを回避する)
    // もちろんシングルタップの動作が鈍くなる
    [twoFingerSingleTap requireGestureRecognizerToFail:twoFingerDoubleTap];
    [self.allGesturesView addGestureRecognizer:twoFingerSingleTap];
    [twoFingerSingleTap release];
    [self.allGesturesView addGestureRecognizer:twoFingerDoubleTap];
    [twoFingerDoubleTap release];
}

- (void)addPinchGestureRecognizer:(UIView *)view
{
    // ピンチインとピンチアウト
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    [self.allGesturesView addGestureRecognizer:pinchGesture];
    [pinchGesture release];
}

- (void)addPanGestureRecognizer:(UIView *)view
{
    // ドラッグ
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.panGestureView addGestureRecognizer:panGesture];
    [panGesture release];
}

- (void)addSwipeGestureRecognizer:(UIView *)view
{
    // スワイプ
    // (UISwipeGestureRecognizerDirectionRight|UISwipeGestureRecognizerDirectionLeft|UISwipeGestureRecognizerDirectionUp|UISwipeGestureRecognizerDirectionDown)
    // とすると、directionでどの方向に動いたかを取得できないため複数のジェスチャを作成
    UISwipeGestureRecognizer *swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    [swipeRightGesture setDirection:UISwipeGestureRecognizerDirectionRight];
    [view addGestureRecognizer:swipeRightGesture];
    [swipeRightGesture release];
    
    UISwipeGestureRecognizer *swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    [swipeLeftGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
    [view addGestureRecognizer:swipeLeftGesture];
    [swipeLeftGesture release];
    
    UISwipeGestureRecognizer *swipeUpGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    [swipeUpGesture setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [view addGestureRecognizer:swipeUpGesture];
    [swipeUpGesture release];
    
    UISwipeGestureRecognizer *swipeDownGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    [swipeDownGesture setDirection:UISwipeGestureRecognizerDirectionDown];
    [view addGestureRecognizer:swipeDownGesture];
    [swipeDownGesture release];
}

- (void)addRotationGestureRecognizer:(UIView *)view
{
    // 回転
    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotationGesture:)];
    [self.allGesturesView addGestureRecognizer:rotationGesture];
    [rotationGesture release];
}

- (void)addLongPressGestureRecognizer:(UIView *)view
{
    // 長押し
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    [self.allGesturesView addGestureRecognizer:longPressGesture];
    [longPressGesture release];
}

#pragma mark -
#pragma mark GestureRecognizer handlers

// 一本指でシングルタップ
- (void)handleSingleFingerSingleTap:(UITapGestureRecognizer *)recognizer {
    [self.gestureNameLabel setText:@"UITapGestureRecognizer"];
    [self.subInformationLabel setText:@"[Single finger, Single tap]"];
}

// 一本指でダブルタップ
- (void)handleSingleFingerDoubleTap:(UITapGestureRecognizer *)recognizer {
    [self.gestureNameLabel setText:@"UITapGestureRecognizer"];
    [self.subInformationLabel setText:@"[Single finger, Double tap]"];
}

// 二本指でシングルタップ
- (void)handleTwoFingerSingleTap:(UITapGestureRecognizer *)recognizer {
    [self.gestureNameLabel setText:@"UITapGestureRecognizer"];
    [self.subInformationLabel setText:@"[Two finger, Single tap]"];
}

// 二本指でダブルタップ
- (void)handleTwoFingerDoubleTap:(UITapGestureRecognizer *)recognizer {
    [self.gestureNameLabel setText:@"UITapGestureRecognizer"];
    [self.subInformationLabel setText:@"[Two finger, Double tap]"];
}

// ピンチイン・ピンチアウト
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer {
    [self.gestureNameLabel setText:@"UIPinchGestureRecognizer"];
    [self.subInformationLabel setText:[NSString stringWithFormat:@"[scale:%f, velocity:%f]", recognizer.scale, recognizer.velocity]];
}

// ドラッグ
- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer {
    [self.gestureNameLabel setText:@"UIPanGestureRecognizer"];
    UIView *targetView = [recognizer view];
    CGPoint translationPoint = [recognizer translationInView:targetView];
    CGPoint velocityPoint = [recognizer velocityInView:targetView];
    [self.subInformationLabel setText:[NSString stringWithFormat:@"[translation:(%f,%f), velocity:(%f,%f)]", translationPoint.x, translationPoint.y, velocityPoint.x, velocityPoint.y]];
}

// スワイプ
- (void)handleSwipeGesture:(UISwipeGestureRecognizer *)recognizer {
    [self.gestureNameLabel setText:@"UISwipeGestureRecognizer"];
    NSString *directionString = nil;
    switch ([recognizer direction]) {
        case UISwipeGestureRecognizerDirectionRight:
            directionString = @"UISwipeGestureRecognizerDirectionRight";
            break;
        case UISwipeGestureRecognizerDirectionLeft:
            directionString = @"UISwipeGestureRecognizerDirectionLeft";
            break;
        case UISwipeGestureRecognizerDirectionUp:
            directionString = @"UISwipeGestureRecognizerDirectionUp";        
            break;
        case UISwipeGestureRecognizerDirectionDown:
            directionString = @"UISwipeGestureRecognizerDirectionDown";
            break;
    }
    [self.subInformationLabel setText:[NSString stringWithFormat:@"[%@]", directionString]];
}

// 回転
- (void)handleRotationGesture:(UIRotationGestureRecognizer *)recognizer {
    [self.gestureNameLabel setText:@"UIRotationGestureRecognizer"];
    [self.subInformationLabel setText:[NSString stringWithFormat:@"[rotation:%f, velocity:%f]", recognizer.rotation, recognizer.velocity]];
}

// 長押し
- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)recognizer {
    [self.gestureNameLabel setText:@"UILongPressGestureRecognizer"];
    NSString *stateString = nil;
    switch ([recognizer state]) {
        case UIGestureRecognizerStateBegan:
            stateString = @"UIGestureRecognizerStateBegan";
            break;
        case UIGestureRecognizerStateChanged:
            stateString = @"UIGestureRecognizerStateChanged";
            break;
        case UIGestureRecognizerStateEnded:
            stateString = @"UIGestureRecognizerStateEnd";
            break;
        case UIGestureRecognizerStateCancelled:
            stateString = @"UIGestureRecognizerStateCancelled";
            break;
        default:
            break;
    }
    [self.subInformationLabel setText:[NSString stringWithFormat:@"[%@]", stateString]];
}

@end
