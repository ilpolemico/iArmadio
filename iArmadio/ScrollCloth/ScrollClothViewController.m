//
//  SecondViewController.m
//  iArmadio
//
//  Created by William Pompei on 03/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LookViewController.h"

@implementation LookViewController
 
@synthesize 
stile_1,
stile_2,
stile_3,
stagione_1,
stagione_2,
stagione_3,
gradimento_1,
gradimento_2,
gradimento_3,
undoBtn,
saveBtn,
deleteBtn,
addPreferitiBtn,
choice1,
choice2,
choice3,
choice4,
choice5,
choice6,
choice7,
choice8,
choice9,
choice10;






// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    dao = [IarmadioDao shared];
    [CurrState shared].currSection = SECTION_LOOKVIEW;
    [self initInputType];
    
}

- (void)initInputType{
    UIPickerView *tmp = [[[UIPickerView alloc] init] autorelease];
    CGAffineTransform rotate = CGAffineTransformMakeRotation(3.14/2);
    rotate = CGAffineTransformScale(rotate, 0.25, 2.0);
    
    
    tmp = [[[UIPickerView alloc] init] autorelease];
    tmp.showsSelectionIndicator = NO;
    tmp.backgroundColor = [UIColor clearColor];
    [tmp setTransform:rotate];
    
    [tmp setDelegate:self];
    [tmp setDataSource:self];
    [self.choice1 addSubview:tmp];
    [tmp setTag:1];
    
    tmp = [[[UIPickerView alloc] init] autorelease];
    tmp.showsSelectionIndicator = NO;
    tmp.backgroundColor = [UIColor clearColor];
    [tmp setTransform:rotate];
    [tmp setDelegate:self];
    [tmp setDataSource:self];
    [self.choice2 addSubview:tmp];
    [tmp setTag:2];
    
    tmp = [[[UIPickerView alloc] init] autorelease];
    tmp.showsSelectionIndicator = NO;
    tmp.backgroundColor = [UIColor clearColor];
    [tmp setTransform:rotate];
    [tmp setDelegate:self];
    [tmp setDataSource:self];
    [self.choice3 addSubview:tmp];
    [tmp setTag:3];
    
    tmp = [[[UIPickerView alloc] init] autorelease];
    tmp.showsSelectionIndicator = NO;
    tmp.backgroundColor = [UIColor clearColor];
    [tmp setTransform:rotate];
    [tmp setDelegate:self];
    [tmp setDataSource:self];
    [self.choice4 addSubview:tmp];
    [tmp setTag:4];
    
    tmp = [[[UIPickerView alloc] init] autorelease];
    tmp.showsSelectionIndicator = NO;
    tmp.backgroundColor = [UIColor clearColor];
    [tmp setTransform:rotate];
    [tmp setDelegate:self];
    [tmp setDataSource:self];

    [self.choice5 addSubview:tmp];
    [tmp setTag:5];
    
    tmp = [[[UIPickerView alloc] init] autorelease];
    tmp.showsSelectionIndicator = NO;
    tmp.backgroundColor = [UIColor clearColor];
    [tmp setTransform:rotate];
    [tmp setDelegate:self];
    [tmp setDataSource:self];
    [self.choice6 addSubview:tmp];
    [tmp setTag:6];
    
    tmp = [[[UIPickerView alloc] init] autorelease];
    tmp.showsSelectionIndicator = NO;
    tmp.backgroundColor = [UIColor clearColor];
    [tmp setTransform:rotate];
    [tmp setDelegate:self];
    [tmp setDataSource:self];

    [self.choice7 addSubview:tmp];
    [tmp setTag:7];
    
    
    tmp = [[[UIPickerView alloc] init] autorelease];
    tmp.showsSelectionIndicator = NO;
    tmp.backgroundColor = [UIColor clearColor];
    [tmp setTransform:rotate];
    [tmp setDelegate:self];
    [tmp setDataSource:self];

    [self.choice8 addSubview:tmp];
    [tmp setTag:8];
    
    tmp = [[[UIPickerView alloc] init] autorelease];
    tmp.showsSelectionIndicator = NO;
    tmp.backgroundColor = [UIColor clearColor];
    [tmp setTransform:rotate];
    [tmp setDelegate:self];
    [tmp setDataSource:self];

    [self.choice9 addSubview:tmp];
    [tmp setTag:9];
    
    tmp = [[[UIPickerView alloc] init] autorelease];
    tmp.showsSelectionIndicator = NO;
    tmp.backgroundColor = [UIColor clearColor];
    [tmp setTransform:rotate];
    [tmp setDelegate:self];
    [tmp setDataSource:self];

    [self.choice10 addSubview:tmp];
    [tmp setTag:10];




}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{/*
    CGRect rect = CGRectMake(0, 0, 120, 80);
    UILabel *label = [[UILabel alloc]initWithFrame:rect];
    CGAffineTransform rotate = CGAffineTransformMakeRotation(3.14/2);
    rotate = CGAffineTransformScale(rotate, 0.25, 2.0);
    [label setTransform:rotate];
    label.text = @"prova";
    label.font = [UIFont systemFontOfSize:22.0];
    label.textAlignment = UITextAlignmentCenter;
    label.numberOfLines = 2;
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.backgroundColor = [UIColor clearColor];
    label.clipsToBounds = YES;*/
    UILabel *label = [[UILabel alloc] init];
    label.text = @"prova";
    return label ;
}


- (NSString *)pickerView:(UIPickerView *)pickerView
			 titleForRow:(NSInteger)row
			forComponent:(NSInteger)component
{
	return [NSString stringWithFormat:@"VALORE NUM:%d",row];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return 20;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return NO;
}

-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{

   
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


-(void)populateClothChoiceHolder{
    

}


-(IBAction) addPreferiti:(id)sender{
}

-(IBAction) saveLook:(id) sender {
    NSLog(@"savelook");
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction) undoLook:(id) sender {
     NSLog(@"undolook");
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction) deleteLook:(id)sender{
     NSLog(@"deletelook");
    [self dismissModalViewControllerAnimated:YES];
}
	
  

-(void) dealloc{
}



@end
