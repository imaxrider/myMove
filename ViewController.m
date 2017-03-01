//
//  ViewController.m
//  myMove
//
//  Created by smartax on 8/31/15.
//  Copyright (c) 2015 Rachanon Kwampien. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize locationManager,maLocation;
- (void)viewDidLoad {
    [super viewDidLoad];
    myMap.showsUserLocation = YES;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone; //whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestAlwaysAuthorization];
        Geocoder = [[CLGeocoder alloc]init];
    
    // Add This Line
    [myMap setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    
    [myMap setZoomEnabled:YES];
    [myMap setScrollEnabled:YES];
    [btnStop setHidden:TRUE];
    [lblDate setHidden:TRUE];
    [lblStart setHidden:TRUE];
    [lblStop setHidden:TRUE];
    [txtTime setUserInteractionEnabled:NO];
    [txtSpeed setUserInteractionEnabled:NO];
    [txtDistance setUserInteractionEnabled:NO];
    [txtAddress setUserInteractionEnabled:NO];
    
    [self openDB];
    [self createTable:@"savemove" dataField1:@"Date" dataField2:@"Distance" dataField3:@"Time" dataField4:@"Startlo" dataField5:@"Stoplo" dataField6:@"latiArray" dataField7:@"longiArray"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (locationManager == nil) {
        locationManager = [[CLLocationManager alloc] init];
    }
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.activityType = CLActivityTypeFitness;
    
    locationManager.distanceFilter = 10;
}
- (void)distanceSecond
{
    seconds++;
    txtTime.text = [NSString stringWithFormat:@"%@",[DistanceObject stringifySecondCount:seconds usingLongFormat:NO]];
    txtDistance.text = [NSString stringWithFormat:@"%@", [DistanceObject stringifyDistance:distance]];
  NSString * strPace = [NSString stringWithFormat:@"Pace: %@",  [DistanceObject stringifyAvgPaceFromDist:distance overTime:seconds]];
    //lblPrice.text = [NSString stringWithFormat:@"%@",[DistanceController stringifyPrice:priceSum]];
    NSLog(@"Pace: %@",strPace);
}

-(IBAction)startMove:(id)sender
{
    [myMap removeAnnotations:myMap.annotations];
    [myMap removeOverlays:myMap.overlays];
    
    seconds = 0;
    distance = 0;
    maLocation = [NSMutableArray array];
    [btnStart setHidden:TRUE];
    [btnStop setHidden:FALSE];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self
                                           selector:@selector(distanceSecond) userInfo:nil repeats:YES];

    [locationManager startUpdatingLocation];
    
    MKUserLocation *UserLocation = myMap.userLocation;
    CLLocationCoordinate2DMake(UserLocation.coordinate.latitude,UserLocation.coordinate.longitude);
    
    MKCoordinateRegion region = {{0.0,0.0},{0.0,0.0}};
    region.center.latitude = UserLocation.coordinate.latitude;
    region.center.longitude= UserLocation.coordinate.longitude;
    
    [myMap setRegion:region animated:YES];
    
    MKPointAnnotation * MarkStart = [[MKPointAnnotation alloc]init];
    MarkStart.title = @"Start";
    MarkStart.subtitle=@"";
    MarkStart.coordinate=region.center;
    
    [myMap addAnnotation:MarkStart];
    lblStart.text = [NSString stringWithFormat:@"%.6f,%.6f",UserLocation.coordinate.latitude,UserLocation.coordinate.longitude];
}
- (IBAction)stopMove:(id)sender
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:SS"];
    //[formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Bangkok"]];
    NSString*  Datetime = [formatter stringFromDate:[NSDate date]];
    lblDate.text = Datetime;
    
    NSString * strDetail = [NSString stringWithFormat:@"Distance : %@ km\nTime : %@ min\nDate : %@",txtDistance.text,txtTime.text,lblDate.text];
    
    UIAlertView * alvDetail =[[UIAlertView alloc]initWithTitle:@"Confirm Stop" message:strDetail delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Stop", nil];
    [alvDetail show];

}
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    for (CLLocation *newLocation in locations) {
        
        NSDate *eventDate = newLocation.timestamp;
        
        NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
        
        if (fabs(howRecent) < 10.0 && newLocation.horizontalAccuracy < 20) {
            
            // update distance
            if (maLocation.count > 0) {
                distance += [newLocation distanceFromLocation:maLocation.lastObject];
                
                CLLocationCoordinate2D coords[2];
                coords[0] = ((CLLocation *)self.maLocation.lastObject).coordinate;
                coords[1] = newLocation.coordinate;
                
                MKCoordinateRegion region =
                MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 500, 500);
                [myMap setRegion:region animated:YES];
                
                [myMap addOverlay:[MKPolyline polylineWithCoordinates:coords count:2]];
                NSLog(@"%.6f :: %.6f",coords[0].latitude,coords[0].longitude);
                NSLog(@"%.6f :: %.6f",coords[1].latitude,coords[1].longitude);
                
                //mi  *2.23693629
                NSLog(@"speed : %.0f",newLocation.speed*3.6);
                
                txtSpeed.text =[NSString stringWithFormat:@"%.0f",newLocation.speed*3.6];
                //LocationDis = newLocation.speed*3.6;
                           }
            [maLocation addObject:newLocation];
            myLocation = newLocation;
            [Geocoder reverseGeocodeLocation:myLocation completionHandler:^(NSArray * myPlacemarks,NSError * error)
             {
                 if (error == nil && [myPlacemarks count]>0) {
                     myPlacemark = [myPlacemarks lastObject];
                     txtAddress.text = [NSString stringWithFormat:@"%@,%@,%@,%@",myPlacemark.thoroughfare,myPlacemark.locality,myPlacemark.administrativeArea,myPlacemark.postalCode];
                     NSLog(@"%@",txtAddress.text);
                 }
                 else {
                     NSLog(@"%@",error.debugDescription);
                 }
             }];
        }
    }
}
-(void)StopMove
{
    [locationManager stopUpdatingLocation];
    if (timer !=nil)
    {
        [timer invalidate];
        timer = nil;
        NSLog(@"Cancel Trip2");
    }
    [btnStop setHidden:TRUE];
    [btnStart setHidden:FALSE];
    
    MKUserLocation *UserLocation = myMap.userLocation;
    CLLocationCoordinate2DMake(UserLocation.coordinate.latitude,UserLocation.coordinate.longitude);
    
    MKCoordinateRegion region = {{0.0,0.0},{0.0,0.0}};
    region.center.latitude = UserLocation.coordinate.latitude;
    region.center.longitude= UserLocation.coordinate.longitude;
    // region.span.longitudeDelta = 8;
    // region.span.latitudeDelta = 8;
    
    [myMap setRegion:region animated:YES];
    
    MKPointAnnotation * MarkStop = [[MKPointAnnotation alloc]init];
    MarkStop.title = @"Stop";
    MarkStop.subtitle=@"";
    MarkStop.coordinate=region.center;
    
    [myMap addAnnotation:MarkStop];
    lblStop.text = [NSString stringWithFormat:@"%.6f,%.6f",UserLocation.coordinate.latitude,UserLocation.coordinate.longitude];
    
    UIAlertView * alvSave =[[UIAlertView alloc]initWithTitle:@"Confirm Save" message:@"You can save or not your activity?" delegate:self cancelButtonTitle:@"Don't" otherButtonTitles:@"Save", nil];
    [alvSave show];

}
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        polyLine = (MKPolyline *)overlay;
        MKPolylineRenderer *aRenderer = [[MKPolylineRenderer alloc] initWithPolyline:polyLine];
        aRenderer.strokeColor = [UIColor blueColor];
        aRenderer.lineWidth = 4;
        
        return aRenderer;
    }
    return [[MKOverlayRenderer alloc]initWithOverlay:overlay];
}
- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation
{
    if ([[annotation title] isEqualToString:@"Current Location"]) {
        return nil;
    }
    MKAnnotationView *AntView = [[MKAnnotationView alloc ] initWithAnnotation:annotation reuseIdentifier:@"mylocation"];
    if ([[annotation title] isEqualToString:@"Start"])
        AntView.image = [UIImage imageNamed:@"iMark.png"];
    else if ([[annotation title] isEqualToString:@"End"])
        AntView.image = [UIImage imageNamed:@"iMark.png"];
    else
        AntView.image = [UIImage imageNamed:@"iMark.png"];
    AntView.enabled = YES;
    AntView.canShowCallout = YES;
    return AntView;
}
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    alertAction = [alertView buttonTitleAtIndex:buttonIndex];
    if (buttonIndex == 0) {
        if ([alertAction isEqualToString:@"Cancel"]) {
            
        }
    }
    else if (buttonIndex == 1)
    {
        if ([alertAction isEqualToString:@"Stop"]) {
            [self StopMove];
        }
       else if ([alertAction isEqualToString:@"Save"]) {
           [self SaveDataMove];
        }
    }
}
-(void)createTable:(NSString *) tableName dataField1:(NSString *)field1 dataField2:(NSString *)field2 dataField3:(NSString *)field3 dataField4:(NSString *)field4 dataField5:(NSString *)field5 dataField6:(NSString *)field6 dataField7:(NSString *)field7
{
    char * endErr;
    NSString * mySql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@'(ID INTEGER PRIMARY KEY AUTOINCREMENT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT ,'%@' TEXT,'%@' TEXT,'%@' TEXT);",tableName,field1,field2,field3,field4,field5,field6,field7];
    
    if(sqlite3_exec(db, [mySql UTF8String],NULL, NULL, &endErr)!=SQLITE_OK){
        sqlite3_close(db);
        NSAssert(0, @"Could not create table");
        NSLog(@"Could not create table");
    }else{
        NSLog(@"table created");
    }
}
-(NSString *)fileMeter
{
    NSArray *paths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0]stringByAppendingPathComponent:@"dbMove.sql"];
}
-(void)openDB
{
    if (sqlite3_open([[self fileMeter]UTF8String],&db)!=SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(0,@"Database Error");
        NSLog(@"Database Error");
    }else
    {
        NSLog(@"database open");
    }
}
-(void)SaveDataMove
{
    latiArray = [[NSMutableArray alloc]init];
    longiArray = [[NSMutableArray alloc]init];
    
    for (myLocation in self.maLocation) {
        
        nlati = [NSNumber numberWithDouble:myLocation.coordinate.latitude];
        nlongi = [NSNumber numberWithDouble:myLocation.coordinate.longitude];
        
        [latiArray addObject:nlati];
        [longiArray addObject:nlongi];;
    }
    NSString * saveSql = [NSString stringWithFormat:@"INSERT INTO savemove ('Date','Distance','Time','Startlo','Stoplo','latiArray','longiArray') VALUES ('%@','%@','%@','%@','%@','%@','%@')"
                          ,lblDate.text,txtDistance.text,txtTime.text,lblStart.text,lblStop.text,latiArray,longiArray];
    char *enderr;
    if (sqlite3_exec(db,[saveSql UTF8String], NULL, NULL, &enderr)!=SQLITE_OK)
    {
        sqlite3_close(db);
        // NSAssert(0,@"Could not update table");
        NSLog(@"Could not update table");
    }
    else
    {
        NSLog(@"database updated : %@",saveSql);
    }
}
@end
