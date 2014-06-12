//
//  SelfieManager.h
//  RestkitExample
//
//  Created by sah-fueled on 09/06/14.
//  Copyright (c) 2014 Fueled.Inc. All rights reserved.
//

#import "ObjectManager.h"
#import "User.h"

@interface SelfieManager : ObjectManager

+ (void) loadSelfieForUser:(User *)user success:(void (^)(NSArray *selfies, NSError *error))block ;
+ (void)loadPaginatedSelfieForUser:(User *)user success:(void (^)(NSArray *selfies, NSError *error))block;

@end
