//
//  GeoLocal.h
//  iArmadio
//
//  Created by Casa Fortunato on 19/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "IarmadioDao.h"
#import "SetupViewController.h"



@class IarmadioDao;
#define MAX_TENTATIVI 30

@interface GeoLocal: NSObject  <MKMapViewDelegate, CLLocationManagerDelegate, MKReverseGeocoderDelegate, NSXMLParserDelegate> { 
    
    IarmadioDao *dao;
    MKReverseGeocoder *geoCoder;
    NSData *responseData;
    int temperatura;
    int oldTemperatura;
    NSString *currLocation;
    CLLocationManager *locationManager;
    BOOL isEnableGPS;
    BOOL isStartedUpdatingLocation;
    NSDate *lastUpdate;
    int tentativi;
}

@property (nonatomic, retain) NSDate *lastUpdate;
@property (nonatomic) BOOL isEnableGPS;


+ (GeoLocal *)shared;
-(void)setTemperatura;
-(BOOL)isEnableGPS;
-(void)enableGPS;
-(void)disableGPS;

@end
