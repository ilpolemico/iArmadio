//
//  GeoLocal.m
//  iArmadio
//
//  Created by Casa Fortunato on 19/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GeoLocal.h"

@implementation GeoLocal
@synthesize isEnableGPS;

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
    oldLocation = @"";
    curr_temp = 999;
    oldTemperatura = 999;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    [locationManager startMonitoringSignificantLocationChanges];
    return self;
}

-(BOOL)isEnableGPS{
    return [locationManager locationServicesEnabled];
}

-(void)enableGPS{
    NSLog(@"Enable GPS");
    locationManager.delegate=self;
    [locationManager startMonitoringSignificantLocationChanges];
}

-(void)disableGPS{
    NSLog(@"Disable GPS");
    [locationManager stopUpdatingLocation];
    locationManager.delegate=nil;
}


-(void)setTemperatura{
    if(([currLocation length]>0)&&(![currLocation isEqualToString:oldLocation])){
        NSString *request = [NSString stringWithFormat:@"http://www.google.com/ig/api?weather=%@",currLocation];
        
        NSURLRequest *myRequest = [ [[NSURLRequest alloc] initWithURL: [NSURL URLWithString:request]] autorelease];
        
        NSError        *error = nil;
        NSURLResponse  *response = nil;
        responseData = [ NSURLConnection sendSynchronousRequest:myRequest returningResponse: &response error: &error ];
       
        /*
        NSString *encodingName = [[NSString alloc] initWithString:[response textEncodingName]]; 
       
        
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(CFStringConvertIANACharSetNameToEncoding((CFStringRef) encodingName));*/
        
        
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:responseData];
        parser.delegate = self;  
        [parser parse];
        [parser release];
        
        oldTemperatura = curr_temp;
        
        [dao setCurrStagioneKeyFromTemp:curr_temp]; 
    }
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *) qualifiedName attributes:(NSDictionary *)attributeDict{
    
    if([elementName isEqualToString:@"current_conditions"]){
        currentConditions = YES;
    }
    
    else if (currentConditions){
        if([elementName isEqualToString:@"temp_c"]){
            curr_temp =[((NSString *)[attributeDict objectForKey:@"data"]) intValue];
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
    dao.localita = currLocation;
    [self setTemperatura];
    [currLocation retain];
    [geoCoder release];
    geoCoder = nil;
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
    NSLog(@"reverseGeocoder:%@ didFailWithError:%@", geocoder, error);
    [geoCoder autorelease];
    geoCoder = nil;
}


- (MKReverseGeocoder *)geoCoder{
        return geoCoder;
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation 
{
    
    if(!geoCoder){
        //NSLog(@"%@",newLocation);
        geoCoder = [[MKReverseGeocoder alloc] initWithCoordinate:newLocation.coordinate];
        [geoCoder setDelegate:self];
        [geoCoder start];
         
    }
    //[locationManager stopUpdatingLocation];
    
}

// this delegate method is called if an error occurs in locating your current location
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error 
{
    NSLog(@"locationManager:%@ didFailWithError:%@", manager, error);
    
}

-(void)dealloc{
    [locationManager release];
    [singleton release];
    [super dealloc];
}



@end
