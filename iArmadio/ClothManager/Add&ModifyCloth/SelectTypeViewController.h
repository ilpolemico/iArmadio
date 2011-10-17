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
    NSIndexPath *selectedIndexPath;
    ArmadioTableViewController *armadio;
    IBOutlet UINavigationBar *navigationBar;
}

@property (retain,nonatomic) IBOutlet UINavigationBar *navigationBar;

-(IBAction)undo:(id)sender;
- (void) selectedIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *) getIndexPath;
@end
