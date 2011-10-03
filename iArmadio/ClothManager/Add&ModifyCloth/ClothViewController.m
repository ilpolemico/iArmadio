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
            elegante,
            toolbar,
            currTipologia,
            currStile,
            trash;
 


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil setImage:(UIImage *)image{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    newimage = image;
    [newimage retain];
    addCloth = YES;
    currTipologia = nil;
    currStile = nil;
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil getVestito:(Vestito *)_vestito{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    vestito = _vestito;
    [vestito retain];
    addCloth = NO;
    currTipologia = nil;
    currStile = nil;
    return self;
}




// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    lastScaleFactor = 0;
    dao = [IarmadioDao shared];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    //Edit image
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    
    tapGesture.numberOfTapsRequired = 2;
    [self.imageView addGestureRecognizer:tapGesture];
    [tapGesture release];
    
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    
    [self.imageView addGestureRecognizer:pinchGesture];
    [pinchGesture release];
    
    
    UIRotationGestureRecognizer *rotateGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotateGesture:)];
    
    [self.imageView addGestureRecognizer:rotateGesture];
    [rotateGesture release];
    [self.imageView setUserInteractionEnabled:YES];
    self.imageView.multipleTouchEnabled = YES;
    
    ////////////
    
    
    if(newimage != nil){
        [self.imageView setImage:newimage];
        //[self.addNavigationBar setHidden:NO];
        NSMutableArray *items = [[toolbar.items mutableCopy] autorelease];
        [items removeObject:trash]; 
        toolbar.items = items;
    }
    
    if(vestito != nil){
        //self.navigationItem.rightBarButtonItem = ((UINavigationItem *)[self.addNavigationBar.items objectAtIndex:0]).rightBarButtonItem;
        
        
        //[self.addNavigationBar setHidden:YES];
        [self.imageView setImage:[dao getImageFromVestito:vestito]];
       
        //self.imageView.image = ;
    }
    
    
    
    UIImage *image = [UIImage imageNamed:@"02.png"];
    
    tipologie = dao.listTipiKeys;
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
    [self.scrollview setContentSize:CGSizeMake(320,734)];
    
    
    //self.scrollview.frame = CGRectMake(0,90, self.scrollview.frame.size.width, self.scrollview.frame.size.height);
    
    
    
    if(newimage != nil){
        if(self.currTipologia){
            self.tipologia.selectedSegmentIndex = [[indextipo objectForKey:self.currTipologia] intValue];
        }
        else{
            self.tipologia.selectedSegmentIndex = 0;
        }  
        
        if([[CurrState shared] currStagioneIndex] == nil){
            ([CurrState shared]).currStagioneKey = dao.currStagioneKey;
        }
    }
    else if(vestito != nil){
        
        Tipologia *tipo = [[vestito.tipi allObjects] objectAtIndex:0];
        self.tipologia.selectedSegmentIndex = [[indextipo objectForKey:tipo.nome] intValue];
        
        NSNumber *grad = vestito.gradimento;
        
        if(grad != nil){
            gradimento.selectedSegmentIndex = grad.intValue;
        } 
        
        NSString *stagioneKey = vestito.perLaStagione.stagione;
        
        
        
        ([CurrState shared]).currStagioneKey = stagioneKey;
        
        //NSLog(@"%@", [[CurrState shared] currStagioneIndex]);
       
        
        [self initStagioniEntities:[[CurrState shared] currStagioneIndex]];
        
        
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
    [indextipo release];
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

-(IBAction) deleteCloth:(id) sender {
    
    [dao delVestitoEntity:vestito];
    [self dismissModalViewControllerAnimated:YES];    

}

-(IBAction) saveCloth:(id) sender {
	//NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(imageView.image)];
   
   
    
   NSString *nametipo = [tipologie objectAtIndex:self.tipologia.selectedSegmentIndex]; 
   NSArray *tipi = [[NSArray alloc] initWithObjects:nametipo,nil];
   
    NSMutableArray *stili = [[NSMutableArray alloc] init];
    if(casual.on){
        [stili addObject:@"casual"];
    }
    if(sportivo.on){
        [stili addObject:@"sportivo"]; 
    }
    if(elegante.on){
        [stili addObject:@"elegante"]; 
    } 
    
    
    
    NSString *scelta_stagione = [[dao listStagioniKeys] objectAtIndex:stagione.selectedSegmentIndex] ;
    
    if(addCloth){ 
        [dao addVestitoEntity:self.imageView.image.normal gradimento:gradimento.selectedSegmentIndex tipiKeys:tipi stagioneKey:scelta_stagione stiliKeys:stili];
    }
    else{
        
        NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(self.imageView.image)];
        NSString *imageFilename; 
        imageFilename = vestito.immagine;
        [imageData writeToFile:[self filePathDocuments:imageFilename] atomically:YES];
        
        [dao modifyVestitoEntity:vestito isNew:NO gradimento:gradimento.selectedSegmentIndex tipiKeys:tipi stagioneKey:scelta_stagione stiliKeys:stili];
    }
    
    [tipi release];
    [stili release];
    CurrState *currstate = [CurrState shared];
    currstate.currStagioneIndex = [NSNumber numberWithInteger:stagione.selectedSegmentIndex]; 
    [self dismissModalViewControllerAnimated:YES];
    
}



-(IBAction) undoCloth:(id) sender{
   [self dismissModalViewControllerAnimated:YES];
}


- (void)initStagioniEntities:(NSNumber *)stagioneIndex{
    stagione.selectedSegmentIndex = [stagioneIndex intValue];
}

- (IBAction)segmentSwitch:(id)sender {
    //UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    //NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    //NSLog(@"%@",selectedSegment);
    
}

-(IBAction) selectImage:(id) sender{
        UIActionSheet *popupAddItem = [[UIActionSheet alloc] initWithTitle:@"Cambia Immagine Vestito" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Fotocamera", @"Album", nil];
        
        popupAddItem.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [popupAddItem showInView:self.view];
        [popupAddItem release];
}

-(void) dealloc{
   
    [super dealloc];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    if (buttonIndex == 0) {
#if !(TARGET_IPHONE_SIMULATOR)
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
#else
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
#endif
        [self presentModalViewController:picker animated:YES];
        [picker release];
    }
    else if (buttonIndex == 1) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //picker.allowsEditing = YES;
        [self presentModalViewController:picker animated:YES];
        [picker release];
    } 
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo 
{
	[picker dismissModalViewControllerAnimated:NO];
    
    [self.imageView setImage:image];
}


-(IBAction) handleTapGesture:(UIGestureRecognizer *)sender{
    if(sender.view.contentMode == UIViewContentModeScaleAspectFit)
        sender.view.contentMode = UIViewContentModeCenter;
    else
        sender.view.contentMode = UIViewContentModeScaleAspectFit;
}

-(IBAction) handlePinchGesture:(UIGestureRecognizer *)sender{
    CGFloat factor = [(UIPinchGestureRecognizer *)sender scale];
    if(factor > 1){
        sender.view.transform = CGAffineTransformMakeScale(lastScaleFactor + (factor-1),lastScaleFactor + (factor-1));
                                                           
    }
    else{
        sender.view.transform = CGAffineTransformMakeScale(lastScaleFactor*factor, lastScaleFactor+factor);
    }
    
    if(sender.state == UIGestureRecognizerStateEnded){
        if(factor > 1){
            lastScaleFactor += (factor-1);
        }
        else{
            lastScaleFactor *=factor;
        }
    }
    
}


-(IBAction) handleRotateGesture:(UIGestureRecognizer *)sender{
    CGFloat rotation = [(UIRotationGestureRecognizer *)sender rotation];
    sender.view.transform = CGAffineTransformMakeRotation(rotation + netRotation);
    
    if(sender.state == UIGestureRecognizerStateEnded){
        netRotation += rotation;
    }
}



@end
