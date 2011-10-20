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
choice10;






// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    dao = [IarmadioDao shared];
    [CurrState shared].currSection = SECTION_LOOKVIEW;
    [self initInputType];
    
}

- (void)initInputType{
    
    
    SEL selector = NSSelectorFromString(@"choice1");
    NSMutableArray *images = [[NSMutableArray alloc] init];
    [images addObject:[UIImage imageNamed:@"02.png"]];
    [images addObject:[UIImage imageNamed:@"02.png"]];
    
    UIView *view = [self performSelector:selector]; 
    [view addSubview:[self fillScrollView:images indexTag:1]];
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
    
    int index = 0;
    int sizeScrollView = 0;
    for(UIImage *image in images){
        
        UIImageView *imageview = [[[UIImageView alloc] initWithImage:image] autorelease];
        
        imageview.frame = CGRectMake(index*imageview_size_width,0,imageview_size_width,imageview_size_height);
        [scrollview addSubview:imageview];
        
        
        sizeScrollView += imageview_size_width;
        index++;
    }
    
    
    
    [scrollview setContentSize: CGSizeMake(sizeScrollView,scrollview_size_height)];
    [scrollview setTag:indexView];
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


-(IBAction) addPreferiti:(id)sender{
}

-(IBAction) saveLook:(id) sender {
    NSLog(@"savelook");
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
	
  

-(void) dealloc{
}



@end
