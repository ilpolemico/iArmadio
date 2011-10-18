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
        singleton = [[Shake2Style alloc] initWithNibName:@"ShakeView" bundle:nil];
    }
    return singleton;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self becomeFirstResponder];
     
    
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}


-(void) motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if(![[CurrState shared].currSection isEqualToString:SECTION_SHAKE2STYLE]){
        if([[[dao.config objectForKey:@"Settings"] objectForKey:@"shake"] boolValue]){
            [CurrState shared].currSection = SECTION_SHAKE2STYLE;
            self.view.backgroundColor = [UIColor colorWithPatternImage:[dao getImageFromSection:[CurrState shared].currSection type:@"background"]];
            iArmadioAppDelegate *appDelegate =  ((iArmadioAppDelegate *)[[UIApplication sharedApplication] delegate]);
            [appDelegate.tabBarController presentModalViewController:self animated:YES];

        }
    }
}


-(IBAction)done:(id)sender{
    [CurrState shared].currSection = [CurrState shared].oldCurrSection;
    [self dismissModalViewControllerAnimated:YES];
    
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
    [singleton release];
    [dao release];
    [super dealloc];
}

@end
