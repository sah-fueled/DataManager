//
//  AccountManager.h
//  RestkitExample
//
//  Created by sah-fueled on 16/06/14.
//  Copyright (c) 2014 Fueled.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountManager : NSObject

+ (instancetype)sharedManager;
- (void)signupWithUsername:(NSString *)username
                 withEmail:(NSString *)email
              withPassword:(NSString *)password
            withCompletion:(void (^)(BOOL success)) completion;

- (void)loginWithUsername:(NSString *)username
             withPassword:(NSString *)password withCompletion:(void (^)(NSString *token, NSError *error)) completion;

- (void)logout;

- (void)refreshTokenWithCompletion:(void(^)(NSString *token, NSError *error)) block;

- (BOOL)hasLoggedInUser;


@end
