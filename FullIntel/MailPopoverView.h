//
//  MailPopoverView.h
//  FullIntel
//
//  Created by Arul on 3/20/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface MailPopoverView : UIViewController<MFMailComposeViewControllerDelegate>{
    MFMailComposeViewController *mailComposer;
}
@property (nonatomic,strong) NSString *mailSubject;
@property (nonatomic,strong) NSString *mailBody;
@property(nonatomic,strong) NSString *articleId;

@property (nonatomic,strong) IBOutlet UILabel *mailTitleLabel;
@property (nonatomic,strong) IBOutlet UITextField *toAddressTextField;
@property (nonatomic,strong) IBOutlet UITextField *ccAddressTextField;
@property (nonatomic,strong) IBOutlet UITextField *subjectTextField;
@property (nonatomic,strong) IBOutlet UITextView *mailBodyTextView;
@property (nonatomic,strong) IBOutlet UIView *outerView;

- (IBAction)sendButtonClick:(id)sender;
- (IBAction)cancelAction:(id)sender;

@end
