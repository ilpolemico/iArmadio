//
//  CurrState.m
//  iArmadio
//
//  Created by Casa Fortunato on 02/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CurrState.h"

@implementation CurrState
@synthesize currStagioneKey,currStagioneIndex,currStile,currEventi,currTipologia,currGradimento, currSection, oldCurrSection;


static CurrState *singleton;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


+ (CurrState *)shared{
    if(singleton == nil){
        singleton = [[CurrState  alloc] init];
    }
    return singleton;
}

-(void)setCurrStagioneKey:(NSString *)key{
    
    if(currStagioneKey != nil){
        [currStagioneKey release];
    }
    
    if(currStagioneIndex != nil){
        [currStagioneIndex release];
    }
    
    currStagioneKey = key;
    
    if([currStagioneKey isEqualToString:@"ALL"]){
        currStagioneIndex = [NSNumber numberWithInteger:[([IarmadioDao shared]).listStagioniKeys count]];
        return;
    }
    
    currStagioneIndex = nil;
    int index=0;
    NSArray *tmp = [IarmadioDao shared].listStagioniKeys;
    while((currStagioneIndex == nil)&&([tmp count] > index)){
        if([key isEqualToString:[tmp objectAtIndex:index]]){
            currStagioneIndex = [NSNumber numberWithInt:index];
        }
        index++;
    }
    
    //NSLog(@"%@ - %@",currStagioneKey,currStagioneIndex);
    
    [currStagioneIndex retain];
    [currStagioneKey retain];
}

-(void)setCurrStagioneIndex:(NSNumber *)index{
    if(currStagioneKey != nil){
        [currStagioneKey release];
    }
    
    if(currStagioneIndex != nil){
        [currStagioneIndex release];
    }
    
    
    currStagioneIndex = index;
    if([([IarmadioDao shared]).listStagioniKeys count] <= [index intValue]){
        currStagioneKey = @"ALL";
        
    }
    else{
    
        currStagioneKey =  
        [([IarmadioDao shared]).listStagioniKeys objectAtIndex:[index            intValue]
        ];
    }
    [currStagioneIndex retain];
    [currStagioneKey retain];
}

-(NSString *)currStagioneKey{
    return currStagioneKey;
}
-(NSNumber *)currStagioneIndex{
    return currStagioneIndex;
}
-(NSString *)currStile{
    return currStile;
}
-(NSString *)currEventi{
    return currEventi;
}
-(NSString *)currTipologia{
    return currTipologia;
}
-(NSNumber *)currGradimento{
    return currGradimento;
}

-(void)setCurrSection:(NSString *)section{
    oldCurrSection = currSection;
    currSection = section;
}

@end
