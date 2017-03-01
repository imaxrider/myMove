//
//  ViewController.h
//  myMove
//
//  Created by smartax on 8/31/15.
//  Copyright (c) 2015 Rachanon Kwampien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DistanceObject.h"
#import <CoreLocation/CoreLocation.h>
#import <sqlite3.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate,UIActionSheetDelegate,NSFileManagerDelegate>
{
    IBOutlet UIButton *btnStart;
    IBOutlet UIButton *btnStop;
    sqlite3 * db;
    MKPolyline *polyLine;
    NSMutableArray * latiArray,*longiArray;
    
    CLLocation * myLocation;
    float distance;
    IBOutlet MKMapView * myMap;
    int SecondsC,LocationDis,seconds;
    
    IBOutlet UITextField *  txtDistance,*txtTime,*txtSpeed,*txtAddress;
    
    NSTimer * timer;
    
   IBOutlet UILabel * lblDate,*lblStart,*lblStop;
    
    //Get Address
    CLGeocoder * Geocoder;
    CLPlacemark * myPlacemark;
    
    NSString * alertAction;
    
    NSNumber * nlati,*nlongi;
}
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *maLocation;
@end

