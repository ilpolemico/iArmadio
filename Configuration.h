//
//  Configuration.h
//  iArmadio
//
//  Created by Casa Fortunato on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


#define CLOTH_THUMBNAIL_SIZE_X 200
#define CLOTH_THUMBNAIL_SIZE_Y 200

#define CLOTH_NORMAL_SIZE_X 400
#define CLOTH_NORMAL_SIZE_Y 400

#define MAX_CLOTH 100



#define SECTION_ARMADIO   @"ArmadioTableView"
#define SECTION_COVERFLOW @"CoverView"
#define SECTION_CLOTHVIEW @"ClothView"
#define SECTION_CLOTHMANAGERVIEW @"ClothManagerView"

#define SECTION_LOOKVIEW @"LookView"
#define SECTION_LOOKMANAGERVIEW @"LookManagerView"

#define SECTION_FAVORITES @"FavoritesView"
#define SECTION_PREFERENCE @"PreferenceView"

#define SECTION_TRANSIENT @"TransientView"


@interface Configuration : NSObject

@end
