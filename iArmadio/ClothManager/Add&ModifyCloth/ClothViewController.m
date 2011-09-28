//
//  SecondViewController.m
//  iArmadio
//
//  Created by William Pompei on 03/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ClothViewController.h"

@implementation ClothViewController




@synthesize imageView, 
            undoButton, 
            saveButton, 
            tipologia, 
            stagione, 
            gradimento, 
            scrollview, 
            addNavigationBar,
            casual,
            sportivo,
            elegante;
 


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil setImage:(UIImage *)image{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    newimage = image;
    [newimage retain];
    addCloth = YES;
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil getVestito:(Vestito *)_vestito{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    vestito = _vestito;
    [vestito retain];
    addCloth = NO;
    return self;
}




// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    dao = [IarmadioDao shared];
   
    if(newimage != nil){
        self.imageView.image = newimage;
        [self.addNavigationBar setHidden:NO];
    }
    
    if(vestito != nil){
        self.navigationItem.rightBarButtonItem = ((UINavigationItem *)[self.addNavigationBar.items objectAtIndex:0]).rightBarButtonItem;
        
        
        [self.addNavigationBar setHidden:YES];
        
        self.imageView.image = [dao getImageFromVestito:vestito];
    }
    
    
    
    UIImage *image = [UIImage imageNamed:@"02.png"];
    
    tipologie = dao.listTipi;
    NSInteger cont;
    cont = 0;
    
    
    [self.tipologia removeSegmentAtIndex:0 animated:NO];
    [self.tipologia removeSegmentAtIndex:0 animated:NO];
    
    NSMutableDictionary *indextipo =  [[NSMutableDictionary alloc] init];
    
    for(NSString *tipo in tipologie){
        [self.tipologia insertSegmentWithImage:image atIndex:cont animated:YES];
        [self.tipologia setEnabled: YES forSegmentAtIndex: cont];
        [indextipo setObject:[NSString stringWithFormat:@"%d",cont]  forKey:tipo];
        cont++;
    }
    
    
    self.scrollview.scrollEnabled = YES;
    //self.scrollview.pagingEnabled = YES;
    //self.scrollview.clipsToBounds = YES;
    self.scrollview.directionalLockEnabled = YES;
    self.scrollview.showsVerticalScrollIndicator = NO;
    self.scrollview.showsHorizontalScrollIndicator = YES;
    self.scrollview.delegate = self;
    //self.scrollview.autoresizesSubviews = YES;
    self.scrollview.bounces = YES; 
    [self.scrollview setContentSize:CGSizeMake(320,560)];
    
    if(!addCloth){
        self.scrollview.frame = CGRectMake(0,90, self.scrollview.frame.size.width, self.scrollview.frame.size.height);
    }
    
    
    if(newimage != nil){
        self.tipologia.selectedSegmentIndex = 0;
        [self initStagione:dao.curr_stagione];
    }
    else if(vestito != nil){
        
        Tipologia *tipo = [[vestito.tipi allObjects] objectAtIndex:0];
        self.tipologia.selectedSegmentIndex = [[indextipo objectForKey:tipo.nome] intValue];
        
        NSNumber *grad = vestito.gradimento;
        
        if(grad != nil){
            gradimento.selectedSegmentIndex = grad.intValue;
        } 
        
        [self initStagione:[vestito.perLaStagione allObjects]];
        
        
        if([vestito.conStile count] > 0){
            NSArray *stili = [vestito.conStile allObjects];
            
            for(Stile *tmp in stili){
                if([tmp.stile caseInsensitiveCompare:@"casual"] == 0){
                    casual.on = YES; 
                }
                if([tmp.stile caseInsensitiveCompare:@"sportivo"] == 0){
                    sportivo.on = YES; 
                }
                if([tmp.stile caseInsensitiveCompare:@"elegante"] == 0){
                    elegante.on = YES; 
                }
                
            }
        }
        
        
        
    }
    
    [super viewDidLoad];
   
}

- (void) scrollViewDidScroll:(UIScrollView *) scrollView
{	
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

-(IBAction) addCloth:(id) sender {
	//NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(imageView.image)];
   
   
    
   NSString *nametipo = [tipologie objectAtIndex:self.tipologia.selectedSegmentIndex]; 
   NSArray *tipi = [[NSArray alloc] initWithObjects:[dao getTipo: nametipo],nil];
   
    NSMutableArray *stili = [[NSMutableArray alloc] init];
    if(casual.on){
        [stili addObject:[dao getStile:@"casual"]];
    }
    if(sportivo.on){
        [stili addObject:[dao getStile:@"sportivo"]]; 
    }
    if(elegante.on){
        [stili addObject:[dao getStile:@"elegante"]]; 
    } 
    
    
    NSMutableArray *scelta_stagioni = [[NSMutableArray alloc] init];
    
    if(stagione.selectedSegmentIndex == 0){
        [scelta_stagioni addObject:[dao getStagione:@"estiva"]];
        [scelta_stagioni addObject:[dao getStagione:@"primaverile"]];
    }
    
    if(stagione.selectedSegmentIndex == 1){
        [scelta_stagioni addObject:[dao getStagione:@"invernale"]];
        [scelta_stagioni addObject:[dao getStagione:@"autunnale"]];
    }
    
    if(stagione.selectedSegmentIndex == 2){
        [scelta_stagioni addObject:[dao getStagione:@"invernale"]];
        [scelta_stagioni addObject:[dao getStagione:@"autunnale"]];
        [scelta_stagioni addObject:[dao getStagione:@"estiva"]];
        [scelta_stagioni addObject:[dao getStagione:@"primaverile"]];
    }
    
    if(addCloth){ 
        [dao addVestito:self.imageView.image gradimento:gradimento.selectedSegmentIndex tipi:tipi stagioni:scelta_stagioni stili:stili];
    }
    else{
        vestito.gradimento = [NSNumber numberWithInteger:gradimento.selectedSegmentIndex] ;
        vestito.tipi = [NSSet setWithArray:tipi];
        vestito.conStile = [NSSet setWithArray:stili];
        vestito.perLaStagione = [NSSet setWithArray:scelta_stagioni];
        [dao modifyVestito:vestito];
    }
    
    if(addCloth){
        [self dismissModalViewControllerAnimated:YES];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    } 
    
}



-(IBAction) undoCloth:(id) sender{
    if(addCloth){
        [self dismissModalViewControllerAnimated:YES];
    }
  
}


- (void)initStagione:(NSArray *)_stagioni{
    BOOL caldo = NO;
    BOOL freddo = NO;
    
    for(Stagione *s in _stagioni){
        if(([s.stagione caseInsensitiveCompare:@"primaverile"] == 0)||([s.stagione caseInsensitiveCompare:@"estiva"] == 0)){
            caldo = YES; 
            stagione.selectedSegmentIndex = 0;
        }
        else{
            freddo = YES;
            stagione.selectedSegmentIndex = 1;
        }
    }
    
    if(caldo&&freddo){
        stagione.selectedSegmentIndex = 2;
    } 
}

- (IBAction)segmentSwitch:(id)sender {
    //UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    //NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    //NSLog(@"%@",selectedSegment);
    
}

-(IBAction) selectImage:(id) sender{
    ImageItemViewController *imageviewcontroller = [[ImageItemViewController alloc] initWithNibName:@"ImageItemViewController" bundle:nil];
    
    
    //[self.view addSubview:imageviewcontroller.view]; 
    [((iArmadioAppDelegate *)[[UIApplication sharedApplication] delegate]).tabBarController presentModalViewController:imageviewcontroller animated:YES];     
    imageviewcontroller.imageviewFinale.image = [dao getImageFromVestito:vestito];

}


@end
