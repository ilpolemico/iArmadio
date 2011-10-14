//
//  ButtonSegmentControl.h
//  iArmadio
//
//  Created by Casa Fortunato on 14/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol ButtonSegmentDelegate;

@interface ButtonSegmentControl : NSObject{
  
    NSArray *buttons;
    id <ButtonSegmentDelegate> delegate;
    NSInteger selectedIndex;
    

}

@property (retain, nonatomic) id <ButtonSegmentDelegate> delegate; 
@property (nonatomic) NSInteger selectedIndex;

- (IBAction)buttonPressed:(id)sender;

@end




@protocol ButtonSegmentDelegate
- (NSArray *)buttons:(ButtonSegmentControl *)buttonSegmentControl;
- (void)selectedButton:(UIButton *)button selectedIndex:(NSInteger)selectedIndex;
@end
