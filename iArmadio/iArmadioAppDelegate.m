//
//  iArmadioAppDelegate.m
//  iArmadio
//
//  Created by William Pompei on 03/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "iArmadioAppDelegate.h"
@interface iArmadioAppDelegate (PrivateMethods)
- (CGFloat) horizontalLocationFor:(NSUInteger)tabIndex;
- (void) addTabBarArrow;
@end

@implementation iArmadioAppDelegate


@synthesize window;
@synthesize tabBarController;
@synthesize tabBarArrow, openView;


- (IarmadioDao *)dao{return dao;}






- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //[NSThread sleepForTimeInterval:5.0];
    // Override point for customization after application launch.
    // Add the tab bar controller's current view as a subview of the window
    geolocal = [GeoLocal shared];
    dao = [IarmadioDao shared];
    [dao setupDB];
    shake2style = [Shake2Style shared];
    [self.tabBarController.view setUserInteractionEnabled:YES];
    tabBarController.delegate = self;
    self.window.backgroundColor = [UIColor colorWithPatternImage:[dao getImageFromSection:SECTION_MAIN_WINDOW type:@"background"]];;
    self.window.rootViewController = self.tabBarController;
    [self.window addSubview:shake2style.view];
    
    
    
    openView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,320,480)];
    openView.pagingEnabled = YES;
    openView.bounces = NO;
    openView.delegate = self;
    openView.showsHorizontalScrollIndicator = NO;
    openView.backgroundColor = [UIColor clearColor];
    openView.contentOffset = CGPointMake(0,0);
    openView.contentSize = CGSizeMake(640,480);
    UIImageView *openimage = [[[UIImageView alloc] initWithImage:[dao getImageBundleFromFile:@"Default.png"]] autorelease];
    [openView addSubview:openimage];
    
    

    NSArray *array = self.tabBarController.tabBar.items;
    for(UITabBarItem *item in array){
        item.title = NSLocalizedString(item.title,nil);
    }

    [self.window addSubview:tabBarController.view];
    [self.window addSubview:openView];
    [self addTabBarArrow];
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.x == 320){
        [scrollView setHidden:YES];
        [scrollView autorelease];
        [self.tabBarController.view setUserInteractionEnabled:YES];
        [shake2style becomeFirstResponder];
    }
}




- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}



- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void) addTabBarArrow
{
    UIImage* tabBarArrowImage = [UIImage imageNamed:@"TabBarNipple.png"];
    self.tabBarArrow = [[[UIImageView alloc] initWithImage:tabBarArrowImage] autorelease];
    // To get the vertical location we start at the bottom of the window, go up by height of the tab bar, go up again by the height of arrow and then come back down 2 pixels so the arrow is slightly on top of the tab bar.
    CGFloat verticalLocation = self.window.frame.size.height - tabBarController.tabBar.frame.size.height - tabBarArrowImage.size.height + 2;
    tabBarArrow.frame = CGRectMake([self horizontalLocationFor:0], verticalLocation, tabBarArrowImage.size.width, tabBarArrowImage.size.height);
    
    [self.tabBarController.view addSubview:tabBarArrow];
}

- (CGFloat) horizontalLocationFor:(NSUInteger)tabIndex
{
    // A single tab item's width is the entire width of the tab bar divided by number of items
    CGFloat tabItemWidth = tabBarController.tabBar.frame.size.width / tabBarController.tabBar.items.count;
    
    // A half width is tabItemWidth divided by 2 minus half the width of the arrow
    CGFloat halfTabItemWidth = (tabItemWidth / 2.0) - (tabBarArrow.frame.size.width / 2.0);
    
    // The horizontal location is the index times the width plus a half width
    
    return (tabIndex * tabItemWidth) + halfTabItemWidth;
}

- (void)tabBarController:(UITabBarController *)theTabBarController didSelectViewController:(UIViewController *)viewController
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    CGRect frame = tabBarArrow.frame;
    frame.origin.x = [self horizontalLocationFor:tabBarController.selectedIndex];
    tabBarArrow.frame = frame;
    [UIView commitAnimations];  
    
}




- (void)dealloc
{
    [window release];
    [dao release];
    [geolocal release];
    [tabBarController release];
    [tabBarArrow release];
    [super dealloc];
}





@end
