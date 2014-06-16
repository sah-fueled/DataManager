//
//  AccountManager.m
//  RestkitExample
//
//  Created by sah-fueled on 16/06/14.
//  Copyright (c) 2014 Fueled.Inc. All rights reserved.
//

#import "AccountManager.h"

#define kSignupURL   @"sign-up/"
#define kLoginURL    @"auth-token/"

static AccountManager *sharedDataManager = nil;

@implementation AccountManager

+ (instancetype)sharedManager {
  sharedDataManager = [[self alloc]init];
  return sharedDataManager;
}

- (instancetype) init {
  self = [super init];
  if (self) {

  }
  return self;
}

//- (void)signupWithUsername:(NSString *)username withEmail:(NSString *)email withPassword:(NSString *)password {
//  NSDictionary *dict = @{@"name": username,
//                         @"email": email,
//                         @"password": password};
//  [self.objectManager postObject:nil path:@"/sign-up" parameters:dict success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
//
//  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
//
//  }];
//}

- (void)signupWithUsername:(NSString *)username withEmail:(NSString *)email withPassword:(NSString *)password withCompletion:(void (^)(BOOL success)) completion{
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,kSignupURL]];
  NSDictionary *info = @{@"name": username,
                         @"email": email,
                         @"password": password};
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
                             completion(NO);
                           }
                           else {
                             NSError *error;
                             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                             NSLog(@"data = %@",dict);
                             completion(YES);
                           }
                         }];

}

- (void)loginWithUsername:(NSString *)username withPassword:(NSString *)password withCompletion:(void (^)(NSString *, NSError *))completion {
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,kLoginURL]];
  NSDictionary *info = @{@"username": username,
                         @"password": password};
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
                             completion(nil,connectionError);
                           }
                           else {
                             NSError *error;
                             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                             NSString *token = [NSString stringWithFormat:@"%@ %@",@"JWT",[dict objectForKey:@"token"]];
                             NSLog(@"token = %@",token);
                             if (token) {
                               completion(token,nil);
                             }else {
                               NSError *error = [NSError errorWithDomain:@"Login Error" code:1 userInfo:@{@"message":@"Invalid credential"}];
                               completion(nil,error);
                             }
                           }
                         }];

}

@end
