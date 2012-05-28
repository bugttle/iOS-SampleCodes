//
//  ViewController.m
//  CoreLocationSample-MKReverseGeocoder
//
//  Created by UQ Times on 12/05/28.
//  Copyright (c) 2012年 Individual. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, retain) MKReverseGeocoder *geocoder;
@property (nonatomic, retain) NSMutableArray *addressesArray;
@end

@implementation ViewController

@synthesize geocoder = _geocoder;
@synthesize addressesArray = _addressesArray;

@synthesize mapView = _mapView;
@synthesize resultTableView = _resultTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 現在地を利用する
    _mapView.showsUserLocation = YES;
    
    // 履歴を保持する配列
    _addressesArray = [[NSMutableArray alloc] init];
}

- (void)viewDidUnload
{
    [_geocoder cancel];
    _geocoder.delegate = nil;
    
    self.geocoder = nil;
    self.addressesArray = nil;
    
    self.mapView = nil;
    self.resultTableView = nil;
    
    [super viewDidUnload];
}

- (void)dealloc
{
    [_geocoder cancel];
    _geocoder.delegate = nil;
    
    [_geocoder release];
    [_addressesArray release];
    
    [_mapView release];
    [_resultTableView release];
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/* UIMapViewの中心点の座標を元に、逆ジオコーディング */
- (IBAction)convertCoordinate:(UIButton *)sender {
    CLLocationCoordinate2D location = [_mapView convertPoint:_mapView.center toCoordinateFromView:_mapView];
    NSLog(@"%lf, %lf", location.latitude, location.longitude);
    
    self.geocoder = [[[MKReverseGeocoder alloc] initWithCoordinate:location] autorelease];
    _geocoder.delegate = self;
    [_geocoder start];
}

#pragma mark - MKReverseGeocoderDelegate methods

/* エラー発生時 */
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
    NSLog(@"%s | %@", __PRETTY_FUNCTION__, error);
    [_addressesArray insertObject:[error localizedDescription] atIndex:0];
    [_resultTableView reloadData];
}

/* ジオコーディング成功時 */
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
    // ログに残す
    [self logPlacemark:placemark];
    // 履歴に追加
    NSString *formattedAddress = [[placemark.addressDictionary objectForKey:@"FormattedAddressLines"] componentsJoinedByString:@" "];
    [_addressesArray insertObject:formattedAddress atIndex:0];  // 最新のものを先頭に
    [_resultTableView reloadData];
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

/* プレースマークの情報をログに残すだけ
 * iOS 4.3と iOS 5.0との差分は以下のURLを参照
 * http://developer.apple.com/library/ios/#releasenotes/General/iOS50APIDiff/index.html#//apple_ref/doc/uid/TP40011042
 */
- (void)logPlacemark:(MKPlacemark *)placemark
{
    NSLog(@"addressDictionary: %@", placemark.addressDictionary);
    NSLog(@"administrativeArea: %@", placemark.administrativeArea);
    if ([placemark respondsToSelector:@selector(areasOfInterest)]) {
        NSLog(@"areasOfInterest: %@", placemark.areasOfInterest);  // iOS 5.0以降
    }
    NSLog(@"country: %@", placemark.country);
    if ([placemark respondsToSelector:@selector(inlandWater)]) {
        NSLog(@"inlandWater: %@", placemark.inlandWater);  // iOS 5.0以降
    }
    NSLog(@"locality: %@", placemark.locality);
    if ([placemark respondsToSelector:@selector(name)]) {
        NSLog(@"name: %@", placemark.name);  // iOS 5.0以降
    }
    if ([placemark respondsToSelector:@selector(ocean)]) {
        NSLog(@"ocean: %@", placemark.ocean);  // iOS 5.0以降
    }
    NSLog(@"postalCode: %@", placemark.postalCode);
    if ([placemark respondsToSelector:@selector(region)]) {
        NSLog(@"region: %@", placemark.region);  // iOS 5.0以降
    }
    NSLog(@"subAdministrativeArea: %@", placemark.subAdministrativeArea);
    NSLog(@"subLocality: %@", placemark.subLocality);
    NSLog(@"subThoroughfare: %@", placemark.subThoroughfare);
    NSLog(@"thoroughfare: %@", placemark.thoroughfare);
}

@end
