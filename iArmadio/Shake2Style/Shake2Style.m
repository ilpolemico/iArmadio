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


static Shake2Style *singleton;

+ (Shake2Style *)shared{
    if(singleton == nil){
        singleton = [[Shake2Style alloc] init];
    }
    return singleton;
}

- (id)init
{
    self = [super init];
    if (self) {
        srand(time(NULL));
        dao = [IarmadioDao shared];
        [dao retain];
    }
    shakeView = [[UIView alloc] init];
    self.view = shakeView;
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self becomeFirstResponder];
    
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [self.view becomeFirstResponder];
}


-(void) motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if([[[dao.config objectForKey:@"Settings"] objectForKey:@"shake"] boolValue]){
        NSLog(@"OK");
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}




- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}





- (void)viewDidUnload
{
    
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


-(void) dealloc{
    [shakeView release];
    [dao release];
    [super dealloc];
}

@end
