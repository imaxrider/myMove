//
//  UIViewController+History.m
//  myMove
//
//  Created by smartax on 9/1/15.
//  Copyright (c) 2015 Rachanon Kwampien. All rights reserved.
//

#import "HistoryViewController.h"

@implementation HistoryViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    lblOne.text = [self.moveData description];
    [lblOne setHidden:TRUE];
    
    lblOne.text = [lblOne.text stringByReplacingOccurrencesOfString:@"Distance : " withString:@""];
    lblOne.text = [lblOne.text stringByReplacingOccurrencesOfString:@" km" withString:@""];
    lblOne.text = [lblOne.text stringByReplacingOccurrencesOfString:@"Time : " withString:@""];
    lblOne.text = [lblOne.text stringByReplacingOccurrencesOfString:@" min" withString:@""];
    
    NSArray * locationArray = [lblOne.text componentsSeparatedByString:@"^"];
    NSArray * DetailArray = [lblOne.text componentsSeparatedByString:@","];
    
    txtDate.text = [DetailArray objectAtIndex:0];
      txtDis.text = [DetailArray objectAtIndex:1];
      txtTime.text = [DetailArray objectAtIndex:2];
    
    strStartLa = [DetailArray objectAtIndex:3];
    strStartLo = [DetailArray objectAtIndex:4];
    strStopLa = [DetailArray objectAtIndex:5];
    strStopLo = [DetailArray objectAtIndex:6];
    
    NSString * strLatitude = [locationArray objectAtIndex:1];
    NSString * strLongitude  = [locationArray objectAtIndex:2];
    
    //ทำละลองstring กลับเป็น array
    
    latiArray = [[NSArray alloc]init];
    longArray = [[NSArray alloc]init];
    latiArray = [strLatitude componentsSeparatedByString:@","];
    longArray = [strLongitude componentsSeparatedByString:@","];
    
    [txtDis setUserInteractionEnabled:NO];
    [txtTime setUserInteractionEnabled:NO];
    [txtDate setUserInteractionEnabled:NO];
    
    //start location
    dbStartLa = [strStartLa doubleValue];
    dbStartLo = [strStartLo doubleValue];
    
    //stop location
    dbStopLa = [strStopLa doubleValue];
    dbStopLo = [strStopLo doubleValue];

    [myMap setZoomEnabled:YES];
    [myMap setScrollEnabled:YES];
    
    MKCoordinateRegion region1 = {{0.0,0.0},{0.0,0.0}};
    region1.center.latitude = dbStartLa;
    region1.center.longitude = dbStartLo;
    [myMap setRegion:region1 animated:YES];
    
    NSString * StartSub = [NSString stringWithFormat:@"%@,%@",strStartLa,strStartLo];
    
    MKPointAnnotation *StartMark = [[MKPointAnnotation alloc]init];
    StartMark.title = @"Start";
    StartMark.subtitle = StartSub;
    StartMark.coordinate = region1.center;
    [myMap addAnnotation:StartMark];
    
    //marker stop
    MKCoordinateRegion region2 = {{0.0,0.0},{0.0,0.0}};
    region2.center.latitude = dbStopLa;
    region2.center.longitude = dbStopLo;
    region2.span.longitudeDelta = 0.1;
    region2.span.latitudeDelta = 0.1;
    [myMap setRegion:region2 animated:YES];
    
    NSString * StopSub = [NSString stringWithFormat:@"%@,%@",strStopLa,strStopLo];
    
    MKPointAnnotation *StopMark = [[MKPointAnnotation alloc]init];
    StopMark.title = @"End";
    StopMark.subtitle = StopSub;
    StopMark.coordinate = region2.center;
    [myMap addAnnotation:StopMark];
  [self loadPolyline];
}
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *polyLine = (MKPolyline *)overlay;
        MKPolylineRenderer *aRenderer = [[MKPolylineRenderer alloc] initWithPolyline:polyLine];
        aRenderer.strokeColor = [UIColor redColor];
        aRenderer.lineWidth = 4;
        return aRenderer;
    }
    
    return nil;
}
- (MKCoordinateRegion)mapRegion
{//[latiArray count] && (และ)[longArray count]
    MKCoordinateRegion region;
    
    for (int k = 0;k < [latiArray count]; k++) {
        
        NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@".0123456789-"]invertedSet];//เอาเฉพาะตัวที่กำหนด
        strNewLa = [NSString stringWithFormat:@"%@",[[latiArray[k] componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""]];
        strNewLong = [NSString stringWithFormat:@"%@",[[longArray[k] componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""]];
        
        //แปลงstring เป็น double
        Latitude = [strNewLa doubleValue];
        Longitude = [strNewLong doubleValue];
        NSLog(@"%f,%f",Latitude,Longitude);
        
        double minLat = Latitude;
        double minLng = Longitude;
        double maxLat = Latitude;
        double maxLng = Longitude;
        
        
        
        if(Latitude < minLat)
        {
            minLat = Latitude;
        }
        if(Longitude < minLng)
        {
            minLng = Longitude;
        }
        
        if(Latitude > maxLat)
        {
            maxLat = Latitude;
        }
        
        if(Longitude > maxLng)
        {
            maxLng = Longitude;
        }
        
        region.center.latitude = (minLat + maxLat) / 2.0f;
        region.center.longitude = (minLng + maxLng) / 2.0f;
        
        region.span.latitudeDelta = (maxLat - minLat) * 1.1f; // 10% padding
        region.span.longitudeDelta = (maxLng - minLng) * 1.1f; // 10% padding
        
    }
    return region;
}

- (MKPolyline *)polyLine {
    
    CLLocationCoordinate2D coord[[latiArray count] ];
    
    for (int l = 0; l < [latiArray count] ; l++) {
        
        NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@".0123456789-"]invertedSet];//เอาเฉพาะตัวที่กำหนด
        strNewLa = [NSString stringWithFormat:@"%@",[[latiArray[l] componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""]];
        strNewLong = [NSString stringWithFormat:@"%@",[[longArray[l] componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""]];
        
        //แปลงstring เป็น double
        Latitude = [strNewLa doubleValue];
        Longitude = [strNewLong doubleValue];
        //  NSLog(@"%d",l);
        coord[l] = CLLocationCoordinate2DMake(Latitude,Longitude);
    }
    
    return [MKPolyline polylineWithCoordinates:coord count:[latiArray count]];
}
-(void)loadPolyline
{
    if (latiArray.count && longArray.count > 0) {
        //[myMap setRegion:[self mapRegion]];
        [myMap addOverlay:[self polyLine]];
    }
    else {
        
        // no locations were found!
        
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:@"Sorry, this run has no locations saved."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
    
    [myMap addOverlay:[self polyLine]];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(IBAction)Back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    // Movement threshold for new events.
    locationManager.distanceFilter = 10; // meters
    //[timer invalidate];
}
-(MKAnnotationView*)annotationView {
    
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] init];
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
 //   annotationView.image = [[UIImage imageNamed:@"ic_search"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationView.tintColor = [UIColor redColor];
    return annotationView;
}
- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation
{
    if ([[annotation title] isEqualToString:@"Current Location"]) {
        return nil;
    }
    MKAnnotationView *AntView = [[MKAnnotationView alloc ] initWithAnnotation:annotation reuseIdentifier:@"mylocation"];
    if ([[annotation title] isEqualToString:@"Start"])
        AntView.image = [ UIImage imageNamed:@"iMark.png" ];
    else if ([[annotation title] isEqualToString:@"End"])
        AntView.image = [ UIImage imageNamed:@"iMark.png" ];
    else
        AntView.image = [ UIImage imageNamed:@"iMark.png" ];
    
    AntView.annotation = annotation;
    AntView.enabled = YES;
    AntView.canShowCallout = YES;
    return AntView;
}

@end
