//
//  CorporateNewsDetailsTest.m
//  FullIntel
//
//  Created by Capestart on 5/13/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "CorporateNewsDetailsTest.h"
#import "CorporateDetailCell.h"
#import "FISharedResources.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FIUtils.h"

@interface CorporateNewsDetailsTest ()

@end

@implementation CorporateNewsDetailsTest

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCuratedNewsDetails) name:@"CuratedNewsDetails" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCuratedNewsAuthorDetails) name:@"CuratedNewsAuthorDetails" object:nil];
    
    oneSecondTicker = [[NSTimer alloc] init];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    [self.collectionView setPagingEnabled:YES];
    [self.collectionView setCollectionViewLayout:flowLayout];
    [self.collectionView reloadData];
    
   // self.collectionView.contentOffset = CGPointMake(self.collectionView.frame.size.width*2, 0);
    
    
    [self getArticleIdListFromDB];
    
}

-(void)viewDidAppear:(BOOL)animated {
    CGSize currentSize = self.collectionView.bounds.size;
    float offset = self.currentIndex * currentSize.width;
    [self.collectionView setContentOffset:CGPointMake(offset, 0)];
    
}


-(void)loadCuratedNewsDetails {
    NSManagedObjectContext *managedObjectContext = [[FISharedResources sharedResourceManager]managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"articleId == %@",[self.articleIdArray objectAtIndex:self.selectedIndex]];
    [fetchRequest setPredicate:predicate];
    NSArray *newPerson =[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    if(newPerson.count != 0) {
        NSManagedObject *curatedNews = [newPerson objectAtIndex:0];
        curatedNewsDetail = [curatedNews valueForKey:@"details"];
    }
    [self.collectionView reloadData];
}

-(void)loadCuratedNewsAuthorDetails {
    NSManagedObjectContext *managedObjectContext = [[FISharedResources sharedResourceManager]managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"articleId == %@",[self.articleIdArray objectAtIndex:self.selectedIndex]];
    [fetchRequest setPredicate:predicate];
    NSArray *newPerson =[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSManagedObject *curatedNews;
    if(newPerson.count != 0) {
        curatedNews = [newPerson objectAtIndex:0];
        curatedNewsAuthorDetail = [curatedNews valueForKey:@"authorDetails"];
    }
    [self.collectionView reloadData];
}
-(void)getArticleIdListFromDB {
    //[oneSecondTicker invalidate];
    
    
    BOOL testFlag = [[NSUserDefaults standardUserDefaults]boolForKey:@"Test"];
    if(testFlag) {
        NSLog(@"test flag is TRUE");
        self.collectionView.scrollEnabled = YES;
        NSManagedObjectContext *context = [[FISharedResources sharedResourceManager]managedObjectContext];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"CuratedNews" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:nil];
        
        NSMutableArray *elementsFromColumn = [[NSMutableArray alloc] init];
        for (NSManagedObject *fetchedObject in fetchedObjects) {
            [elementsFromColumn addObject:[fetchedObject valueForKey:@"articleId"]];
        }
        
        NSLog(@"elementsfrom column:%@",elementsFromColumn);
        self.articleIdArray = [[NSMutableArray alloc]initWithArray:elementsFromColumn];
        NSLog(@"article id array:%@",self.articleIdArray);
        [self.collectionView reloadData];
        [self.activityIndicator stopAnimating];
        [oneSecondTicker invalidate];
    } else {
        NSLog(@"test flag is FALSE");
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.articleIdArray.count;
}




-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   // NSLog(@"cell indexpath:%@",indexPath);
    self.selectedIndex = indexPath.row;
    CorporateDetailCell *cell = (CorporateDetailCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    [cell.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];

    
    NSManagedObjectContext *managedObjectContext = [[FISharedResources sharedResourceManager]managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"articleId == %@",[self.articleIdArray objectAtIndex:indexPath.row]];
    [fetchRequest setPredicate:predicate];
    NSArray *newPerson =[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    if(newPerson.count != 0) {
        NSManagedObject *curatedNews = [newPerson objectAtIndex:0];
       // NSLog(@"selected curated news:%@",curatedNews);
        cell.articleTitle.text = [curatedNews valueForKey:@"title"];
        [cell.articleImageView sd_setImageWithURL:[NSURL URLWithString:[curatedNews valueForKey:@"image"]] placeholderImage:nil];
        [cell.articleImageView setContentMode:UIViewContentModeScaleAspectFill];
        cell.articleDate.text = [FIUtils getDateFromTimeStamp:[[curatedNews valueForKey:@"date"] doubleValue]];
        cell.articleOutlet.text = [curatedNews valueForKey:@"outlet"];
        
        NSSet *authorSet = [curatedNews valueForKey:@"author"];
        NSMutableArray *authorArray = [[NSMutableArray alloc]initWithArray:[authorSet allObjects]];
        NSManagedObject *authors;
        if(authorArray.count != 0) {
            authors = [authorArray objectAtIndex:0];
        }
        cell.articleAuthor.text = [authors valueForKey:@"name"];
        cell.authorName.text = [authors valueForKey:@"name"];
        cell.authorWorkTitle.text = [authors valueForKey:@"title"];
        [cell.authorImageView sd_setImageWithURL:[NSURL URLWithString:[authors valueForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"userIcon_150"]];
        [cell.authorImageView setContentMode:UIViewContentModeScaleAspectFill];
        
        curatedNewsDetail = [curatedNews valueForKey:@"details"];
        curatedNewsAuthorDetail = [curatedNews valueForKey:@"authorDetails"];
        if(curatedNewsDetail == nil) {
            // NSLog(@"details is null");
           
            [cell.articleWebview loadHTMLString:@"" baseURL:nil];
            NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
            [resultDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
            [resultDic setObject:[curatedNews valueForKey:@"articleId"] forKey:@"selectedArticleId"];
            NSData *jsondata = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:nil];
            
            NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
            [[FISharedResources sharedResourceManager]getCuratedNewsDetailsWithDetails:resultStr];
        } else {
            NSString *htmlString = [NSString stringWithFormat:@"<body style='color:#666e73;font-family:Open Sans;line-height: 1.7;font-size: 16px;font-weight: 310;'>%@",[curatedNewsDetail valueForKey:@"article"]];
            [cell.articleWebview loadHTMLString:htmlString baseURL:nil];
        }
        
        
        
        if(curatedNewsAuthorDetail == nil) {
            NSMutableDictionary *auhtorResultDic = [[NSMutableDictionary alloc] init];
            [auhtorResultDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
            [auhtorResultDic setObject:[curatedNews valueForKey:@"articleId"] forKey:@"articleId"];
            NSData *authorJsondata = [NSJSONSerialization dataWithJSONObject:auhtorResultDic options:NSJSONWritingPrettyPrinted error:nil];
            
            NSString *authorResultStr = [[NSString alloc]initWithData:authorJsondata encoding:NSUTF8StringEncoding];
            [[FISharedResources sharedResourceManager]getCuratedNewsAuthorDetailsWithDetails:authorResultStr withArticleId:[curatedNews valueForKey:@"articleId"]];
        } else {
            NSSet *authorSet = [curatedNewsAuthorDetail valueForKey:@"authorDetails"];
            NSMutableArray *legendsArray = [[NSMutableArray alloc]initWithArray:[authorSet allObjects]];
            NSManagedObject *author;
            if(legendsArray.count != 0) {
                author  = [legendsArray objectAtIndex:0];
            }
            self.socialLinksArray = [[NSMutableArray alloc]init];
            NSSet *socialLinkSet = [author valueForKey:@"authorSocialMedia"];
            self.socialLinksArray = [[NSMutableArray alloc]initWithArray:[socialLinkSet allObjects]];
            cell.socialLinksArray = self.socialLinksArray;
//            if(self.socialLinksArray.count == 0) {
//                self.socialLinkLabel.hidden = YES;
//                self.socialLinkDivider.hidden = YES;
//                self.socialLinkCollectionView.hidden = YES;
//            } else {
//                self.socialLinkLabel.hidden = NO;
//                self.socialLinkDivider.hidden = NO;
//                self.socialLinkCollectionView.hidden = NO;
//                self.socialLinkCollectionView.delegate = self;
//                self.socialLinkCollectionView.dataSource = self;
//                [self.socialLinkCollectionView reloadData];
//            }
//            NSString *authorName = [NSString stringWithFormat:@"%@ %@",[author valueForKey:@"firstName"],[author valueForKey:@"lastName"]];
//            self.aboutAuthorName.text = authorName;
//            self.bioLabel.text = [author valueForKey:@"bibliography"];
//            
//            if([[author valueForKey:@"isInfluencer"]isEqualToNumber:[NSNumber numberWithInt:1]]) {
//                self.influencerIconImage.hidden = NO;
//            } else {
//                self.influencerIconImage.hidden = YES;
//            }
//            
//            [self.aboutAuthorImageView sd_setImageWithURL:[NSURL URLWithString:[author valueForKey:@"imageURL"]] placeholderImage:[UIImage imageNamed:@"userIcon_150"]];
//            [self.aboutAuthorImageView setContentMode:UIViewContentModeScaleAspectFill];
//            
//            NSSet *workTitleSet = [author valueForKey:@"authorWorkTitle"];
//            NSMutableArray *workTitleArray = [[NSMutableArray alloc]initWithArray:[workTitleSet allObjects]];
//            if(workTitleArray.count != 0) {
//                NSManagedObject *workTitle = [workTitleArray objectAtIndex:0];
//                self.authorWorkTitleLabel.text = [workTitle valueForKey:@"title"];
//            } else {
//                self.authorWorkTitleImageView.hidden = YES;
//                self.workTitleHeightConstraint.constant = 0;
//                self.workTitleImageHeightConstraint.constant = 0;
//                self.workTitleTop.constant = 0;
//                self.workTitleLabelTop.constant = 0;
//            }
//            
//            NSSet *outletSet = [author valueForKey:@"authorOutlet"];
//            NSMutableArray *outletArray = [[NSMutableArray alloc]initWithArray:[outletSet allObjects]];
//            if(outletArray.count != 0) {
//                NSManagedObject *outlet = [outletArray objectAtIndex:0];
//                self.authorOutletName.text = [outlet valueForKey:@"outletname"];
//            }else {
//                self.authorOutletImageView.hidden = YES;
//                self.outletHeightConstraint.constant = 0;
//                self.outletImageViewHeightConstraint.constant = 0;
//                self.outletTop.constant = 0;
//                self.outletLabelTop.constant = 0;
//            }
//            if([[author valueForKey:@"starRating"] integerValue] == 0) {
//                self.ratingControl.hidden = YES;
//            } else {
//                self.ratingControl.hidden = NO;
//                self.starRating.rating = [[author valueForKey:@"starRating"] integerValue];
//            }
//            
//            
//            NSString *city = [author valueForKey:@"city"];
//            NSString *country = [author valueForKey:@"country"];
//            NSString *authorPlace;
//            if(city.length == 0) {
//                authorPlace = [NSString stringWithFormat:@"%@",country];
//            } else if(country.length == 0) {
//                authorPlace = [NSString stringWithFormat:@"%@",city];
//            } else {
//                authorPlace = [NSString stringWithFormat:@"%@, %@",city,country];
//            }
//            
//            
//            if(authorPlace.length !=0 ){
//                self.authorLocationLabel.text = authorPlace;
//            } else {
//                self.authorLocationImageView.hidden = YES;
//                self.locationImageViewHeightConstraint.constant = 0;
//                self.locationLabelHeightConstraint.constant = 0;
//                self.locationTop.constant = 0;
//                self.locationLabelTop.constant = 0;
//            }
//            NSSet *beatSet = [author valueForKey:@"authorBeat"];
//            NSMutableArray *beatsArray = [[NSMutableArray alloc]initWithArray:[beatSet allObjects]];
//            NSMutableArray *beats = [[NSMutableArray alloc]init];
//            for(NSManagedObject *beat in beatsArray) {
//                [beats addObject:[NSString stringWithFormat:@"#%@",[beat valueForKey:@"name"]]];
//            }
//            NSString *beatString = [beats componentsJoinedByString:@" "];
//            if(beatString.length != 0){
//                self.authorTagLabel.text = beatString;
//            } else {
//                self.authorTagImageView.hidden = YES;
//                self.tagImageViewHeightConstraint.constant = 0;
//                self.tagLabelHeightConstraint.constant = 0;
//                self.tagTop.constant = 0;
//                self.tagLabelTop.constant = 0;
//            }
        }
    }
    
    return cell;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.collectionView.frame.size;
}

#pragma mark -
#pragma mark Rotation handling methods

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:
(NSTimeInterval)duration {
    
    // Fade the collectionView out
    [self.collectionView setAlpha:0.0f];
    
    // Suppress the layout errors by invalidating the layout
    [self.collectionView.collectionViewLayout invalidateLayout];
    
    // Calculate the index of the item that the collectionView is currently displaying
    CGPoint currentOffset = [self.collectionView contentOffset];
    self.currentIndex = currentOffset.x / self.collectionView.frame.size.width;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    // Force realignment of cell being displayed
    CGSize currentSize = self.collectionView.bounds.size;
    float offset = self.currentIndex * currentSize.width;
    [self.collectionView setContentOffset:CGPointMake(offset, 0)];
    
    // Fade the collectionView back in
    [UIView animateWithDuration:0.125f animations:^{
        [self.collectionView setAlpha:1.0f];
    }];
    
}

-(void)scrollViewDidScroll: (UIScrollView*)scrollView
{
    int lastCount = self.articleIdArray.count-1;
    float scrollOffset = self.collectionView.contentOffset.x;
    //NSLog(@"scrollview offset:%f and collectionview width:%f",scrollOffset,self.collectionView.frame.size.width*lastCount);
    if(scrollOffset > self.collectionView.frame.size.width*lastCount) {
       // NSLog(@"reached end");
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.view addSubview:self.activityIndicator];
        self.activityIndicator.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
        [self.activityIndicator startAnimating];
        
        self.collectionView.scrollEnabled = NO;
        NSString *inputJson = [FIUtils createInputJsonForContentWithToekn:[[NSUserDefaults standardUserDefaults] valueForKey:@"accesstoken"] lastArticleId:[self.articleIdArray lastObject] contentTypeId:@"1" listSize:10 activityTypeId:@"" categoryId:[[NSUserDefaults standardUserDefaults] valueForKey:@"categoryId"]];
        [[FISharedResources sharedResourceManager]getCuratedNewsListWithAccessToken:inputJson withCategoryId:[[[NSUserDefaults standardUserDefaults] valueForKey:@"categoryId"] integerValue] withFlag:@""];
        oneSecondTicker = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self
                                       selector:@selector(getArticleIdListFromDB) userInfo:nil repeats:YES];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"Test"];
    }
}


@end
