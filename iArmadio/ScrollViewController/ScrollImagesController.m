//
//  ScrollImagesController.m
//  iArmadio
//
//  Created by Casa Fortunato on 13/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScrollImagesController.h"

@implementation ScrollImagesController

@synthesize scrollview;
@synthesize appDelegate;




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil listCoth:(NSArray *)list size:(CGSize)size
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        listCloth = list;
        sizeCloth = size;
        [listCloth retain];
    }
    return self;
}





- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.frame =  CGRectMake(0, 0, sizeCloth.width, sizeCloth.height);
    appDelegate = (iArmadioAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    
    scrollview.scrollEnabled = YES;
    scrollview.pagingEnabled = YES;
    scrollview.clipsToBounds = YES;
    scrollview.directionalLockEnabled = YES;
    scrollview.showsVerticalScrollIndicator = NO;
    scrollview.showsHorizontalScrollIndicator = YES;
    scrollview.delegate = self;
    scrollview.autoresizesSubviews = YES;
    scrollview.bounces = YES;
    scrollview.frame = CGRectMake(0, 0, sizeCloth.width, sizeCloth.height);
    [scrollview  setContentSize:CGSizeMake([listCloth count]*(sizeCloth.width),sizeCloth.width)];
    
    //[self setImages:listCloth];

    
}

- (void) scrollViewDidScroll:(UIScrollView *) scrollView
{	
	}

/*
- (void) setImages:(NSArray *) images
{
	if(imageSet == nil) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:[listCloth count]];
        
        int count = 0;
        for(Vestito *vestito in  listCloth){
            NSString *filename = [appDelegate filePathBundle:vestito.immagine];
            
            UIImage *image = [UIImage imageWithContentsOfFile:filename];
            ClothView *imageview = [[ClothView alloc] initWithImage:image]; 
            imageview.vestito = vestito;
            
            imageview.contentMode = UIViewContentModeScaleAspectFit;
            imageview.frame = CGRectMake(count*(sizeCloth.width),0,sizeCloth.width,sizeCloth.height);
            
            UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc]
                                                  initWithTarget:self action:@selector(handleTapGesture:)];
            tapgesture.numberOfTapsRequired = 2;
            imageview.userInteractionEnabled = YES;
            [imageview addGestureRecognizer:tapgesture];
            count++;
            [[self scrollview] addSubview:imageview]; 
            [tapgesture release];
            [imageview release];
            
            
        }
        
        imageSet = [NSArray arrayWithArray:array];
        [imageSet retain];
    }
    
    
  	
}
 */

- (IBAction)handleTapGesture:(UIGestureRecognizer *)sender{
    /*
    ClothDetailViewController *detailviewcontroller = 
    [[ClothDetailViewController alloc ]initWithNibName:@"ClothDetailViewController" bundle:nil setCloth:((ClothView *)sender.view).vestito];
    
    
    CGFloat start_y_view = self.view.frame.size.height+detailviewcontroller.view.frame.size.height;
    CGFloat start_x_view = 0;
    
    CGFloat end_y_view = 0;    
    CGFloat end_x_view = 0;
    
    
    detailviewcontroller.view.frame = CGRectMake(start_x_view,start_y_view, detailviewcontroller.view.frame.size.width , detailviewcontroller.view.frame.size.height);
    
    
    [appDelegate.window addSubview:detailviewcontroller.view];
    
    [UIView animateWithDuration:1.0 animations:^{
		detailviewcontroller.view.frame = CGRectMake(end_x_view,end_y_view, detailviewcontroller.view.frame.size.width , detailviewcontroller.view.frame.size.height);
	}];
     */

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
