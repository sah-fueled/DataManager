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
#import "MappingProvider.h"

@interface SelfieDetailViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *selfieIdLabel;
@property (weak, nonatomic) IBOutlet UITextField *captionTextField;
@property (weak, nonatomic) IBOutlet UIImageView *selfieImageView;

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

- (IBAction)saveInfo:(id)sender {
  if (!self.selfie) {
    self.selfie = [[SelfieDataManager sharedManager].objectManager.managedObjectStore.mainQueueManagedObjectContext insertNewObjectForEntityForName:kEntitySelfie];
    self.selfie.caption = self.captionTextField.text;
    self.selfie.user = [RestkitModel sharedModel].currentUser;
    self.selfie.imageURL = @"http://placehold.it/320x427&text=Selfie+No.+38";
    self.selfie.imageSize = @"{320, 427}";
    self.selfie.category = @"interests";
    RKResponseDescriptor *selfieResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[MappingProvider selfieMappingForStore:[SelfieDataManager sharedManager].objectManager.managedObjectStore]
                                                                                                  method:RKRequestMethodPOST
                                                                                             pathPattern:nil
                                                                                                 keyPath:@"detail"
                                                                                             statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [[SelfieDataManager sharedManager].objectManager addResponseDescriptor:selfieResponseDescriptor];
    [[SelfieDataManager sharedManager].objectManager.HTTPClient setDefaultHeader:@"Authorization" value:@"JWT eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE0MDI5MTYwODcsInVzZXJfaWQiOjEsImVtYWlsIjoiZGVtb0BvcGhpby5jby5pbiIsInVzZXJuYW1lIjoiZGVtb0BvcGhpby5jby5pbiJ9.JXi5rWapCpBP27PHUa2rFCDK8Ri1vCsHJYlF0J1jmik"];
        [[SelfieDataManager sharedManager].objectManager postObject:self.selfie path:@"selfie" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
      } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
      }];

  
  }else {
    self.selfie.caption = self.captionTextField.text;
    RKResponseDescriptor *selfieResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[MappingProvider selfieMappingForStore:[SelfieDataManager sharedManager].objectManager.managedObjectStore]
                                                                                                  method:RKRequestMethodPOST
                                                                                             pathPattern:nil
                                                                                                 keyPath:@"detail"
                                                                                             statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [[SelfieDataManager sharedManager].objectManager addResponseDescriptor:selfieResponseDescriptor];

    [[SelfieDataManager sharedManager].objectManager putObject:self.selfie path:@"selfie/" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
      
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
      
    }];
  }
}

- (IBAction)showCamera:(id)sender {
  UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
  imagePicker.delegate = self;
  imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  [self presentViewController:imagePicker animated:YES completion:^{
    
  }];
}

#pragma mark - UIImagePickerController delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
  [picker dismissViewControllerAnimated:YES completion:^{
    [self.selfieImageView setImage:originalImage];
  }];
}

@end
