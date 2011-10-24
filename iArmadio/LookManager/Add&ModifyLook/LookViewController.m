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
gradimento_1,
gradimento_2,
gradimento_3,
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
lookSfondo;



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    dao = [IarmadioDao shared];
    [CurrState shared].currSection = SECTION_LOOKVIEW;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[dao getImageFromSection:[CurrState shared].currSection type:@"background"]];
    
    
  
    
    
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
    
    [self.mainView setContentSize:CGSizeMake(320,700)];
    self.mainView.bounces = YES;
    
    self.lookSfondo.layer.shadowColor = [UIColor grayColor].CGColor;
    self.lookSfondo.layer.shadowOffset = CGSizeMake(-7, 1);
    self.lookSfondo.layer.shadowOpacity = 1;
    self.lookSfondo.layer.shadowRadius = 3.0;
    
    selectedVestiti = [[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"",@"",@"",@"" @"",@"",@"",nil];
    [self initInputType];
}

- (void)initInputType{
    
    //self.listCloth.pagingEnabled = YES;
    self.listCloth.bounces = YES;
    self.listCloth.delegate = self;
    //self.listCloth.backgroundColor = [UIColor colorWithPatternImage:[dao getImageBundleFromFile:@"prova.jpeg"]]; 
    
    //self.captureView.backgroundColor = [UIColor colorWithPatternImage:[dao getImageBundleFromFile:@"looksfondo.png"]];  
                                      
                                      
    
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
    }
    
    
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
    choiceStagione.selectedIndex = 0;
    
    
    [self.gradimento_1 setImage:[dao getImageFromSection:[CurrState shared].currSection type:@"icona_gradimento_1"] forState: UIControlStateNormal];
    [self.gradimento_2 setImage:[dao getImageFromSection:[CurrState shared].currSection type:@"icona_gradimento_2"] forState: UIControlStateNormal];
    [self.gradimento_3 setImage:[dao getImageFromSection:[CurrState shared].currSection type:@"icona_gradimento_3"] forState: UIControlStateNormal]; 
    
    segmentGradimento = [[NSArray alloc] initWithObjects:self.gradimento_1,self.gradimento_2,self.gradimento_3, nil];
    choiceGradimento = [[ButtonSegmentControl alloc] init:@"gradimento"];
    choiceGradimento.delegate = self;
    choiceGradimento.selectedIndex = 0;
    
    NSSet *stili;

    
    if(self.combinazione != nil){
        stili = combinazione.conStile;
        [CurrState shared].currStagioneKey = stagione.stagione;
        Stile *tmp = [[stili objectEnumerator] nextObject];    
        choiceStile.selectedIndex = [tmp.id intValue]-1;
    }
    else{
        NSMutableArray *items = [[toolbar.items mutableCopy] autorelease];
        [items removeObject:deleteBtn]; 
        toolbar.items = items;
    }
    
    if([[CurrState shared] currStagioneIndex] == nil){
        ([CurrState shared]).currStagioneKey = dao.currStagioneKey;
    }
    
    choiceStagione.selectedIndex = [([CurrState shared]).currStagioneIndex intValue];
    
    if(self.combinazione){self.preferito = self.combinazione.preferito;}
    [self.view setUserInteractionEnabled:NO];
    if((self.preferito != nil)&&([self.preferito length]>0)){
        addPreferitiBtn.selected = YES;
        [addPreferitiBtn setSelected:YES];
        [addPreferitiBtn setHighlighted:YES];
    }    
    else{
        addPreferitiBtn.selected = NO;
        [addPreferitiBtn setSelected:NO];
        [addPreferitiBtn setHighlighted:NO];
    }
    [self.view setUserInteractionEnabled:YES];
    
    
    
    
    
    
}

-(IBAction) addPreferiti:(id)sender{
    if(self.view.isUserInteractionEnabled){
        [self performSelector:@selector(keepHighlightButton) withObject:nil afterDelay:0.0];
    }    
    
}

- (void)keepHighlightButton{
    if(!addPreferitiBtn.selected){
        [addPreferitiBtn setSelected:YES];
        [addPreferitiBtn setHighlighted:YES];
        NSDate* date = [NSDate date];
        NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
        [formatter setDateFormat:@"yyyy-MM-dd-hh-mm-ss"];
        NSString *str = [formatter stringFromDate:date];
        NSTimeInterval timePassed_ms = [date timeIntervalSinceNow] * -1000.0;
        NSString *millisecondi = [NSString stringWithFormat:@"-%d",timePassed_ms];
        self.preferito = [str stringByAppendingString:millisecondi];
    } else {
        [addPreferitiBtn setHighlighted:NO];
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
    if(currButton != nil){
        [currButton setHighlighted:NO];
        [currButton setSelected:NO];
    }
    
    currButton = (UIButton *)sender;
    [self performSelector:@selector(keepHighlightButton:) withObject:(UIButton *)sender afterDelay:0.0];
    
    int scrollview_size_width = self.listCloth.frame.size.width;
    //int scrollview_size_height = self.listCloth.frame.size.height;
    
    int imageview_size_width = scrollview_size_width;
    int imageview_size_height = 80;
    
     
    
    for (UIView *view in self.listCloth.subviews) {
        [view removeFromSuperview];
    }
    
    
    NSArray *tipi = [choiceToTipi objectForKey:[NSString stringWithFormat:@"%d",index,nil]]; 
    
 
    
    
 
    
    int sizeScrollView = imageview_size_height;
    
    
    UIImage *imageTmp = [dao getImageBundleFromFile:@"emptyCloth.png"];
    UIButton *button = [[[UIButton alloc] init] autorelease];
    [button setImage:imageTmp forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button setTag:0];
    
    
    button.frame = CGRectMake(0,0,imageview_size_width,imageview_size_height);
    [self.listCloth addSubview:button];

    int count = 1;
    
    if(vestitiForTipi != nil){
        [vestitiForTipi release];
        vestitiForTipi = nil;
    }
    
    if(tipi != nil){
        vestitiForTipi = [dao getVestitiEntities:tipi filterStagioneKey:nil filterStiliKeys:nil filterGradimento:-1 sortOnKeys:nil preferiti:NO];
        
        [vestitiForTipi retain];
    } 
    else{
        vestitiForTipi = [[[NSArray alloc] init] autorelease];
    }
    
    
    for(Vestito *vestito in vestitiForTipi){
        UIImage *imageTmp = [dao getThumbnailFromVestito:vestito];
        UIButton *button = [[[UIButton alloc] init] autorelease];
        [button setImage:imageTmp forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:count];
        
        
        button.frame = CGRectMake(0,count*imageview_size_height,imageview_size_width,imageview_size_height);
        [self.listCloth addSubview:button];
        
        
        sizeScrollView += imageview_size_height;
        [self.listCloth setContentSize: CGSizeMake(scrollview_size_width,sizeScrollView)];
        count++;
    }
    
    currChoice = index;
    
}

-(IBAction)buttonPressed:(id)sender{
    int tag = ((UIButton *)sender).tag;
    
    [currButton setSelected:NO];
    [currButton setHighlighted:NO];
   
    
    SEL selector = NSSelectorFromString([@"choice" stringByAppendingFormat:@"%d",currChoice,nil]);
    UIButton *button = [self performSelector:selector];
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    if(tag == 0){
         [button setImage:[dao getImageBundleFromFile:@"emptyCloth.png"] 
                  forState:UIControlStateNormal];
         [selectedVestiti replaceObjectAtIndex:currChoice withObject:@""];
         return;
     }
    
    if([vestitiForTipi count] > 0){
        Vestito *vestito = [vestitiForTipi objectAtIndex:tag-1];
        
        [button  setImage:[dao getImageFromVestito:vestito] forState:UIControlStateNormal];
        [selectedVestiti replaceObjectAtIndex:currChoice withObject:vestito];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"%f %f", scrollView.contentOffset.y, scrollView.contentSize.height);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidEndDecelerating");
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidEndScrollingAnimation");
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidScroll");
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return NO;
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
    
    UIGraphicsBeginImageContext(CGSizeMake(self.captureView.frame.size.width,self.captureView.frame.size.height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.captureView.layer renderInContext:context];
    UIImage *snapShotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
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
        [dao addCombinazioneEntity:vestitiInCombinazione snapshot:snapShotImage gradimento:choiceGradimento.selectedIndex stagioneKey:scelta_stagione stiliKeys:stili preferito:self.preferito];
    }   
    else{
        [dao modifyCombinazioneEntity:self.combinazione  vestitiEntities:vestitiInCombinazione snapshot:snapShotImage isNew:NO gradimento:choiceGradimento.selectedIndex stagioneKey:scelta_stagione stiliKeys:stili preferito:self.preferito];
    
    }
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction) undoLook:(id) sender {
     NSLog(@"undolook");
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
    else if([buttonSegmentControl.tag isEqualToString:@"gradimento"]){
        return segmentGradimento;
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
    else if([buttonControl.tag isEqualToString:@"gradimento"]){
        choiceGradimento.selectedIndex = selectedIndex;
    }
    
}

  

-(void) dealloc{
    [selectedVestiti release];
}



@end
