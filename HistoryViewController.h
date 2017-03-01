//
//  UIViewController+History.h
//  myMove
//
//  Created by smartax on 9/1/15.
//  Copyright (c) 2015 Rachanon Kwampien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface HistoryViewController : UIViewController<UITextFieldDelegate,MKMapViewDelegate,CLLocationManagerDelegate>
{
    IBOutlet UILabel *lblOne;
    NSString * strStartLa,*strStartLo,*strStopLa,*strStopLo;
    IBOutlet MKMapView * myMap;
    
    double dbStartLa,dbStartLo,dbStopLa,dbStopLo;
    
    IBOutlet UITextField * txtDis,*txtTime,*txtDate;
    
    MKRouteStep * routeStep;
    NSUInteger * routeIndex;
    
    NSArray * latiArray,*longArray;
    
    NSString * strNewLa,*strNewLong;
    double Latitude,Longitude;
    CLLocationManager *locationManager;
}
@property (strong , nonatomic)id moveData;
@end
