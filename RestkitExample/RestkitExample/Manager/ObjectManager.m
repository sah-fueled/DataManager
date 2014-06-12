//
//  ObjectManager.m
//  RestkitExample
//
//  Created by sah-fueled on 09/06/14.
//  Copyright (c) 2014 Fueled.Inc. All rights reserved.
//
#import <RestKit/CoreData.h>

#import <RestKit.h>
#import "ObjectManager.h"

static ObjectManager *sharedManager = nil;

@interface ObjectManager ()

@property (nonatomic,strong) NSString *token;

@end

@implementation ObjectManager

+ (instancetype)sharedManager {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    
  NSURL *url = [NSURL URLWithString:BASE_URL];
  sharedManager = [self managerWithBaseURL:url];
  sharedManager.requestSerializationMIMEType = RKMIMETypeJSON;
  [sharedManager configureManagedObjectStore];
  });
  
  return sharedManager;
}

- (ObjectManager *)init {
  self = [super init];
  if (self) {
    
  }
  return self;
}

- (void)configureManagedObjectStore {
  NSURL *modelURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Model" ofType:@"momd"]];
  NSManagedObjectModel *managedObjectModel = [[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL] mutableCopy];
  RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];

//  NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
//  RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
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
  self.managedObjectStore = managedObjectStore;
}

- (RKManagedObjectStore *)store {
  return self.managedObjectStore;
}

- (void)authorizeWithCompletion:(void (^)(BOOL success))block {
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,@"auth-token/"]];
  NSDictionary *info = @{@"username":@"admin@ophio.co.in",@"password":@"1234"};
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
                              [sharedManager.HTTPClient setDefaultHeader:@"Authorization" value:token];
                              block(YES);
                            }
                         }];
}

- (void) setupRequestDescriptors {
}

- (void) setupResponseDescriptors {
}

- (void) setupPaginator {
  RKObjectMapping *paginationMapping = [RKObjectMapping mappingForClass:[RKPaginator class]];
  [paginationMapping addAttributeMappingsFromDictionary:@{@"count": @"objectCount"}];
  [self setPaginationMapping:paginationMapping];
  NSString *requestString = [NSString stringWithFormat:@"selfie/?page=:currentPage"];
  
  self.paginator = [self paginatorWithPathPattern:requestString];
  
  [self.paginator setCompletionBlockWithSuccess:^(RKPaginator *paginator, NSArray *objects, NSUInteger page) {
    
    
  } failure:^(RKPaginator *paginator, NSError *error) {
    
  }];
}
@end
