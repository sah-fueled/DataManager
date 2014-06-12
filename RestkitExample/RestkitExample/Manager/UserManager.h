//
//  UserManager.h
//  RestkitExample
//
//  Created by sah-fueled on 09/06/14.
//  Copyright (c) 2014 Fueled.Inc. All rights reserved.
//

#import "ObjectManager.h"
#import "User.h"

@class User;

@interface UserManager : ObjectManager

+ (void) loadAuthenticatedUser:(void (^)(User *))success failure:(void (^)(RKObjectRequestOperation *, NSError *))failure;

@end
