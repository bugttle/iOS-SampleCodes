//
//  StrokeGestureRecognizer.m
//  CustomizedGestureRecognizer
//
//  Created by UQ Times on 12/05/05.
//  Copyright (c) 2012年 Individual. All rights reserved.
//

#import "StrokeGestureRecognizer.h"

// どの方向でもない "None" が必要なため、ヘッダとは別に定義
typedef enum {
    LocalStrokeDirectionNone = -1,
    LocalStrokeDirectionUp,
    LocalStrokeDirectionRight,
    LocalStrokeDirectionDown,
    LocalStrokeDirectionLeft,
} LocalStrokeDirection;

@interface StrokeGestureRecognizer()
{
  @private
    int _strokeCount;  // ジェスチャーの線であると認識された回数
    float _strokeLengths[4];   // 動かした距離を上下左右のそれぞれの方向で保持する
    LocalStrokeDirection _lastDirection;  // 最後に動かした方向(→→のように同じ方向をジェスチャーと認識しないように)
    NSMutableArray *_wantedGesture;  // 最終的に必要なジェスチャー
}
@property (nonatomic, retain) NSMutableArray *wantedGesture;
@end
    
@implementation StrokeGestureRecognizer

@synthesize lowerLimitOfStrokeLength = _lowerLimitOfStrokeDistance;
@synthesize wantedGesture = _wantedGesture;

- (id)initWithTarget:(id)target action:(SEL)action
{
    self = [super initWithTarget:target action:action];
    if (self != nil) {
        self.lowerLimitOfStrokeLength = 50;  // 初期値
        [self clearVariables];
        self.wantedGesture = [NSMutableArray array];
        
        // 呼び出し元のビューではまだ操作をしているので、ビューには伝えない
        self.cancelsTouchesInView = NO;
    }
    return self;
}

- (void)dealloc
{
    [_wantedGesture release];
    [super dealloc];
}

/* それぞれの方向への移動距離をリセット */
- (void)clearDistances
{
    for (int i = 0; i < 4; i++) {
        _strokeLengths[i] = 0;
    }
}

/* 初期化やリセット時に呼ばれる */
- (void)clearVariables
{
    _strokeCount = 0;
    [self clearDistances];
    _lastDirection = LocalStrokeDirectionNone;
}

#pragma mark -
#pragma mark public methods

- (void)addWantedStroke:(StrokeGestureRecognizerDirection)direction
{
    // ヘッダに書いてあるものとenumの値は同じだが、変換する
    LocalStrokeDirection localDirection;
    switch (direction) {
        case StrokeGestureRecognizerDirectionUp:
            localDirection = LocalStrokeDirectionUp;
            break;
        case StrokeGestureRecognizerDirectionRight:
            localDirection = LocalStrokeDirectionRight;
            break;
        case StrokeGestureRecognizerDirectionDown:
            localDirection = LocalStrokeDirectionDown;
            break;
        case StrokeGestureRecognizerDirectionLeft:
            localDirection = LocalStrokeDirectionLeft;
            break;
        default:  // 変な値を入れられたら失敗
            self.state = UIGestureRecognizerStateFailed;
            return;
    }
    [self.wantedGesture addObject:[NSNumber numberWithInt:localDirection]];
}

#pragma mark -
#pragma mark UIGestureRecognizerSubclass methods

- (void)reset{
    [super reset];
    
    [self clearVariables];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];

    // ・1本指以外は失敗
    // ・認識したいジェスチャが定義されていない場合は失敗
    if ([touches count] != 1 || [self.wantedGesture count] == 0) {
        self.state = UIGestureRecognizerStateFailed;
        return;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    CGPoint nowPoint = [[touches anyObject] locationInView:self.view];
    CGPoint prevPoint = [[touches anyObject] previousLocationInView:self.view];
    LocalStrokeDirection currentDirection;  // 前回と今回とを比較しどの方向に移動したか
    
    float xDistance = nowPoint.x - prevPoint.x;
    float yDistance = nowPoint.y - prevPoint.y;
    if (abs(yDistance) < abs(xDistance)) {
        // 縦方向と横方向の移動量を比較し、"横"方向への移動が多い
        if(nowPoint.x < prevPoint.x) {
            currentDirection = LocalStrokeDirectionLeft;  // "左"に移動している
        } else if(prevPoint.x < nowPoint.x) {
            currentDirection = LocalStrokeDirectionRight;  // "右"に移動している
        }
        _strokeLengths[currentDirection] += abs(xDistance);
    } else {
        // 縦方向と横方向の移動量を比較し、"縦"方向への移動が多い
        if(nowPoint.y < prevPoint.y) {
            currentDirection = LocalStrokeDirectionUp;  // "上"に移動している
        } else if(prevPoint.y < nowPoint.y) {
            currentDirection = LocalStrokeDirectionDown;  // "下"に移動している
        }
        _strokeLengths[currentDirection] += abs(yDistance);
    }
    
    if (self.lowerLimitOfStrokeLength <= _strokeLengths[currentDirection]) {
        // 最低の移動距離を超えたためジェスチャーとして処理する
        if (_lastDirection != currentDirection) {
            // 前回と移動方向が異なるので、ジェスチャーとして比較する (同じ方向が連続する場合は比較しない)
            _lastDirection = currentDirection;  // 移動方向を更新
            _strokeCount++;  // ストロークの回数を増やす
            if ([self.wantedGesture count] < _strokeCount) {
                // 必要とするジェスチャーを通り過ぎた
                // ここが実行される時には
                //     iOS4: Began, iOS5: Began/Changed
                // なので、Canclledにする
                self.state = UIGestureRecognizerStateCancelled;
                return;
            }
            LocalStrokeDirection wantedDirection = [[self.wantedGesture objectAtIndex:_strokeCount - 1] intValue];
            if (wantedDirection != currentDirection) {
                // 必要とするジェスチャーではない
                // 「Possible ならば Faild」「Began/Changed ならば Canceled」とする
                if (self.state == UIGestureRecognizerStatePossible) {
                    self.state = UIGestureRecognizerStateFailed;
                } else {
                    self.state = UIGestureRecognizerStateCancelled;
                }
                return;
            }
            if ([self.wantedGesture count] == _strokeCount) {
                // 必要とするジェスチャーと一致
                //   iOS4では"Began"に設定すると"Changed"に設定しない限りずっと"Began"だが、
                //   iOS5では1度だけBeganで自動的に"Changed"になってしまう
                //     iOS4: Possible -> Began -> Ended
                //     iOS5: Possible -> Began -> Changed -> Ended
                self.state = UIGestureRecognizerStateBegan;
                return;
            }
            
        }
        [self clearDistances];  // 次のジェスチャーに備えて、移動量をクリア
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    switch (self.state) {
        case UIGestureRecognizerStatePossible:  // 移動せずに終了した
        case UIGestureRecognizerStateFailed:  // ジェスチャーと認識されなかった
            self.state = UIGestureRecognizerStateFailed;
            break;
        case UIGestureRecognizerStateBegan:  // iOS4
        case UIGestureRecognizerStateChanged:  // iOS5
            // ジェスチャーが正しく認識された状態で指を話した
            self.state = UIGestureRecognizerStateEnded;
            break;
        default:
            // ジェスチャーの認識中に指が離された
            self.state = UIGestureRecognizerStateCancelled;
            break;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    // resetは呼ばれないため、初期化
    [self clearVariables];
    self.state = UIGestureRecognizerStateFailed;
}

@end
