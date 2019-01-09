//
//  ViewController.m
//  MultitouchTrackingSample
//
//  Created by UQ Times on 12/05/31.
//  Copyright (c) 2012年 Individual. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    // UITouchの情報を格納するため、CFMutableDictionaryRefを利用する
    // 詳細は、「iOSイベント処理ガイド」の「複雑なマルチタッチシーケンスの処理」を参照
    // https://developer.apple.com/jp/devcenter/ios/library/documentation/EventHandlingiPhoneOS.pdf#page=28
    CFMutableDictionaryRef _touchSession;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // viewのマルチタッチを有効にする
    self.view.multipleTouchEnabled = YES;
    
    // UITouchの情報を格納するため、CFMutableDictionaryRefを利用する
    _touchSession = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
}

- (void)viewDidUnload
{
    if (_touchSession) {
        CFRelease(_touchSession);
    }
    
    [super viewDidUnload];
}

- (void)dealloc
{
    if (_touchSession) {
        CFRelease(_touchSession);
    }
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // タッチの下図だけラベルを生成し、viewに配置
    for (UITouch *touch in touches) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        label.text = @"touched";
        label.textAlignment = UITextAlignmentCenter;
        label.center = [touch locationInView:self.view];
        [self.view addSubview:label];
        
        // copyできないため、CFMutableDictionaryRefでアドレスを保持する
        CFDictionaryAddValue(_touchSession, touch, label);
        [label release];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        // 同じUITouchはアドレスが変わらないので、CFMutableDictionaryRefから保持しているラベルを取得
        UILabel *label = (UILabel *)CFDictionaryGetValue(_touchSession, touch);
        
        // 指に合わせて移動
        label.center = [touch locationInView:self.view];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        // 離された指の情報を取得し、ラベルを削除
        UILabel *label = (UILabel *)CFDictionaryGetValue(_touchSession, touch);
        [label removeFromSuperview];
        CFDictionaryRemoveValue(_touchSession, touch);
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    // touchesEndedと同じ
    for (UITouch *touch in touches) {
        UILabel *label = (UILabel *)CFDictionaryGetValue(_touchSession, touch);
        [label removeFromSuperview];
        CFDictionaryRemoveValue(_touchSession, touch);
    }
}

@end
