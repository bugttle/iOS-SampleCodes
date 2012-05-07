//
//  ViewController.h
//  GestureRecognizers
//
//  Created by UQ Times on 12/05/04.
//  Copyright (c) 2012年 Individual. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIView *allGesturesView;  // 全てのジェスチャーを設定する
@property (nonatomic, retain) IBOutlet UIView *panGestureView;  // ドラッグジェスチャのみを設定する
@property (nonatomic, retain) IBOutlet UIView *swipeGestureView;  // スワイプジェスチャのみを設定する
@property (nonatomic, retain) IBOutlet UILabel *gestureNameLabel;  // 検出したジェスチャを出力する
@property (nonatomic, retain) IBOutlet UILabel *subInformationLabel;  // それに付随する情報を出力する

@end
