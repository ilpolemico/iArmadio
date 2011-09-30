//
//  FileSystem.h
//  iArmadio
//
//  Created by Casa Fortunato on 30/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (FileSystem)
- (NSString *) filePathDocuments: (NSString *) fileName;
- (NSString *) filePathBundle: (NSString *) fileName;
@end
