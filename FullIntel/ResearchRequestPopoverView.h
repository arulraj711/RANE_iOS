//
//  ResearchRequestPopoverView.h
//  FullIntel
//
//  Created by Arul on 3/20/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResearchRequestPopoverView : UIViewController<UITextViewDelegate>
@property (nonatomic,strong) NSString *articleId;
@property (nonatomic,strong) NSString *articleUrl;
@property BOOL fromAddContent;
- (IBAction)send:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *articleDesc;
@property (nonatomic,strong) NSString *articleTitle;
@property (nonatomic,strong) IBOutlet UIView *outerView;
- (IBAction)closeAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *backImgeView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (nonatomic,strong) IBOutlet UILabel *titleText;
@end
