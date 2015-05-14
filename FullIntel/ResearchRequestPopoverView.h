//
//  ResearchRequestPopoverView.h
//  FullIntel
//
//  Created by Arul on 3/20/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResearchRequestPopoverView : UIViewController
@property (nonatomic,strong) NSString *articleId;
- (IBAction)send:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *articleDesc;
@property (nonatomic,strong) NSString *articleTitle;
@end
