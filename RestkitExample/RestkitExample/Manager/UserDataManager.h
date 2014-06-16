//
//  UserDataManager.h
//  RestkitExample
//
//  Created by sah-fueled on 12/06/14.
//  Copyright (c) 2014 Fueled.Inc. All rights reserved.
//

#import "DataManager.h"
#import "User.h"

@interface UserDataManager : DataManager

- (void) loadAuthenticatedUser:(void (^)(User *user))success failure:(void (^)(RKObjectRequestOperation *requestOperation, NSError *error))failure;

@end
