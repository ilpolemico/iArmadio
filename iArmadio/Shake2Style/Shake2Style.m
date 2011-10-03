//
//  Shake2Style.m
//  iArmadio
//
//  Created by Casa Fortunato on 20/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Shake2Style.h"

@implementation Shake2Style
@synthesize dao;

- (id)init
{
    self = [super init];
    if (self) {
        srand(time(NULL));
        dao = [IarmadioDao shared];
        [dao retain];
    }
    
    return self;
}


- (Combinazione *)shake2style:(NSArray *)filterStili filterStagione:(NSString *)filterStagione{
    NSArray *combinazioni = [dao getCombinazioniEntities:0 filterStagioneKey:filterStagione filterStiliKeys:filterStili];
    
    
    if([combinazioni count] == 0){ return nil;}
    
    int tot = 0;
    
    NSMutableArray *pesi = [[NSMutableArray alloc] init];
    
    int cont = 0;
    for(Combinazione *c in combinazioni){
        tot += [c.gradimento intValue];
        [pesi addObject:[NSNumber numberWithInt:tot]];
    }
    if(tot==0){tot = 1;}
    int random = rand() % tot;
    int index = 0;
    cont = 0;
    for(NSNumber *peso in pesi){
        if(random >= [peso intValue]){index = cont;}
        else{break;}
        cont++;
    }
    
    
    [pesi autorelease];
    return [combinazioni objectAtIndex: index];
}

-(void) dealloc{
    [super dealloc];
    [dao release];
    
}

@end
