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
    
    self.title = @"Top Stories";
    NSString *path = [[NSBundle mainBundle] pathForResource:@"chart_story" ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSError *error;
    chartStoryList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    [self.storyTableView reloadData];
    // Do any additional setup after loading the view.
}
#pragma mark - UITableview Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [chartStoryList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StoryTableViewCell *cell = (StoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    int cnt = indexPath.row+1;
    cell.numberLabel.text = [NSString stringWithFormat:@"%d",cnt];
    NSDictionary *dic;
    
    dic = [chartStoryList objectAtIndex:indexPath.row];
    cell.titleLabel.text = [dic objectForKey:@"title"];
    cell.outletLabel.text = [dic objectForKey:@"outlet"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        
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
