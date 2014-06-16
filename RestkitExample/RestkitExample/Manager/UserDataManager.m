//
//  UserDataManager.m
//  RestkitExample
//
//  Created by sah-fueled on 12/06/14.
//  Copyright (c) 2014 Fueled.Inc. All rights reserved.
//

#import "UserDataManager.h"
#import "Restkit.h"
#import "MappingProvider.h"
#import "User.h"

static UserDataManager *sharedDataManager = nil;

@implementation UserDataManager

+ (instancetype)sharedManager {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedDataManager = [super sharedManager];
  });
  return sharedDataManager;
}

- (void)setupRoutes {
  [self.objectManager.router.routeSet addRoute:[RKRoute routeWithClass:[User class] pathPattern:@"user/" method:RKRequestMethodGET]];
}

- (void)setupResponseDescriptors {
  [super setupResponseDescriptors];
  RKResponseDescriptor *authenticatedUserResponseDescriptors = [RKResponseDescriptor responseDescriptorWithMapping:[MappingProvider userMapping]
                                                                                                            method:RKRequestMethodGET
                                                                                                       pathPattern:@"user/"
                                                                                                           keyPath:nil
                                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
  [self.objectManager addResponseDescriptor:authenticatedUserResponseDescriptors];
}

- (void)setupResponseDescriptorsForStore:(RKManagedObjectStore *)store {
  [super setupResponseDescriptorsForStore:store];
  RKResponseDescriptor *authenticatedUserResponseDescriptors = [RKResponseDescriptor responseDescriptorWithMapping:[MappingProvider userMappingForStore:store]
                                                                                                            method:RKRequestMethodGET
                                                                                                       pathPattern:@"user/"
                                                                                                           keyPath:nil
                                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
  [self.objectManager addResponseDescriptor:authenticatedUserResponseDescriptors];
}


- (void) loadAuthenticatedUser:(void (^)(User *))success failure:(void (^)(RKObjectRequestOperation *, NSError *))failure {
 
  
//  [self getObjectsAtPath:@"user/" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
// if (success) {
// User *currentUser = (User *)[mappingResult.array firstObject];
// success(currentUser);
// }
// } failure:^(RKObjectRequestOperation *operation, NSError *error) {
// if (failure) {
// failure(operation, error);
// }
// }];
 }
//+ (void)loadPaginatedSelfieForUser:(User *)user success:(void (^)(NSArray *selfies, NSError *error))block {
//  [SelfieManager setupResponseDescriptors];
//  [[ObjectManager sharedManager]setupPaginator];
//  [[ObjectManager sharedManager].paginator loadPage:1];
//}

@end
