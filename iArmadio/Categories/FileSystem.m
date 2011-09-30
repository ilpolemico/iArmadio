//
//  FileSystem.m
//  iArmadio
//
//  Created by Casa Fortunato on 30/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FileSystem.h"

@implementation NSObject (FileSystem)

- (NSString *) filePathDocuments: (NSString *) fileName { 
	NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0]; 
	return [documentsDir stringByAppendingPathComponent:fileName];	
}

- (NSString *) filePathBundle: (NSString *) fileName { 
   return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];	
}

@end
