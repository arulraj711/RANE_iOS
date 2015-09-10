//
//  MailPopoverView.m
//  FullIntel
//
//  Created by Arul on 3/20/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "MailPopoverView.h"
#import "FIUtils.h"
#import "FISharedResources.h"
#import "UIView+Toast.h"

@interface MailPopoverView ()

@end

@implementation MailPopoverView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.mailTitleLabel.text = self.mailSubject;
    self.subjectTextField.text = self.mailSubject;
    self.mailBodyTextView.text = self.mailBody;
    self.toAddressTextField.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"customerEmail"];
    
//    self.outerView.layer.masksToBounds = YES;
//    self.outerView.layer.cornerRadius = 10.0f;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
    [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"CloseMailView"];
}


- (IBAction)sendButtonClick:(id)sender {
    
    if(self.toAddressTextField.text.length != 0){
        NSArray *toAddressArray = [self.toAddressTextField.text componentsSeparatedByString:@","];
        NSLog(@"comma sep array:%d",toAddressArray.count);
        BOOL validateToAddressField = YES;
        if(toAddressArray.count > 1){
            for(NSString *toAddressString in toAddressArray){
                if([FIUtils NSStringIsValidEmail:toAddressString]){
                    validateToAddressField = YES;
                } else {
                    validateToAddressField = NO;
                    return;
                }
            }
        } else {
            validateToAddressField = [FIUtils NSStringIsValidEmail:self.toAddressTextField.text];
        }
        
        
        if(validateToAddressField){
            NSMutableDictionary *gradedetails = [[NSMutableDictionary alloc] init];
            
            [gradedetails setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"customerEmail"] forKey:@"from"];
            [gradedetails setObject:self.toAddressTextField.text forKey:@"to"];
            [gradedetails setObject:@"" forKey:@"cc"];
            [gradedetails setObject:self.subjectTextField.text forKey:@"subject"];
            [gradedetails setObject:self.mailBodyTextView.text forKey:@"mailBody"];
            NSData *jsondata = [NSJSONSerialization dataWithJSONObject:gradedetails options:NSJSONWritingPrettyPrinted error:nil];
            
            NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
            NSLog(@"mail jsoin:%@",resultStr);
            [[FISharedResources sharedResourceManager]sendMailWithAccessToken:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] withDetails:resultStr];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.view makeToast:@"Please check the email address." duration:1 position:CSToastPositionCenter];
        }
    } else {
        [self.view makeToast:@"Please enter a email address." duration:1 position:CSToastPositionCenter];
    }
}

#pragma mark - mail compose delegate
-(void)mailComposeController:(MFMailComposeViewController *)controller
         didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (result) {
       // NSLog(@"Result : %d",result);
    }
    if (error) {
       // NSLog(@"Error : %@",error);
    }
    //[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
