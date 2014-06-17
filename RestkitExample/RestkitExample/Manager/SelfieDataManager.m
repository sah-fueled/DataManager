//
//  SelfieDataManager.m
//  RestkitExample
//
//  Created by sah-fueled on 12/06/14.
//  Copyright (c) 2014 Fueled.Inc. All rights reserved.
//

#import "SelfieDataManager.h"
#import "MappingProvider.h"
#import "Restkit/Coredata.h"
#import "Restkit.h"
#import "Selfie.h"

static SelfieDataManager *sharedDataManager = nil;

@implementation SelfieDataManager

+ (instancetype)sharedManager {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedDataManager = [super sharedManager];
  });
  return sharedDataManager;
}

- (void)setupRoutes {
  self.path = @"selfie/";
  [self.objectManager.router.routeSet addRoute:[RKRoute routeWithClass:[Selfie class] pathPattern:@"selfie/:id" method:RKRequestMethodGET]];
  [self.objectManager.router.routeSet addRoute:[RKRoute routeWithClass:[Selfie class] pathPattern:@"selfie/" method:RKRequestMethodPOST]];

}

- (void) setupRequestDescriptorsForStore:(RKManagedObjectStore *)store {
  RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:[MappingProvider selfieMappingForStore:store].inverseMapping objectClass:[Selfie class] rootKeyPath:nil method:RKRequestMethodAny];

  [self.objectManager addRequestDescriptor:requestDescriptor];
}

- (void) setupResponseDescriptors {
  RKResponseDescriptor *selfieResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[MappingProvider selfieMapping]
                                                                                                method:RKRequestMethodGET
                                                                                           pathPattern:@"selfies/"
                                                                                               keyPath:nil
                                                                                           statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
  [self.objectManager addResponseDescriptor:selfieResponseDescriptor];
}

- (void)setupResponseDescriptorsForStore:(RKManagedObjectStore *)store {
  RKResponseDescriptor *selfieResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[MappingProvider selfieMappingForStore:store]
                                                                                                method:RKRequestMethodGET
                                                                                           pathPattern:@"selfies/"
                                                                                               keyPath:nil
                                                                                           statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
  [self.objectManager addResponseDescriptor:selfieResponseDescriptor];

}

- (void)setupPagination {
  RKObjectMapping *paginationMapping = [RKObjectMapping mappingForClass:[RKPaginator class]];
  [paginationMapping addAttributeMappingsFromDictionary:@{@"count": @"objectCount"}];
  [self.objectManager setPaginationMapping:paginationMapping];
  NSString *requestString = [NSString stringWithFormat:@"selfie/?page=:currentPage"];
  self.paginator = [self.objectManager paginatorWithPathPattern:requestString];
}

/*+ (void) loadSelfieForUser:(User *)user success:(void (^)(NSArray *selfies, NSError *error))block {
 NSLog(@"self = %@",self);
 [SelfieManager setupResponseDescriptors];
 NSDictionary *queryParam =  (user == nil) ? nil :@{@"user.id":user.userId};
 [[SelfieManager sharedManager] getObjectsAtPath:@"selfie/" parameters:queryParam success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
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
*/

@end
