//
//  iarmadioDao.h
//  captureCloth
//
//  Created by luke on 06/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "iArmadioAppDelegate.h"
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

static NSString * const TIPOLOGIA_PLIST = @"tipologia";
static NSString * const STAGIONE_PLIST = @"stagione";
static NSString * const STILE_PLIST = @"stile";

@class iArmadioAppDelegate;

@interface IarmadioDao : NSObject {
    NSManagedObjectContext *managedObjectContext;
    NSManagedObjectModel *managedObjectModel;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSMutableDictionary *stagioni;
    NSMutableDictionary *stili;
    NSMutableDictionary *tipi;
    NSArray *listTipi;
    NSArray *listStagioni;
    NSArray *listStili;
    iArmadioAppDelegate *appDelegate;
    NSArray *curr_stagione; 
    
}

@property (retain) NSArray *curr_stagione;
@property (nonatomic, retain) iArmadioAppDelegate *appDelegate;
@property (nonatomic, retain, readonly) NSMutableDictionary *stagioni;
@property (nonatomic, retain, readonly) NSMutableDictionary *stili;
@property (nonatomic, retain, readonly) NSMutableDictionary *tipi;
@property (nonatomic, retain, readonly) NSArray *listTipi;
@property (nonatomic, retain, readonly) NSArray *listStili;
@property (nonatomic, retain, readonly) NSArray *listStagioni;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (IarmadioDao *)shared;
- (IarmadioDao *)initDao;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)setupDB;
- (void)debugDB;

- (void)curr_stagioneFromTemp:(int)temp;
- (Tipologia *)getTipo:(NSString *)tipo;
- (Stile *)getStile:(NSString *)stile;
- (Stagione *)getStagione:(NSString *)stagione;
- (UIImage *)getImageFromVestito:(Vestito *)vestito;
- (UIImage *)getImageFromFile:(NSString *)file;



- (NSArray *)getVestiti:(NSArray *)filterTipi filterStagioni:(NSArray *)filterStagioni filterStili:(NSArray*)filterStili filterGradimento:(NSInteger)filterGradimento;

- (Vestito *)addVestito:(UIImage *)image gradimento:(NSInteger)gradimento  tipi:(NSArray *)_tipi stagioni:(NSArray *)_stagioni stili:(NSArray *)_stili;



- (void)delVestito:(Vestito *)Vestito;
- (void)modifyVestito:(Vestito *)Vestito;


- (NSArray *)getCombinazioni:(NSInteger)filterGradimento filterStagioni:(NSArray *)filterStagioni filterStili:(NSArray *)filterStili;
    

- (Combinazione *)addCombinazione:(NSSet *)vestiti gradimento:(NSInteger)gradimento stagioni:(NSArray *)stagioni stile:(NSArray *)stili;


- (void)delCombinazione:(Combinazione *)Combinazione;


@end
