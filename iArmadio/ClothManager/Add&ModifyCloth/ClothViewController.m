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
            tipologiaBtn, 
            tipologiaLabel,
            stagione, 
            gradimento, 
            scrollview, 
            addNavigationBar,
            stile,
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
    currGradimento = nil;
    currStagione = nil;
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil getVestito:(Vestito *)_vestito{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    vestito = _vestito;
    [vestito retain];
    addCloth = NO;
    currTipologia = nil;
    currStile = nil;
    currGradimento = nil;
    currStagione = nil;
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
    
    
    

    
    if(newimage != nil){
        if(self.currTipologia){
            Tipologia *tipologiaEntity = [dao getTipoEntity:self.currTipologia];
            [self.tipologiaBtn setImage:[dao getImageFromTipo:tipologiaEntity] forState:UIControlStateNormal];
            self.tipologiaLabel.text = tipologiaEntity.nome;
        }
        else{
            Tipologia *tipologiaEntity = [dao getTipoEntity:[dao.listTipiKeys objectAtIndex:0]];
            [self.tipologiaBtn setImage:[dao getImageFromTipo:tipologiaEntity] forState:UIControlStateNormal];
            self.tipologiaLabel.text = [dao.listTipiKeys objectAtIndex:0];
        }  
        
        if([[CurrState shared] currStagioneIndex] == nil){
            ([CurrState shared]).currStagioneKey = dao.currStagioneKey;
        }
    }
    else if(vestito != nil){
        
        Tipologia *tipo = [[vestito.tipi allObjects] objectAtIndex:0];
        [self.tipologiaBtn setImage:[dao getImageFromTipo:tipo] forState:UIControlStateNormal];
         self.tipologiaLabel.text = tipo.nome;
        
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
            Stile *tmp = [stili objectAtIndex:0];
            stile.selectedSegmentIndex = [tmp.id intValue]-1;
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

-(IBAction) deleteCloth:(id) sender {
    
    [dao delVestitoEntity:vestito];
    [self dismissModalViewControllerAnimated:YES];    

}

-(IBAction) saveCloth:(id) sender {
	
   NSString *nametipo = self.tipologiaLabel.text; 
   NSArray *tipi = [[NSArray alloc] initWithObjects:nametipo,nil];
   
   NSMutableArray *stili = [[NSMutableArray alloc] init];
   if(stile.selectedSegmentIndex < [dao.listStiliKeys count]){
       [stili addObject:[dao.listStiliKeys objectAtIndex:stile.selectedSegmentIndex]];
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

-(IBAction) selectTipo:(id) sender{
    
    selectController = [[SelectTypeViewController alloc] initWithNibName:@"SelectTypeViewController" bundle:nil];
    
    [self presentModalViewController:selectController animated:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
    
    if((selectController != nil)&&([selectController getIndex] != -1)){
         self.tipologiaLabel.text = [dao getTipoEntity:[dao.listTipiKeys objectAtIndex:[selectController getIndex] ]].nome;
        
        [selectController release];
        selectController = nil;    
    }
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}



@end
