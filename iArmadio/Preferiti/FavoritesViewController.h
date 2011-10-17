//
//  FavoritesViewController.h
//  iArmadio
//
//  Created by Casa Fortunato on 06/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IarmadioDao.h"
#import "ClothViewController.h"

@interface FavoritesViewController : UIViewController
    <UITableViewDataSource, UITableViewDelegate>{
    IarmadioDao *dao;
    IBOutlet UITableView *tableview; 
    NSArray *vestiti;    
    IBOutlet UINavigationBar *navbar;    
}

@property (nonatomic,retain) IBOutlet UITableView *tableview;
@property (nonatomic,retain) IBOutlet UINavigationBar *navbar;
@property (nonatomic,retain) NSArray *vestiti;

-(void) reloadVestitiPreferiti:(NSNotification *)notification;

@end
