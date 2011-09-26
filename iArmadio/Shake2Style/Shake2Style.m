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
        iArmadioAppDelegate *appDelegate = (iArmadioAppDelegate *)[[UIApplication sharedApplication] delegate];
        dao = appDelegate.dao;
        [appDelegate retain];
    }
    
    return self;
}


- (Combinazione *)shake2style:(NSArray *)filterStili filterStagioni:(NSArray *)filterStagioni{
    NSArray *combinazioni = [dao getCombinazioni:0 filterStagioni:filterStagioni filterStili:filterStili];
    
    
    if([combinazioni count] == 0){ return nil;}
    
    int tot = 0;
    
    NSMutableArray *pesi = [[NSMutableArray alloc] init];
    
    int cont = 0;
    for(Combinazione *c in combinazioni){
        tot += [c.gradimento intValue];
        [pesi addObject:[NSNumber numberWithInt:tot]];
    }
    int random = rand() % tot;
    int index = 0;
    cont = 0;
    for(NSNumber *peso in pesi){
        if(random >= [peso intValue]){index = cont;}
        else{break;}
        cont++;
    }
    
    return [combinazioni objectAtIndex: index];
}

@end
