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
    curr_temp = 999;
    tentativi = 0;
    oldTemperatura = 999;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    isStartedUpdatingLocation = FALSE;
    
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
    if(!isStartedUpdatingLocation){
        locationManager.delegate=self;
        [dao setCurrStagioneKeyFromTemp:curr_temp];
        [locationManager startUpdatingLocation];
        isStartedUpdatingLocation = TRUE;
    }
}

-(void)disableGPS{
    if(isStartedUpdatingLocation){
        [locationManager stopUpdatingLocation];
        locationManager.delegate=nil;
        isStartedUpdatingLocation = FALSE;
    }
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
        if([SetupViewController shared] != nil){
            int farTemp = (curr_temp*(9/5)) + 32;
            NSString *textLabel = [NSString stringWithFormat:@"Temp: %d C - %d F", curr_temp,farTemp,nil];
            //NSLog(@"%@",textLabel);
            [SetupViewController shared].labelTemp.text = textLabel;
        }
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
    NSLog(@"location:%@",currLocation);
    [currLocation retain];
    dao.localita = currLocation;
    [self setTemperatura];
    [geoCoder setDelegate:nil];
    [geoCoder release];
    tentativi = 0;
    geoCoder = nil;
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
    NSLog(@"reverseGeocoder:%@ didFailWithError:%@", geocoder, error);
    [geoCoder setDelegate:nil];
    [geoCoder autorelease];
    geoCoder = nil;
    
    [currLocation release];
    currLocation = @"";
    [currLocation retain];
    
    tentativi++;
    if(tentativi <= MAX_TENTATIVI){
        [self disableGPS];
        [self enableGPS];
    }
    
}


- (MKReverseGeocoder *)geoCoder{
        return geoCoder;
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation 
{
    NSDate *currdate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setHour:1];
    //[comps setMinute:5];
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    [gregorian setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    NSDate *date = [gregorian dateByAddingComponents:comps toDate:lastUpdate  options:0];
    [comps release];
    
    
    if(
       (![currLocation isEqualToString:@""])&&
       (![[SetupViewController shared].labelTemp.text isEqualToString:@"?"]) &&
       ([date compare:currdate] == NSOrderedDescending)
    ){
        //NSLog(@"NO location! %@",[SetupViewController shared].labelTemp.text);
        return;
    }
    
    [currLocation release];
    currLocation = @"";
    [currLocation retain];
    [dao setCurrStagioneKeyFromTemp:999];
    if([SetupViewController shared] != nil){
        [SetupViewController shared].labelTemp.text = @"?";
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
