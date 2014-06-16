//
//  SelfieDetailViewController.m
//  RestkitExample
//
//  Created by sah-fueled on 12/06/14.
//  Copyright (c) 2014 Fueled.Inc. All rights reserved.
//

#import "SelfieDetailViewController.h"
#import "SelfieDataManager.h"
#import "RestkitModel.h"

@interface SelfieDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *selfieIdLabel;
@property (weak, nonatomic) IBOutlet UITextField *captionTextField;

@end

@implementation SelfieDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  if (self.selfie) {
    self.selfieIdLabel.text = [NSString stringWithFormat:@"SelfieId : %@",self.selfie.selfieId];
    self.captionTextField.text = [NSString stringWithFormat:@"%@",self.selfie.caption];
  }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveInfo:(id)sender {
  if (!self.selfie) {
    [[SelfieDataManager sharedManager] shouldDataPersist:YES];

    self.selfie = [[SelfieDataManager sharedManager].objectManager.managedObjectStore.mainQueueManagedObjectContext insertNewObjectForEntityForName:kEntitySelfie];
    self.selfie.caption = self.captionTextField.text;
    self.selfie.user = [RestkitModel sharedModel].currentUser;
    self.selfie.imageURL = @"http://placehold.it/320x427&text=Selfie+No.+38";
    self.selfie.imageSize = @"{320, 427}";
    [[SelfieDataManager sharedManager].objectManager postObject:self.selfie path:@"selfie/" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
      
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
      NSLog(@"error = %@",error);
    }];
  }
}

@end
