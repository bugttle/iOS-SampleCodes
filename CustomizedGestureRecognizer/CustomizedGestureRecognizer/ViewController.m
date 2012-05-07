//
//  ViewController.m
//  CustomizedGestureRecognizer
//
//  Created by UQ Times on 12/05/05.
//  Copyright (c) 2012年 Individual. All rights reserved.
//

#import "ViewController.h"
#import "StrokeGestureRecognizer.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize canvasView = _canvasView;
@synthesize currentGestureName = _currentGestureName;
@synthesize fixedGestureName = _fixGestureName;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /* "I型" のジェスチャー */
    StrokeGestureRecognizer *iShapedGesture = [[StrokeGestureRecognizer alloc] initWithTarget:self action:@selector(handleIShapedGesture:)];
    iShapedGesture.delegate = self;
    [iShapedGesture setLowerLimitOfStrokeLength:45];
    [iShapedGesture addWantedStroke:StrokeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:iShapedGesture];
    [iShapedGesture release];
    
    /* "L型" のジェスチャー */
    StrokeGestureRecognizer *lShapedGesture = [[StrokeGestureRecognizer alloc] initWithTarget:self action:@selector(handleLShapedGesture:)];
    lShapedGesture.delegate = self;
    [lShapedGesture setLowerLimitOfStrokeLength:45];
    [lShapedGesture addWantedStroke:StrokeGestureRecognizerDirectionDown];
    [lShapedGesture addWantedStroke:StrokeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:lShapedGesture];
    [lShapedGesture release];
    
    /* "U型" のジェスチャー */
    StrokeGestureRecognizer *uShapedGesture = [[StrokeGestureRecognizer alloc] initWithTarget:self action:@selector(handleUShapedGesture:)];
    uShapedGesture.delegate = self;
    [uShapedGesture setLowerLimitOfStrokeLength:45];
    [uShapedGesture addWantedStroke:StrokeGestureRecognizerDirectionDown];
    [uShapedGesture addWantedStroke:StrokeGestureRecognizerDirectionRight];
    [uShapedGesture addWantedStroke:StrokeGestureRecognizerDirectionUp];
    [self.view addGestureRecognizer:uShapedGesture];
    [uShapedGesture release];
    
    /* "O型" のジェスチャー */
    StrokeGestureRecognizer *oShapedGesture = [[StrokeGestureRecognizer alloc] initWithTarget:self action:@selector(handleOShapedGesture:)];
    oShapedGesture.delegate = self;
    [oShapedGesture setLowerLimitOfStrokeLength:45];
    [oShapedGesture addWantedStroke:StrokeGestureRecognizerDirectionDown];
    [oShapedGesture addWantedStroke:StrokeGestureRecognizerDirectionRight];
    [oShapedGesture addWantedStroke:StrokeGestureRecognizerDirectionUp];
    [oShapedGesture addWantedStroke:StrokeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:oShapedGesture];
    [oShapedGesture release];

    /* "C型" のジェスチャー */
    StrokeGestureRecognizer *cShapedGesture = [[StrokeGestureRecognizer alloc] initWithTarget:self action:@selector(handleCShapedGesture:)];
    cShapedGesture.delegate = self;
    [cShapedGesture setLowerLimitOfStrokeLength:10];
    [cShapedGesture addWantedStroke:StrokeGestureRecognizerDirectionLeft];
    [cShapedGesture addWantedStroke:StrokeGestureRecognizerDirectionDown];
    [cShapedGesture addWantedStroke:StrokeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:cShapedGesture];
    [cShapedGesture release];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.canvasView = nil;
    self.currentGestureName = nil;
    self.fixedGestureName = nil;
}

- (void)dealloc
{
    [_canvasView release];
    [_currentGestureName release];
    [_fixGestureName release];
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.currentGestureName setText:@"none"];
    [self.fixedGestureName setText:@"none"];
    self.canvasView.image = nil;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint currentPoint = [[touches anyObject] locationInView:self.canvasView];
    CGPoint prevPoint = [[touches anyObject] previousLocationInView:self.canvasView];

    UIGraphicsBeginImageContext(self.canvasView.frame.size);
    [self.canvasView.image drawInRect:CGRectMake(0, 0, self.canvasView.frame.size.width, self.canvasView.frame.size.height)];
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 10.0);  // 太さ
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);  // 線の色
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  // 線の角を丸く
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), prevPoint.x, prevPoint.y);  // ここから
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);  // ここへ
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    
    self.canvasView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // ジェスチャーの結果が何であったかを出力
    NSString *result = nil;
    switch (_gestureResult) {
        case StrokeGestureResultNone:
            result = @"none";
            break;
        case StrokeGestureResultIShaped:
            result = @"I-shaped gesture";
            break;
        case StrokeGestureResultLShaped:
            result = @"L-shaped gesture";
            break;
        case StrokeGestureResultUShaped:
            result = @"U-shaped gesture";
            break;
        case StrokeGestureResultOShaped:
            result = @"O-shaped gesture";
            break;
        case StrokeGestureResultCShaped:
            result = @"C-shaped gesture";
            break;
    }
    [self.currentGestureName setText:@"none"];
    [self.fixedGestureName setText:result];
    _gestureResult = StrokeGestureResultNone;
}

#pragma mark -
#pragma mark UIGestureRecognizerDelegate methods

/* 複数のジェスチャーを同時認識させるため */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark -
#pragma mark StrokeGestureRecognizer handlers

- (void)handleIShapedGesture:(StrokeGestureRecognizer *)recognizer
{
    switch ([recognizer state]) {
        case UIGestureRecognizerStateBegan:  // iOS4
        case UIGestureRecognizerStateChanged:  // iOS5
            // まだ途中だが、正しいジェスチャーであると認識している
            [self.currentGestureName setText:@"I-shaped gesture"];
            break;
        case UIGestureRecognizerStateEnded:
            // 指が離され、正しいジェスチャーであると認識された
            _gestureResult = StrokeGestureResultIShaped;
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            // 正しいジェスチャーであるとは認識できなかった
            [self.currentGestureName setText:@"none"];
            break;
        default:
            [self.fixedGestureName setText:@"UNKNOWN"];
            break;
    }
}

- (void)handleLShapedGesture:(StrokeGestureRecognizer *)recognizer
{
    switch ([recognizer state]) {
        case UIGestureRecognizerStateBegan:  // iOS4
        case UIGestureRecognizerStateChanged:  // iOS5
            // まだ途中だが、正しいジェスチャーであると認識している
            [self.currentGestureName setText:@"L-shaped gesture"];
            break;
        case UIGestureRecognizerStateEnded:
            // 指が離され、正しいジェスチャーであると認識された
            _gestureResult = StrokeGestureResultLShaped;
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            // 正しいジェスチャーであるとは認識できなかった
            [self.currentGestureName setText:@"none"];
            break;
        default:
            [self.fixedGestureName setText:@"UNKNOWN"];
            break;
    }
}

- (void)handleUShapedGesture:(StrokeGestureRecognizer *)recognizer
{
    switch ([recognizer state]) {
        case UIGestureRecognizerStateBegan:  // iOS4
        case UIGestureRecognizerStateChanged:  // iOS5
            // まだ途中だが、正しいジェスチャーであると認識している
            [self.currentGestureName setText:@"U-shaped gesture"];
            break;
        case UIGestureRecognizerStateEnded:
            // 指が離され、正しいジェスチャーであると認識された
            _gestureResult = StrokeGestureResultUShaped;
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            // 正しいジェスチャーであるとは認識できなかった
            [self.currentGestureName setText:@"none"];
            break;
        default:
            [self.fixedGestureName setText:@"UNKNOWN"];
            break;

    }
}

- (void)handleOShapedGesture:(StrokeGestureRecognizer *)recognizer
{
    switch ([recognizer state]) {
        case UIGestureRecognizerStateBegan:  // iOS4
        case UIGestureRecognizerStateChanged:  // iOS5
            // まだ途中だが、正しいジェスチャーであると認識している
            [self.currentGestureName setText:@"O-shaped gesture"];
            break;
        case UIGestureRecognizerStateEnded:
            // 指が離され、正しいジェスチャーであると認識された
            _gestureResult = StrokeGestureResultOShaped;
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            // 正しいジェスチャーであるとは認識できなかった
            [self.currentGestureName setText:@"none"];
            break;
        default:
            [self.fixedGestureName setText:@"UNKNOWN"];
            break;
    }
}

- (void)handleCShapedGesture:(StrokeGestureRecognizer *)recognizer
{
    switch ([recognizer state]) {
        case UIGestureRecognizerStateBegan:  // iOS4
        case UIGestureRecognizerStateChanged:  // iOS5
            // まだ途中だが、正しいジェスチャーであると認識している
            [self.currentGestureName setText:@"C-shaped gesture"];
            break;
        case UIGestureRecognizerStateEnded:
            // 指が離され、正しいジェスチャーであると認識された
            _gestureResult = StrokeGestureResultCShaped;
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            // 正しいジェスチャーであるとは認識できなかった
            [self.currentGestureName setText:@"none"];
            break;
        default:
            [self.fixedGestureName setText:@"UNKNOWN"];
            break;
    }
}

@end
