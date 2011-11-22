//
//  SetupViewController.m
//  iArmadio
//
//  Created by Casa Fortunato on 06/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SetupViewController.h"

@implementation SetupViewController

@synthesize navcontroler, viewImpostazioni, labelGPS, labelShake, tutorial, gps, shake, clima, selectClima, labelTemp;

static SetupViewController *singleton;

+ (SetupViewController *)shared{
    return singleton;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    singleton = self;
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    singleton = self;
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


- (void) viewWillAppear:(BOOL)animated{
   
    NSMutableDictionary *options = [dao.config objectForKey:@"Settings"];
    shake.on = [[options objectForKey:@"shake"] boolValue];
    [Shake2Style shared].enableShake = shake.on;
    if(!shake.isOn){
        gps.on = NO;
        [gps setEnabled:NO];
        self.clima.enabled = NO;
        self.selectClima.alpha = 0.2;
        [self.clima setEnabled:NO forSegmentAtIndex:0];
        [self.clima setEnabled:NO forSegmentAtIndex:1];
        [self.clima setEnabled:NO forSegmentAtIndex:2];
        [options setValue:[NSNumber numberWithBool:gps.isOn] forKey:@"gps"];
        [[GeoLocal shared] disableGPS];
    }
    else{
        gps.on = [[options objectForKey:@"gps"] boolValue];
        if(gps.on){
            self.clima.enabled = NO;
            self.selectClima.alpha = 0.2;
            [self.clima setEnabled:NO forSegmentAtIndex:0];
            [self.clima setEnabled:NO forSegmentAtIndex:1];
            [self.clima setEnabled:NO forSegmentAtIndex:2];
        }
        else{
            labelTemp.hidden = YES;
            self.clima.enabled = YES;
            self.selectClima.alpha = 1;
            [self.clima setEnabled:YES forSegmentAtIndex:0];
            [self.clima setEnabled:YES forSegmentAtIndex:1];
            [self.clima setEnabled:YES forSegmentAtIndex:2];
        }
    };
    self.clima.selectedSegmentIndex = [[options objectForKey:@"customStagione"] intValue];
    tutorial.on = [[options objectForKey:@"tutorial"] boolValue];
    
    
    
    
    
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    dao = [IarmadioDao shared]; 
    [self.view addSubview:navcontroler.view];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
    label.text = NSLocalizedString(@"Impostazioni", nil);
    label.textColor = [UIColor whiteColor];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"STHeitiSC-Medium" size: 22.0];
    [self.navcontroler.navigationBar.topItem setTitleView:label];
    self.navigationController.navigationBar.topItem.title = NSLocalizedString(@"Impostazioni", nil);
    [label release];
    
    self.navcontroler.navigationBar.topItem.rightBarButtonItem.title = NSLocalizedString(@"Credits",nil);
    
    
    //self.labelGPS.text = NSLocalizedString(self.labelGPS.text, nil);
    //self.labelShake.text = NSLocalizedString(self.labelShake.text, nil);
     
    
     
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
    

    NSMutableDictionary *settings = [dao.config copy];
    NSMutableDictionary *options = [settings objectForKey:@"Settings"];

    [options setValue:[NSNumber numberWithBool:((UISwitch *)sender).isOn] forKey:@"gps"];
    dao.config = settings;
    [settings release];
    
    if(((UISwitch *)sender).isOn){
        [[GeoLocal shared] enableGPS];
        self.clima.enabled = NO;
        self.labelTemp.hidden = NO;
        self.selectClima.alpha = 0.2;
        [self.clima setEnabled:NO forSegmentAtIndex:0];
        [self.clima setEnabled:NO forSegmentAtIndex:1];
        [self.clima setEnabled:NO forSegmentAtIndex:2];
        
    }
    else{
        [[GeoLocal shared] disableGPS];
        self.labelTemp.hidden = YES;
        [self.clima setEnabled:YES];
        self.selectClima.alpha = 1;
        self.clima.selectedSegmentIndex = [[options objectForKey:@"customStagione"] intValue];
        [self.clima setEnabled:YES forSegmentAtIndex:0];
        [self.clima setEnabled:YES forSegmentAtIndex:1];
        [self.clima setEnabled:YES forSegmentAtIndex:2];

        [dao setCurrStagioneKeyFromTemp:999];
    }
}

-(IBAction)setStagione:(id)sender{
    NSMutableDictionary *settings = [dao.config copy];
    NSMutableDictionary *options = [settings objectForKey:@"Settings"];
    int index = ((UISegmentedControl *)sender).selectedSegmentIndex;
    
    [options setValue:[NSNumber numberWithInt:index] forKey:@"customStagione"];
    dao.config = settings;
    [dao setCurrStagioneKeyFromTemp:999];
    [settings release];
       
}


-(IBAction)enableShake:(id)sender{
    NSMutableDictionary *settings = [dao.config copy];
    NSMutableDictionary *options = [settings objectForKey:@"Settings"];
    
    [options setValue:[NSNumber numberWithBool:((UISwitch *)sender).isOn] forKey:@"shake"];
    
    [Shake2Style shared].enableShake = ((UISwitch *)sender).isOn;
    if(!((UISwitch *)sender).isOn){
        gps.on = NO;
        [gps setEnabled:NO];
        self.clima.enabled = NO;
        self.selectClima.alpha = 0.2;
        [self.clima setEnabled:NO forSegmentAtIndex:0];
        [self.clima setEnabled:NO forSegmentAtIndex:1];
        [self.clima setEnabled:NO forSegmentAtIndex:2];
        [options setValue:[NSNumber numberWithBool:((UISwitch *)sender).isOn] forKey:@"gps"];
        [[GeoLocal shared] disableGPS];
    }
    else{
        gps.on = YES;
        self.labelTemp.hidden = NO;
        [gps setEnabled:YES];
        self.clima.enabled = NO;
        self.selectClima.alpha = 0.2;
        [self.clima setEnabled:NO forSegmentAtIndex:0];
        [self.clima setEnabled:NO forSegmentAtIndex:1];
        [self.clima setEnabled:NO forSegmentAtIndex:2];
        [options setValue:[NSNumber numberWithBool:((UISwitch *)sender).isOn] forKey:@"gps"];
        [[GeoLocal shared] enableGPS];
        [[Shake2Style shared] becomeFirstResponder];
    }
    dao.config = settings;
    [settings release];
}


-(IBAction)enableTutorial:(id)sender{
    NSMutableDictionary *settings = [dao.config copy];
    NSMutableDictionary *options = [settings objectForKey:@"Settings"];
    NSMutableDictionary *tutorial_step = [settings objectForKey:@"Tutorial"];
    
    [options setValue:[NSNumber numberWithBool:((UISwitch *)sender).isOn] forKey:@"tutorial"];
    if(((UISwitch *)sender).isOn){
        [[Tutorial shared] loadTutorialDictionary];
        [tutorial_step removeAllObjects];
    }
   dao.config = settings;
    [settings release];
}


-(IBAction)reset:(id)sender{
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString( @"Cancellare tutte le impostazioni",nil) message:NSLocalizedString(@"Vuoi cancellare tutte le impostazioni? In questo modo cancellerai anche tutti i vestiti",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Annulla",nil) otherButtonTitles:NSLocalizedString( @"Cancella",nil), nil] autorelease];
    
    [alert show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex != 0){
        [dao deleteSQLDB];
        shake.on = YES;
        gps.on = YES;
        gps.enabled = YES;
        tutorial.on = YES;
        self.clima.enabled = NO;
        self.selectClima.alpha = 0.2;
        [self.clima setEnabled:NO forSegmentAtIndex:0];
        [self.clima setEnabled:NO forSegmentAtIndex:1];
        [self.clima setEnabled:NO forSegmentAtIndex:2];
        [[GeoLocal shared] enableGPS];
        [self viewDidAppear:NO];
    }
    
}


- (void)fade:(UIView *)view
{
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationDelegate:self];
    if ([view alpha] == 1.0f)
        [view setAlpha:0.0f];
    else
        [view setAlpha:1.0f];
    [UIView commitAnimations];
}


- (void)dealloc{
    [navcontroler release];
    [viewImpostazioni release];
    [gps release];
    [shake release];
    [clima release];
    [selectClima release];
    [labelShake release];
    [labelGPS release];
    [labelTemp release];
    [super dealloc];
}

@end
