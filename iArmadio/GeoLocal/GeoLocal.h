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



@interface GeoLocal: NSObject  <MKMapViewDelegate, CLLocationManagerDelegate, MKReverseGeocoderDelegate, NSXMLParserDelegate> { 
    
    IarmadioDao *dao;
    MKReverseGeocoder *geoCoder;
    NSData*responseData;
    int temperatura;
    int oldTemperatura;
    NSString *currLocation;
    NSString *oldLocation;
    CLLocationManager *locationManager;
    BOOL isEnableGPS;
      
}

@property (nonatomic) BOOL isEnableGPS;
@property (nonatomic,retain, readonly) MKReverseGeocoder *geoCoder;


+ (GeoLocal *)shared;
-(void)setTemperatura;
-(BOOL)isEnableGPS;
-(void)enableGPS;
-(void)disableGPS;

@end
