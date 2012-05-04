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

@synthesize allGesturesView;
@synthesize panGestureView;
@synthesize swipeGestureView;
@synthesize showGestureName;
@synthesize showSubInformation;

/* 一つの view に全てのジェスチャーを設定 */
- (void)setAllGestures {
    // 一本指でシングルタップ
    UITapGestureRecognizer *singleFingerSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerSingleTap:)];
    // 一本指でダブルタップ
    UITapGestureRecognizer *singleFingerDoubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerDoubleTap:)];
    [singleFingerDoubleTap setNumberOfTapsRequired:2];    
    // ダブルタップの失敗時のみシングルタップを実行する (シングルタップとダブルタップが同時に認識されてしまうのを回避する)
    // もちろんシングルタップの動作が鈍くなる
    [singleFingerSingleTap requireGestureRecognizerToFail:singleFingerDoubleTap];
    [self.allGesturesView addGestureRecognizer:singleFingerSingleTap];
    [singleFingerSingleTap release];
    [self.allGesturesView addGestureRecognizer:singleFingerDoubleTap];
    [singleFingerDoubleTap release];
    
    // 二本指でシングルタップ
    UITapGestureRecognizer *twoFingerSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoFingerSingleTap:)];
    [twoFingerSingleTap setNumberOfTouchesRequired:2];    
    // 二本指でダブルタップ
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
    
    // ピンチインとピンチアウト
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    [self.allGesturesView addGestureRecognizer:pinchGesture];
    [pinchGesture release];
    
    // ドラッグ
    [self setPanGesture:allGesturesView];
    
    // スワイプ
    [self setSwipeGesture:allGesturesView];
        
    // 回転
    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotationGesture:)];
    [self.allGesturesView addGestureRecognizer:rotationGesture];
    [rotationGesture release];
    
    // 長押し
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    [self.allGesturesView addGestureRecognizer:longPressGesture];
    [longPressGesture release];
}

/* スワイプと同じ動作なので分ける */
- (void)setPanGesture:(UIView *)view {
    // ドラッグ
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.panGestureView addGestureRecognizer:panGesture];
    [panGesture release];
}

/* ドラッグと同じ動作なので分ける */
- (void)setSwipeGesture:(UIView *)view {
    // スワイプ
    //(UISwipeGestureRecognizerDirectionUp|UISwipeGestureRecognizerDirectionRight|UISwipeGestureRecognizerDirectionDown|UISwipeGestureRecognizerDirectionLeft)とできないものか
    UISwipeGestureRecognizer *swipeUpGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    [swipeUpGesture setDirection:UISwipeGestureRecognizerDirectionUp];
    [view addGestureRecognizer:swipeUpGesture];
    [swipeUpGesture release];

    UISwipeGestureRecognizer *swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    [swipeRightGesture setDirection:UISwipeGestureRecognizerDirectionRight];
    [view addGestureRecognizer:swipeRightGesture];
    [swipeRightGesture release];

    UISwipeGestureRecognizer *swipeDownGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    [swipeDownGesture setDirection:UISwipeGestureRecognizerDirectionDown];
    [view addGestureRecognizer:swipeDownGesture];
    [swipeDownGesture release];
    
    UISwipeGestureRecognizer *swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    [swipeLeftGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
    [view addGestureRecognizer:swipeLeftGesture];
    [swipeLeftGesture release];
}

- (void)loadView {
    [super loadView];
    
    [self setAllGestures];
    [self setPanGesture: panGestureView];
    [self setSwipeGesture: swipeGestureView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.allGesturesView = nil;
    self.panGestureView = nil;
    self.swipeGestureView = nil;
    self.showGestureName = nil;
    self.showSubInformation = nil;
}

- (void)dealloc {
    [allGesturesView release];
    [panGestureView release];
    [swipeGestureView release];
    [showGestureName release];
    [showSubInformation release];
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark touch handler
/* 各種ジェスチャーのハンドラ */
// 一本指でシングルタップ
- (void)handleSingleFingerSingleTap:(UITapGestureRecognizer *)recognizer {
    [showGestureName setText:@"UITapGestureRecognizer"];
    [showSubInformation setText:@"[Single finger, Single tap]"];
}

// 一本指でダブルタップ
- (void)handleSingleFingerDoubleTap:(UITapGestureRecognizer *)recognizer {
    [showGestureName setText:@"UITapGestureRecognizer"];
    [showSubInformation setText:@"[Single finger, Double tap]"];
}

// 二本指でシングルタップ
- (void)handleTwoFingerSingleTap:(UITapGestureRecognizer *)recognizer {
    [showGestureName setText:@"UITapGestureRecognizer"];
    [showSubInformation setText:@"[Two finger, Single tap]"];
}

// 二本指でダブルタップ
- (void)handleTwoFingerDoubleTap:(UITapGestureRecognizer *)recognizer {
    [showGestureName setText:@"UITapGestureRecognizer"];
    [showSubInformation setText:@"[Two finger, Double tap]"];
}

// ピンチイン・ピンチアウト
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer {
    [showGestureName setText:@"UIPinchGestureRecognizer"];
    [showSubInformation setText:[NSString stringWithFormat:@"[scale:%f, velocity:%f]", recognizer.scale, recognizer.velocity]];
}

// ドラッグ
- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer {
    [showGestureName setText:@"UIPanGestureRecognizer"];
    UIView *targetView = [recognizer view];
    CGPoint translationPoint = [recognizer translationInView:targetView];
    CGPoint velocityPoint = [recognizer velocityInView:targetView];
    [showSubInformation setText:[NSString stringWithFormat:@"[translation:(%f,%f), velocity:(%f,%f)]", translationPoint.x, translationPoint.y, velocityPoint.x, velocityPoint.y]];
}

// スワイプ
- (void)handleSwipeGesture:(UISwipeGestureRecognizer *)recognizer {
    [showGestureName setText:@"UISwipeGestureRecognizer"];
    NSString *directionName = nil;
    switch ([recognizer direction]) {
        case UISwipeGestureRecognizerDirectionUp:
            directionName = @"UISwipeGestureRecognizerDirectionUp";
            break;
        case UISwipeGestureRecognizerDirectionRight:
            directionName = @"UISwipeGestureRecognizerDirectionRight";
            break;
        case UISwipeGestureRecognizerDirectionDown:
            directionName = @"UISwipeGestureRecognizerDirectionDown";
            break;
        case UISwipeGestureRecognizerDirectionLeft:
            directionName = @"UISwipeGestureRecognizerDirectionLeft";
            break;
    }
    [showSubInformation setText:[NSString stringWithFormat:@"[%@]", directionName]];
}

// 回転
- (void)handleRotationGesture:(UIRotationGestureRecognizer *)recognizer {
    [showGestureName setText:@"UIRotationGestureRecognizer"];
    [showSubInformation setText:[NSString stringWithFormat:@"[rotation:%f, velocity:%f]", recognizer.rotation, recognizer.velocity]];
}

// 長押し
- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)recognizer {
    [showGestureName setText:@"UILongPressGestureRecognizer"];
    NSString *actionName = nil;
    switch ([recognizer state]) {
        case UIGestureRecognizerStateBegan:
            actionName = @"UIGestureRecognizerStateBegan";
            break;
        case UIGestureRecognizerStateChanged:
            actionName = @"UIGestureRecognizerStateChanged";
            break;
        case UIGestureRecognizerStateEnded:
            actionName = @"UIGestureRecognizerStateEnd";
            break;
        case UIGestureRecognizerStateCancelled:
            actionName = @"UIGestureRecognizerStateCancelled";
            break;
        default:
            break;
    }
    [showSubInformation setText:[NSString stringWithFormat:@"[%@]", actionName]];
}

@end
