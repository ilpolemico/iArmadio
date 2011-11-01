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
    NSString *tag;
    id <ButtonSegmentDelegate> delegate;
    NSInteger selectedIndex;
    NSInteger currSelectedIndex;
    BOOL invertHighlight;

}

@property (retain, nonatomic) id <ButtonSegmentDelegate> delegate; 
@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic) NSInteger currSelectedIndex;
@property (retain,nonatomic, readonly) NSString  *tag;
@property (nonatomic) BOOL invertHighlight;


- (id)init:(NSString *)tag;
- (IBAction)buttonPressed:(id)sender;

@end




@protocol ButtonSegmentDelegate
@required
- (NSArray *)buttons:(ButtonSegmentControl *)buttonSegmentControl;
- (void)buttonSegmentControl:(ButtonSegmentControl *)buttonSegment  selectedButton:(UIButton *)button selectedIndex:(NSInteger)selectedIndex;
@end
