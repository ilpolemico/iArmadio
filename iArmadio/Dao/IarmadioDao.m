//
//  iarmadioDao.m
//  captureCloth
//
//  Created by luke on 06/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IarmadioDao.h"




@implementation IarmadioDao

@synthesize category,listCategoryKeys, localita;

static IarmadioDao *singleton;

+ (IarmadioDao *)shared{
    if(singleton == nil){
        singleton = [[IarmadioDao alloc] initDao];
    }
    return singleton;
}

- (IarmadioDao*)initDao{
    srand(time(NULL));
    singleton = self;
    silenceNotification = NO;
    return self;
}


- (NSDictionary *)imagesDictionary{
    if(imagesDictionary == nil){
        NSString *path=[[NSBundle mainBundle] pathForResource:IMAGES_PLIST ofType:@"plist"];
        imagesDictionary=[NSDictionary dictionaryWithContentsOfFile:path];
        [imagesDictionary retain];
    }

    return imagesDictionary;
}


- (UIImage *)getImageFromSection:(NSString *)section type:(NSString *)type{
    NSString *filename =  [[self.imagesDictionary objectForKey:section] objectForKey:type];
    return [[[self getImageBundleFromFile:filename] retain] autorelease];
}

- (UIImage *)getImageFromVestito:(Vestito *)vestitoEntity{
    return [[[self getImageDocumentFromFile:vestitoEntity.immagine] retain] autorelease];
}

- (UIImage *)getThumbnailFromVestito:(Vestito *)vestitoEntity{
      return [[[self getImageDocumentFromFile:vestitoEntity.thumbnail] retain] autorelease];
}


- (UIImage *)getImageWithInfoFromVestito:(Vestito *)vestitoEntity{
    UIImage *image = [[[self getImageDocumentFromFile:vestitoEntity.immagine] retain] autorelease];
    
    NSString *preferito = vestitoEntity.preferito;
    Stagione *stagione = vestitoEntity.perLaStagione;
    //Stile *stile = [[vestitoEntity.conStile objectEnumerator] nextObject];
    
    UIView *viewTmp = [[[UIView alloc] initWithFrame:CGRectMake(0,0,image.size.width, image.size.height)] autorelease]; 
    
    viewTmp.contentMode = UIViewContentModeScaleAspectFit;
    UIGraphicsBeginImageContext(CGSizeMake(viewTmp.frame.size.width,viewTmp.frame.size.height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    [viewTmp addSubview:[[[UIImageView alloc] initWithImage:image] autorelease]];
    
    int offset = 0;
    
    
    if((preferito != nil)&&(preferito.length > 0)){
        
        UIImageView *tmp = [[[UIImageView alloc] initWithImage:[self getImageBundleFromFile:@"bookmark.png"]] autorelease];
        tmp.frame = CGRectMake(offset, 0, 40, 40);
        tmp.contentMode = UIViewContentModeScaleAspectFit;
        
        [viewTmp addSubview:tmp];
        offset += 40;
    }
    
    if(stagione != nil){
        UIImageView *tmp = [[[UIImageView alloc] initWithImage:[self getImageFromStagione:stagione]] autorelease];
        
        tmp.frame = CGRectMake(offset, 0, 30, 30);
        tmp.contentMode = UIViewContentModeScaleAspectFit;
        [viewTmp addSubview:tmp];
        //offset += 40;
    }
    
    [viewTmp.layer renderInContext:context];
    UIImage *snapShotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return snapShotImage;
}

- (UIImage *)getThumbnailWithInfoFromVestito:(Vestito *)vestitoEntity{
    UIImage *thumbnail = [[[self getImageDocumentFromFile:vestitoEntity.thumbnail] retain] autorelease];
    
    NSString *preferito = vestitoEntity.preferito;
    Stagione *stagione = vestitoEntity.perLaStagione;
    //Stile *stile = [[vestitoEntity.conStile objectEnumerator] nextObject];
    
    UIView *viewTmp = [[[UIView alloc] initWithFrame:CGRectMake(0,0,thumbnail.size.width, thumbnail.size.height)] autorelease]; 
    
    viewTmp.contentMode = UIViewContentModeScaleAspectFit;
    UIGraphicsBeginImageContext(CGSizeMake(viewTmp.frame.size.width,viewTmp.frame.size.height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    [viewTmp addSubview:[[[UIImageView alloc] initWithImage:thumbnail] autorelease]];
    
    int offset = 0;
    
 
    if((preferito != nil)&&(preferito.length > 0)){
        
        UIImageView *tmp = [[[UIImageView alloc] initWithImage:[self getImageBundleFromFile:@"bookmark.png"]] autorelease];
        tmp.frame = CGRectMake(offset, 0, 40, 40);
        tmp.contentMode = UIViewContentModeScaleAspectFit;
        
        [viewTmp addSubview:tmp];
        offset += 40;
    }
   
    if(stagione != nil){
        UIImageView *tmp = [[[UIImageView alloc] initWithImage:[self getImageFromStagione:stagione]] autorelease];
        
        tmp.frame = CGRectMake(offset, 0, 30, 30);
        tmp.contentMode = UIViewContentModeScaleAspectFit;
        [viewTmp addSubview:tmp];
        //offset += 40;
    }
    /*
    if(stile != nil){
        UIImageView *tmp = [[[UIImageView alloc] initWithImage:[self getImageFromStile:stile]] autorelease];        
        tmp.frame = CGRectMake(offset, 0, 40, 40);
        tmp.contentMode = UIViewContentModeScaleAspectFit;
        [viewTmp addSubview:tmp];
    }*/
    
    [viewTmp.layer renderInContext:context];
    UIImage *snapShotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return snapShotImage;
}

- (UIImage *)getImageFromTipo:(Tipologia *)tipologiaEntity{
    return [[[self getImageBundleFromFile:tipologiaEntity.icon] retain] autorelease];
}

- (UIImage *)getImageFromGradimento:(int)gradimento{
    UIImage *image;
    NSString *filename = [NSString stringWithFormat:@"icon-%dstar-002@x.png",gradimento+1];
    //NSLog(@"%@",filename);
    image = [self getImageBundleFromFile:filename];
    return image;
}

- (UIImage *)getImageFromStile:(Stile *)stileEntity{
    return [[[self getImageBundleFromFile:stileEntity.icon] retain] autorelease];
}

- (UIImage *)getImageFromStagione:(Stagione *)stagioneEntity{
    return [[[self getImageBundleFromFile:stagioneEntity.icon] retain] autorelease];
}


- (UIImage *)getImageBundleFromFile:(NSString *)file{
    NSString *filename = [self filePathBundle:file];
    return [UIImage imageWithContentsOfFile:filename];
}

- (UIImage *)getImageDocumentFromFile:(NSString *)file{
    NSString *filename = [self filePathDocuments:file];
    return [UIImage imageWithContentsOfFile:filename];
}

- (NSString *)getNewID{
    NSDate* date = [NSDate date];
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd-hh-mm-ss"];
    NSString *str = [formatter stringFromDate:date];
    NSTimeInterval timePassed_ms = [date timeIntervalSinceNow] * -1000.0;
    
    int d1 = rand() % 9;
    int d2 = rand() % 9;
    int d3 = rand() % 9;
    int d4 = rand() % 9;
    NSString *tail_casual = [NSString stringWithFormat:@"_%d%d%d%d%d",timePassed_ms,d1,d2,d3,d4];
    
    return  [str stringByAppendingString:tail_casual];
 }


- (NSArray *)getVestitiEntitiesPreferiti:(NSArray *)filterTipiKeys filterStagioneKey:(NSString *)filterStagioneKey filterStiliKeys:(NSArray *)filterStiliKeys filterGradimento:(NSInteger)filterGradimento{
    
    return [self getVestitiEntities:filterTipiKeys filterStagioneKey:filterStagioneKey filterStiliKeys:filterStiliKeys filterGradimento:filterGradimento sortOnKeys:nil preferiti:YES];
    
}

- (NSArray *)getVestitiEntities:(NSArray *)filterTipiKeys filterStagioneKey:(NSString *)filterStagioneKey filterStiliKeys:(NSArray *)filterStiliKeys filterGradimento:(NSInteger)filterGradimento{

    return [self getVestitiEntities:filterTipiKeys filterStagioneKey:filterStagioneKey filterStiliKeys:filterStiliKeys filterGradimento:filterGradimento sortOnKeys:nil preferiti:NO];
    
}

- (NSArray *)getVestitiEntities:(NSArray *)filterTipiKeys filterStagioneKey:(NSString *)filterStagioneKey filterStiliKeys:(NSArray *)filterStiliKeys filterGradimento:(NSInteger)filterGradimento sortOnKeys:(NSArray *)sortonkeys preferiti:(BOOL) preferiti
    {
   
    NSMutableArray *sortDescriptors = [[[NSMutableArray alloc] init] autorelease];
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *ed = [NSEntityDescription entityForName:@"Vestito" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:ed];
    
    
    if(sortonkeys != nil){
        for(NSDictionary *key in sortonkeys){
            
            BOOL ascending = [(NSString*)[key objectForKey:@"ascending"] boolValue];
            NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:[key objectForKey:@"field"] ascending:ascending] autorelease];
            [sortDescriptors addObject:sortDescriptor];
        }
    }
        
    NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"id" ascending:NO] autorelease];
    [sortDescriptors addObject:sortDescriptor];
         
    
        
    NSMutableArray *predicates = [[[NSMutableArray alloc] init] autorelease];     
    if((filterTipiKeys != nil)&&([filterTipiKeys count] > 0)){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY tipi.nome in %@",filterTipiKeys];
        [predicates addObject:predicate];
    }
    
    if(preferiti){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"preferito.length > 0"];
        [predicates addObject:predicate];
    }
    
    if((filterStagioneKey != nil)&&(![filterStagioneKey isEqualToString:@"ALL"])){
        NSMutableArray *tmp = [[[NSMutableArray alloc] init] autorelease];
        NSPredicate *predicate = nil;
        
        
        if(![filterStagioneKey isEqualToString:@"calda-fredda"]){
            [tmp addObject:filterStagioneKey];
            [tmp addObject:@"calda-fredda"];
            predicate = [NSPredicate predicateWithFormat:@"ANY perLaStagione.stagione in %@",tmp];
        }
        else{
            predicate = [NSPredicate predicateWithFormat:@"perLaStagione.stagione == %@",filterStagioneKey];
        }    
        [predicates addObject:predicate];
    }  
    
    
    if((filterStiliKeys != nil)&&([filterStiliKeys count] > 0)){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY conStile.stile in %@",filterStiliKeys];
        [predicates addObject:predicate];
    }    
    
    if(filterGradimento != -1){
        NSPredicate *predicate = [NSPredicate  predicateWithFormat:@"gradimento >= %d",filterGradimento];
        
        [predicates addObject:predicate];
    }
     
    
    if([predicates count] > 0){
        NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
        if(sortDescriptors != nil){
            [fetchRequest setSortDescriptors:sortDescriptors];
        }
        [fetchRequest setPredicate: predicate];
    }
    
    NSError *error = nil;
    NSArray *vestiti = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
       
        
    if( vestiti == nil)
    {
       NSLog(@"GetVestitiEntities error %@, %@", error, [error userInfo]);
       abort(); 
    }
    
    [vestiti retain];
    [vestiti autorelease];
    return vestiti;
}


- (Vestito *)addVestitoEntity:(UIImage *)image gradimento:(NSInteger)gradimento  tipiKeys:(NSArray *)tipiKeys stagioneKey:(NSString *)stagioneKey stiliKeys:(NSArray *)stiliKeys preferito:(NSString *)preferito; {
    NSString *imageFilename; 
    NSString *thumbnailFilename; 
    
    Vestito *vestito = [NSEntityDescription insertNewObjectForEntityForName:@"Vestito" inManagedObjectContext:self.managedObjectContext];
    
    NSString *id = [self getNewID];
    imageFilename = [id stringByAppendingString:@".png"];
    thumbnailFilename = [@"thumbnail_" stringByAppendingString:imageFilename];
    
    [vestito setValue:id forKey:@"id"];
    [vestito setValue:imageFilename forKey:@"immagine"];
    [vestito setValue:thumbnailFilename forKey:@"thumbnail"];
    if(preferito != nil){
        [vestito setValue:preferito forKey:@"preferito"];
    }
    
    vestito = [self modifyVestitoEntity:vestito image:image isNew:YES gradimento:gradimento  tipiKeys:tipiKeys stagioneKey:stagioneKey stiliKeys:stiliKeys];
    
    [self saveContext];
    
    [vestito retain];
    [vestito autorelease];
    
    if(!silenceNotification){
        [[NSNotificationCenter defaultCenter]
         postNotificationName:ADD_CLOTH_EVENT
         object:self];
    }
    return vestito;
    

}

- (Vestito *)modifyVestitoEntity:(Vestito *)vestito image:(UIImage *)image  isNew:(BOOL)new gradimento:(NSInteger)gradimento  tipiKeys:(NSArray *)tipiKeys stagioneKey:(NSString *)stagioneKey stiliKeys:(NSArray *)stiliKeys {
    [vestito retain];
    if(image != nil){
        NSData *imageData = UIImagePNGRepresentation(image);
        [imageData writeToFile:[self filePathDocuments:vestito.immagine] atomically:YES];
        
        NSData *thumbnailData = UIImagePNGRepresentation([image thumbnail]);
        [thumbnailData writeToFile:[self filePathDocuments:vestito.thumbnail] atomically:YES];
    
    }
    
  
    
    

    [vestito setValue:[NSNumber numberWithInteger:gradimento] forKey:@"gradimento"];
    
    if((tipiKeys != nil )&&([tipiKeys count] > 0)){
        NSMutableArray *tmp = [[[NSMutableArray alloc] init] autorelease];
        for (NSString *key in tipiKeys) {
            [tmp addObject:[self getTipoEntity:key]];
        }
        
        if((vestito.tipi != nil)&&([vestito.tipi count]>0)){
            Tipologia *tipoCurr = [[vestito.tipi allObjects] objectAtIndex:0];
            Tipologia *tipoNew = [tmp objectAtIndex:0];
            
            if(![tipoCurr.nome isEqualToString:tipoNew.nome]){
               
              
                NSSet *inCombinazioni = vestito.inCombinazioni;
                NSArray *tmpCombinazioni = [inCombinazioni allObjects];
                
                for(Combinazione *combinazione in tmpCombinazioni){
                    if([combinazione.fattaDi count] == 1){
                        silenceNotification = YES;  
                        [self delCombinazioneEntity:combinazione];
                        silenceNotification = NO;
                    }
                }
                vestito.inCombinazioni = nil;
                
            }
        }
        
        
        vestito.tipi = [NSSet setWithArray: tmp];
    }
    if((stiliKeys != nil )&&([stiliKeys count] > 0)){
        NSMutableArray *tmp = [[[NSMutableArray alloc] init] autorelease];
        for (NSString *key in stiliKeys) {
            [tmp addObject:[self getStileEntity:key]];
        }
        vestito.conStile = [NSSet setWithArray:tmp];
    }
    if(stagioneKey != nil){
        vestito.perLaStagione = [self getStagioneEntity:stagioneKey];
    }


    if(!new){
        [self saveContext];
        if(!silenceNotification){
        [[NSNotificationCenter defaultCenter]
         postNotificationName:MOD_CLOTH_EVENT
         object:self];
        }    
    }
    [vestito autorelease];
    return vestito;
}


- (void)delVestitoEntity:(Vestito *)vestitoEntity{
    
    NSSet *inCombinazioni = vestitoEntity.inCombinazioni;
    
    
    NSArray *tmpCombinazioni = [inCombinazioni allObjects];
    
    for(Combinazione *combinazione in tmpCombinazioni){
        if([combinazione.fattaDi count] == 1){
            silenceNotification = YES;
            [self delCombinazioneEntity:combinazione]; 
            silenceNotification = NO;
        }
    }
    
    
    
    if((vestitoEntity.immagine != nil)&&([vestitoEntity.immagine length] > 0)){ 
        [[NSFileManager defaultManager] 
            removeItemAtPath:[self filePathDocuments:vestitoEntity.immagine]
            error:nil
        ];
    }
    
    if((vestitoEntity.thumbnail != nil)&&([vestitoEntity.thumbnail length] > 0)){ 
        [[NSFileManager defaultManager] 
         removeItemAtPath:[self filePathDocuments:vestitoEntity.thumbnail]
         error:nil
         ];
    }
    
    [self.managedObjectContext deleteObject:vestitoEntity];
    [self saveContext];
    if(!silenceNotification){
    [[NSNotificationCenter defaultCenter]
     postNotificationName:DEL_CLOTH_EVENT
     object:self];
    }    
    
}

- (void)modifyVestitiEntities{
    [self saveContext];
    if(!silenceNotification){
    [[NSNotificationCenter defaultCenter]
     postNotificationName:MOD_CLOTH_EVENT
     object:self];
    }    
}


- (NSArray *)getCombinazioniEntities:(NSInteger)filterGradimento filterStagioneKey:(NSString *)filterStagioneKey filterStiliKeys:(NSArray *)filterStiliKeys{

    
    return [self getCombinazioniEntities:filterGradimento filterStagioneKey:filterStagioneKey filterStiliKeys:filterStiliKeys sortOnKeys:nil preferiti:NO];
    
}

- (NSArray *)getCombinazioniEntities:(NSInteger)filterGradimento filterStagioneKey:(NSString *)filterStagioneKey filterStiliKeys:(NSArray *)filterStiliKeys sortOnKeys:(NSArray *)sortonkeys preferiti:(BOOL)preferiti{
    
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *ed = [NSEntityDescription entityForName:@"Combinazione" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:ed];
    
    
    
    NSMutableArray *predicates = [[[NSMutableArray alloc] init] autorelease]; 
    
    
    if(preferiti){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"preferito.length > 0"];
        [predicates addObject:predicate];
    }
    
    NSMutableArray *sortDescriptors = [[[NSMutableArray alloc] init] autorelease];
    
    if(sortonkeys != nil){
        for(NSDictionary *key in sortonkeys){
            
            BOOL ascending = [(NSString*)[key objectForKey:@"ascending"] boolValue];
            NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:[key objectForKey:@"field"] ascending:ascending] autorelease];
            [sortDescriptors addObject:sortDescriptor];
        }
    }
    
    NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"id" ascending:NO] autorelease];
    [sortDescriptors addObject:sortDescriptor];
    
    
    if((filterStagioneKey != nil)&&(![filterStagioneKey isEqualToString:@"ALL"])){
        NSMutableArray *tmp = [[[NSMutableArray alloc] init] autorelease];
        NSPredicate *predicate = nil;
        
        
        if(![filterStagioneKey isEqualToString:@"calda-fredda"]){
            [tmp addObject:filterStagioneKey];
            [tmp addObject:@"calda-fredda"];
            predicate = [NSPredicate predicateWithFormat:@"ANY perLaStagione.stagione in %@",tmp];
        }
        else{
            predicate = [NSPredicate predicateWithFormat:@"perLaStagione.stagione == %@",filterStagioneKey];
        }    
        [predicates addObject:predicate];
    }  

    
    
    if((filterStiliKeys != nil)&&([filterStiliKeys count] > 0)){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY conStile.stile in %@",filterStiliKeys];
        [predicates addObject:predicate];
    }    
    
    
    if(filterGradimento != -1){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"gradimento >= %d",filterGradimento];
        
        [predicates addObject:predicate];
    }
    
    
    if([predicates count] > 0){
        NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
        if(sortDescriptors != nil){
            [fetchRequest setSortDescriptors:sortDescriptors];
        }
        [fetchRequest setPredicate: predicate];
    }
    
    NSError *error = nil;
    NSArray *combinazioni = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if( combinazioni == nil)
    {
         NSLog(@"GetCombinazioniEntities error %@, %@", error, [error userInfo]);
         abort();
    }
    
    [combinazioni retain];
    [combinazioni autorelease];
    return combinazioni;

    
    
}


- (Combinazione *)addCombinazioneEntity:(NSArray *)vestitiEntities  gradimento:(NSInteger)gradimento stagioneKey:(NSString *)stagioneKey stiliKeys:(NSArray *)stiliKeys preferito:(NSString *)preferito;{
    
    Combinazione *combinazione = [NSEntityDescription insertNewObjectForEntityForName:@"Combinazione" inManagedObjectContext:self.managedObjectContext];
    
    NSString *id = [self getNewID];
    [combinazione setValue:id forKey:@"id"];
    [combinazione setValue:[NSNumber numberWithInteger:gradimento] forKey:@"gradimento"];
    
    
    combinazione = [self modifyCombinazioneEntity:combinazione vestitiEntities:vestitiEntities isNew:YES gradimento:gradimento stagioneKey:stagioneKey stiliKeys:stiliKeys preferito:preferito];
    if(!silenceNotification){
    [[NSNotificationCenter defaultCenter]
     postNotificationName:ADD_LOOK_EVENT
     object:self];
    }    
    [combinazione retain];
    [combinazione autorelease];
    return combinazione;    
}

- (Combinazione *)modifyCombinazioneEntity:(Combinazione *)combinazione vestitiEntities:(NSArray *)vestitiEntities isNew:(BOOL)isnew gradimento:(NSInteger)gradimento stagioneKey:(NSString *)stagioneKey stiliKeys:(NSArray *)stiliKeys preferito:(NSString *)preferito{
    
    combinazione.preferito = preferito;
    if(preferito != nil){ [combinazione setValue:preferito forKey:@"preferito"];}
    else{
        
    }
    [combinazione setValue:[NSNumber numberWithInteger:gradimento] forKey:@"gradimento"];
    
    
    if((stiliKeys != nil )&&([stiliKeys count] > 0)){
        NSMutableArray *tmp = [[[NSMutableArray alloc] init] autorelease];
        for (NSString *key in stiliKeys) {
            [tmp addObject:[self getStileEntity:key]];
        }
        combinazione.conStile = [NSSet setWithArray:tmp];
    }
    if(stagioneKey != nil ){
       combinazione.perLaStagione = [self getStagioneEntity:stagioneKey];
    }
    combinazione.fattaDi = [NSSet setWithArray:vestitiEntities];
    
    [self saveContext];
    
    if(!isnew){
        if(!silenceNotification){
                [[NSNotificationCenter defaultCenter]
                    postNotificationName:MOD_LOOK_EVENT
                    object:self];
        }      
    }    
    
    return combinazione;
}


- (void)delCombinazioneEntity:(Combinazione *)combinazione{
    [self.managedObjectContext deleteObject:combinazione];
    [self saveContext];
    
    if(!silenceNotification){
    [[NSNotificationCenter defaultCenter]
     postNotificationName:DEL_LOOK_EVENT
     object:self];
    }    
}


- (void)modifyCombinazioniEntities{
    [self saveContext];
    if(!silenceNotification){
    [[NSNotificationCenter defaultCenter]
     postNotificationName:MOD_LOOK_EVENT
     object:self];
    }    
}



- (NSMutableDictionary *)tipiEntities{
	if([tipiEntities count] == 0){
		NSFetchRequest *allItem = [[[NSFetchRequest alloc] init] autorelease];
        
        NSMutableArray *sortDescriptors = [[[NSMutableArray alloc] init] autorelease];
        
        NSSortDescriptor * sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"category" ascending:YES] autorelease];
        [sortDescriptors addObject:sortDescriptor];
        
        sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES] autorelease];
        [sortDescriptors addObject:sortDescriptor];
        
        [allItem setEntity:[NSEntityDescription entityForName:@"Tipologia" inManagedObjectContext:self.managedObjectContext]];
        
        [allItem setSortDescriptors:sortDescriptors];
        
		NSError * error = nil;
		NSArray *entities = [self.managedObjectContext executeFetchRequest:allItem error:&error];
        
       
        
        if(entities == nil){
            NSLog(@"tipiEntities error %@, %@", error, [error userInfo]);
            abort();
        }    
        
        tipiEntities = [[NSMutableDictionary alloc] init];
        listTipiKeys = [[NSMutableArray alloc] init];
        category = [[NSMutableDictionary alloc] init];
        listCategoryKeys = [[NSMutableArray alloc] init];
        NSString *currCategory = @"";
        for (Tipologia *obj in entities) {
            [tipiEntities setObject:obj forKey:obj.nome];
            [listTipiKeys addObject:obj.nome];
            NSMutableArray *tmp = [category objectForKey:obj.category];
            if(tmp == nil){
                tmp = [[[NSMutableArray alloc] init] autorelease];
            }
            [tmp addObject:obj.nome];
            [category setValue:tmp forKey:obj.category];
            if(![currCategory isEqualToString:obj.category]){
                currCategory = obj.category;
                [listCategoryKeys addObject:obj.category];
            }    
        }
	}
    
	return tipiEntities;
};


- (NSMutableArray *)listTipiKeys{
    if(listTipiKeys == nil){
        [self tipiEntities];
    }
    return listTipiKeys;
};

- (NSMutableArray *)listStagioniKeys{
    if(listStagioniKeys == nil){
        [self stagioniEntities]; 
    }
    return listStagioniKeys;
};




- (NSMutableArray *)listStiliKeys{
 
    if(listStiliKeys == nil){
        [self stiliEntities]; 
    }
    
    return listStiliKeys;
};

- (Tipologia *) getTipoEntity:(NSString *)tipo{
   return (Tipologia *)[self.tipiEntities objectForKey:tipo];
}

- (NSMutableDictionary *)stiliEntities{
	if([stiliEntities count] == 0){
        NSFetchRequest *allItem = [[[NSFetchRequest alloc] init] autorelease];
		[allItem setEntity:[NSEntityDescription entityForName:@"Stile" inManagedObjectContext:self.managedObjectContext]];
        
        NSMutableArray *sortDescriptors = [[[NSMutableArray alloc] init] autorelease];
        
        NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES] autorelease];
        [sortDescriptors addObject:sortDescriptor];
        
        [allItem setSortDescriptors:sortDescriptors];
        
        
		NSError *error = nil;
		NSArray *entities = [self.managedObjectContext executeFetchRequest:allItem error:&error];
        
        if(entities == nil){
            NSLog(@"stiliEntities error %@, %@", error, [error userInfo]);
            abort();
        }
        
        [stiliEntities release];
        [listStiliKeys release];
        
        stiliEntities = nil;
        listStiliKeys = nil;
        
        stiliEntities = [[NSMutableDictionary alloc] init];
        listStiliKeys = [[NSMutableArray alloc] init];
        for (Stile *obj in entities) {
            [stiliEntities setObject:obj forKey:obj.stile];
            [listStiliKeys addObject:obj.stile]  ;
        }
        
        
        
	}
	return stiliEntities;
};


- (Stile *) getStileEntity:(NSString *)stileKey{
    return (Stile *)[self.stiliEntities objectForKey:stileKey];
}


- (NSMutableDictionary *)stagioniEntities{
	if([stagioniEntities count] == 0){
		NSFetchRequest *allItem = [[[NSFetchRequest alloc] init] autorelease];
        [allItem setEntity:[NSEntityDescription entityForName:@"Stagione" inManagedObjectContext:self.managedObjectContext]];
        
        
        NSMutableArray *sortDescriptors = [[[NSMutableArray alloc] init] autorelease];
        
        NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES] autorelease];
        [sortDescriptors addObject:sortDescriptor];
        
        [allItem setSortDescriptors:sortDescriptors];

        
		NSError *error = nil;
		NSArray *entities = [self.managedObjectContext executeFetchRequest:allItem error:&error];
        
        if(entities == nil){
             NSLog(@"stagioniEntities error %@, %@", error, [error userInfo]);
             abort();
        }
        
        [stagioniEntities release];
        stagioniEntities = nil;
        [listStagioniKeys release];
        listStagioniKeys = nil;
        
        stagioniEntities = [[NSMutableDictionary alloc] init];
        listStagioniKeys = [[NSMutableArray alloc] init];
        for (Stagione *obj in entities) {
            [stagioniEntities setObject:obj forKey:obj.stagione];
            [listStagioniKeys addObject:obj.stagione];
        }
	}
	return stagioniEntities;
};

- (Stagione *) getStagioneEntity:(NSString *)stagioneKey{
    return (Stagione *)[self.stagioniEntities objectForKey:stagioneKey];
}



/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)loadTipologie:(NSString *)namefile{
	    NSString *path=[[NSBundle mainBundle] pathForResource:namefile ofType:@"plist"];
        NSDictionary *dict=[NSDictionary dictionaryWithContentsOfFile:path];
        
        NSEnumerator *keys = [dict keyEnumerator];
        NSString *key;
        while ((key = [keys nextObject])) {
            NSDictionary *type = (NSDictionary *)[dict objectForKey:key];
            NSString *values = (NSString *)[type objectForKey:@"name"];
            
            NSArray *tmp = [values componentsSeparatedByString:@"-"];
            
            NSString *single =[[tmp objectAtIndex:0] stringByTrimmingCharactersInSet:
                                            [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            NSString *plural;
            if([tmp count] > 1){
              plural =[[tmp objectAtIndex:1] stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            }
            else{
              plural = single;
            }
            NSString *icon = (NSString *)[type objectForKey:@"icon"];
            NSString *order = (NSString *)[type objectForKey:@"order"];
            NSString *categoria = (NSString *)[type objectForKey:@"category"];
            NSString *choice = (NSString *)[type objectForKey:@"choice"];
            Tipologia *tipologia = [self getTipologiaWithID:key];
            [tipologia setValue:key forKey:@"id"];
            [tipologia setValue:single forKey:@"nome"];
            [tipologia setValue:plural forKey:@"plural"];
            [tipologia setValue:icon forKey:@"icon"];
            [tipologia setValue:categoria forKey:@"category"];
            [tipologia setValue:choice forKey:@"choice"];
            [tipologia setValue:[NSNumber numberWithInteger:[order integerValue]] forKey:@"order"];
            
        }
        
        [self saveContext];
        
        for (NSString *key in self.tipiEntities) {
            NSMutableSet *array = [[NSMutableSet alloc] init];
            Tipologia *tipo = [self.tipiEntities objectForKey:key];
            NSDictionary *type = (NSDictionary *)[dict objectForKey:tipo.id];
            NSString *allow = (NSString *)[type objectForKey:@"allow"];
            NSArray *tipologieAllow = [allow componentsSeparatedByString:@","];
            for (NSString *tipoallow in tipologieAllow){
                tipoallow = [tipoallow stringByTrimmingCharactersInSet:
                 [NSCharacterSet whitespaceAndNewlineCharacterSet]];
                 Tipologia *t = [self getTipoEntity:tipoallow];
                 if(t != nil){
                    [array addObject:[self getTipoEntity:tipoallow]];
                 }    
            }
            tipo.allow = array;
            [array autorelease];
        }
        [self saveContext];
    
}



- (void)loadStili:(NSString *)namefile{
	
        NSString *path=[[NSBundle mainBundle] pathForResource:namefile ofType:@"plist"];
        NSDictionary *dict=[NSDictionary dictionaryWithContentsOfFile:path];
        
        NSEnumerator *keys = [dict keyEnumerator];
        NSString *key;
        while ((key = [keys nextObject])) {
            
            NSDictionary *prop = [dict objectForKey:key];
            NSString *value = [prop objectForKey:@"id"];
            NSString *icon = [prop objectForKey:@"icon"];
            Stile *stile = [self getStileWithID:[prop objectForKey:@"id"]];
            [stile setValue:key forKey:@"stile"];
            [stile setValue:value forKey:@"id"]; 
            [stile setValue:icon forKey:@"icon"]; 
            
        }
        
        [self saveContext];
    
}




- (void)loadStagioni:(NSString *)namefile{
	
        NSString *path=[[NSBundle mainBundle] pathForResource:namefile ofType:@"plist"];
        NSDictionary *dict=[NSDictionary dictionaryWithContentsOfFile:path];
        
        NSEnumerator *keys = [dict keyEnumerator];
        NSString *key;
        while ((key = [keys nextObject])) {
            NSDictionary *prop = [dict objectForKey:key];
            Stagione *stagione = [self getStagioneWithID:[prop objectForKey:@"id"]];
            
            [stagione setValue:(NSNumber *)[prop objectForKey:@"id"] forKey:@"id"];
            [stagione setValue:[prop objectForKey:@"icon"] forKey:@"icon"];
            [stagione setValue:[prop objectForKey:@"temp_min"] forKey:@"temp_min"];
            [stagione setValue:[prop objectForKey:@"temp_max"] forKey:@"temp_max"];
            [stagione setValue:[prop objectForKey:@"date_from"] forKey:@"date_from"];
            [stagione setValue:[prop objectForKey:@"date_to"] forKey:@"date_to"];
            [stagione setValue:[prop objectForKey:@"date_from_2"] forKey:@"date_from_2"];
            [stagione setValue:[prop objectForKey:@"date_to_2"] forKey:@"date_to_2"];
            [stagione setValue:key forKey:@"stagione"];
        }
        [self saveContext];
}

- (Stagione *)getStagioneWithID:(NSString *)id{
    NSFetchRequest *fetch = [[[NSFetchRequest alloc] init] autorelease];
    [fetch setEntity:[NSEntityDescription entityForName:@"Stagione" inManagedObjectContext:self.managedObjectContext]];
    NSPredicate *predicate = [NSPredicate  predicateWithFormat:@"id = %@",id];
    [fetch setPredicate: predicate];
    
    NSError *error = nil;
    NSArray *entities = [self.managedObjectContext executeFetchRequest:fetch error:&error];
    
    if(entities == nil){
        NSLog(@"loadStagioni error %@, %@", error, [error userInfo]);
        abort();
    }
    
    if([entities count] > 0){
        return [entities objectAtIndex:0];
        
    }
    
    Stagione *stagione = [NSEntityDescription insertNewObjectForEntityForName:@"Stagione" inManagedObjectContext:self.managedObjectContext];
    return stagione;
     
}


- (Stile *)getStileWithID:(NSString *)id{
    NSFetchRequest *fetch = [[[NSFetchRequest alloc] init] autorelease];
    [fetch setEntity:[NSEntityDescription entityForName:@"Stile" inManagedObjectContext:self.managedObjectContext]];
    NSPredicate *predicate = [NSPredicate  predicateWithFormat:@"id = %@",id];
    [fetch setPredicate: predicate];
    
    NSError *error = nil;
    NSArray *entities = [self.managedObjectContext executeFetchRequest:fetch error:&error];
    
    if(entities == nil){
        NSLog(@"loadStili error %@, %@", error, [error userInfo]);
        abort();
    }
    
    if([entities count] > 0){
        return [entities objectAtIndex:0];
        
    }
    
    Stile *stile = [NSEntityDescription insertNewObjectForEntityForName:@"Stile" inManagedObjectContext:self.managedObjectContext];
    return stile;
    
}


- (Tipologia *)getTipologiaWithID:(NSString *)id{
    NSFetchRequest *fetch = [[[NSFetchRequest alloc] init] autorelease];
    [fetch setEntity:[NSEntityDescription entityForName:@"Tipologia" inManagedObjectContext:self.managedObjectContext]];
    NSPredicate *predicate = [NSPredicate  predicateWithFormat:@"id = %@",id];
    [fetch setPredicate: predicate];
    
    NSError *error = nil;
    NSArray *entities = [self.managedObjectContext executeFetchRequest:fetch error:&error];
    
    if(entities == nil){
        NSLog(@"loadTipologie error %@, %@", error, [error userInfo]);
        abort();
    }
    
    if([entities count] > 0){
        return [entities objectAtIndex:0];
        
    }
    
    Tipologia *tipo = [NSEntityDescription insertNewObjectForEntityForName:@"Tipologia" inManagedObjectContext:self.managedObjectContext];
    return tipo;
    
}




- (NSMutableDictionary *)config{
    if(config == nil){
        NSString *pathDocumentSettings= [self filePathDocuments:[CONFIG_PLIST stringByAppendingString:@".plist"]];
        NSString *pathBundleSettings= [self filePathBundle:[CONFIG_PLIST stringByAppendingString:@".plist"]];
        
        if(![[NSFileManager defaultManager] fileExistsAtPath:pathDocumentSettings]){
             
             [[NSFileManager defaultManager] copyItemAtPath:pathBundleSettings 
                                                     toPath:pathDocumentSettings 
                                                      error:nil];
        };
        config = [NSMutableDictionary dictionaryWithContentsOfFile:pathDocumentSettings];
         
        [config retain];
    }
    return config;
}


- (void)setConfig:(NSMutableDictionary *)_config{
    if(config != nil){
        [config release];
        config = nil;
    }
    config = _config;
    [config retain];
     NSString *pathDocumentSettings= [self filePathDocuments:[CONFIG_PLIST stringByAppendingString:@".plist"]];

    [config writeToFile:pathDocumentSettings atomically:YES];
}

-(void)setupDB
{
    [self loadTipologie:TIPOLOGIA_PLIST];
    [self loadStagioni:STAGIONE_PLIST];
    [self loadStili:STILE_PLIST];
    [self config];
    [self tipiEntities];
    [self stiliEntities];
    [self stagioniEntities];
}


-(void)debugDB{
    NSLog(@"Inzio test DB...");
    
}


- (void)setCurrStagioneKeyFromTemp:(int)temperatura{
    NSPredicate *predicate;
    
    
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *ed = [NSEntityDescription entityForName:@"Stagione" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:ed];
  
    NSMutableArray *predicates = [[[NSMutableArray alloc] init] autorelease];
    
    if(temperatura != 999){
        predicate = [NSPredicate predicateWithFormat:@"temp_min <= %d AND temp_max >=%d",temperatura,temperatura];
        [predicates addObject:predicate];
    }
    else{
        NSDate* date = [NSDate date];
        NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
        [formatter setDateFormat:@"MM-dd"];
        NSString *filterdate = [formatter stringFromDate:date];
        predicate = [NSPredicate predicateWithFormat:@"(date_from <= %@ AND date_to >=%@) OR (date_from_2 <= %@ AND date_to_2 >=%@)",filterdate,filterdate,filterdate,filterdate];
        [predicates addObject:predicate];
    }
    
    [fetchRequest setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:predicates]];
    
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error]; 
    
    
    
    if([results count] > 0){
        if(!currStagioneKey){ [currStagioneKey release];} 
       currStagioneKey = ((Stagione *)[results objectAtIndex:0]).stagione;
        [currStagioneKey retain];
    }
    else{
        currStagioneKey = @"calda-fredda";
    }
    
    NSLog(@"CurrStagione:%@",currStagioneKey);
    
}


- (NSString *)currStagioneKey{
    NSDate* currdate = [NSDate date];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:1];
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    [gregorian setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    NSDate *date = [gregorian dateByAddingComponents:comps toDate:[GeoLocal shared].lastUpdate  options:0];
    [comps release];
    
    if([date compare:currdate] == NSOrderedDescending){
        [self setCurrStagioneKeyFromTemp:999];
    }
    else if(currStagioneKey == nil){
        [self setCurrStagioneKeyFromTemp:999];
    }
    return currStagioneKey;
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


- (void)deleteSQLDB{
    NSError *error;
    
    NSArray *stores = [persistentStoreCoordinator persistentStores];
    
    for(NSPersistentStore *store in stores) {
        [persistentStoreCoordinator removePersistentStore:store error:&error];
        [[NSFileManager defaultManager] removeItemAtPath:store.URL.path error:&error];
    }
    
    
    [persistentStoreCoordinator release];
    [managedObjectContext release];
    [managedObjectModel release];
    managedObjectModel = nil;
    managedObjectContext = nil;
    persistentStoreCoordinator = nil;
    
    [config release];
    [stiliEntities release];
    [tipiEntities release];
    [listTipiKeys release];
    [listStagioniKeys release];
    [listStiliKeys release];
    [listCategoryKeys release];
    [category release];
    [stagioniEntities release];
    [currStagioneKey release];
    stiliEntities = nil;
    tipiEntities = nil;
    listTipiKeys = nil;
    listStagioniKeys = nil;
    listStiliKeys = nil;
    listCategoryKeys = nil;
    category = nil;
    stagioniEntities = nil;
    currStagioneKey = nil;
    config = nil;
    
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *directory = [[self filePathDocuments:@""] stringByAppendingString:@"/"] ;
    
   
    for (NSString *file in [fm contentsOfDirectoryAtPath:directory error:&error]) {
         [fm removeItemAtPath:[NSString stringWithFormat:@"%@%@", directory, file] error:&error];
    }
    
    [self setupDB];
    if(!silenceNotification){
    [[NSNotificationCenter defaultCenter]
     postNotificationName:MOD_CLOTH_EVENT
     object:self];
    }   
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



- (void)dealloc{
	[managedObjectContext release];
	[managedObjectModel release];
    [persistentStoreCoordinator release]; 
    [stiliEntities release];
    [tipiEntities release];
    [listTipiKeys release];
    [listStagioniKeys release];
    [listStiliKeys release];
    [listCategoryKeys release];
    [category release];
    [stagioniEntities release];
    [currStagioneKey release];
    [imagesDictionary release];
    [config release];
    [localita release];
	[super dealloc];
}
@end
