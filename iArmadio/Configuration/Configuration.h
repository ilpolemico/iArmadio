//
//  Configuration.h
//  iArmadio
//
//  Created by Casa Fortunato on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CLOTH_THUMBNAIL_SIZE_X 256
#define CLOTH_THUMBNAIL_SIZE_Y 256

#define CLOTH_SMALL_SIZE_X 50
#define CLOTH_SMALL_SIZE_Y 50

#define CLOTH_NORMAL_SIZE_X 400
#define CLOTH_NORMAL_SIZE_Y 400

#define MAX_CLOTH 100
#define MAX_LOOK 1000

#define LENGTH_NOTE 100


#define DISABLE_SHAKE   @"NoShake"
#define ENABLE_SHAKE   @"Shake"
#define ENABLE_SHAKE_IN_LOOK  @"ShakeInLook"



#define SECTION_ARMADIO   @"ArmadioTableView"
#define SECTION_COVERFLOW @"CoverView"
#define SECTION_CLOTHVIEW @"ClothView"
#define SECTION_CLOTHMANAGERVIEW @"ClothManagerView"

#define SECTION_LOOKVIEW @"LookView"
#define SECTION_LOOKTABLEVIEW @"LookTableView"

#define SECTION_LOOKMANAGERVIEW @"LookManagerView"

#define SECTION_FAVORITES @"FavoritesView"
#define SECTION_PREFERENCE @"PreferenceView"

#define SECTION_TRANSIENT @"TransientView"
#define SECTION_SHAKE2STYLE @"Shake2Style"

#define SECTION_MAIN_WINDOW @"MainWindow"





@interface Configuration : NSObject

@end
