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

@interface MJRootViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, NewsParserDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *parallaxCollectionView;
@property (nonatomic, strong) NSMutableArray* images;
@property (nonatomic, strong) NewsParser* news;


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

#pragma mark - UIScrollViewdelegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    for(MJCollectionViewCell *view in self.parallaxCollectionView.visibleCells) {
        CGFloat yOffset = ((self.parallaxCollectionView.contentOffset.y - view.frame.origin.y) / IMAGE_HEIGHT) * IMAGE_OFFSET_SPEED;
        view.imageOffset = CGPointMake(0.0f, yOffset);
    }
}

@end
