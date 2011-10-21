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
preferito,
combinazione;



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    dao = [IarmadioDao shared];
    [CurrState shared].currSection = SECTION_LOOKVIEW;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[dao getImageFromSection:[CurrState shared].currSection type:@"background"]];
    [self initInputType];
}

- (void)initInputType{
    
    vestiti = [dao getVestitiEntities:nil filterStagioneKey:nil filterStiliKeys:nil filterGradimento:-1];
    
    vestitiInScrollView = [[NSMutableDictionary alloc] init];     
    
    NSMutableDictionary *viewScrollimages = [[NSMutableDictionary alloc] init];
    
    
    for(Vestito *vestito in vestiti){
        Tipologia *tipo = ([[vestito.tipi objectEnumerator] nextObject]);
        NSString *idView = [@"choice" stringByAppendingFormat:@"%d",[tipo.choice intValue]];  
        NSMutableArray *temp = [viewScrollimages objectForKey:idView];
        NSMutableArray *vestitiId = [vestitiInScrollView objectForKey:idView];
       
        
        if(temp == nil){
            temp = [[[NSMutableArray alloc] init] autorelease];
            vestitiId = [[[NSMutableArray alloc] init] autorelease];
            [viewScrollimages setValue:temp forKey:idView];
            [vestitiInScrollView setValue:vestitiId forKey:idView];
        }
        
        [vestitiId addObject:vestito];
        [temp addObject: [dao getImageFromVestito:vestito]];
    }
    
    for(NSString* choice in viewScrollimages){
        SEL selector = NSSelectorFromString(choice);
        UIView *view = [self performSelector:selector];
        [view addSubview:[self fillScrollView:[viewScrollimages objectForKey:choice] indexTag:[[choice substringToIndex:6] intValue]]];
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
    int gradimento;

    
    if(self.combinazione != nil){
        stili = combinazione.conStile;
        gradimento = [combinazione.gradimento intValue];
        [CurrState shared].currStagioneKey = stagione.stagione;
        Stile *tmp = [[stili objectEnumerator] nextObject];    
        choiceStile.selectedIndex = [tmp.id intValue]-1;
    }
    
    if([[CurrState shared] currStagioneIndex] == nil){
        ([CurrState shared]).currStagioneKey = dao.currStagioneKey;
    }
    
    choiceStagione.selectedIndex = [([CurrState shared]).currStagioneIndex intValue];
    
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


- (UIScrollView *)fillScrollView:(NSArray *)images indexTag:(int) indexView{
    UIScrollView *scrollview = [[[UIScrollView alloc] init] autorelease];
    int scrollview_size_width = self.choice1.frame.size.width;
    int scrollview_size_height = self.choice1.frame.size.height;
    
    int imageview_size_width = self.choice1.frame.size.width;
    int imageview_size_height = self.choice1.frame.size.height;
    
    
    
    scrollview.frame = CGRectMake(0,0,scrollview_size_width,scrollview_size_height);
    scrollview.pagingEnabled = YES;
    scrollview.bounces = YES;
    scrollview.delegate = self;
    
    int index = 0;
    int sizeScrollView = 0;
    NSArray *vestiti_scrollview = [vestitiInScrollView objectForKey:[@"choice" stringByAppendingFormat:@"%d",indexView]];
    
    for(UIImage *image in images){
        
        UIImageView *imageview = [[[UIImageView alloc] initWithImage:image] autorelease];
        
        imageview.frame = CGRectMake(index*imageview_size_width,0,imageview_size_width,imageview_size_height);
        [scrollview addSubview:imageview];
    
        
        sizeScrollView += imageview_size_width;
        
        Vestito *vestito = [vestiti_scrollview objectAtIndex:index];
        if(self.combinazione){
            if([vestito.inCombinazioni containsObject:self.combinazione]){
               [scrollview scrollRectToVisible:imageview.frame animated:NO];
            }
        }
        
        index++;
    }
    
   
  
    
    [scrollview setContentSize: CGSizeMake(sizeScrollView,scrollview_size_height)];
    [scrollview setTag:1];
    return scrollview;
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
    float tmp;
    int index;
    NSMutableArray *vestitiInCombinazione = [[NSMutableArray alloc] init];
    
    for(int i=1;i<=10;i++){
        NSString *choice = [@"choice" stringByAppendingFormat:@"%d",i];
        if([[vestitiInScrollView objectForKey:choice] count] > 0){
            SEL selector = NSSelectorFromString(choice);
            UIView *view = [self performSelector:selector];
            UIScrollView *scroll = (UIScrollView *)[view viewWithTag:1];
            tmp = scroll.contentOffset.x / scroll.frame.size.width;
            index = [[NSNumber numberWithFloat:tmp] intValue];
            NSLog(@"%d %f %f",index,scroll.contentOffset.x,scroll.frame.size.width);
            Vestito *vestito = (Vestito *)[[vestitiInScrollView objectForKey:choice] objectAtIndex:index];
            if(vestito != nil){[vestitiInCombinazione addObject:vestito];}
        }
    }
    
    
    NSMutableArray *stili = [[NSMutableArray alloc] init];
    if(choiceStile.selectedIndex < [dao.listStiliKeys count]){
        [stili addObject:[dao.listStiliKeys objectAtIndex:choiceStile.selectedIndex]];
    }
    
    
    NSString *scelta_stagione = [[dao listStagioniKeys] objectAtIndex:choiceStagione.selectedIndex] ;
    
    [dao addCombinazioneEntity:vestitiInCombinazione gradimento:choiceGradimento.selectedIndex stagioneKey:scelta_stagione stiliKeys:stili preferito:self.preferito];
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction) undoLook:(id) sender {
     NSLog(@"undolook");
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction) deleteLook:(id)sender{
     NSLog(@"deletelook");
    [self dismissModalViewControllerAnimated:YES];
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
}



@end
