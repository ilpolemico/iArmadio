//
//  ScrollImagesController.h
//  iArmadio
//
//  Created by Casa Fortunato on 13/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Vestito.h"
#import "iArmadioAppDelegate.h"



@interface ScrollImagesController : UIViewController <UIScrollViewDelegate> {

    IBOutlet UIScrollView *scrollview;
    NSArray *listCloth;
    CGSize sizeCloth;
    NSArray *imageSet;
    iArmadioAppDelegate *appDelegate;

}

@property(nonatomic,retain) IBOutlet UIScrollView *scrollview;

@property(nonatomic,retain, readonly) iArmadioAppDelegate *appDelegate;

/*
- (void)setImages: (NSArray *) vestiti;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil listCoth:(NSArray *)list size:(CGSize)size;
*/


@end
