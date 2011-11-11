//
//  UIImage+UIImage_Effect.m
//  iArmadio
//
//  Created by Casa Fortunato on 29/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "UIImage+Effect.h"

@implementation UIView (UIImage_Effect)

- (CGPathRef)renderPaperCurl{
	CGSize size = self.bounds.size;
	CGFloat curlFactor = 15.0f;
	CGFloat shadowDepth = 5.0f;
    
	UIBezierPath *path = [UIBezierPath bezierPath];
	[path moveToPoint:CGPointMake(0.0f, 0.0f)];
	[path addLineToPoint:CGPointMake(size.width, 0.0f)];
	[path addLineToPoint:CGPointMake(size.width, size.height + shadowDepth)];
	[path addCurveToPoint:CGPointMake(0.0f, size.height + shadowDepth)
			controlPoint1:CGPointMake(size.width - curlFactor, size.height + shadowDepth - curlFactor)
			controlPoint2:CGPointMake(curlFactor, size.height + shadowDepth - curlFactor)];
    
	return path.CGPath;
}

- (UIView *)shadow:(UIImage *)image{
    UIView *shadow = [[[UIView alloc] initWithFrame:CGRectMake(5,5,image.size.width,image.size.height)] autorelease];
    shadow.backgroundColor = [UIColor grayColor];
    shadow.alpha = 0.5;
    
    //UIView *imagewithshadow = [[[UIView alloc] initWithFrame:CGRectMake(0,0,image.size.width+5,image.size.height+5)] autorelease];
    //imagewithshadow.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
    
    [self  addSubview:shadow];
    [self  addSubview:imageView];
    
    return self;
}


@end
