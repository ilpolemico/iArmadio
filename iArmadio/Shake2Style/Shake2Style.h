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
#import "LookViewController.h"

@interface Shake2Style : UIViewController <UIActionSheetDelegate>{
    IarmadioDao *dao;
    IBOutlet UIImageView *imageView;
    IBOutlet UIButton *vestitoBtn;
    IBOutlet UILabel *stagione;
    IBOutlet UILabel *localita;
    Vestito *vestito;
    Combinazione *currCombinazione;
}

@property (nonatomic, retain, readonly) IBOutlet UILabel *stagione;
@property (nonatomic, retain, readonly) IBOutlet UILabel *localita;
@property (nonatomic, retain, readonly) IBOutlet UIImageView *imageView;
@property (nonatomic, retain, readonly) IBOutlet UIButton *vestitoBtn;
@property (nonatomic, retain, readonly) IarmadioDao *dao;
@property (nonatomic, retain) Vestito *vestito;
@property (nonatomic, retain) Combinazione *currCombinazione;


+ (Shake2Style *)shared;
- (Combinazione *)shake2style:(NSArray *)filterStili filterStagione:(NSString *)filterStagione;

-(IBAction)done:(id)sender;
-(IBAction)selectCloth:(id)sender;

@end
