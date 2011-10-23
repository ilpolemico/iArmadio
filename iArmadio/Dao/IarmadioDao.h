//
//  iarmadioDao.h
//  captureCloth
//
//  Created by luke on 06/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "FileSystem.h"
#import "ProprietaVestito.h"
#import "Combinazione.h"
#import "Tipologia.h"
#import "Stagione.h"
#import "Stile.h"
#import "Vestito.h"
#import "ProprietaCombinazione.h"
#import "CurrState.h"
#import "NYXImagesUtilities.h"


static NSString * const ADD_CLOTH_EVENT = @"add_cloth_event";
static NSString * const MOD_CLOTH_EVENT = @"mod_cloth_event";
static NSString * const DEL_CLOTH_EVENT = @"del_cloth_event";

static NSString * const ADD_LOOK_EVENT = @"add_look_event";
static NSString * const MOD_LOOK_EVENT = @"mod_look_event";
static NSString * const DEL_LOOK_EVENT = @"del_look_event";

static NSString * const TIPOLOGIA_PLIST = @"tipologia";
static NSString * const STAGIONE_PLIST = @"stagione";
static NSString * const STILE_PLIST = @"stile";
static NSString * const IMAGES_PLIST = @"images";
static NSString * const CONFIG_PLIST = @"Config";

@class iArmadioAppDelegate;

@interface IarmadioDao : NSObject {
    NSManagedObjectContext *managedObjectContext;
    NSManagedObjectModel *managedObjectModel;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSMutableDictionary *stagioniEntities;
    NSMutableDictionary *stiliEntities;
    NSMutableDictionary *tipiEntities;
    NSMutableArray *listTipiKeys;
    NSMutableArray *listStagioniKeys;
    NSMutableArray *listStiliKeys;
    NSMutableDictionary *category;
    NSMutableArray *listCategoryKeys;
    NSString *currStagioneKey; 
    NSString *localita;
    NSDictionary *imagesDictionary;
    NSMutableDictionary *config;
}

@property (nonatomic, retain) NSMutableDictionary *config;
@property (nonatomic, retain, readonly) NSMutableDictionary *category;
@property (nonatomic, retain, readonly) NSMutableArray *listCategoryKeys;
@property (nonatomic, retain) NSString *localita;
@property (nonatomic, retain, readonly) NSString *currStagioneKey;
@property (nonatomic, retain, readonly) NSDictionary *imagesDictionary;
@property (nonatomic, retain, readonly) NSMutableDictionary *stagioniEntities;
@property (nonatomic, retain, readonly) NSMutableDictionary *stiliEntities;
@property (nonatomic, retain, readonly) NSMutableDictionary *tipiEntities;
@property (nonatomic, retain, readonly) NSMutableArray *listTipiKeys;
@property (nonatomic, retain, readonly) NSMutableArray *listStiliKeys;
@property (nonatomic, retain, readonly) NSMutableArray *listStagioniKeys;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (IarmadioDao *)shared;
- (IarmadioDao *)initDao;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)setupDB;
- (void)debugDB;

- (void)setCurrStagioneKeyFromTemp:(int)temp;
- (Tipologia *)getTipoEntity:(NSString *)tipoKeys;
- (Stile *)getStileEntity:(NSString *)stileKeys;
- (Stagione *)getStagioneEntity:(NSString *)stagioneKeys;
- (UIImage *)getImageFromVestito:(Vestito *)vestitoEntity;
- (UIImage *)getThumbnailFromVestito:(Vestito *)vestitoEntity;
- (UIImage *)getImageFromTipo:(Tipologia *)tipologiaEntity;
- (UIImage *)getImageFromStile:(Stile *)stileEntity;
- (UIImage *)getImageFromStagione:(Stagione *)stagioneEntity;
- (UIImage *)getImageBundleFromFile:(NSString *)file;
- (UIImage *)getImageDocumentFromFile:(NSString *)file;
- (UIImage *)getImageFromSection:(NSString *)section type:(NSString *)type;




- (NSArray *)getVestitiEntities:(NSArray *)filterTipiKeys filterStagioneKey:(NSString *)filterStagioneKey filterStiliKeys:(NSArray *)filterStiliKeys filterGradimento:(NSInteger)filterGradimento sortOnKeys:(NSArray *)keys preferiti:(BOOL)preferiti;

- (NSArray *)getVestitiEntities:(NSArray *)filterTipiKeys filterStagioneKey:(NSString *)filterStagioneKey filterStiliKeys:(NSArray*)filterStiliKeys filterGradimento:(NSInteger)filterGradimento;

- (Vestito *)addVestitoEntity:(UIImage *)image gradimento:(NSInteger)gradimento  tipiKeys:(NSArray *)tipiKeys stagioneKey:(NSString *)stagioneKey stiliKeys:(NSArray *)stiliKeys  preferito:(NSString *)preferito;


- (Vestito *)modifyVestitoEntity:(Vestito *)vestito image:(UIImage *)image isNew:(BOOL)new gradimento:(NSInteger)gradimento  tipiKeys:(NSArray *)tipiKeys stagioneKey:(NSString *)stagioneKey stiliKeys:(NSArray *)stiliKeys;

- (void)delVestitoEntity:(Vestito *)Vestito;



- (NSArray *)getCombinazioniEntities:(NSInteger)filterGradimento filterStagioneKey:(NSString *)filterStagioneKey filterStiliKeys:(NSArray *)filterStiliKeys sortOnKeys:(NSArray *)keys preferiti:(BOOL)preferiti;

- (NSArray *)getCombinazioniEntities:(NSInteger)filterGradimento filterStagioneKey:(NSString *)filterStagioneKey filterStiliKeys:(NSArray *)filterStiliKeys;
    

- (Combinazione *)addCombinazioneEntity:(NSArray *)vestitiEntities snapshot:(UIImage *)snapshot gradimento:(NSInteger)gradimento stagioneKey:(NSString *)stagioneKey stiliKeys:(NSArray *)stiliKeys preferito:(NSString *)preferito;

- (Combinazione *)modifyCombinazioneEntity:(Combinazione *)combinazione vestitiEntities:(NSArray *)vestitiEntities snapshot:(UIImage *)snapshot isNew:(BOOL)isnew gradimento:(NSInteger)gradimento  stagioneKey:(NSString *)stagioneKey stiliKeys:(NSArray *)stiliKeys preferito:(NSString *)preferito;



- (void)delCombinazioneEntity:(Combinazione *)Combinazione;

- (void)deleteSQLDB;



@end
