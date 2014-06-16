//
//  ViewController.m
//  RestkitExample
//
//  Created by sah-fueled on 09/06/14.
//  Copyright (c) 2014 Fueled.Inc. All rights reserved.
//

#import "ViewController.h"
#import "SelfieListViewController.h"
#import "UserDataManager.h"
#import "SelfieDataManager.h"
#import "DataManager.h"
#import "User.h"
#import "RestkitModel.h"

@interface ViewController ()

@property (nonatomic, strong) User *user;
@property (weak, nonatomic) IBOutlet UITextField *loginUsername;
@property (weak, nonatomic) IBOutlet UITextField *loginPassword;
@property (weak, nonatomic) IBOutlet UITextField *signupUsernameField;
@property (weak, nonatomic) IBOutlet UITextField *signupPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *confPasswordField;

@end

@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self performSegueWithIdentifier:@"showSelfie" sender:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)load:(id)sender {
//  [UserManager loadAuthenticatedUser:^(User *user) {
//    self.user = user;
//
//
//  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
//  }];
//


}
- (IBAction)loadSelfies:(id)sender {
//  [SelfieManager loadSelfieForUser:self.user success:^(NSArray *selfies, NSError *error) {
//    NSLog(@"array = %@ error = %@",selfies,error);
//  }];
  [self performSegueWithIdentifier:@"showSelfie" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  SelfieListViewController *vc = segue.destinationViewController;
  vc.user = self.user;
}

/**
 RKObjectManager --> ObjectManager --> UserManager
                                   --> SelfieManager
 
 
*/

/**
 Class DataManager :  Fetches data to be used by views
 
 
 The data are of two types : Transient and Persistant

 Setter methods
 1. Setup response descriptor
 2. Setup request descriptor
 3. 
 
 Common interface to access data
 1. Fetch objects
 2. Fetch object
 3. Create object
 4. Update object
 5. Delete object
 
 BOOL isDataPersistent
 The client needs to specify type : isDataPersistent : YES/NO
 isDataPersistent ------------------> To map and store in coredata.
 
 Class DataMapper : Provides mapping functions for rkobjectmanager
 Each entity has mapper for both transient and persistent
*/

/**
  Implementation of concrete class
  class 
*/
/**
  Implentation of factory : DataModel
  [DataModel sharedModel]initWithEntityname:
  Job :  setup descriptors, setup path, setup keypath
  The job of factory is to provide approprate DataManager depending upon the entity
  User, Selfie 
 
  User Factory
 
*/

/**
 
*/
- (IBAction)signup:(id)sender {
  
//  User *user = [User new];
//  user.email = self.signupUsernameField.
}

- (IBAction)login:(id)sender {
  NSDictionary *param = @{@"name" : self.loginUsername.text};
  [UserDataManager sharedManager].path = @"user/";
  [[UserDataManager sharedManager]shouldDataPersist:YES];
  [[UserDataManager sharedManager].objectManager getObjectsAtPath:@"user/" parameters:param success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
    [RestkitModel sharedModel].currentUser = (User *)[mappingResult firstObject];
    [self performSegueWithIdentifier:@"showSelfie" sender:nil];

  } failure:^(RKObjectRequestOperation *operation, NSError *error) {

  }];
}

@end
