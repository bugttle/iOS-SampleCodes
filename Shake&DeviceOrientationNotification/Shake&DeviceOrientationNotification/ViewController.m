//
//  ViewController.m
//  Shake&DeviceOrientationNotification
//
//  Created by UQ Times on 12/05/12.
//  Copyright (c) 2012年 Individual. All rights reserved.
//

#import <AudioToolbox/AudioServices.h>
#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, getter=isMotionEventEnabled) BOOL motionEventEnabled;
@end

@implementation ViewController

@synthesize orientationNameLabel = _orientationNameLabel;
@synthesize motionEventEnabled = _motionEventEnabled;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // まだモーションジェスチャーは無効なので、有効にする
    [self toggleOrientationNotification];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.orientationNameLabel = nil;
}

- (void)dealloc
{
    if (self.isMotionEventEnabled) {
        // まだモーションイベントが有効である場合は無効にする
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    }

    [_orientationNameLabel release];
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark -
#pragma mark setting for first responder

/* ファーストレスポンダになるためのメソッドのオーバーライド */
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self becomeFirstResponder];
}

#pragma mark -
#pragma mark motion event methods

/* モーションジェスチャーの開始時に実行される */
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"%s | %@", __PRETTY_FUNCTION__, event);
}

/* モーションジェスチャーの終了時に実行される */
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"%s | %@", __PRETTY_FUNCTION__, event);
    
    // モーションイベントの有効・無効を切り替え
    [self toggleOrientationNotification];
    
    // iPhoneのみだが、受け付けたらバイブレーションで知らせる
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}

/* 大抵の場合、デバイスが動いたが結局シェイクジェスチャーではなかった場合に呼ばれる */
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"%s | %@", __PRETTY_FUNCTION__, event);
}

#pragma mark -
#pragma mark private methods

- (void)orientationChanged:(NSNotification *)notification
{
    NSString *orientationString;
    switch ([UIDevice currentDevice].orientation) {
        case UIDeviceOrientationUnknown:
            orientationString = @"UIDeviceOrientationUnknown";
            break;
        case UIDeviceOrientationPortrait:
            // バックグラウンドから呼び戻した場合、必ずこの値になる
            orientationString = @"UIDeviceOrientationPortrait";
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            orientationString = @"UIDeviceOrientationPortraitUpsideDown";
            break;
        case UIDeviceOrientationLandscapeLeft:
            orientationString = @"UIDeviceOrientationLandscapeLeft";
            break;
        case UIDeviceOrientationLandscapeRight:
            orientationString = @"UIDeviceOrientationLandscapeRight";
            break;
        case UIDeviceOrientationFaceUp:
            orientationString = @"UIDeviceOrientationFaceUp";
            break;
        case UIDeviceOrientationFaceDown:
            orientationString = @"UIDeviceOrientationFaceDown";
            break;
    }
    [self.orientationNameLabel setText:orientationString];
    NSLog(@"%s | %@", __PRETTY_FUNCTION__, orientationString);
}

- (void)toggleOrientationNotification
{
    // 傾きを検知を有効: 青色
    // 傾きを検知を無効: 赤色
    if (!self.isMotionEventEnabled) {
        //[[UIDevice currentDevice] isGeneratingDeviceOrientationNotifications]を使いたいがうまく動作しなかった
        // モーションジェスチャーが無効であれば、青色にして有効にする
        self.motionEventEnabled = YES;
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
        self.view.backgroundColor = [UIColor colorWithRed:142.0/255.0 green:200.0/255.0 blue:255.0/255.0 alpha:1.0];
    } else {
        // モーションジェスチャーが有効であれば、赤色にして無効にする
        self.motionEventEnabled = NO;
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
        [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
        self.view.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:190.0/255.0 blue:160.0/255.0 alpha:1.0];
    }
}

@end
