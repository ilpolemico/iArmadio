//
//  SelectTypeViewController.h
//  iArmadio
//
//  Created by Casa Fortunato on 04/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArmadioTableViewController.h"

@class ArmadioTableViewController;

@interface SelectTypeViewController : UIViewController{
    NSInteger selectedIndex;
    ArmadioTableViewController *armadio;
}

-(IBAction)undo:(id)sender;
- (void) selectedIndex:(NSInteger )index;
- (NSInteger) getIndex;
@end
