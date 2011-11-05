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
#import "LookViewController.h"
#import "UIImage+Effect.h"

@interface FavoritesViewController : UIViewController
    <UITableViewDataSource, UITableViewDelegate>{
    IarmadioDao *dao;
    IBOutlet UITableView *tableview; 
    NSArray *vestiti;    
    NSArray *combinazioni;
    IBOutlet UINavigationBar *navbar;   
}
@property (nonatomic,retain) IBOutlet UITableView *tableview;
@property (nonatomic,retain) IBOutlet UINavigationBar *navbar;
@property (nonatomic,retain) NSArray *vestiti;
@property (nonatomic,retain) NSArray *combinazioni;

-(void) reloadVestitiPreferiti:(NSNotification *)notification;

@end
