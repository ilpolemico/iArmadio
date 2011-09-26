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


@class iArmadioAppDelegate;

@interface GeoLocal: NSObject  <MKMapViewDelegate, CLLocationManagerDelegate, MKReverseGeocoderDelegate, NSXMLParserDelegate> { 
    
    MKReverseGeocoder *geoCoder;
    NSData*responseData;
    int temperatura;
    int oldTemperatura;
    NSString *currLocation;
    NSString *oldLocation;
    CLLocationManager *locationManager;
    iArmadioAppDelegate *appDelegate;
    
}


@property (nonatomic,retain, readonly) MKReverseGeocoder *geoCoder;
@property (nonatomic, retain) iArmadioAppDelegate *appDelegate;

+ (GeoLocal *)shared;
-(void)setTemperatura;

@end
