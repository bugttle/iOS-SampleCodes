//
//  ViewController.h
//  GestureRecognizers
//
//  Created by UQ Times on 12/05/04.
//  Copyright (c) 2012年 Individual. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    UIView *allGesturesView; // 全てのジェスチャーを設定する
    UIView *panGestureView; // ドラッグジェスチャのみを設定する
    UIView *swipeGestureView; // スワイプジェスチャのみを設定する
    UILabel *showGestureName; // どのようなジェスチャを検知したかを出力する
    UILabel *showSubInfomation; // それに付随する情報を出力する
}

@property (nonatomic, retain) IBOutlet UIView *allGesturesView;
@property (nonatomic, retain) IBOutlet UIView *panGestureView;
@property (nonatomic, retain) IBOutlet UIView *swipeGestureView;
@property (nonatomic, retain) IBOutlet UILabel *showGestureName;
@property (nonatomic, retain) IBOutlet UILabel *showSubInformation;

@end
