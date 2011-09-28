//
//  ImageItemViewController.h
//  iArmadio
//
//  Created by Casa Fortunato on 27/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFOpenFlowView.h"
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <ImageIO/ImageIO.h>
#import "IarmadioDao.h"

@interface ImageItemViewController : UIViewController{

    IBOutlet UIImageView *imageviewSfondo;
    
    IBOutlet UIImageView *imageviewVestito;
    
    IBOutlet UIImageView *imageviewFinale;
    
    
    NSOperationQueue *loadImagesOperationQueue;
    IarmadioDao *dao;
    
}


@property(retain, nonatomic) IBOutlet UIImageView *imageviewSfondo;
@property(retain, nonatomic) IBOutlet UIImageView *imageviewVestito;
@property(retain, nonatomic) IBOutlet UIImageView *imageviewFinale;

-(IBAction)undo:(id)sender;

-(IBAction)save:(id)sender;

-(IBAction)takePictureSfondo:(id)sender;
-(IBAction)takePictureVestito:(id)sender;
-(IBAction)elabora:(id)sender;
@end
