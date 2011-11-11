//
//  Shake2Style.m
//  iArmadio
//
//  Created by Casa Fortunato on 20/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Shake2Style.h"

@implementation Shake2Style
@synthesize enableShake, delegate;


static Shake2Style *singleton;

+ (Shake2Style *)shared{
    if(singleton == nil){
        singleton = [[Shake2Style alloc] initWithNibName:@"ShakeView" bundle:nil];
        singleton.enableShake = YES;
    }
    return singleton;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        srand(time(NULL));
        dao = [IarmadioDao shared];
    }
    return self;
}


- (Vestito *)shake2styleVestiti:(NSArray *)tipi filterStagione:(NSString *)filterStagione{
    
    
    
    NSArray *vestiti = [dao getVestitiEntities:tipi  filterStagioneKey:filterStagione filterStiliKeys:nil filterGradimento:0];
    
    
    if([vestiti count] == 0){ return nil;}
    
    int tot = 0;
    
    NSMutableArray *pesi = [[NSMutableArray alloc] init];
    
    int cont = 0;
    for(Vestito *c in vestiti){
        tot += [c.gradimento intValue]+2;
        [pesi addObject:[NSNumber numberWithInt:tot]];
        NSLog(@"tot:%d",tot);
    }
    if(tot==0){tot = 1;}
    int random = arc4random()%(tot+1);
    random++;
    int index = 0;
    cont = 0;
    for(NSNumber *peso in pesi){
        index = cont;
        if(!((random > [peso intValue])&&(cont < [pesi count]-1)))
            break;
        cont++;
    }
    
    
    [pesi autorelease];
    NSLog(@"count vestiti:%d random:%d index:%d",
          [vestiti count] ,random, index);
    return [vestiti objectAtIndex: index];
}


- (Combinazione *)shake2style:(NSArray *)filterStili filterStagione:(NSString *)filterStagione{
    
    
    
    NSArray *combinazioni = [dao getCombinazioniEntities:0 filterStagioneKey:filterStagione filterStiliKeys:filterStili];
    
    
    if([combinazioni count] == 0){ return nil;}
    
    int tot = 0;
    
    NSMutableArray *pesi = [[NSMutableArray alloc] init];
    
    int cont = 0;
    for(Combinazione *c in combinazioni){
        tot += [c.gradimento intValue]+2;
        [pesi addObject:[NSNumber numberWithInt:tot]];
        NSLog(@"tot:%d",tot);
    }
    if(tot==0){tot = 1;}
    int random = arc4random()%(tot+1);
    random++;
    int index = 0;
    cont = 0;
    for(NSNumber *peso in pesi){
        index = cont;
        if(!((random > [peso intValue])&&(cont < [pesi count]-1)))
                break;
        cont++;
    }
    
    
    [pesi autorelease];
    NSLog(@"count combinazioni:%d random:%d index:%d",
          [combinazioni count] ,random, index);
    return [combinazioni objectAtIndex: index];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setHidden:YES];
    [self becomeFirstResponder];
}

-(void)choiceStyle{
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"ShakeYourStyle, scegli uno stile",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"sportivo",nil), 
                            NSLocalizedString(@"casual",nil),
                            NSLocalizedString(@"elegante",nil), 
                            NSLocalizedString(@"tutte",nil),                           
                            nil];
    
    popup.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    
    [popup showInView:((iArmadioAppDelegate *)[[UIApplication sharedApplication] delegate]).window];
    [popup release];
}

-(void)shake:(NSString *)style{
    NSArray *stili = nil;
    if(style != nil){
        stili = [[[NSArray alloc] initWithObjects:style, nil] autorelease];
    }
    
    Combinazione *combinazione=[self shake2style:stili filterStagione:dao.currStagioneKey];
    
       
    /*
    if(combinazione == nil){
         combinazione=[self shake2style:stili filterStagione:nil];
    } */
   
    
    if(combinazione != nil){
        LookViewController *lookviewcontroller = [[LookViewController alloc] initWithNibName:@"LookViewController" bundle:nil];
        lookviewcontroller.combinazione = combinazione;       
        
        iArmadioAppDelegate *appDelegate = (iArmadioAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        
        [appDelegate.tabBarController presentModalViewController:lookviewcontroller animated:YES];
        [lookviewcontroller release];
    }
    else{
    
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString( @"Shake2Style",nil) message:NSLocalizedString(@"Non ci sono combinazioni disponibili per la stagione corrente!",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Annulla",nil) otherButtonTitles:nil] autorelease];
        
        [alert show];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        [self shake:@"sportivo"];
    }
    else if (buttonIndex == 1) {
        [self shake:@"casual"];
    } 
    else if (buttonIndex == 2) {
        [self shake:@"elegante"];
    }    
    else if (buttonIndex == 3) {
        [self shake:nil];
    }
    else{
        [self dismissModalViewControllerAnimated:YES];
    }    
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}


-(void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if(
       (event.type == UIEventSubtypeMotionShake)
       &&
       (![[CurrState shared].currSection isEqualToString:DISABLE_SHAKE])
       &&
       (self.enableShake)
       &&
       ([[[dao.config objectForKey:@"Settings"] objectForKey:@"shake"] boolValue])
       ){
           AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
           if(![[CurrState shared].currSection isEqualToString:ENABLE_SHAKE_IN_LOOK]) {
               [self choiceStyle];
           }
           else{
               NSArray *categories = [self.delegate setCategoryShake];
               //NSLog(@"Categories: %@",categories);
               NSMutableArray *vestiti = [[[NSMutableArray alloc] init] autorelease];
               for(NSArray *tipi in categories){
                   //NSLog(@"Tipi: %@",tipi);
                   Vestito *vestito = [self shake2styleVestiti:tipi filterStagione:dao.currStagioneKey];
                   if(vestito != nil){
                       [vestiti addObject:vestito];
                   }
               }
               [self.delegate getVestitiShake:vestiti];
           }
        }
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
    [super dealloc];
}

@end
