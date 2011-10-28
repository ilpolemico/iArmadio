//
//  ButtonSegmentControl.m
//  iArmadio
//
//  Created by Casa Fortunato on 14/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ButtonSegmentControl.h"

@implementation ButtonSegmentControl
@synthesize delegate, selectedIndex, currSelectedIndex, tag;

- (id)init:(NSString *)_tag
{
    self = [super init];
    if (self) {
        tag = _tag;
    }
    
    return self;
}


- (void)setSelectedIndex:(NSInteger)_selectedIndex{
    selectedIndex = _selectedIndex;
    [self performSelector:@selector(keepHighlightButton) withObject:nil afterDelay:0.0];
}


- (void) keepHighlightButton{
    for (int i = 0; i < [buttons count]; i++) {
        UIButton *button = [buttons objectAtIndex:i];
        if (i == selectedIndex) {
            [button setSelected:YES];
            [button setHighlighted:NO];
        } else {
           
                [button setHighlighted:YES];
                [button setSelected:NO];
        }
    }

}

- (void) setDelegate:(id <ButtonSegmentDelegate>) _delegate{
    delegate = _delegate;
    buttons = [delegate buttons:self];
    
    for (int i = 0; i < [buttons count]; i++) {
        UIButton *button = [buttons objectAtIndex:i];
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:i];
    }
    self.currSelectedIndex = -1;
}


- (IBAction)buttonPressed:(id)sender {
    if(self.currSelectedIndex != self.selectedIndex){
        self.currSelectedIndex = self.currSelectedIndex;
        self.selectedIndex = [(UIButton *)sender tag];
        [delegate buttonSegmentControl:self selectedButton:[buttons objectAtIndex:self.selectedIndex] selectedIndex:self.selectedIndex];
    }    
    
}


- (void) dealloc{
    [buttons release];
    [tag release];
    [(NSObject *)delegate release];
    [super dealloc];
}






@end
