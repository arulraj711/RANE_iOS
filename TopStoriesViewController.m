//
//  TopStoriesViewController.m
//  FullIntel
//
//  Created by cape start on 01/03/16.
//  Copyright © 2016 CapeStart. All rights reserved.
//

#import "TopStoriesViewController.h"

@interface TopStoriesViewController ()

@end

@implementation TopStoriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(afterFetchingTopStories:)
                                                 name:@"FetchedTopStoriesInfo"
                                               object:nil];
    
    self.title = @"Top Stories";
    // Do any additional setup after loading the view.
}
-(void)afterFetchingTopStories:(id)sender {
    
    NSNotification *notification = sender;
    reportObject = [[notification userInfo] objectForKey:@"TopStories"];
    
    headingArray = [reportObject valueForKey:@"heading"];
    
    NSArray *inameArrays = [reportObject valueForKeyPath:@"contact.name"];
    NSLog(@"%@",inameArrays);
    NSArray *flatArray = [inameArrays valueForKeyPath: @"@unionOfArrays.self"];
    NSLog(@"%@",flatArray);
    
    nameArray = [NSArray arrayWithArray:flatArray];
    
    
    NSArray *iOutArrays = [reportObject valueForKeyPath:@"outlet.name"];
    NSLog(@"%@",iOutArrays);
    NSArray *iflatArray = [iOutArrays valueForKeyPath: @"@unionOfArrays.self"];
    NSLog(@"%@",iflatArray);
    


    outletArray = [NSArray arrayWithArray:iflatArray];
    
    articleIdArray =[reportObject valueForKeyPath:@"id"];

    
    
    NSLog(@"%@",nameArray);
    NSLog(@"%@",outletArray);
    NSLog(@"%@",headingArray);

    NSLog(@"%@",articleIdArray);

    [self.storyTableView reloadData];


}

#pragma mark - UITableview Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [headingArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StoryTableViewCell *cell = (StoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    int cnt = indexPath.row+1;
    cell.numberLabel.text = [NSString stringWithFormat:@"%d",cnt];
    NSDictionary *dic;
    
    cell.titleLabel.text = [headingArray objectAtIndex:indexPath.row];
    NSString *outletAndName = [NSString stringWithFormat:@"%@,%@",[nameArray objectAtIndex:indexPath.row],[outletArray objectAtIndex:indexPath.row]];
    cell.outletLabel.text = outletAndName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyBoard;
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        storyBoard = [UIStoryboard storyboardWithName:@"CorporateNewsListViewPhone" bundle:nil];
        
    } else {
        storyBoard = [UIStoryboard storyboardWithName:@"CorporateNewsListView" bundle:nil];
        
    }
    NSString *userAccountTypeId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"d"]];
    CorporateNewsDetailsView *testView;

    testView = [storyBoard instantiateViewControllerWithIdentifier:@"UpgradeView"];
    testView.forTopStories = 1;
    testView.articleTitle = [headingArray objectAtIndex:indexPath.row];
    testView.currentIndex = indexPath.row;
    testView.selectedIndexPath = indexPath;
    testView.articleIdFromSearchLst =[NSMutableArray arrayWithArray:articleIdArray];
    [self.navigationController pushViewController:testView animated:YES];


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

@end
