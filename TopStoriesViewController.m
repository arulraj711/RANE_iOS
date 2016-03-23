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
    articleIdArray =[_devices valueForKeyPath:@"id"];
    NSLog(@"%@",articleIdArray);
    self.title = @"Top Stories";
    // Do any additional setup after loading the view.
}
-(void)viewDidDisappear:(BOOL)animated{

}

#pragma mark - UITableview Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_devices count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StoryTableViewCell *cell = (StoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    int cnt = indexPath.row+1;
    cell.numberLabel.text = [NSString stringWithFormat:@"%d",cnt];
    NSDictionary *dic;
    
    dic = [_devices objectAtIndex:indexPath.row];
    cell.titleLabel.text = NULL_TO_NIL([dic objectForKey:@"heading"]);
    headingArray = NULL_TO_NIL([dic objectForKey:@"heading"]);
    //Fetching contact details
    NSString *contactName;
    NSArray *contactArray = NULL_TO_NIL([dic objectForKey:@"contact"]);
    if(contactArray.count != 0){
        NSDictionary *contactDic = [contactArray objectAtIndex:0];
        contactName = [NSString stringWithFormat:@"%@,",NULL_TO_NIL([contactDic objectForKey:@"name"])];
    } else {
        contactName = @"";
    }
    
    //Fetching outlet details
    NSString *outletName;
    NSArray *outletArray = NULL_TO_NIL([dic objectForKey:@"outlet"]);
    if(outletArray.count != 0){
        NSDictionary *outletDic = [outletArray objectAtIndex:0];
        outletName = [NSString stringWithFormat:@"%@",NULL_TO_NIL([outletDic objectForKey:@"name"])];
    } else {
        outletName = @"";
    }
    
    NSString *contactOutletString = [NSString stringWithFormat:@"%@%@",contactName,outletName];

    cell.outletLabel.text = contactOutletString;
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
    
    
    NSDictionary *dic;
    
    dic = [_devices objectAtIndex:indexPath.row];
    
    CorporateNewsDetailsView *testView;
    testView = [storyBoard instantiateViewControllerWithIdentifier:@"UpgradeView"];
    testView.forTopStories = [NSNumber numberWithInt:1];
   // testView.articleTitle = NULL_TO_NIL([dic objectForKey:@"heading"]);
    testView.currentIndex = indexPath.row;
    testView.selectedIndexPath = indexPath;
    testView.selectedNewsArticleId = [dic objectForKey:@"id"];
    // testView.articleIdFromSearchLst =[NSMutableArray arrayWithArray:articleIdArray];
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
