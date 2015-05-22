//
//  ViewController.m
//  MAKS
//
//  Created by Lowtrack on 13.05.15.
//  Copyright (c) 2015 Vladimir Popov. All rights reserved.
//

#import "ViewController.h"
#import "NewsParser.h"
#import "NewsTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "SizeCell.h"
#import "UIScrollView+AH3DPullRefresh.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray * arrayViews;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getArrayNews:) name:ArrayNews object:nil];

    NewsParser * news = [NewsParser new];
    news.view = self.view;
    [news api_wall_your_future];
    

    [self.tableView setPullToRefreshHandler:^{
        
        [self test1];

    }];
    
    // Set the pull to laod more handler block
    [self.tableView setPullToLoadMoreHandler:^{
        


        [self test2];
    }];

     
}

- (void) test2 {
    
    NSLog(@"test2");
    
    [self.tableView loadMoreFinished];
    
}

- (void) test1 {
    
    NSLog(@"test1");
    
    [self.tableView refreshFinished];

}

- (void) dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void) getArrayNews: (NSNotification *) notification {
    
    self.arrayViews = [[NSMutableArray alloc] initWithArray:[notification.userInfo objectForKey:@"array"]];
//    NSLog(@"arrayViews %@", self.arrayViews);

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{    //back on main thread
                                          
                                          [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                                          
                                          
                                      });});

    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayViews.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    NewsTableViewCell *cell = (NewsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    for(UIView *view in cell.contentView.subviews){
        if ([view isKindOfClass:[UIView class]]) {
            [view removeFromSuperview];
        }
    }
    
    cell.clipsToBounds = YES;
    [cell.contentView addSubview:[self.arrayViews objectAtIndex:indexPath.row]];


    
//    cell.heightImage = [[self.arrayViews objectAtIndex:indexPath.row] valueForKey:@"height"];
//    cell.widthImage = [[self.arrayViews objectAtIndex:indexPath.row] valueForKey:@"width"];
//    cell.string_NewsText = [[self.arrayViews objectAtIndex:indexPath.row] valueForKey:@"news_text"];
//    cell.string_Link = [[self.arrayViews objectAtIndex:indexPath.row] valueForKey:@"link"];
//
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [cell setup_News_View];
//    });

    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    
//    CGFloat heightText = [SizeCell heightForText:self.view Text:[[self.arrayViews objectAtIndex:indexPath.row] valueForKey:@"news_text"]];
//    
//    return [SizeCell getSize:self.view Width:[[[self.arrayViews objectAtIndex:indexPath.row] valueForKey:@"width"]floatValue ]Height:[[[self.arrayViews objectAtIndex:indexPath.row] valueForKey:@"width"]floatValue]] + heightText;
    
    UIView * cellView = [self.arrayViews objectAtIndex:indexPath.row];
    
    return cellView.bounds.size.height;
    
//    return 1000;
}



@end
