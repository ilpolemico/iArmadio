//
//  SetupViewController.m
//  iArmadio
//
//  Created by Casa Fortunato on 06/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SetupViewController.h"

@implementation SetupViewController

@synthesize navcontroler, viewImpostazioni, labelGPS, labelShake, gps, shake;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void) viewDidAppear:(BOOL)animated{
    NSMutableDictionary *options = [dao.config objectForKey:@"Settings"];
    gps.on = [[options objectForKey:@"gps"] boolValue];
    shake.on = [[options objectForKey:@"shake"] boolValue];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dao = [IarmadioDao shared]; 
    [CurrState shared].currSection = SECTION_PREFERENCE;
    
    [self.view addSubview:navcontroler.view];
    
    
    self.viewImpostazioni.backgroundColor = [UIColor colorWithPatternImage:[dao getImageFromSection:[CurrState shared].currSection type:@"background"]];
    
    // Do any additional setup after loading the view from its nib.
    self.navcontroler.navigationBar.topItem.title =  NSLocalizedString(@"Impostazioni", nil);
    self.navcontroler.navigationBar.topItem.rightBarButtonItem.title = NSLocalizedString(@"Credits",nil);
    
    self.labelGPS.text = NSLocalizedString(self.labelGPS.text, nil);
    self.labelShake.text = NSLocalizedString(self.labelShake.text, nil);
    
 
     
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



-(IBAction)credits:(id)sender{
    CreditsViewController *creditsviewcontroller = [[CreditsViewController alloc] initWithNibName:@"CreditsViewController" bundle:nil];
    
    [self.navcontroler pushViewController:creditsviewcontroller animated:YES];
    
    [creditsviewcontroller release];

}
-(IBAction)enableGPS:(id)sender{
    if(((UISwitch *)sender).isOn){
        [[GeoLocal shared] enableGPS];
        
    }
    else{
        [[GeoLocal shared] disableGPS];
    }

    NSMutableDictionary *settings = [dao.config copy];
    NSMutableDictionary *options = [settings objectForKey:@"Settings"];

    [options setValue:[NSNumber numberWithBool:((UISwitch *)sender).isOn] forKey:@"gps"];
    dao.config = settings;
    [settings release];

}

-(IBAction)enableShake:(id)sender{
    NSMutableDictionary *settings = [dao.config copy];
    NSMutableDictionary *options = [settings objectForKey:@"Settings"];
    
    [options setValue:[NSNumber numberWithBool:((UISwitch *)sender).isOn] forKey:@"shake"];
    dao.config = settings;
    [settings release];
}


-(IBAction)reset:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString( @"Cancellare tutte le impostazioni",nil) message:NSLocalizedString(@"Vuoi cancellare tutte le impostazioni? In questo modo cancellerai anche tutti i vestiti",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Annulla",nil) otherButtonTitles:NSLocalizedString( @"Cancella",nil), nil];
    
    [alert show];
    [alert release];


}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex != 0){
        [dao deleteSQLDB];
        [self viewDidAppear:NO];
    }
    
}



- (void)dealloc{
    [labelShake release];
    [labelGPS release];
    [super dealloc];
}

@end
