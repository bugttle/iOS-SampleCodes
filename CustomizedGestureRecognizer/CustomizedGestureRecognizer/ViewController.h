//
//  ViewController.h
//  CustomizedGestureRecognizer
//
//  Created by UQ Times on 12/05/05.
//  Copyright (c) 2012年 Individual. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    StrokeGestureResultNone,
    StrokeGestureResultIShaped,
    StrokeGestureResultLShaped,
    StrokeGestureResultUShaped,
    StrokeGestureResultOShaped,
    StrokeGestureResultCShaped,
} StrokeGestureResult;

@interface ViewController : UIViewController <UIGestureRecognizerDelegate>
{
    UIImageView *_canvasView;
    UILabel *_currentGestureName;
    UILabel *_fixGestureName;
    StrokeGestureResult _gestureResult;
}

@property (nonatomic, retain) IBOutlet UIImageView *canvasView;
@property (nonatomic, retain) IBOutlet UILabel *currentGestureName;
@property (nonatomic, retain) IBOutlet UILabel *fixedGestureName;

@end
