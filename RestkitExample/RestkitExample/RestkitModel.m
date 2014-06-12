//
//  RestkitModel.m
//  RestkitExample
//
//  Created by sah-fueled on 10/06/14.
//  Copyright (c) 2014 Fueled.Inc. All rights reserved.
//

#import "RestkitModel.h"
#import "ObjectManager.h"

static RestkitModel *sharedModel = nil;

@interface RestkitModel ()

@property (nonatomic, strong) ObjectManager *objectManager;

@end

@implementation RestkitModel

+ (RestkitModel *) sharedModel {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    [sharedModel initialSetup];
  });
  return sharedModel;
}


- (void)initialSetup {
    
}

- (void) loadAuthenticatedUser:(void (^)(User *))success failure:(void (^)(RKObjectRequestOperation *, NSError *))failure {
//  [self.objectManager setupResponseDescriptors:]
  NSLog(@"self = %@",self);
  [self.objectManager getObjectsAtPath:@"user/" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
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
@end
