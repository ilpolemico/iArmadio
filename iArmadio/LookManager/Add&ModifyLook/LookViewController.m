//
//  SecondViewController.m
//  iArmadio
//
//  Created by William Pompei on 03/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LookViewController.h"

@implementation LookViewController
 
@synthesize 
stile_1,
stile_2,
stile_3,
stagione_1,
stagione_2,
stagione_3,
viewGradimento,
undoBtn,
saveBtn,
deleteBtn,
addPreferitiBtn,
choice1,
choice2,
choice3,
choice4,
choice5,
choice6,
choice7,
choice8,
choice9,
choice10,
listCloth,
captureView,
preferito,
combinazione,
toolbar,
mainView,
lookSfondo,
zoomClothView;



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    
    
    dao = [IarmadioDao shared];
    [CurrState shared].currSection = SECTION_LOOKVIEW;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadLook:) name:ADD_CLOTH_EVENT object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadLook:) name:MOD_CLOTH_EVENT object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadLook:) name:DEL_CLOTH_EVENT object:nil];

    
    [addPreferitiBtn setImage:[dao getImageBundleFromFile:@"bookmark_deselect.png"] forState:UIControlStateNormal];
    
    [addPreferitiBtn setImage:[dao getImageBundleFromFile:@"bookmark.png"] forState:UIControlStateSelected];
    
    
    currIndex = 0;    
    [self initInputType];
    
    if(iconeTipi != nil){
        [iconeTipi release];
        iconeTipi = nil;
    }
    
    iconeTipi = [[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"",@"",@"",@"" ,@"",@"",@"",nil];
    
    [iconeTipi replaceObjectAtIndex:1 withObject:[dao getImageBundleFromFile:@"cappotto.png"]];
    [iconeTipi replaceObjectAtIndex:2 withObject:[dao getImageBundleFromFile:@"maglione.png"]];
    [iconeTipi replaceObjectAtIndex:3 withObject:[dao getImageBundleFromFile:@"maglietta.png"]];
    [iconeTipi replaceObjectAtIndex:4 withObject:[dao getImageBundleFromFile:@"pantaloni.png"]];
    [iconeTipi replaceObjectAtIndex:5 withObject:[dao getImageBundleFromFile:@"scarpe.png"]];
    [iconeTipi replaceObjectAtIndex:6 withObject:[dao getImageBundleFromFile:@"cappello.png"]];
    [iconeTipi replaceObjectAtIndex:7 withObject:@""];
    [iconeTipi replaceObjectAtIndex:8 withObject:[dao getImageBundleFromFile:@"sciarpa.png"]];
    [iconeTipi replaceObjectAtIndex:9 withObject:[dao getImageBundleFromFile:@"borsa.png"]];
    
}


- (void)viewWillAppear:(BOOL)animated{
    [[Tutorial shared] actionInfo:ACTION_LOOKVIEW];

}

- (void)reloadLook:(NSNotification *)pNotification{
    [self initInputType];
        

}

- (void)initInputType{
    choiceToTipi = [[NSMutableDictionary alloc] init];
    NSArray *tipiKey = dao.listTipiKeys;
    for(NSString *tipoKey in tipiKey){
        Tipologia *tipoEntity = [dao getTipoEntity:tipoKey];
        int choice = [tipoEntity.choice intValue];
        
        NSMutableArray *tipi = [choiceToTipi objectForKey:[NSString stringWithFormat:@"%d",choice,nil]];
        
        
        if(tipi == nil){
            tipi = [[[NSMutableArray alloc] init] autorelease];
        }
        [tipi addObject:tipoEntity.nome];
        [choiceToTipi setValue:tipi forKey:[NSString stringWithFormat:@"%d",choice,nil]]; 
    }
    
    [self.mainView setContentSize:CGSizeMake(242,880)];
    //self.mainView.bounces = YES;
    
    self.lookSfondo.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.lookSfondo.bounds].CGPath;
    self.lookSfondo.layer.shadowColor = [UIColor grayColor].CGColor;
    self.lookSfondo.layer.shadowOffset = CGSizeMake(-7, 1);
    self.lookSfondo.layer.shadowOpacity = 1;
    self.lookSfondo.layer.shadowRadius = 3.0;
    
    if(selectedVestiti != nil){
        [selectedVestiti release];
        selectedVestiti = nil;
    }
    
    selectedVestiti = [[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"",@"",@"",@"" ,@"",@"",@"",nil];
    

    //self.listCloth.pagingEnabled = YES;
    self.listCloth.bounces = YES;
    self.listCloth.delegate = self;
    //self.listCloth.backgroundColor = [UIColor colorWithPatternImage:[dao getImageBundleFromFile:@"prova.jpeg"]]; 
    
    //self.captureView.backgroundColor = [UIColor colorWithPatternImage:[dao getImageBundleFromFile:@"looksfondo.png"]];  
    
    
    /*
    for(int i=1;i<=10;i++){
       SEL selector = NSSelectorFromString([@"choice" stringByAppendingFormat:@"%d",i,nil]);
            UIButton *button = [self performSelector:selector];
         
    }
     */
                                      
    gradimento = 1;
    if(self.combinazione){
        NSSet *vestitiInCombinazione = self.combinazione.fattaDi; 
        for(Vestito *vestito in vestitiInCombinazione){
            Tipologia *tipo = ([[vestito.tipi objectEnumerator] nextObject]);
            SEL selector = NSSelectorFromString([@"choice" stringByAppendingFormat:@"%d",[tipo.choice intValue],nil]);
            
            UIButton *button = [self performSelector:selector];
            button.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [button  setImage:[dao getImageFromVestito:vestito] forState:UIControlStateNormal];
            [selectedVestiti replaceObjectAtIndex:[tipo.choice intValue] withObject:vestito];
        }
        
        NSNumber *grad = combinazione.gradimento;
        
        if(grad != nil){
            gradimento = grad.intValue;
            
        } 
        
    }
    
  
    [self selectGradimento:[self.view viewWithTag:gradimento]];
    
    //Seleziona Stili
    NSArray *stiliKeys = [dao listStiliKeys];
    Stile *stile;
    stile = [dao getStileEntity:[stiliKeys objectAtIndex:0]];
    [self.stile_1 setImage:[dao getImageFromStile:stile] forState: UIControlStateNormal];
    stile = [dao getStileEntity:[stiliKeys objectAtIndex:1]];
    [self.stile_2 setImage:[dao getImageFromStile:stile] forState: UIControlStateNormal];
    stile = [dao getStileEntity:[stiliKeys objectAtIndex:2]];
    [self.stile_3 setImage:[dao getImageFromStile:stile] forState: UIControlStateNormal]; 
    
    segmentStile = [[NSArray alloc] initWithObjects:self.stile_1,self.stile_2,self.stile_3, nil];
    choiceStile = [[ButtonSegmentControl alloc] init:@"stili"];
    choiceStile.delegate = self;
    //choiceStile.invertHighlight = YES;
    choiceStile.selectedIndex = 0;
    
    
    NSArray *stagioniKeys = [dao listStagioniKeys];
    Stagione *stagione;
    stagione = [dao getStagioneEntity:[stagioniKeys objectAtIndex:0]];
    [self.stagione_1 setImage:[dao getImageFromStagione:stagione] forState: UIControlStateNormal];
    stagione = [dao getStagioneEntity:[stagioniKeys objectAtIndex:1]];
    [self.stagione_2 setImage:[dao getImageFromStagione:stagione] forState: UIControlStateNormal];
    stagione = [dao getStagioneEntity:[stagioniKeys objectAtIndex:2]];
    [self.stagione_3 setImage:[dao getImageFromStagione:stagione] forState: UIControlStateNormal]; 
    
    segmentStagione = [[NSArray alloc] initWithObjects:self.stagione_1,self.stagione_2,self.stagione_3, nil];
    choiceStagione = [[ButtonSegmentControl alloc] init:@"stagioni"];
    choiceStagione.delegate = self;
    choiceStagione.invertHighlight = YES;
    choiceStagione.selectedIndex = 1;
    
    
    
    NSSet *stili;

    
    if(self.combinazione != nil){
        stili = combinazione.conStile;
        choiceStagione.selectedIndex = [stagione.id intValue];
        Stile *tmp = [[stili objectEnumerator] nextObject];    
        choiceStile.selectedIndex = [tmp.id intValue]-1;
    }
    else{
        NSMutableArray *items = [[toolbar.items mutableCopy] autorelease];
        [items removeObject:deleteBtn]; 
        toolbar.items = items;
        choiceStagione.selectedIndex = [([CurrState shared]).currStagioneIndex intValue];
        if([([CurrState shared]).currStagioneIndex intValue] > 2){
            choiceStagione.selectedIndex = 2;
        }
    }
    
    
    
    if(self.combinazione){self.preferito = self.combinazione.preferito;}
    [self.view setUserInteractionEnabled:NO];
    if((self.preferito != nil)&&([self.preferito length]>0)){
        addPreferitiBtn.selected = YES;
        [addPreferitiBtn setSelected:YES];
    }    
    else{
        addPreferitiBtn.selected = NO;
        [addPreferitiBtn setSelected:NO];
    }
    [self.view setUserInteractionEnabled:YES];
    
    
    if(currIndex != 0){
        SEL selector = NSSelectorFromString([@"choice" stringByAppendingFormat:@"%d",currIndex,nil]);
        UIButton *button = [self performSelector:selector];

        [self selectCloth: button];
    }
    
    for(int i=1;i<=10;i++){
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureIconCloth:)];
        
        tapGesture.numberOfTapsRequired = 2;
        SEL selector = NSSelectorFromString([@"choice" stringByAppendingFormat:@"%d",i,nil]);
        UIButton *button = [self performSelector:selector];
        [button addGestureRecognizer:tapGesture];
    }
}

-(IBAction) addPreferiti:(id)sender{
    if(self.view.isUserInteractionEnabled){
        [self performSelector:@selector(keepHighlightButton) withObject:nil afterDelay:0.0];
    }    
    
}

- (void)keepHighlightButton{
    if(!addPreferitiBtn.selected){
        [addPreferitiBtn setSelected:YES];
        NSDate* date = [NSDate date];
        NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
        [formatter setDateFormat:@"yyyy-MM-dd-hh-mm-ss"];
        NSString *str = [formatter stringFromDate:date];
        NSTimeInterval timePassed_ms = [date timeIntervalSinceNow] * -1000.0;
        NSString *millisecondi = [NSString stringWithFormat:@"-%d",timePassed_ms];
        self.preferito = [str stringByAppendingString:millisecondi];
    } else {
        [addPreferitiBtn setSelected:NO];
        self.preferito = nil;
    }
    
}



- (void)keepHighlightButton:(id)button{
        [((UIButton *)button) setSelected:YES];
        [((UIButton *)button) setHighlighted:YES];
}


- (IBAction)selectCloth:(id)sender{
    int index = ((UIButton *)sender).tag;
    currIndex = index;
    
    
    if(currButton != nil){
        [currButton setHighlighted:NO];
        [currButton setSelected:NO];
        [currButton release];
        currButton = nil;
    }
    self.listCloth.contentMode = UIViewContentModeScaleAspectFit;
    currButton = (UIButton *)sender;
    [currButton retain];
    [self performSelector:@selector(keepHighlightButton:) withObject:(UIButton *)sender afterDelay:0.0];
    
    int scrollview_size_width = self.listCloth.frame.size.width-8;
    //int scrollview_size_height = self.listCloth.frame.size.height;
    
    int imageview_size_width = scrollview_size_width-4;
    int imageview_size_height = 80;
    
     
    
    for (UIView *view in self.listCloth.subviews) {
        [view removeFromSuperview];
    }
    
    
    NSArray *tipi = [choiceToTipi objectForKey:[NSString stringWithFormat:@"%d",index,nil]]; 
    
    
     
    
    int sizeScrollView = imageview_size_height;
    
    
    UIImage *imageTmp = [dao getImageBundleFromFile:@"emptyCloth.png"];
    UIButton *button = [[[UIButton alloc] init] autorelease];
    [button setImage:imageTmp forState:UIControlStateNormal];
   
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget : self action : @selector (buttonPressed:)];
    singleTap.numberOfTapsRequired = 1;
    [button addGestureRecognizer:singleTap];
    [singleTap release];
    
    [button setTag:0];
    
    button.frame = CGRectMake(3,0,imageview_size_width,imageview_size_height);
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.listCloth addSubview:button];

    int count = 1;
    
    if(vestitiForTipi != nil){
        [vestitiForTipi release];
        vestitiForTipi = nil;
    }
    
    if(tipi != nil){
        NSMutableArray *orderBy = [[[NSMutableArray alloc] init] autorelease];
        NSMutableDictionary *key = [[[NSMutableDictionary alloc] init] autorelease];
        [key setObject:@"gradimento" forKey:@"field"];
        [key setObject:@"NO" forKey:@"ascending"];
        [orderBy addObject:key];
        
        vestitiForTipi = [dao getVestitiEntities:tipi filterStagioneKey:nil filterStiliKeys:nil filterGradimento:-1 sortOnKeys:orderBy preferiti:NO];
        
        
        
        [vestitiForTipi retain];
        
        
        
    } 
    else{
        vestitiForTipi = [[[NSArray alloc] init] autorelease];
    }
    
    
    for(Vestito *vestito in vestitiForTipi){
        UIImage *imageTmp = [dao getThumbnailWithInfoFromVestito:vestito];
        UIImageView *imageview = [[[UIImageView alloc] initWithImage:imageTmp] autorelease];
        
        imageview.layer.shadowColor = [UIColor blackColor].CGColor;
        imageview.layer.shadowOpacity = 0.7f;
        imageview.layer.shadowOffset = CGSizeMake(3.0f, 3.0f);
        imageview.layer.shadowRadius = 2.0f;
        imageview.layer.masksToBounds = NO;
        imageview.layer.shadowPath = [button renderPaperCurl];
        imageview.frame = CGRectMake(0,0,imageview_size_width,imageview_size_height);
        
        
        
        UIButton *button = [[[UIButton alloc] init] autorelease];
        [button addSubview:imageview];
        
        
        
                 
         
        button.contentMode = UIViewContentModeScaleAspectFit;
        [button setImage:imageTmp forState:UIControlStateNormal];
        [button setTag:count];
        
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        
        doubleTap.numberOfTapsRequired = 2;
        [button addGestureRecognizer:doubleTap];
        
        
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget : self action : @selector (buttonPressed:)];
        singleTap.numberOfTapsRequired = 1;
        [singleTap requireGestureRecognizerToFail : doubleTap];
        [button addGestureRecognizer:singleTap];
        
        [singleTap release];
        [doubleTap release];
        
        
        button.layer.shadowPath = [UIBezierPath bezierPathWithRect:button.bounds].CGPath;
        button.layer.shadowColor = [UIColor grayColor].CGColor;
        button.layer.shadowOffset = CGSizeMake(0,7);
        button.layer.shadowOpacity = 1;
        button.layer.shadowRadius = 3.0;
        
        button.frame = CGRectMake(3,count*(imageview_size_height+10),imageview_size_width,imageview_size_height);
        [self.listCloth addSubview:button];
        
        
        sizeScrollView += imageview_size_height+10;
      
        count++;
    }
    sizeScrollView += 10;
    [self.listCloth setContentSize: CGSizeMake(scrollview_size_width,sizeScrollView)];
    currChoice = index;
    
}


-(IBAction) handleTapGestureIconCloth:(UIGestureRecognizer *)sender{
    int tag = sender.view.tag;
    

    Vestito *vestito = [selectedVestiti objectAtIndex:tag];
    if ([vestito class] == [Vestito class]){
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenZoomClothView:)];
        
        tapGesture.numberOfTapsRequired = 1;
        [self.zoomClothView addGestureRecognizer:tapGesture];
        UIImage *tmp = [dao getImageWithInfoFromVestito:vestito];
        [((UIImageView *)[self.zoomClothView.subviews objectAtIndex:0]) setImage:tmp];
        [tapGesture release];
        [self fadeIn:self.zoomClothView];
        [self.zoomClothView setHidden:NO];
        
    }
    
}

- (void) fadeIn:(UIView *)view{
    view.alpha = 0.0f;
    view.transform = CGAffineTransformMakeScale(0.1,0.1);
    [UIView beginAnimations:@"fadeInNewView" context:NULL];
    [UIView setAnimationDuration:0.5];
    view.transform = CGAffineTransformMakeScale(1,1);
    view.alpha = 1.0f;
    [UIView commitAnimations];
}

- (void) fadeOut:(UIView *)view{
    view.alpha = 1.0f;
    view.transform = CGAffineTransformMakeScale(1,1);
    [UIView beginAnimations:@"fadeOutNewView" context:NULL];
    [UIView setAnimationDuration:0.5];
    view.transform = CGAffineTransformMakeScale(0.1,0.1);
    view.alpha = 0.0f;
    [UIView commitAnimations];
}


-(IBAction)hiddenZoomClothView:(UIGestureRecognizer *)sender{
    [self fadeOut:self.zoomClothView];
}


-(IBAction) handleTapGesture:(UIGestureRecognizer *)sender{
    int tag = sender.view.tag;
    
    
    Vestito *vestito = [vestitiForTipi objectAtIndex:tag-1];
    if([vestito class] == [Vestito class]){
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenZoomClothView:)];
        
        tapGesture.numberOfTapsRequired = 1;
        [self.zoomClothView addGestureRecognizer:tapGesture];
        UIImage *tmp = [dao getImageWithInfoFromVestito:vestito];
        [((UIImageView *)[self.zoomClothView.subviews objectAtIndex:0]) setImage:tmp];
        [tapGesture release];
        [self fadeIn:self.zoomClothView];
        [self.zoomClothView setHidden:NO];
    }
}

-(IBAction)buttonPressed:(UIGestureRecognizer *)sender{
    int tag = ((UIButton *)sender.view).tag;
    
    
    [currButton setSelected:NO];
    [currButton setHighlighted:NO];
   
    
    SEL selector = NSSelectorFromString([@"choice" stringByAppendingFormat:@"%d",currChoice,nil]);
    UIButton *button = [self performSelector:selector];
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    if(tag == 0){
         
         [button setImage: [iconeTipi objectAtIndex:currChoice] 
                  forState:UIControlStateNormal];
         [selectedVestiti replaceObjectAtIndex:currChoice withObject:@""];
         return;
     }
    
    if([vestitiForTipi count] > 0){
        Vestito *vestito = [vestitiForTipi objectAtIndex:tag-1];
        UIImage *tmp = [[dao getImageFromVestito:vestito] scaleToFitSize:CGSizeMake(button.frame.size.width,button.frame.size.height)];
        [button setImage:tmp  forState:UIControlStateNormal];
        [selectedVestiti replaceObjectAtIndex:currChoice withObject:vestito];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

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


-(void)populateClothChoiceHolder{
    

}

-(IBAction) saveLook:(id) sender {
    NSMutableArray *vestitiInCombinazione = [[[NSMutableArray alloc] init] autorelease];
    
    for(Vestito *vestito in selectedVestiti){
       if ([vestito class] == [Vestito class]){[vestitiInCombinazione addObject:vestito];}
    }
    
    if([vestitiInCombinazione count] == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString( @"Salvataggio",nil) message:NSLocalizedString(@"Non puo' essere salvato un look senza vestiti",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Annulla",nil) otherButtonTitles:nil];
        
        [alert show];
        [alert release];
        return;
    }
    
    NSMutableArray *stili = [[[NSMutableArray alloc] init] autorelease];
    if(choiceStile.selectedIndex < [dao.listStiliKeys count]){
        [stili addObject:[dao.listStiliKeys objectAtIndex:choiceStile.selectedIndex]];
    }
    
    
    
    NSString *scelta_stagione = [[dao listStagioniKeys] objectAtIndex:choiceStagione.selectedIndex] ;
    if(!self.combinazione){
        [dao addCombinazioneEntity:vestitiInCombinazione gradimento:gradimento stagioneKey:scelta_stagione stiliKeys:stili preferito:self.preferito];
    }   
    else{
        [dao modifyCombinazioneEntity:self.combinazione  vestitiEntities:vestitiInCombinazione  isNew:NO gradimento:gradimento stagioneKey:scelta_stagione stiliKeys:stili preferito:self.preferito];
    
    }
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction) undoLook:(id) sender {
    [self dismissModalViewControllerAnimated:YES];
}


-(IBAction) deleteLook:(id) sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString( @"Cancella",nil) message:NSLocalizedString(@"Vuoi cancellare il look",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Annulla",nil) otherButtonTitles:NSLocalizedString( @"Cancella",nil), nil];
    
    [alert show];
    [alert release];
    
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex != 0){
        if(self.combinazione){
            [dao delCombinazioneEntity:self.combinazione];
        }
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:1];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view.superview cache:YES];
        [self dismissModalViewControllerAnimated:NO];
        [UIView commitAnimations];
    }
    
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

- (void)buttonSegmentControl:(ButtonSegmentControl *)buttonControl  selectedButton:(UIButton *)button selectedIndex:(NSInteger)selectedIndex{
    
    if([buttonControl.tag isEqualToString:@"stili"]){
        choiceStile.selectedIndex = selectedIndex;
    }
    else if([buttonControl.tag isEqualToString:@"stagioni"]){
        choiceStagione.selectedIndex = selectedIndex;
    }
}


-(void) dealloc{
    NSLog(@"Dealloc LookView");
    
    if(preferito != nil){
    	[preferito release];
    	preferito = nil;	
    }
    
    if(iconeTipi != nil){
        [iconeTipi release];
        iconeTipi = nil;
    }
    
    if(currButton != nil){
        [currButton release];
        currButton = nil;
    }
    if(vestitiForTipi != nil){
        [vestitiForTipi release];
        vestitiForTipi = nil;
    }
    
    if(selectedVestiti != nil){
        [selectedVestiti release];
        selectedVestiti = nil;
    }
    
    if(combinazione != nil){
    	[selectedVestiti release];
        selectedVestiti = nil;	
    }
	
	[stile_1 release];
	[stile_2 release];
	[stile_3 release];
	[stagione_1 release];
	[stagione_2 release];
	[stagione_3 release];
	[viewGradimento release];
	[undoBtn release];
	[saveBtn release];
	[deleteBtn release];
	[addPreferitiBtn release];
	[choice1 release];
	[choice2 release];
	[choice3 release];
	[choice4 release];
	[choice5 release];
	[choice6 release];
	[choice8 release];
	[choice9 release];
	[listCloth release];
	[captureView release];
	[preferito release];
	[segmentStagione release];
	[choiceStagione release];
	[segmentStile release];
    [choiceStile release];
    
	
	[combinazione release];
	[toolbar release];
	[mainView release];
	[lookSfondo release];
	[zoomClothView release];
    [super dealloc];
}  


@end
