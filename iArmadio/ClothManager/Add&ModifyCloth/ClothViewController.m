//
//  SecondViewController.m
//  iArmadio
//
//  Created by William Pompei on 03/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ClothViewController.h"

@implementation ClothViewController




@synthesize imageView, undoButton, saveButton, tipologia, stagione, gradimento, scrollview, addNavigationBar;
 


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil setImage:(UIImage *)image{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    newimage = image;
    addCloth = YES;
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil getVestito:(Vestito *)_vestito{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    vestito = _vestito;
    addCloth = NO;
    return self;
}




// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    
   
    if(newimage != nil){
        self.imageView.image = newimage;
        [self.addNavigationBar setHidden:NO];
    }
    
    if(vestito != nil){
        NSLog(@"%@",self.addNavigationBar.items);
        self.navigationItem.rightBarButtonItem = ((UINavigationItem *)[self.addNavigationBar.items objectAtIndex:0]).rightBarButtonItem;
        [self.addNavigationBar setHidden:YES];
    }
    
    dao = [IarmadioDao shared];
    
    UIImage *image = [UIImage imageNamed:@"02.png"];
    
    tipologie = dao.listTipi;
    NSInteger cont;
    cont = 0;
    
    
    [self.tipologia removeSegmentAtIndex:0 animated:NO];
    [self.tipologia removeSegmentAtIndex:0 animated:NO];
    
    for(NSString *tipo in tipologie){
        [self.tipologia insertSegmentWithImage:image atIndex:cont animated:YES];
        [self.tipologia setEnabled: YES forSegmentAtIndex: cont];
        cont++;
    }
    
    
    self.scrollview.scrollEnabled = YES;
    //self.scrollview.pagingEnabled = YES;
    self.scrollview.clipsToBounds = YES;
    self.scrollview.directionalLockEnabled = YES;
    self.scrollview.showsVerticalScrollIndicator = NO;
    self.scrollview.showsHorizontalScrollIndicator = YES;
    self.scrollview.delegate = self;
    self.scrollview.autoresizesSubviews = YES;
    self.scrollview.bounces = YES; 
    [self.scrollview setContentSize:CGSizeMake(320,560)];
    
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
   [dao addVestito:self.imageView.image gradimento:-1 tipi:tipi stagioni:nil stili:nil];
    
   /*NSLog(@"%d",self.tipologia.selectedSegmentIndex);
   
   UITableView *tableview = (UITableView *)self.navigationController;
   NSLog(@"%@",tableview); */
   
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


- (IBAction)segmentSwitch:(id)sender {
    //UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    //NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    //NSLog(@"%@",selectedSegment);
    
}


@end
