//
//  iarmadioDao.m
//  captureCloth
//
//  Created by luke on 06/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IarmadioDao.h"




@implementation IarmadioDao

@synthesize appDelegate;
@dynamic curr_stagione;

static IarmadioDao *singleton;


+ (IarmadioDao *)shared{
    if(singleton == nil){
        singleton = [[IarmadioDao alloc] initDao];
    }
    return singleton;
}

- (IarmadioDao*)initDao{
    srand(time(NULL));
    appDelegate = (iArmadioAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate retain];
    singleton = self;
    return self;
}


- (UIImage *)getImageFromVestito:(Vestito *)vestito{
    return [self getImageFromFile:vestito.immagine];
}


- (UIImage *)getImageFromFile:(NSString *)file{
    NSString *filename = [appDelegate filePathDocuments:file];
    return [UIImage imageWithContentsOfFile:filename];
}

- (NSString *)getNewID{
    NSDate* date = [NSDate date];
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd-hh-mm-ss"];
    NSString *str = [formatter stringFromDate:date];
    
    
    int d1 = rand() % 9;
    int d2 = rand() % 9;
    int d3 = rand() % 9;
    NSString *tail_casual = [NSString stringWithFormat:@"_%d%d%d",d1,d2,d3];
    
    return  [str stringByAppendingString:tail_casual];
}


- (NSArray *)getVestiti:(NSArray *)filterTipi filterStagioni:(NSArray *)filterStagioni filterStili:(NSArray *)filterStili filterGradimento:(NSInteger)filterGradimento
    {
   
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *ed = [NSEntityDescription entityForName:@"Vestito" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:ed];
    
    
    NSMutableArray *predicates = [[[NSMutableArray alloc] init] autorelease];     
    if((filterTipi != nil)&&([filterTipi count] > 0)){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY tipi.nome in %@",filterTipi];
        [predicates addObject:predicate];
    }
    
    
    if((filterStagioni != nil)&&([filterStagioni count] > 0)){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY perLaStagione.stagione in %@",filterStagioni];
        [predicates addObject:predicate];
    }  
    
    
    if((filterStili != nil)&&([filterStili count] > 0)){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY conStile.stile in %@",filterStili];
        [predicates addObject:predicate];
    }    
    
    if(filterGradimento != -1){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"gradimento >= %d",filterGradimento];
        
        [predicates addObject:predicate];
    }
     
    
    if([predicates count] > 0){
        NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
        [fetchRequest setPredicate: predicate];
    }
    
    NSError *error;
    NSArray *vestiti = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if( vestiti == nil)
    {
        NSLog(@"error get vestito -> %@", &error );
    }
    
    [vestiti retain];
    [vestiti autorelease];
    return vestiti;
}


- (Vestito *)addVestito:(UIImage *)image gradimento:(NSInteger)gradimento  tipi:(NSArray *)_tipi stagioni:(NSArray *)_stagioni stili:(NSArray *)_stili; {
    
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
    NSString *imageFilename; 
    NSString *id = [self getNewID];
    imageFilename = [id stringByAppendingString:@".png"];
    [imageData writeToFile:[appDelegate filePathDocuments:imageFilename] atomically:YES];
    
    Vestito *vestito = [NSEntityDescription insertNewObjectForEntityForName:@"Vestito" inManagedObjectContext:self.managedObjectContext];
    
    
    
    [vestito setValue:id forKey:@"id"];
    [vestito setValue:imageFilename forKey:@"immagine"];
    [vestito setValue:[NSNumber numberWithInteger:gradimento] forKey:@"gradimento"];
    
    if((_tipi != nil )&&([_tipi count] > 0)){vestito.tipi = [NSSet setWithArray: _tipi];}
    if((_stili != nil )&&([_stili count] > 0)){vestito.conStile = [NSSet setWithArray:_stili];}
    if((_stagioni != nil )&&([_stagioni count] > 0)){vestito.perLaStagione = [NSSet setWithArray:_stagioni];}
    
    [self saveContext];
    
    [vestito retain];
    [vestito autorelease];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:ADD_CLOTH_EVENT
     object:self];
    return vestito;
    

}


- (void)delVestito:(Vestito *)vestito{
    
    NSSet *inCombinazioni = vestito.inCombinazioni;
    
    for(Combinazione *combinazione in inCombinazioni){
        if([combinazione.fattaDi count] == 1){
            [self delCombinazione:combinazione]; 
        }
    }
    
    
    
    if((vestito.immagine != nil)&&([vestito.immagine length] > 0)){ 
        [[NSFileManager defaultManager] 
            removeItemAtPath:
                    [appDelegate filePathDocuments:vestito.immagine]
            error:nil
        ];
    }
    
    [self.managedObjectContext deleteObject:vestito];
    [self saveContext];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:DEL_CLOTH_EVENT
     object:self];
    
}


- (NSArray *)getCombinazioni:(NSInteger)filterGradimento filterStagioni:(NSArray *)filterStagioni filterStili:(NSArray *)filterStili{
    
    
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *ed = [NSEntityDescription entityForName:@"Combinazione" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:ed];
    
    
    NSMutableArray *predicates = [[[NSMutableArray alloc] init] autorelease];     
    
    
    if((filterStagioni != nil)&&([filterStagioni count] > 0)){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY perLaStagione.stagione in %@",filterStagioni];
        [predicates addObject:predicate];
    }  
    
    
    if((filterStili != nil)&&([filterStili count] > 0)){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY conStile.stile in %@",filterStili];
        [predicates addObject:predicate];
    }    
    
    
    if(filterGradimento != -1){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"gradimento >= %d",filterGradimento];
        
        [predicates addObject:predicate];
    }
    
    
    if([predicates count] > 0){
        NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
        [fetchRequest setPredicate: predicate];
    }
    
    NSError *error;
    NSArray *combinazioni = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if( combinazioni == nil)
    {
        NSLog(@"error get vestito -> %@", &error );
    }
    
    [combinazioni retain];
    [combinazioni autorelease];
    return combinazioni;

    
    
}


- (Combinazione *)addCombinazione:(NSSet *)vestiti gradimento:(NSInteger)gradimento stagioni:(NSArray *)_stagioni stile:(NSArray *)_stili{
    
    Combinazione *combinazione = [NSEntityDescription insertNewObjectForEntityForName:@"Combinazione" inManagedObjectContext:self.managedObjectContext];
    
    NSString *id = @"1";
    [combinazione setValue:id forKey:@"id"];
    [combinazione setValue:[NSNumber numberWithInteger:gradimento] forKey:@"gradimento"];
    
    
    
    if((_stili != nil )&&([_stili count] > 0)){combinazione.conStile = [NSSet setWithArray:_stili];}
    if((_stagioni != nil )&&([_stagioni count] > 0)){combinazione.perLaStagione = [NSSet setWithArray:_stagioni];}
    combinazione.fattaDi = vestiti;
    
    [self saveContext];
    
    [combinazione retain];
    [combinazione autorelease];
    return combinazione;    
}


- (void)delCombinazione:(Combinazione *)combinazione{
    [self.managedObjectContext deleteObject:combinazione];
    [self saveContext];
}




- (NSMutableDictionary *)tipi{
	if([tipi count] == 0){
		NSFetchRequest *allItem = [[[NSFetchRequest alloc] init] autorelease];
		[allItem setEntity:[NSEntityDescription entityForName:@"Tipologia" inManagedObjectContext:self.managedObjectContext]];
		NSError * error = nil;
		NSArray *entities = [self.managedObjectContext executeFetchRequest:allItem error:&error];
        
        
        tipi = [[NSMutableDictionary alloc] init];
        for (Tipologia *obj in entities) {
            [tipi setObject:obj forKey:obj.nome];
        }
        
	}
	return tipi;
};


- (NSArray *)listTipi{

    if(listTipi == nil){
        listTipi = [[self.tipi allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        [listTipi retain];
    }
    return listTipi;
};

- (NSArray *)listStagioni{
    if(listStagioni == nil){
        
        listStagioni = [self.stagioni allKeys]  ;
    }
    
    return listStagioni;
};




- (NSArray *)listStili{
 
    if(listStagioni == nil){
        
      ;
    }
    
    return listStagioni;
};

- (Tipologia *) getTipo:(NSString *)tipo{
   return (Tipologia *)[self.tipi objectForKey:tipo];
}

- (NSMutableDictionary *)stili{
	if([stili count] == 0){
        NSFetchRequest *allItem = [[[NSFetchRequest alloc] init] autorelease];
		[allItem setEntity:[NSEntityDescription entityForName:@"Stile" inManagedObjectContext:self.managedObjectContext]];
		NSError *error = nil;
		NSArray *entities = [self.managedObjectContext executeFetchRequest:allItem error:&error];
        
        stili = [[NSMutableDictionary alloc] init];
        for (Stile *obj in entities) {
            [stili setObject:obj forKey:obj.stile];
        }
        
	}
	return stili;
};


- (Stile *) getStile:(NSString *)stile{
    return (Stile *)[self.stili objectForKey:stile];
}


- (NSMutableDictionary *)stagioni{
	if([stagioni count] == 0){
		NSFetchRequest *allItem = [[[NSFetchRequest alloc] init] autorelease];
		[allItem setEntity:[NSEntityDescription entityForName:@"Stagione" inManagedObjectContext:self.managedObjectContext]];
		NSError * error = nil;
		NSArray *entities = [self.managedObjectContext executeFetchRequest:allItem error:&error];
        
        stagioni = [[NSMutableDictionary alloc] init];
        for (Stagione *obj in entities) {
            [stagioni setObject:obj forKey:obj.stagione];
        }
	}
	return stagioni;
};

- (Stagione *) getStagione:(NSString *)stagione{
    return (Stagione *)[self.stagioni objectForKey:stagione];
}



/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
	if (managedObjectContext != nil) { 
		return managedObjectContext;
	}
	NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
	if (coordinator != nil) { 
		managedObjectContext = [[NSManagedObjectContext alloc] init]; 
		[managedObjectContext setPersistentStoreCoordinator: coordinator];
	} 
	return managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
	if (managedObjectModel != nil) { 
		return managedObjectModel;
	} 
	NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"iArmadio" withExtension:@"momd"];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
	return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"iarmadioDB.sqlite"];
    
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }    
    return persistentStoreCoordinator;
}

- (void)saveContext {
    
    NSError *error = nil;
	if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
  
} 

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)loadTipologia:(NSString *)namefile{
	NSFetchRequest * allItem = [[[NSFetchRequest alloc] init] autorelease];
    [allItem setEntity:[NSEntityDescription entityForName:@"Tipologia" inManagedObjectContext:self.managedObjectContext]];
    [allItem setIncludesPropertyValues:NO];
    
    NSError *error = nil;
    NSArray *entities = [self.managedObjectContext executeFetchRequest:allItem error:&error];
    
    
    if([entities count] == 0){
        NSString *path=[[NSBundle mainBundle] pathForResource:namefile ofType:@"plist"];
        NSDictionary *dict=[NSDictionary dictionaryWithContentsOfFile:path];
        
        NSEnumerator *keys = [dict keyEnumerator];
        NSString *key;
        while ((key = [keys nextObject])) {
            NSDictionary *type = (NSDictionary *)[dict objectForKey:key];
            NSString *value = (NSString *)[type objectForKey:@"name"];
            NSManagedObject *tipologia = [NSEntityDescription insertNewObjectForEntityForName:@"Tipologia" inManagedObjectContext:self.managedObjectContext];
            [tipologia setValue:key forKey:@"id"];
            [tipologia setValue:value forKey:@"nome"];
            
        }
        
        [self saveContext];
        
        for (NSString *key in self.tipi) {
            NSMutableSet *array = [[NSMutableSet alloc] init];
            Tipologia *tipo = [self.tipi objectForKey:key];
            NSDictionary *type = (NSDictionary *)[dict objectForKey:tipo.id];
            NSString *allow = (NSString *)[type objectForKey:@"allow"];
            NSArray *tipologieAllow = [allow componentsSeparatedByString:@","];
            for (NSString *tipoallow in tipologieAllow){
                tipoallow = [tipoallow stringByTrimmingCharactersInSet:
                 [NSCharacterSet whitespaceAndNewlineCharacterSet]];
                 Tipologia *t = [self getTipo:tipoallow];
                 if(t != nil){
                    [array addObject:[self getTipo:tipoallow]];
                 }    
            }
            tipo.allow = array;
            [array autorelease];
        }
    }
}



- (void)loadStile:(NSString *)namefile{
	NSFetchRequest * allItem = [[[NSFetchRequest alloc] init] autorelease];
    [allItem setEntity:[NSEntityDescription entityForName:@"Stile" inManagedObjectContext:self.managedObjectContext]];
    [allItem setIncludesPropertyValues:NO];
    
    NSError *error = nil;
    NSArray *entities = [self.managedObjectContext executeFetchRequest:allItem error:&error];
    
    if([entities count] == 0){
        NSString *path=[[NSBundle mainBundle] pathForResource:namefile ofType:@"plist"];
        NSDictionary *dict=[NSDictionary dictionaryWithContentsOfFile:path];
        
        NSEnumerator *keys = [dict keyEnumerator];
        NSString *key;
        while ((key = [keys nextObject])) {
            NSString *value = (NSString *)[dict objectForKey:key];
            Stile *stile = [NSEntityDescription insertNewObjectForEntityForName:@"Stile" inManagedObjectContext:self.managedObjectContext];
            [stile setValue:key forKey:@"stile"];
            [stile setValue:value forKey:@"id"]; ;
            
        }
        
        [self saveContext];
    }
}


- (void)loadStagione:(NSString *)namefile{
	NSFetchRequest * allItem = [[[NSFetchRequest alloc] init] autorelease];
    [allItem setEntity:[NSEntityDescription entityForName:@"Stagione" inManagedObjectContext:self.managedObjectContext]];
    [allItem setIncludesPropertyValues:NO];
    
    NSError *error = nil;
    NSArray *entities = [self.managedObjectContext executeFetchRequest:allItem error:&error];
    
    if([entities count] == 0){
        NSString *path=[[NSBundle mainBundle] pathForResource:namefile ofType:@"plist"];
        NSDictionary *dict=[NSDictionary dictionaryWithContentsOfFile:path];
        
        NSEnumerator *keys = [dict keyEnumerator];
        NSString *key;
        while ((key = [keys nextObject])) {
            NSDictionary *prop = [dict objectForKey:key];
            Stagione *stagione = [NSEntityDescription insertNewObjectForEntityForName:@"Stagione" inManagedObjectContext:self.managedObjectContext];
            
            
            [stagione setValue:[prop objectForKey:@"temp_min"] forKey:@"temp_min"];
            [stagione setValue:[prop objectForKey:@"temp_max"] forKey:@"temp_max"];
            [stagione setValue:[prop objectForKey:@"date_from"] forKey:@"date_from"];
            [stagione setValue:[prop objectForKey:@"date_to"] forKey:@"date_to"];
            [stagione setValue:key forKey:@"stagione"];
        }
        
        [self saveContext];
    }
}









-(void)setupDB
{
    [self loadTipologia:TIPOLOGIA_PLIST];
    [self loadStagione:STAGIONE_PLIST];
    [self loadStile:STILE_PLIST];
    [self debugDB];
}


-(void)debugDB{
    NSLog(@"Inzio test DB...");
    
    
    NSMutableArray *_tipi = [[NSMutableArray alloc] init];
    NSMutableArray *_stili = [[NSMutableArray alloc] init];
    NSMutableArray *_stagioni = [[NSMutableArray alloc] init];
    
    
    //NSArray *_curr_stagioni = [self getCurrStagioni];
    
    
    [_tipi addObject:[self getTipo:@"giacca"]];
    [_stili addObject:[self getStile:@"casual"]];
    [_stagioni addObject:[self getStagione:@"estiva"]];
    
   
    
    Vestito *v1=[self addVestito:[[UIImage alloc] autorelease] gradimento:-1  tipi:_tipi stagioni:_stagioni stili:_stili];
    
    
    
    //[_tipi addObject:[self getTipo:@"giacca"]];
    [_stili addObject:[self getStile:@"casual"]];
    [_stagioni addObject:[self getStagione:@"estiva"]];
    
    Vestito *v2 = [self addVestito:[[UIImage alloc] autorelease] gradimento:-1  tipi:_tipi stagioni:_stagioni stili:_stili];

    
    NSMutableArray *a = [NSMutableArray arrayWithObjects:v1,v2,nil];
    
    
    //NSMutableArray *filterTipi = [[NSMutableSet alloc] init];
    //NSMutableArray *filterStili = [[NSMutableSet alloc] init];
    
    
    NSMutableSet *set = [[NSMutableSet alloc] initWithArray:a];
    
    
    [self addCombinazione:set  gradimento:-1 stagioni:nil stile:nil];
    
    //NSArray *res = [self getCombinazioni:-1 filterStagioni:nil filterStili:nil];
    
    
    //Combinazione *combinazione = (Combinazione *)[res objectAtIndex:0];
    
    /*
    NSSet *vestiti = [combinazione.fattaDi copy];
    
    for(Vestito *vestito in vestiti){
        [self delVestito:vestito];
    }*/
    
    //[managedObjectContext refreshObject:combinazione mergeChanges:YES];
    //[managedObjectContext refreshObject:combinazione mergeChanges:NO];
    /*vestiti = combinazione.fattaDi;
    
    for(Vestito *vestito in vestiti){
        NSLog(@"%@",vestito);
    }*/
    
    [set release];
    [_tipi release];
    [_stili release];
    [_stagioni release];
    //[vestiti release];
    
}


- (void)curr_stagioneFromTemp:(int) temperatura{
    NSPredicate *predicate;
    
    
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *ed = [NSEntityDescription entityForName:@"Stagione" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:ed];
  
    predicate = [NSPredicate predicateWithFormat:@"temp_min <= %d AND temp_max >=%d",temperatura,temperatura];
    NSError *error;
    [fetchRequest setPredicate:predicate];
    if(!curr_stagione){ [curr_stagione release]; }
    self.curr_stagione = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if( curr_stagione == nil)
    {
        NSLog(@"error get stagioni -> %@", &error);
    }
}

- (void)setCurr_stagione:(NSArray *)_curr_stagione{
    @synchronized(self) {
        if(curr_stagione == nil){
            [curr_stagione release];
        }
        curr_stagione = _curr_stagione;
        [curr_stagione retain];
    }    
}

- (NSArray *)curr_stagione{
    @synchronized(self) {
        if(curr_stagione == nil){
            NSPredicate *predicate;
            NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
            NSEntityDescription *ed = [NSEntityDescription entityForName:@"Stagione" inManagedObjectContext:self.managedObjectContext];
            [fetchRequest setEntity:ed];

        
            NSDate* date = [NSDate date];
            NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
            [formatter setDateFormat:@"MM-dd"];
            NSString *filterdate = [formatter stringFromDate:date];
            
            predicate = [NSPredicate predicateWithFormat:@"date_from <= %@ AND date_to >=%@",filterdate,filterdate];
            NSError *error;
            [fetchRequest setPredicate:predicate];
            if(curr_stagione == nil){ [curr_stagione release]; }
            curr_stagione = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
            if( curr_stagione == nil)
            {
                NSLog(@"error get stagioni -> %@", &error);
            }
        }
    }
    return curr_stagione;

    
}


- (void)dealloc{
	[managedObjectContext release];
	[managedObjectModel release];
    [persistentStoreCoordinator release]; 
    [appDelegate release];
    [stili release];
    [tipi release];
    [listTipi release];
    [listStagioni release];
    [listStili release];
    [stagioni release];
    [curr_stagione release];
	[super dealloc];
}

@end
