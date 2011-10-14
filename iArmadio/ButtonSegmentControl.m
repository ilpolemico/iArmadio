//
//  ButtonSegmentControl.m
//  iArmadio
//
//  Created by Casa Fortunato on 14/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ButtonSegmentControl.h"

@implementation ButtonSegmentControl
@synthesize delegate, selectedIndex;

- (id)init
{
    self = [super init];
    if (self) {
       
    }
    
    return self;
}


- (void)setSelectedIndex:(NSInteger)_selectedIndex{
    for (int i = 0; i < [buttons count]; i++) {
        UIButton *button = [buttons objectAtIndex:i];
        if (i == selectedIndex) {
            [button setSelected:YES];
        } else {
            [button setSelected:NO];
        }
    }
}

- (void) delegate:(id <ButtonSegmentDelegate>) _delegate{
    delegate = _delegate;
    buttons = [delegate buttons:self];
    
    for (int i = 0; i < [buttons count]; i++) {
        UIButton *button = [buttons objectAtIndex:i];
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:i];
    }
}


- (IBAction)buttonPressed:(id)sender {
    self.selectedIndex = [sender tag];
    [delegate selectedButton:[buttons objectAtIndex:self.selectedIndex] selectedIndex:self.selectedIndex];
    
}

- (void) dealloc{
    [buttons release];
    [delegate release];
    [super dealloc];
}






@end
