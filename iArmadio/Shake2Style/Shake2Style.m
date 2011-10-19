//
//  Shake2Style.m
//  iArmadio
//
//  Created by Casa Fortunato on 20/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Shake2Style.h"

@implementation Shake2Style
@synthesize dao, imageView,vestitoBtn, vestito, combinazione, stagione, localita;


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


- (Vestito *)shake2style:(NSArray *)vestiti{
    
    if([vestiti count] == 0){ return nil;}
    
    int tot = 0;
    
    NSMutableArray *pesi = [[NSMutableArray alloc] init];
    
    int cont = 0;
    for(Vestito *c in vestiti){
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
    return [vestiti objectAtIndex: index];
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
    [self.view setHidden:YES];
    [self becomeFirstResponder];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
   NSArray *vestiti = [dao getVestitiEntities:nil filterStagioneKey:dao.currStagioneKey  filterStiliKeys:nil filterGradimento:-1];
   
   
   self.stagione.text = dao.currStagioneKey; 
   self.localita.text = dao.localita; 
    
   if(vestito != nil){
       [vestito release];
       vestito = nil;
   }    
   
    
   self.vestito = [self shake2style:vestiti]; 
   self.imageView.image = nil;
    
   
    
    
   if(self.vestito == nil){
       [self.vestitoBtn setEnabled:NO];
       NSLog(@"Nessun vestito trovato!");
   } 
   else{
       [self.vestitoBtn setEnabled:YES];
       self.imageView.contentMode = UIViewContentModeScaleAspectFit;
       self.imageView.image = [dao getImageFromVestito:vestito];
   }
    
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}


-(void) motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if(![[CurrState shared].currSection isEqualToString:SECTION_SHAKE2STYLE]){
        if([[[dao.config objectForKey:@"Settings"] objectForKey:@"shake"] boolValue]){
            iArmadioAppDelegate *appDelegate =  ((iArmadioAppDelegate *)[[UIApplication sharedApplication] delegate]);
            
            [CurrState shared].currSection = SECTION_SHAKE2STYLE;
            [self.view setHidden:NO];
            self.view.backgroundColor = [UIColor colorWithPatternImage:[dao getImageFromSection:[CurrState shared].currSection type:@"background"]];
            
            [appDelegate.tabBarController presentModalViewController:self animated:YES];

        }
    }
}


-(IBAction)done:(id)sender{
    [CurrState shared].currSection = [CurrState shared].oldCurrSection;
    [self dismissModalViewControllerAnimated:YES];
    iArmadioAppDelegate *appDelegate =  ((iArmadioAppDelegate *)[[UIApplication sharedApplication] delegate]);
    [appDelegate.window addSubview:self.view];    
}

-(IBAction)selectCloth:(id)sender{
    ClothViewController *getviewcontroller = [[ClothViewController alloc] initWithNibName:@"ClothView" bundle:nil getVestito:self.vestito];
    
    getviewcontroller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self presentModalViewController:getviewcontroller animated:YES];
    [getviewcontroller release];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
