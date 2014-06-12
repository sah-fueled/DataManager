//
//  SelfieManager.m
//  RestkitExample
//
//  Created by sah-fueled on 09/06/14.
//  Copyright (c) 2014 Fueled.Inc. All rights reserved.
//

#import "SelfieManager.h"
#import "Selfie.h"
#import "User.h"
#import <RestKit/CoreData.h>
#import <RestKit/RestKit.h>
#import "MappingProvider.h"


@interface SelfieManager ()

@property (nonatomic, strong) RKPaginator *paginator;

@end

@implementation SelfieManager

+ (void) loadSelfieForUser:(User *)user success:(void (^)(NSArray *selfies, NSError *error))block {
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

+ (void)loadPaginatedSelfieForUser:(User *)user success:(void (^)(NSArray *selfies, NSError *error))block {
  [SelfieManager setupResponseDescriptors];
  [[ObjectManager sharedManager]setupPaginator];
  [[ObjectManager sharedManager].paginator loadPage:1];
}

#pragma mark - Setup Helpers
+ (void) setupResponseDescriptors {
  
  RKResponseDescriptor *selfieResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[MappingProvider selfieMappingForStore:[[ObjectManager sharedManager]store]]
                                                                                                            method:RKRequestMethodGET
                                                                                                       pathPattern:@"selfie/"
                                                                                                           keyPath:@"results"
                                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
  [[ObjectManager sharedManager] addResponseDescriptor:selfieResponseDescriptor];
}

@end
