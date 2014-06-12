//
//  DataManager.m
//  RestkitExample
//
//  Created by sah-fueled on 12/06/14.
//  Copyright (c) 2014 Fueled.Inc. All rights reserved.
//

#import "DataManager.h"
#import <Restkit/CoreData.h>
#import "Restkit.h"

static DataManager *sharedDataManager = nil;
@interface DataManager()

@property (nonatomic, strong) RKObjectManager *objectManager;

@end

@implementation DataManager

+ (instancetype)sharedManager {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedDataManager = [[self alloc]init];
  });
  
  return sharedDataManager;
}

- (instancetype) init {
  self = [super init];
  if (self) {
    [self configureObjectManager];
    [self configureManagedObjectStore];
  }
  return self;
}

- (void)configureObjectManager {
  self.objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:BASE_URL]];
  self.objectManager.requestSerializationMIMEType = RKMIMETypeJSON;
}

- (void)configureManagedObjectStore {
  NSURL *modelURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Model" ofType:@"momd"]];
  NSManagedObjectModel *managedObjectModel = [[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL] mutableCopy];
  RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
  
  NSError *error;
  BOOL success = RKEnsureDirectoryExistsAtPath(RKApplicationDataDirectory(), &error);
  if (! success) {
    RKLogError(@"Failed to create Application Data Directory at path '%@': %@", RKApplicationDataDirectory(), error);
  }
  NSString *path = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"Model.sqlite"];
  NSPersistentStore *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:path fromSeedDatabaseAtPath:nil withConfiguration:nil options:nil error:&error];
  if (! persistentStore) {
    RKLogError(@"Failed adding persistent store at path '%@': %@", path, error);
  }
  [managedObjectStore createManagedObjectContexts];
  NSLog(@"managed object conetxt = %@ in manager",managedObjectStore.mainQueueManagedObjectContext);
  NSLog(@"obejct store = %@ in object manager",managedObjectStore);
  self.objectManager.managedObjectStore = managedObjectStore;
}

/* Setter methods
 1. Setup response descriptor
 2. Setup request descriptor
 3.
 
 Common interface to access data
 1. Fetch objects
 2. Fetch object
 3. Create object
 4. Update object
 5. Delete object
 
 BOOL isDataPersistent
 The client needs to specify type : isDataPersistent : YES/NO
 isDataPersistent ------------------> To map and store in coredata.
 
 Class DataMapper : Provides mapping functions for rkobjectmanager
 Each entity has mapper for both transient and persistent
 */


- (void)fetchObjectsWithCompletion:(void(^)(NSArray *objects, NSError *error))block {
  [self.objectManager getObjectsAtPath:self.path parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
    if (block) {
      NSLog(@"result count = %d",mappingResult.count);
      NSArray *selfies = mappingResult.array;
      block(selfies,nil);
    }
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    if (block) {
      block(nil,error);
    }
  }];
}

- (void)fetchObject:(id)object withCompletion:(void (^)(BOOL success)) block {
  

}

@end
