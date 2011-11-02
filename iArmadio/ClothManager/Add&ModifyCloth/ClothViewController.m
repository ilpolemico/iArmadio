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
            imageSfondo,
            imageViewReflect,
            stile_1,
            stile_2,
            stile_3,
            stagione_1,
            stagione_2,
            stagione_3,
            undoButton, 
            saveButton, 
            tipologiaBtn, 
            tipologiaLabel,
            tipologiaSelected,
            stileLabel,
            stagioneLabel,
            gradimentoLabel,
            addNavigationBar,
            toolbar,
            currTipologia,
            currStile,
            trash,
            addPreferiti,
            preferito,
            viewGradimento,
            captureView,
            sfondoView,
            sliderZoom,
            imageViewGradimento;
 


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil setImage:(UIImage *)image{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    newimage = image;
    [newimage retain];
    
    addCloth = YES;
    currTipologia = [CurrState shared].currTipologia;
    currStile = nil;
    currGradimento = nil;
    currStagione = nil;
    preferito = @"";
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil getVestito:(Vestito *)_vestito{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    vestito = _vestito;
    [vestito retain];
    addCloth = NO;
    currTipologia = [CurrState shared].currTipologia;
    currStile = nil;
    currGradimento = nil;
    currStagione = nil;
    return self;
}




// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isChangeImage = NO;
    dao = [IarmadioDao shared];
    [CurrState shared].currSection = SECTION_CLOTHVIEW;
    gradimento = 1;
    
    if(vestito != nil){self.preferito = vestito.preferito;}
    [self initInputType];
    lastScaleFactor = 0;
    //currTransform = CGAffineTransformMake;
    
    
    self.stileLabel.text = NSLocalizedString(self.stileLabel.text,nil);
    self.stagioneLabel.text = NSLocalizedString(self.stagioneLabel.text,nil);
    self.gradimentoLabel.text = NSLocalizedString(self.gradimentoLabel.text,nil);
    
    self.imageSfondo.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.imageSfondo.bounds].CGPath;
    self.imageSfondo.layer.shadowColor = [UIColor grayColor].CGColor;
    self.imageSfondo.layer.shadowOffset = CGSizeMake(10,10);
    self.imageSfondo.layer.shadowOpacity = 1;
    self.imageSfondo.layer.shadowRadius = 4.0;
    
   
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    /*self.captureView.layer.shadowPath = [self renderPaperCurl:self.captureView]; 
    self.captureView.layer.shadowColor = [UIColor blackColor].CGColor;
	self.captureView.layer.shadowOpacity = 0.7f;
	self.captureView.layer.shadowOffset = CGSizeMake(10.0f, 10.0f);
	self.captureView.layer.shadowRadius = 2.0f;
	self.captureView.layer.masksToBounds = NO;
     */
    
    
    self.imageViewGradimento.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.imageSfondo.bounds].CGPath;
    self.imageViewGradimento.layer.shadowColor = [UIColor grayColor].CGColor;
    self.imageViewGradimento.layer.shadowOffset = CGSizeMake(0,4);
    self.imageViewGradimento.layer.shadowOpacity = 1;
    self.imageViewGradimento.layer.shadowRadius = 4.0;
    
    
    
     
    
    
    
    self.imageViewReflect.contentMode = UIViewContentModeScaleAspectFit;
    
    
    self.captureView.clipsToBounds = YES;
    //Edit image
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    
    tapGesture.numberOfTapsRequired = 2;
    [self.imageView addGestureRecognizer:tapGesture];
    [tapGesture release];
    
    
    netRotation = 0;
    netTranslation.x = 0;
    netTranslation.y = 0;
    currTransform = self.view.transform;
    
    
    UIRotationGestureRecognizer *rotateGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotateGesture:)];
    
    [self.imageView addGestureRecognizer:rotateGesture];
    [rotateGesture release];
    
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    
    [self.imageView addGestureRecognizer:panGesture];
    [panGesture release];
    
    
    [self.imageView setUserInteractionEnabled:YES];
    self.imageView.multipleTouchEnabled = YES;
    
    ////////////
    
    
    if(newimage != nil){
        [self.imageView setImage:newimage];
        //[self.imageViewReflect setImage:[newimage reflectedImageWithHeight:200 fromAlpha:0.5 toAlpha:1]];
        //[self.addNavigationBar setHidden:NO];
        NSMutableArray *items = [[toolbar.items mutableCopy] autorelease];
        [items removeObject:trash]; 
        toolbar.items = items;
        
    }
    
    if(vestito != nil){
        [self.imageView setImage:[dao getImageFromVestito:vestito]];
        //[self.imageViewReflect setImage:[[dao getImageFromVestito:vestito] reflectedImageWithHeight:200 fromAlpha:0.5 toAlpha:0]];
       self.preferito = vestito.preferito;
    }
    
    
    

    
    if(newimage != nil){
        if(self.currTipologia){
            Tipologia *tipologiaEntity = [dao getTipoEntity:self.currTipologia];
            [self.tipologiaBtn setImage:[dao getImageFromTipo:tipologiaEntity] forState:UIControlStateNormal];
            self.tipologiaLabel.text = NSLocalizedString(tipologiaEntity.nome,nil);
            self.tipologiaSelected = tipologiaEntity.nome;
        }
        else{
            Tipologia *tipologiaEntity = [dao getTipoEntity:[dao.listTipiKeys objectAtIndex:0]];
            [self.tipologiaBtn setImage:[dao getImageFromTipo:tipologiaEntity] forState:UIControlStateNormal];
            self.tipologiaLabel.text = NSLocalizedString([dao.listTipiKeys objectAtIndex:0],nil);
            self.tipologiaSelected = tipologiaEntity.nome;
        }  
        
        if([[CurrState shared] currStagioneIndex] == nil){
            ([CurrState shared]).currStagioneKey = dao.currStagioneKey;
        }
        
        if([[[CurrState shared] currStagioneIndex] intValue] == 3){
            [self initStagioniEntities:[NSNumber numberWithInt:2]];
        }
        else{
            [self initStagioniEntities:[[CurrState shared] currStagioneIndex]];
        }    
    }
    else if(vestito != nil){
        
        Tipologia *tipo = [[vestito.tipi allObjects] objectAtIndex:0];
        [self.tipologiaBtn setImage:[dao getImageFromTipo:tipo] forState:UIControlStateNormal];
         self.tipologiaLabel.text = NSLocalizedString(tipo.nome,nil);
         self.tipologiaSelected = tipo.nome;
        
        NSNumber *grad = vestito.gradimento;
        
        if(grad != nil){
            gradimento = grad.intValue;
            [self selectGradimento:[self.view viewWithTag:gradimento]];
        } 
        
        [self initStagioniEntities:vestito.perLaStagione.id];
        
        
        if([vestito.conStile count] > 0){
            NSArray *stili = [vestito.conStile allObjects];
            Stile *tmp = [stili objectAtIndex:0];
            choiceStile.selectedIndex = [tmp.id intValue]-1;
        }
        
    }

   
   
}


- (void)initInputType{
    //Seleziona Stili
    //NSArray *stiliKeys = [dao listStiliKeys];
    segmentStile = [[NSArray alloc] initWithObjects:self.stile_1,self.stile_2,self.stile_3, nil];
    choiceStile = [[ButtonSegmentControl alloc] init:@"stili"];
    choiceStile.delegate = self;
    choiceStile.invertHighlight = YES;
    choiceStile.selectedIndex = 0;
    
    
    //NSArray *stagioniKeys = [dao listStagioniKeys];
    //Stagione *stagione;
    //stagione = [dao getStagioneEntity:[stagioniKeys objectAtIndex:0]];
    
    //self.stagione_1.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //[self.stagione_1 setImage:[dao getImageFromStagione:stagione] forState: UIControlStateNormal];
    //stagione = [dao getStagioneEntity:[stagioniKeys objectAtIndex:1]];
    //[self.stagione_2 setImage:[dao getImageFromStagione:stagione] forState: UIControlStateNormal];
    //stagione = [dao getStagioneEntity:[stagioniKeys objectAtIndex:2]];
    //[self.stagione_3 setImage:[dao getImageFromStagione:stagione] forState: UIControlStateNormal]; 
    
    segmentStagione = [[NSArray alloc] initWithObjects:self.stagione_1,self.stagione_2,self.stagione_3, nil];
    choiceStagione = [[ButtonSegmentControl alloc] init:@"stagioni"];
    choiceStagione.delegate = self;
    choiceStagione.invertHighlight = YES;
    choiceStagione.selectedIndex = 0;
    
    [addPreferiti setImage:[dao getImageBundleFromFile:@"bookmark_deselect.png"] forState:UIControlStateNormal];
    
    [addPreferiti setImage:[dao getImageBundleFromFile:@"bookmark.png"] forState:UIControlStateSelected];
    
    [self.view setUserInteractionEnabled:NO];
    if((self.preferito != nil)&&([self.preferito length]>0)){
        [addPreferiti setSelected:YES];
    }    
    else{
        [addPreferiti setSelected:NO];
    }
    [self.view setUserInteractionEnabled:YES];
     
    
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{

   
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

-(IBAction) addPreferiti:(id)sender{
    if(self.view.isUserInteractionEnabled){
     [self performSelector:@selector(keepHighlightButton) withObject:nil afterDelay:0.0];
    }    
    
}

- (void)keepHighlightButton{
    if(!addPreferiti.selected){
        [addPreferiti setSelected:YES];
        NSDate* date = [NSDate date];
        NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
        [formatter setDateFormat:@"yyyy-MM-dd-hh-mm-ss"];
        NSString *str = [formatter stringFromDate:date];
        NSTimeInterval timePassed_ms = [date timeIntervalSinceNow] * -1000.0;
        NSString *millisecondi = [NSString stringWithFormat:@"-%d",timePassed_ms];
        self.preferito = [str stringByAppendingString:millisecondi];
    } else {
        [addPreferiti setSelected:NO];
        self.preferito = nil;
    }

}




- (void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
   
}

-(IBAction) deleteCloth:(id) sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString( @"Cancella",nil) message:NSLocalizedString(@"Vuoi cancellare il vestito",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Annulla",nil) otherButtonTitles:NSLocalizedString( @"Cancella",nil), nil];
    
    [alert show];
    [alert release];
    
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex != 0){
        //[CurrState shared].currSection = [CurrState shared].oldCurrSection;
        [dao delVestitoEntity:vestito];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:1];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view.superview cache:YES];
        [self dismissModalViewControllerAnimated:NO];
        [UIView commitAnimations];
    }
     
}

-(IBAction) saveCloth:(id) sender {
	
   NSString *nametipo = self.tipologiaSelected; 
   NSArray *tipi = [[NSArray alloc] initWithObjects:nametipo,nil];
    
        
    UIGraphicsBeginImageContext(CGSizeMake(self.captureView.frame.size.width,self.captureView.frame.size.height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.captureView.layer renderInContext:context];
    UIImage *snapShotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

   
   NSMutableArray *stili = [[NSMutableArray alloc] init];
   if(choiceStile.selectedIndex < [dao.listStiliKeys count]){
       [stili addObject:[dao.listStiliKeys objectAtIndex:choiceStile.selectedIndex]];
   }
   
    
    NSString *scelta_stagione = [[dao listStagioniKeys] objectAtIndex:choiceStagione.selectedIndex] ;
    
    if(addCloth){ 
        
        if([[dao getVestitiEntities:tipi filterStagioneKey:nil filterStiliKeys:nil filterGradimento:-1] count]+1 > MAX_CLOTH){
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:
                                  NSLocalizedString(@"Numero massimo superato",nil) message: NSLocalizedString(@"Il numero massimo dei capi per questo tipo è stato raggiunto",nil) delegate:self cancelButtonTitle: NSLocalizedString(@"Annulla",nil) otherButtonTitles:nil, nil];
            
            [alert show];
            [alert release];
            [tipi release];
            [stili release];
            return;
        }  
        
        
        
        vestito = [dao addVestitoEntity:snapShotImage gradimento:gradimento tipiKeys:tipi stagioneKey:scelta_stagione stiliKeys:stili preferito:self.preferito];
        [vestito retain];
        
    }
    else{
        if(vestito != nil){[vestito autorelease];}
        vestito.preferito = self.preferito;
        vestito = [dao modifyVestitoEntity:vestito image:snapShotImage  isNew:NO gradimento:gradimento tipiKeys:tipi stagioneKey:scelta_stagione stiliKeys:stili];
            modifyImageCloth = NO;
        [vestito retain];
    }
    
    
    [tipi release];
    [stili release];
     
    
    [self dismissModalViewControllerAnimated:YES];
}



-(IBAction) undoCloth:(id) sender{
   //[CurrState shared].currSection = [CurrState shared].oldCurrSection;
   [self dismissModalViewControllerAnimated:YES];
}


- (void)initStagioniEntities:(NSNumber *)stagioneIndex{
    choiceStagione.selectedIndex = [stagioneIndex intValue];
}


-(IBAction) selectImage:(id) sender{
        UIActionSheet *popupAddItem = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Cambia Immagine Vestito",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Fotocamera",nil),NSLocalizedString(@"Album",nil), nil];
        
        popupAddItem.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [popupAddItem showInView:self.view];
        [popupAddItem release];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIImagePickerController *picker = nil;
    
    if (buttonIndex != 2) {
        picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
    }   
    
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
        [self presentModalViewController:picker animated:YES];
        [picker release];
    } 
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo 
{
	[picker dismissModalViewControllerAnimated:NO];
    [self.imageView setImage:image];
    self.imageView.transform = CGAffineTransformIdentity;
    self.sliderZoom.value = 0;
    modifyImageCloth = YES;
}


-(IBAction) handleTapGesture:(UIGestureRecognizer *)sender{
    if(sender.view.contentMode == UIViewContentModeScaleAspectFit)
        sender.view.contentMode = UIViewContentModeCenter;
    else
        sender.view.contentMode = UIViewContentModeScaleAspectFit;
}


-(IBAction) handleRotateGesture:(UIGestureRecognizer *)sender{
    if(sender.state == UIGestureRecognizerStateBegan){
        currTransform = sender.view.transform;
        isChangeImage = YES;
    }  
    else{
        CGFloat rotation = [(UIRotationGestureRecognizer *)sender rotation];
        sender.view.transform = CGAffineTransformRotate(currTransform,rotation);
    }    
}

-(IBAction) handlePanGesture:(UIGestureRecognizer *)sender{
    
    if(sender.state == UIGestureRecognizerStateBegan){
        currTransform = sender.view.transform;
        isChangeImage = YES;
    }
 
    else{
        CGPoint translation = [(UIPanGestureRecognizer *)sender translationInView:imageView];
        
        CGAffineTransform transform = CGAffineTransformTranslate(currTransform, translation.x, translation.y);
        sender.view.transform = transform;
    }
    
   
    
}

-(IBAction) selectTipo:(id) sender{
    
    selectController = [[SelectTypeViewController alloc] initWithNibName:@"SelectTypeViewController" bundle:nil];
    
    [self presentModalViewController:selectController animated:YES];
}

-(IBAction) startChangeZoom:(id) sender{
 
    
}

-(IBAction) changeZoom:(id) sender{
    if(isChangeImage){
        currTransform = self.imageView.transform;
        isChangeImage = NO;
        offsetScaleFactor = lastScaleFactor;
    }
    scaleFactor = ((UISlider *)sender).value + 1.0;
    CGAffineTransform transform = CGAffineTransformScale(currTransform,scaleFactor,scaleFactor);
    self.imageView.transform = transform;
}

-(IBAction) selectGradimento:(id)sender{
    
    int tag = [(UIButton *)sender tag];
    gradimento = tag;
    for(int i=1;i<5;i++){
        UIButton *button =  (UIButton *)[self.viewGradimento viewWithTag:i];
        if(i <= tag){
            [button setImage:[dao getImageBundleFromFile:@"star.png"] forState:UIControlStateNormal];
        }
        else{
            [button setImage:[dao getImageBundleFromFile:@"star_gray.png"] forState:UIControlStateNormal];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated{
}


-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{

}

- (void)viewWillAppear:(BOOL)animated
{
    modifyImageCloth = NO;
    if(selectController != nil){
        if([selectController getIndexPath] != nil){
            NSString *category = [dao.listCategoryKeys objectAtIndex:[selectController getIndexPath].section];
            
            
            NSArray *tipologie = [dao.category objectForKey:category];
            
            
            Tipologia *entity =  [dao getTipoEntity:[tipologie objectAtIndex:[selectController getIndexPath].row ]];
            
            self.tipologiaLabel.text = NSLocalizedString(entity.nome,nil);
            self.tipologiaSelected = entity.nome;
            
            [self.tipologiaBtn setImage:[dao getImageFromTipo:entity] forState:UIControlStateNormal];
     
        }
        [selectController release];
        selectController = nil;    
    }
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (NSArray *)buttons:(ButtonSegmentControl *)buttonSegmentControl{
    if([buttonSegmentControl.tag isEqualToString:@"stili"]){
        return segmentStile;
    }
 else if([buttonSegmentControl.tag isEqualToString:@"stagioni"]){
        return segmentStagione;
    }
       return nil;
}



- (void)buttonSegmentControl:(ButtonSegmentControl *)buttonControl  selectedButton:(UIButton *)button selectedIndex:(NSInteger)selectedIndex{
    
    if([buttonControl.tag isEqualToString:@"stili"]){
        choiceStile.selectedIndex = selectedIndex;
    }
    else if([buttonControl.tag isEqualToString:@"stagioni"]){
        choiceStagione.selectedIndex = selectedIndex;
    }  
}

-(void) dealloc{
    NSLog(@"Dealloc clothview!!!");
    
    
    if(vestito != nil){
        [vestito release];
    }
    [stile_1 release];
    [stile_2 release];
    [stile_3 release];
    [stagione_1 release];
    [stagione_2 release];
    [currStile release];
    [currTipologia release];
    [toolbar release];
    [trash release];
    [imageViewReflect release];
    [imageView release];
    [saveButton release];
    [addNavigationBar release];
    [undoButton release];
    [tipologiaBtn release];
    [tipologiaLabel release];
    [segmentStile release];
    [segmentStagione release];
    [choiceStile release];
    [choiceStagione release];
    [viewGradimento release];
    [preferito release];
    [super dealloc];
}



@end
