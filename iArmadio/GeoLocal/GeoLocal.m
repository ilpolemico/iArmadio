//
//  GeoLocal.m
//  iArmadio
//
//  Created by Casa Fortunato on 19/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GeoLocal.h"

@implementation GeoLocal
@synthesize isEnableGPS,lastUpdate;

static GeoLocal *singleton;
BOOL currentConditions;
int curr_temp;

+ (GeoLocal *)shared{
    if(singleton == nil){
        singleton = [[GeoLocal alloc] init];
    }
    return singleton;
}


- (id)init{
    self = [super init];
    dao = [IarmadioDao shared];
    currLocation = @"";
    [currLocation retain];
    NSLog(@"retain count:%d",[currLocation retainCount]);
    curr_temp = 999;
    oldTemperatura = 999;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    
    
    if([self isEnableGPS]){
        [self enableGPS];        
    }    
    
    return self;
}

- (BOOL)isEnableGPS{
    NSMutableDictionary *config = dao.config;
    return 
        [[[config objectForKey:@"Settings"] objectForKey:@"gps"] boolValue];
}

-(void)enableGPS{
    [currLocation release];
    currLocation = @"";
    [currLocation retain];
    locationManager.delegate=self;
    
    [locationManager startUpdatingLocation];
    /*if([CLLocationManager significantLocationChangeMonitoringAvailable]){
        [locationManager startMonitoringSignificantLocationChanges];
    }
    else{
        [locationManager startUpdatingLocation];
    }
    */
}

-(void)disableGPS{
    [locationManager stopUpdatingLocation];
    /*if([CLLocationManager significantLocationChangeMonitoringAvailable]){
        [locationManager stopMonitoringSignificantLocationChanges];
    }
    else{
        [locationManager stopUpdatingLocation];
    }
    */
    locationManager.delegate=nil;
}


-(void)setTemperatura{
    if([currLocation length]>0){
        NSString *request = [NSString stringWithFormat:@"http://www.google.com/ig/api?weather=%@",currLocation,nil];

        
        
        request =  [request stringByAddingPercentEscapesUsingEncoding:
                    NSASCIIStringEncoding];
        NSURLRequest *myRequest = [ [[NSURLRequest alloc] initWithURL: [NSURL URLWithString:request]] autorelease];
        
        NSError        *error = nil;
        NSURLResponse  *response = nil;
        responseData = [ NSURLConnection sendSynchronousRequest:myRequest returningResponse: &response error: &error ];
       
        NSString *dataString = [[[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding] autorelease];
        
        NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]; 
        
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
        parser.delegate = self;  
        [parser parse];
        [parser release];
        
        oldTemperatura = curr_temp;
        [dao setCurrStagioneKeyFromTemp:curr_temp]; 
        if(self.lastUpdate != nil){
            [lastUpdate release];
            lastUpdate = nil;
        }
        self.lastUpdate = [NSDate date];
    }
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *) qualifiedName attributes:(NSDictionary *)attributeDict{
    
    if([elementName isEqualToString:@"current_conditions"]){
        currentConditions = YES;
    }
    
    else if (currentConditions){
        if([elementName isEqualToString:@"temp_c"]){
            curr_temp =[((NSString *)[attributeDict objectForKey:@"data"]) intValue];
            currentConditions = NO;
        }
        
    }
    
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{    
}


- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
}




-(void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark { 
    
    
    [currLocation release];
    currLocation = placemark.locality;
    [currLocation retain];
    dao.localita = currLocation;
    [self setTemperatura];
    [geoCoder release];
    geoCoder = nil;
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
    //NSLog(@"reverseGeocoder:%@ didFailWithError:%@", geocoder, error);
    [geoCoder autorelease];
    geoCoder = nil;
    
    [currLocation release];
    currLocation = @"";
    [currLocation retain];
}


- (MKReverseGeocoder *)geoCoder{
        return geoCoder;
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation 
{
    
    if(
       (newLocation.coordinate.latitude == oldLocation.coordinate.latitude)&&
       (newLocation.coordinate.longitude == oldLocation.coordinate.longitude)&&
       (![currLocation isEqualToString:@""])
    ){
        return;
    }
    
    if(!geoCoder){
        geoCoder = [[MKReverseGeocoder alloc] initWithCoordinate:newLocation.coordinate];
        [geoCoder setDelegate:self];
        [geoCoder start];
         
    }
}

// this delegate method is called if an error occurs in locating your current location
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error 
{
    NSLog(@"locationManager:%@ didFailWithError:%@", manager, error);
    
}

-(void)dealloc{
    if(geoCoder != nil){[geoCoder release];}
    [lastUpdate release];
    [currLocation release];
    [locationManager release];
    [super dealloc];
}



@end
