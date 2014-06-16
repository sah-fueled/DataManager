//
//  DataManager.m
//  RestkitExample
//
//  Created by sah-fueled on 12/06/14.
//  Copyright (c) 2014 Fueled.Inc. All rights reserved.
//

#import "DataManager.h"
#import "Restkit.h"

static DataManager *sharedDataManager = nil;

@interface DataManager()


@end

@implementation DataManager

+ (instancetype)sharedManager {
  sharedDataManager = [[self alloc]init];
  return sharedDataManager;
}

- (instancetype) init {
  self = [super init];
  if (self) {
    [self configureObjectManager];
    [self setupRoutes];
  }
  return self;
}

- (void)configureObjectManager {
  NSURL *url = [NSURL URLWithString:BASE_URL];
  self.objectManager = [RKObjectManager managerWithBaseURL:url];
  self.objectManager.requestSerializationMIMEType = RKMIMETypeJSON;
  [self.objectManager.HTTPClient setDefaultHeader:@"Content-Type" value:@"application/json"];
}

- (void)shouldDataPersist:(BOOL)shouldPersist {
  if (shouldPersist) {
    self.isDataPersistent = YES;
    [self configureManagedObjectStore];
    [self setupRequestDescriptorsForStore:self.objectManager.managedObjectStore];
    [self setupResponseDescriptorsForStore:self.objectManager.managedObjectStore];
  }else {
    [self setupResponseDescriptors];
    [self setupRequestDescriptors];
  }
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

- (void)setupRoutes {

}

- (void)setupResponseDescriptors {
  
}

- (void)setupRequestDescriptors {

}

- (void)setupResponseDescriptorsForStore:(RKManagedObjectStore *)store {

}

- (void)setupRequestDescriptorsForStore:(RKManagedObjectStore *)store {

}

- (void)fetchObjectsWithCompletion:(void(^)(NSArray *objects, NSError *error))block {
  [self.objectManager getObjectsAtPath:self.path
                            parameters:nil
                               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
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
  NSLog(@"route = %@",self.objectManager.router);
//  [self.objectManager getObject:selfie path:nil parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
//    
//  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
//    
//  }];
}

- (void)fetchObject:(id)object withCompletion:(void (^)(BOOL success)) block {
  

}

- (void)deleteObject:(id)object withCompletion:(void (^)(BOOL success)) block {

}

- (void)updateObject:(id)object withCompletion:(void (^)(BOOL success)) block {

}

- (void)createObject:(id)object withCompletion:(void (^)(BOOL success)) block {
  [self.objectManager postObject:object
                            path:nil
                      parameters:nil
                         success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
    
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    
  }];
}

- (void)authorizeWithCompletion:(void (^)(BOOL success))block {
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,@"auth-token/"]];
  NSDictionary *info = @{@"username":kServerUsername,@"password":kServerPassword};
  NSData *postData = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:nil];
  NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
  [request setHTTPMethod:@"POST"];
  [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
  [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  [request setHTTPBody:postData];
  [NSURLConnection sendAsynchronousRequest:request
                                     queue:[[NSOperationQueue alloc] init]
                         completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                if (connectionError) {
                                  NSLog(@"Error in getting token");
                                  block(NO);
                                }
                                else {
                                  NSError *error;
                                  NSLog(@"valid = %d",[NSJSONSerialization  isValidJSONObject:data]);
                                  NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                  NSString *token = [NSString stringWithFormat:@"%@ %@",@"JWT",[dict objectForKey:@"token"]];
                                  NSLog(@"data = %@ %@",token,error);
                                  [self.objectManager.HTTPClient setDefaultHeader:@"Authorization" value:token];
//                                  [self.objectManager.HTTPClient setAuthorizationHeaderWithToken:token];
                                  block(YES);
                                }
  }];
  }

/*  - (void) setupPaginator {
  RKObjectMapping *paginationMapping = [RKObjectMapping mappingForClass:[RKPaginator class]];
  [paginationMapping addAttributeMappingsFromDictionary:@{@"count": @"objectCount"}];
  [self setPaginationMapping:paginationMapping];
  NSString *requestString = [NSString stringWithFormat:@"selfie/?page=:currentPage"];
  
  self.paginator = [self paginatorWithPathPattern:requestString];
  
  [self.paginator setCompletionBlockWithSuccess:^(RKPaginator *paginator, NSArray *objects, NSUInteger page) {
  
  
  } failure:^(RKPaginator *paginator, NSError *error) {
  
  }];
  }
  */

@end
