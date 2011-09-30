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


static NSString * const ADD_CLOTH_EVENT = @"add_cloth_event";
static NSString * const MOD_CLOTH_EVENT = @"mod_cloth_event";
static NSString * const DEL_CLOTH_EVENT = @"del_cloth_event";

static NSString * const ADD_LOOK_EVENT = @"add_look_event";
static NSString * const MOD_LOOK_EVENT = @"mod_look_event";
static NSString * const DEL_LOOK_EVENT = @"del_look_event";

static NSString * const TIPOLOGIA_PLIST = @"tipologia";
static NSString * const STAGIONE_PLIST = @"stagione";
static NSString * const STILE_PLIST = @"stile";

@class iArmadioAppDelegate;

@interface IarmadioDao : NSObject {
    NSManagedObjectContext *managedObjectContext;
    NSManagedObjectModel *managedObjectModel;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSMutableDictionary *stagioniEntities;
    NSMutableDictionary *stiliEntities;
    NSMutableDictionary *tipiEntities;
    NSArray *listTipiKeys;
    NSArray *listStagioniKeys;
    NSArray *listStiliKeys;
    NSString *currStagioneKey; 
}

@property (nonatomic,retain, readonly) NSString *currStagioneKey;
@property (nonatomic, retain, readonly) NSMutableDictionary *stagioniEntities;
@property (nonatomic, retain, readonly) NSMutableDictionary *stiliEntities;
@property (nonatomic, retain, readonly) NSMutableDictionary *tipiEntities;
@property (nonatomic, retain, readonly) NSArray *listTipiKeys;
@property (nonatomic, retain, readonly) NSArray *listStiliKeys;
@property (nonatomic, retain, readonly) NSArray *listStagioniKeys;
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
- (UIImage *)getImageFromFile:(NSString *)file;



- (NSArray *)getVestitiEntities:(NSArray *)filterTipiKeys filterStagioniKeys:(NSArray *)filterStagioniKeys filterStiliKeys:(NSArray*)filterStiliKeys filterGradimento:(NSInteger)filterGradimento;

- (Vestito *)addVestitoEntity:(UIImage *)image gradimento:(NSInteger)gradimento  tipiKeys:(NSArray *)tipiKeys stagioniKeys:(NSArray *)stagioniKeys stiliKeys:(NSArray *)stiliKeys;



- (void)delVestitoEntity:(Vestito *)Vestito;
- (void)modifyVestitiEntities;


- (NSArray *)getCombinazioniEntities:(NSInteger)filterGradimento filterStagioniKeys:(NSArray *)filterStagioniKeys filterStiliKeys:(NSArray *)filterStiliKeys;
    

- (Combinazione *)addCombinazioneEntity:(NSSet *)vestitiEntities gradimento:(NSInteger)gradimento stagioniKeys:(NSArray *)stagioniKeys stiliKeys:(NSArray *)stiliKeys;


- (void)delCombinazioneEntity:(Combinazione *)Combinazione;

- (void)modifyCombinazioniEntities;


@end
