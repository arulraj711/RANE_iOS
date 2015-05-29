//
//  SavedListPopoverView.m
//  FullIntel
//
//  Created by Arul on 3/20/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "SavedListPopoverView.h"
#import "SavedListCell.h"

@interface SavedListPopoverView ()

@end

@implementation SavedListPopoverView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _savedListArray = [[NSMutableArray alloc]init];
    [_savedListArray addObject:@"Create New Folder"];
    [_savedListArray addObject:@"Watch Launch"];
    [_savedListArray addObject:@"Boston Outreach"];
    [_savedListArray addObject:@"Cool Articles"];
    [self.savedListTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return self.savedListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SavedListCell *cell = (SavedListCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.name.text = [_savedListArray objectAtIndex:indexPath.row];
    return cell;
}

@end
