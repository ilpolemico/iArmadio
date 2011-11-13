//
//  Tutorial.m
//  iArmadio
//
//  Created by Casa Fortunato on 05/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Tutorial.h"

static Tutorial *singleton;

@implementation Tutorial

+ (Tutorial *)shared{
    if(singleton == nil){
        singleton = [[Tutorial alloc] init];
        [singleton loadTutorialDictionary];
    }
    return singleton;
}

-(id)init{
    dao = [IarmadioDao shared];
    return self;
}

-(void)actionInfo:(NSString *)action{
    NSMutableDictionary *config = [dao.config copy];
    NSMutableDictionary *options = [config objectForKey:@"Settings"];
    NSMutableDictionary *config_tutorial = [config objectForKey:@"Tutorial"];
    if(config_tutorial == nil){
        config_tutorial = [[[NSMutableDictionary alloc] init] autorelease];
        [config setValue:config_tutorial forKey:@"Tutorial"];
    }
    BOOL tutorialEnable = [[options objectForKey:@"tutorial"] boolValue];
    
    if(tutorialEnable){
        NSString *info = [tutorial objectForKey:action];
        if((info != nil)&&([config_tutorial objectForKey:action] == nil)){
            [self showInfo:info];
            [tutorial removeObjectForKey:action];
            [config_tutorial setValue:@"1" forKey:action];
            dao.config = config;
        }
    }
    [config release];
}

- (void) showInfo:(NSString *)info{
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString( @"Istruzioni",nil) message:NSLocalizedString(info,nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Prosegui",nil) otherButtonTitles:nil] autorelease];
    [alert show];
}



- (void)loadTutorialDictionary{
    if(tutorial != nil){
        [tutorial release];
        tutorial = nil;
    }    
    NSString *path=[[NSBundle mainBundle] pathForResource:TUTORIAL_PLIST ofType:@"plist"];
    tutorial=[NSMutableDictionary dictionaryWithContentsOfFile:path];
    [tutorial retain];
}

-(void) dealloc{
    if(tutorial != nil){
        [tutorial release];
    }
    [super dealloc];
}

@end
