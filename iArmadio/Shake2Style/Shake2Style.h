//
//  Shake2Style.h
//  iArmadio
//
//  Created by Casa Fortunato on 20/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IarmadioDao.h"
#import "iArmadioAppDelegate.h"
#import "ClothViewController.h"

@interface Shake2Style : UIViewController{
    IarmadioDao *dao;
    IBOutlet UIImageView *imageView;
    IBOutlet UIButton *vestitoBtn;
    Vestito *vestito;
    Combinazione *combinazione;
}

@property (nonatomic, retain, readonly) IBOutlet UIImageView *imageView;
@property (nonatomic, retain, readonly) IBOutlet UIButton *vestitoBtn;
@property (nonatomic, retain, readonly) IarmadioDao *dao;
@property (nonatomic, retain) Vestito *vestito;
@property (nonatomic, retain) Combinazione *combinazione;


+ (Shake2Style *)shared;
- (Combinazione *)shake2style:(NSArray *)filterStili filterStagione:(NSString *)filterStagione;

-(IBAction)done:(id)sender;
-(IBAction)selectCloth:(id)sender;

@end
