//
//  ViewController.m
//  CoreLocationSample-Geocoding
//
//  Created by UQ Times on 12/05/27.
//  Copyright (c) 2012年 Individual. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()
@property (nonatomic, retain) CLGeocoder *geocoder;
@property (nonatomic, retain) NSMutableArray *addressesArray;
@end

@implementation ViewController

@synthesize geocoder = _geocoder;
@synthesize addressesArray = _addressesArray;

@synthesize placeNameLabel = _placeNameLabel;
@synthesize placeNameText = _placeNameText;
@synthesize latitudeLabel = _latitudeLabel;
@synthesize latitudeText = _latitudeText;
@synthesize longitudeLabel = _longitudeLabel;
@synthesize longitudeText = _longitudeText;
@synthesize resultTableView = _resultTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // ジオコーディングのインスタンス生成
    _geocoder = [[CLGeocoder alloc] init];
    // 履歴を保持する配列
    _addressesArray = [[NSMutableArray alloc] init];
}

- (void)viewDidUnload
{
    self.geocoder = nil;
    self.addressesArray = nil;
    
    self.placeNameLabel = nil;
    self.placeNameText = nil;
    self.latitudeLabel = nil;
    self.latitudeText = nil;
    self.longitudeLabel = nil;
    self.longitudeText = nil;
    self.resultTableView = nil;
    
    [super viewDidUnload];
}

- (void)dealloc {
    [_geocoder release];
    [_addressesArray release];
    
    [_placeNameLabel release];
    [_placeNameText release];
    [_latitudeLabel release];
    [_longitudeLabel release];
    [_latitudeText release];
    [_longitudeText release];
    [_resultTableView release];
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/* キーボードを閉じるため */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideKeyboard];
}

- (void)hideKeyboard
{
    // キーボードを閉じる
    [_placeNameText resignFirstResponder];
    [_latitudeText resignFirstResponder];
    [_longitudeText resignFirstResponder];
}

#pragma mark - IBAction methods

- (IBAction)searchPlaceName:(id)sender {
    // 住所が正しいかをチェック
    if (![self placeNameIsValid]) {
        return;  // エラーがあれば検索しない
    }
    
    // キーボードを閉じる
    [self hideKeyboard];
    
    // 正ジオコーディングの開始
    [_geocoder geocodeAddressString:_placeNameText.text completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"%s | %@", __PRETTY_FUNCTION__, error);
            [_addressesArray insertObject:[self errorToString:error] atIndex:0];  // 最新のものを先頭に
        } else {
            for (CLPlacemark *p in placemarks) {
                // ログ出力
                NSLog(@"%s", __PRETTY_FUNCTION__);
                [self logPlacemark:p];
                // 緯度・経度のテキストフィールドに反映
                _latitudeText.text = [NSString stringWithFormat:@"%lf", p.location.coordinate.latitude];
                _longitudeText.text = [NSString stringWithFormat:@"%lf", p.location.coordinate.longitude];
                // 履歴に残す
                NSString *formattedAddress = [[p.addressDictionary objectForKey:@"FormattedAddressLines"] componentsJoinedByString:@" "];
                [_addressesArray insertObject:formattedAddress atIndex:0];  // 最新のものを先頭に
            }
        }
        // テーブルビューの更新
        [_resultTableView reloadData];
    }];
}

- (IBAction)convertCoordinate:(id)sender {
    // 緯度が正しいかをチェック
    if (![self coordinateIsValid]) {
        return;  // エラーがあれば変換しない
    }
    
    // キーボードを閉じる
    [self hideKeyboard];
    
    // 入力されている緯度・経度を元にCLLocationを作成
    CLLocationDegrees latitude = [_latitudeText.text floatValue];
    CLLocationDegrees longitude = [_longitudeText.text floatValue];
    CLLocation *location = [[[CLLocation alloc] initWithLatitude:latitude longitude:longitude] autorelease];
    
    // 逆ジオコーディングの開始
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"%s | %@", __PRETTY_FUNCTION__, error);
            [_addressesArray insertObject:[self errorToString:error] atIndex:0];  // 最新のものを先頭に
        } else {
            if (0 < [placemarks count]) {
                // ログ出力
                NSLog(@"%s", __PRETTY_FUNCTION__);
                CLPlacemark *p = [placemarks objectAtIndex:0];
                [self logPlacemark:p];
                // 住所のテキストフィールドに反映
                NSString *formattedAddress = [[p.addressDictionary objectForKey:@"FormattedAddressLines"] componentsJoinedByString:@" "];
                _placeNameText.text = formattedAddress;
                // ログに残す
                [_addressesArray insertObject:formattedAddress atIndex:0];  // 最新のものを先頭に
            }
        }
        // テーブルビューの更新
        [_resultTableView reloadData];
    }];
}

#pragma mark - input validation methods

/* 入力されている値が、正しい住所情報であるかを判定 */
- (BOOL)placeNameIsValid
{
    // 単純に空欄・スペースのみでないかをチェック
    NSRange range = [_placeNameText.text rangeOfString:@"^\\s*$" options:NSRegularExpressionSearch];
    if (range.location == NSNotFound) {
        // 正常
        _placeNameText.textColor = [UIColor blackColor];
        return YES;
    } else {
        // 空欄・スペースのみ
        _placeNameText.textColor = [UIColor redColor];
        return NO;
    }
}

/* 入力されている値が、正しい緯度・経度であるかを判定
 * CLLocationCoordinate2DIsValid だと、緯度か経度のどちらが誤っているか検知できない
 */
- (BOOL)coordinateIsValid
{
    NSString *coordinateRangeString = @"^[+-]?\\d+(?:\\.\\d+)?$";
    BOOL latitudeIsValid = YES;
    BOOL longitudeIsValid = YES;
    NSRange range;
    
    /* 緯度が正しいかをチェック */
    range = [_latitudeText.text rangeOfString:coordinateRangeString options:NSRegularExpressionSearch];
    if (range.location == NSNotFound) {
        latitudeIsValid = NO;  // 緯度ではない
    } else {
        // 範囲内の数値であるか
        CLLocationDegrees latitude = [_latitudeText.text floatValue];
        if (latitude < -90 || 90 < latitude) {
            latitudeIsValid = NO;  // 緯度ではない
        }
    }
    // Viewに反映
    if (latitudeIsValid) {
        _latitudeLabel.textColor = [UIColor blackColor];
    } else {
        _latitudeLabel.textColor = [UIColor redColor];
    }
    
    /* 経度が正しいかをチェック */
    range = [_longitudeText.text rangeOfString:coordinateRangeString options:NSRegularExpressionSearch];
    if (range.location == NSNotFound) {
        longitudeIsValid = NO;  // 経度ではない
    } else {
        // 範囲内の数値であるか
        CLLocationDegrees longitude = [_longitudeText.text floatValue];
        if (longitude < -180 || 180 < longitude) {
            longitudeIsValid = NO;  // 経度ではない
        }
    }
    // Viewに反映
    if (longitudeIsValid) {
        _longitudeLabel.textColor = [UIColor blackColor];
    } else {
        _longitudeLabel.textColor = [UIColor redColor];
    }
    
    // 緯度・経度の両方が正しい場合のみYES
    return (latitudeIsValid && longitudeIsValid);
}

#pragma mark - UITableViewDataSource methods

/* テーブルのセクション数 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_addressesArray count];
}

/* テーブルのセルに表示する内容 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"History";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier] autorelease];
	}
    
    // 最新のものが上に来るように数字を数える
    cell.textLabel.text = [NSString stringWithFormat:@"住所%d", ([_addressesArray count] - indexPath.row)];
    cell.detailTextLabel.text = [_addressesArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - private methods

/* エラーを文字列に変換 */
- (NSString *)errorToString:(NSError *)error
{
    switch ([error code]) {
        case kCLErrorGeocodeFoundNoResult:
            return @"NoResult";
        case kCLErrorGeocodeFoundPartialResult:
            return @"PartialResult";
        case kCLErrorGeocodeCanceled:
            return @"Canceled";
        default:
            return [error description];
    }
}

/* プレースマークの情報をログに残すだけ */
- (void)logPlacemark:(CLPlacemark *)placemark
{
    NSLog(@"addressDictionary: %@", placemark.addressDictionary);
    NSLog(@"administrativeArea: %@", placemark.administrativeArea);
    NSLog(@"areasOfInterest: %@", placemark.areasOfInterest);
    NSLog(@"country: %@", placemark.country);
    NSLog(@"inlandWater: %@", placemark.inlandWater);
    NSLog(@"locality: %@", placemark.locality);
    NSLog(@"name: %@", placemark.name);
    NSLog(@"ocean: %@", placemark.ocean);
    NSLog(@"postalCode: %@", placemark.postalCode);
    NSLog(@"region: %@", placemark.region);
    NSLog(@"subAdministrativeArea: %@", placemark.subAdministrativeArea);
    NSLog(@"subLocality: %@", placemark.subLocality);
    NSLog(@"subThoroughfare: %@", placemark.subThoroughfare);
    NSLog(@"thoroughfare: %@", placemark.thoroughfare);
}

@end
