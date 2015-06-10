//
//  MJViewController.m
//  ParallaxImages
//
//  Created by Mayur on 4/1/14.
//  Copyright (c) 2014 sky. All rights reserved.
//

#import "MJRootViewController.h"
#import "MJCollectionViewCell.h"
#import "NewsParser.h"
#import "ATCTransitioningDelegate.h"
#import "ConstruktorForDetailView.h"
#import "DetailNewsViewController.h"


@interface MJRootViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, NewsParserDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *parallaxCollectionView;
@property (nonatomic, strong) NSMutableArray* images;
@property (nonatomic, strong) NewsParser* news;
@property (nonatomic, strong) ATCTransitioningDelegate *atcTransitioningDelegate;


@end

@implementation MJRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.news = [[NewsParser alloc] initWithDelegate:self];
    self.news.view = self.view;
    [self.news getNewsFromWall:AVIA_FACTS_GROUP];

    
	// Do any additional setup after loading the view, typically from a nib.
    
    // Fill image array with images
//    NSUInteger index;
//    for (index = 0; index < 14; ++index) {
//        // Setup image name
//        NSString *name = [NSString stringWithFormat:@"image%03ld.jpg", (unsigned long)index];
//        if(!self.images)
//            self.images = [NSMutableArray arrayWithCapacity:0];
//        [self.images addObject:name];
//    }
    
//    [self.parallaxCollectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - NewsParserDelegate

- (void) newsParsed: (NewsParser *) parser NewsArray: (NSMutableArray *) array {
    
//    NSLog(@"newsParsed array %@", array);
    
    self.images = [[NSMutableArray alloc] initWithArray:array];
    [self.parallaxCollectionView reloadData];
}




#pragma mark - UICollectionViewDatasource Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MJCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MJCell" forIndexPath:indexPath];
    
    //get image name and assign
    UIImage* image = [[self.images objectAtIndex:indexPath.item]objectForKey:DETAIL_IMAGE];
    cell.image = image;
    cell.labelTextNews.text = [[self.images objectAtIndex:indexPath.item]objectForKey:DETAIL_TEXT];
//    NSLog(@"cell.labelTextNews.text %@", cell.labelTextNews.text);
    //set offset accordingly
    CGFloat yOffset = ((self.parallaxCollectionView.contentOffset.y - cell.frame.origin.y) / IMAGE_HEIGHT) * IMAGE_OFFSET_SPEED;
    cell.imageOffset = CGPointMake(0.0f, yOffset);

    return cell;
}

#pragma mark - UICollectionViewDelegate


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.atcTransitioningDelegate = [[ATCTransitioningDelegate alloc] initWithPresentationTransition:ATCTransitionAnimationTypeBounce
                                                                                 dismissalTransition:ATCTransitionAnimationTypeBounce
                                                                                           direction:ATCTransitionAnimationDirectionBottom
                                                                                            duration:0.7];
    
    
    DetailNewsViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailNews"];
    UIImage * image = [[self.images objectAtIndex:indexPath.row] valueForKey:DETAIL_IMAGE];
    NSString * textNews = [[self.images objectAtIndex:indexPath.row] valueForKey:DETAIL_TEXT];
    
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.transitioningDelegate = self.atcTransitioningDelegate;
    UIView * newsView = [ConstruktorForDetailView getViewDetailNews:image Text:textNews];
    
    controller.viewN = newsView;
    
    
    [self presentViewController:controller animated:YES completion:nil];
    
    
}


#pragma mark - UIScrollViewdelegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    for(MJCollectionViewCell *view in self.parallaxCollectionView.visibleCells) {
        CGFloat yOffset = ((self.parallaxCollectionView.contentOffset.y - view.frame.origin.y) / IMAGE_HEIGHT) * IMAGE_OFFSET_SPEED;
        view.imageOffset = CGPointMake(0.0f, yOffset);
    }
}

@end
