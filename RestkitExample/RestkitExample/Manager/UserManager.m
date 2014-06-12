//
//  UserManager.m
//  RestkitExample
//
//  Created by sah-fueled on 09/06/14.
//  Copyright (c) 2014 Fueled.Inc. All rights reserved.
//

#import "UserManager.h"

#import <RestKit/CoreData.h>
#import <Restkit/RestKit.h>
#import "MappingProvider.h"
#import "ObjectManager.h"

static UserManager *sharedManager = nil;

@implementation UserManager

+ (void) loadAuthenticatedUser:(void (^)(User *))success failure:(void (^)(RKObjectRequestOperation *, NSError *))failure {
  NSLog(@"self = %@",self);
  [UserManager setupResponseDescriptors];

  [[UserManager sharedManager] getObjectsAtPath:@"user/" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
    if (success) {
      User *currentUser = (User *)[mappingResult.array firstObject];
      success(currentUser);
    }
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    if (failure) {
      failure(operation, error);
    }
  }];
}

#pragma mark - Setup Helpers

+ (void) setupResponseDescriptors {
  
  RKResponseDescriptor *authenticatedUserResponseDescriptors = [RKResponseDescriptor responseDescriptorWithMapping:[MappingProvider userMappingForStore:[[ObjectManager sharedManager] store]]
                                                                                                            method:RKRequestMethodGET
                                                                                                       pathPattern:@"user/"
                                                                                                           keyPath:nil
                                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
  [[ObjectManager sharedManager] addResponseDescriptor:authenticatedUserResponseDescriptors];
}

@end
