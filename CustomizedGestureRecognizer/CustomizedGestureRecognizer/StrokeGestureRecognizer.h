//
//  StrokeGestureRecognizer.h
//  CustomizedGestureRecognizer
//
//  Created by UQ Times on 12/05/05.
//  Copyright (c) 2012年 Individual. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

typedef enum {
    StrokeGestureRecognizerDirectionUp,  // 上
    StrokeGestureRecognizerDirectionRight,  // 右
    StrokeGestureRecognizerDirectionDown,  // 下
    StrokeGestureRecognizerDirectionLeft,  // 左
} StrokeGestureRecognizerDirection;

@interface StrokeGestureRecognizer : UIGestureRecognizer

/* ジェスチャーであると認識するために、最低でも必要な線の長さ
 * iPhone/iPadで分ける場合にも使える
 */
@property (nonatomic) NSInteger lowerLimitOfStrokeLength;

/* どのようなジェスチャを検出したいかを追加する
 * ex.) ↓→であれば、
 *   StrokeGestureRecognizer *sgr = [[StrokeGestureRecognizer alloc] initWithTarget:target action:action];
 *   [sgr addWantedStroke:StrokeGestureRecognizerDirectionDown];
 *   [sgr addWantedStroke:StrokeGestureRecognizerDirectionRight];
 *   [view addGestureRecognizer:sgr];
 */
- (void) addWantedStroke:(StrokeGestureRecognizerDirection)wantedStroke;

@end
