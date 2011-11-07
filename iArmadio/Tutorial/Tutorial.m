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
    
    NSMutableDictionary *config = [dao.config objectForKey:@"Settings"];
    BOOL tutorialEnable = [[config objectForKey:@"tutorial"] boolValue];
    
    if(tutorialEnable){
        NSString *info = [tutorial objectForKey:action];
        
        if(info != nil){
            [self showInfo:info];
            [tutorial removeObjectForKey:action];
        }
    }
}

- (void) showInfo:(NSString *)info{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString( @"Istruzioni",nil) message:NSLocalizedString(info,nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Prosegui",nil) otherButtonTitles:nil];
    [alert show];
    [alert release];
}



- (void)loadTutorialDictionary{
    if(tutorial != nil){
        [tutorial release];
        tutorial = nil;
    }    
    NSString *path=[[NSBundle mainBundle] pathForResource:TUTORIAL_PLIST ofType:@"plist"];
    tutorial=[NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSLog(@"tutorial : %@",tutorial);
    [tutorial retain];
}

-(void) dealloc{
    [tutorial release];
    [super dealloc];
}

@end
