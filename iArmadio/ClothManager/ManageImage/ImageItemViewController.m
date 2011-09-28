//
//  ImageItemViewController.m
//  iArmadio
//
//  Created by Casa Fortunato on 27/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ImageItemViewController.h"
#import "NYXImagesUtilities.h"

 

@implementation ImageItemViewController
@synthesize imageviewSfondo, imageviewFinale, imageviewVestito;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    dao = [IarmadioDao shared];
    /*
    loadImagesOperationQueue = [[NSOperationQueue alloc] init];
    
	NSString *imageName;
	for (int i=0; i < 10; i++) {
		imageName = [[NSString alloc] initWithFormat:@"02.png"];
		[(AFOpenFlowView *)self.view setImage:[UIImage imageNamed:imageName] forIndex:i];
		[imageName release];
	}
	[(AFOpenFlowView *)self.view setNumberOfImages:10];
    
    UIImage *sfondo = [dao getImageFromFile:@"sfondo.png"];
    UIImage *completa = [dao getImageFromFile:@"completa.png"];
    
    //sfondo = [sfondo grayscale];
    //UIImage *finale  = [completa maskWithImage:sfondo];
    sfondo = [self differenceOfImage:completa  withImage:(UIImage *)sfondo];
    
    UIImage *finale  = [completa maskWithImage:sfondo];
    
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(finale)];
    [imageData writeToFile:[self filePathDocuments:@"finale.png"] atomically:YES];
    
    */
    
    }

- (NSString *) filePathDocuments: (NSString *) fileName { 
	NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0]; 
	return [documentsDir stringByAppendingPathComponent:fileName];	
}



-(UIImage *) differenceOfImage:(UIImage *)top withImage:(UIImage *)bottom {
    CGImageRef topRef = [top CGImage];
    CGImageRef bottomRef = [bottom CGImage];
    
    // Dimensions
    CGRect bottomFrame = CGRectMake(0, 0, CGImageGetWidth(bottomRef), CGImageGetHeight(bottomRef));
    CGRect topFrame = CGRectMake(0, 0, CGImageGetWidth(topRef), CGImageGetHeight(topRef));
    CGRect renderFrame = CGRectIntegral(CGRectUnion(bottomFrame, topFrame));
    
    // Create context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if(colorSpace == NULL) {
        printf("Error allocating color space.\n");
        return NULL;
    }
    
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 renderFrame.size.width,
                                                 renderFrame.size.height,
                                                 8,
                                                 renderFrame.size.width * 4,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpace);
    
    if(context == NULL) {
        printf("Context not created!\n");
        return NULL;
    }
    
    // Draw images
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextDrawImage(context, CGRectOffset(bottomFrame, -renderFrame.origin.x, -renderFrame.origin.y), bottomRef);
    CGContextSetBlendMode(context,  kCGBlendModeExclusion);
    CGContextDrawImage(context, CGRectOffset(topFrame, -renderFrame.origin.x, -renderFrame.origin.y), topRef);
    
    // Create image from context
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage * image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    CGContextRelease(context);
    
    return image;
}



// delegate protocol to tell which image is selected
- (void)openFlowView:(AFOpenFlowView *)openFlowView selectionDidChange:(int)index{
    
	NSLog(@"%d is selected",index);
    
}

// setting the image 1 as the default pic
- (UIImage *)defaultImage{
    
	return [UIImage imageNamed:@"2011-09-09-04-01-11.png"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)undo:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)save:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)takePictureSfondo:(id)sender{
}

-(IBAction)takePictureVestito:(id)sender{
}

-(IBAction)elabora:(id)sender{
}


@end
