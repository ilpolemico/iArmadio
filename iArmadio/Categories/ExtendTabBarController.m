//
//  Extend.m
//  iArmadio
//
//  Created by Casa Fortunato on 15/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ExtendTabBarController.h"

@implementation UITabBarController (Extend)

-(void)presentModalViewController:(UIViewController *) controller animated:(BOOL)animated{
    
    
    UIImageView *tabbararrow = ((iArmadioAppDelegate *)[[UIApplication sharedApplication] delegate]).tabBarArrow;
    
    if(!tabbararrow.hidden){
        [tabbararrow setHidden:YES];
    }
    
    
    [super presentModalViewController: controller animated:animated];
    
    

}

-(void)viewWillAppear:(BOOL)animated{
    
    
    [super viewWillAppear:animated];

    
    if(
        (![[CurrState shared].currSection isEqualToString:SECTION_TRANSIENT])
      ) 
       { 
        [[NSRunLoop currentRunLoop] addTimer: 
         [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(showArrow:) userInfo:nil repeats:NO] forMode:NSDefaultRunLoopMode];
    }    
    
    
    
}

/*
-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return (self.interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


-(void)showArrow:(NSTimer *)timer{
    [((iArmadioAppDelegate *)[[UIApplication sharedApplication] delegate]).tabBarArrow setHidden:NO];
}

@end
