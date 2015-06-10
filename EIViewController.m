//
//  EIViewController.m
//  WaterfallCollectionView
//
//  Created by Miroslaw Stanek on 12.07.2013.
//  Copyright (c) 2013 Event Info Ltd. All rights reserved.
//

#import "EIViewController.h"
#import "FRGWaterfallCollectionViewCell.h"
#import "FRGWaterfallCollectionViewLayout.h"
#import "FRGWaterfallHeaderReusableView.h"
#import "NSString+HTML.h"
#import "MWFeedParser.h"
#import "DetailNewsViewController.h"
#import "ATCTransitioningDelegate.h"
#import "ConstruktorForDetailView.h"

static NSString* const WaterfallCellIdentifier = @"WaterfallCell";
static NSString* const WaterfallHeaderIdentifier = @"WaterfallHeader";

#define CELL_VIEW @"cellView"


#define SIZE_FONT_FOR_CELL 15
#define CELL_VIEW_TAG 50




@interface EIViewController () <FRGWaterfallCollectionViewDelegate, UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *cellViews;
@property (nonatomic, strong) ATCTransitioningDelegate *atcTransitioningDelegate;

@end

@implementation EIViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.cv.delegate = self;

    
    FRGWaterfallCollectionViewLayout *cvLayout = [[FRGWaterfallCollectionViewLayout alloc] init];
    cvLayout.delegate = self;
    cvLayout.itemWidth = [self getWithCell];
    cvLayout.topInset = 0.0f;
    cvLayout.bottomInset = 10.0f;
    cvLayout.stickyHeader = YES;

    [self.cv setCollectionViewLayout:cvLayout];
    
    //откатываем frame_CollectionView выше
    
    CGRect frame_CollectionView = [self.cv frame];
    frame_CollectionView.origin.y = frame_CollectionView.origin.y - 400;
    self.cv.frame = frame_CollectionView;
    self.cv.alpha = 0;

    //подписываемся на нотификации
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideCollView) name:NEWS_IS_HIDEN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCollView) name:NEWS_IS_NOT_HIDEN object:nil];

    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    parsedItems = [[NSMutableArray alloc] init];
    self.itemsToDisplay = [NSArray array];
    
    NSURL *feedURL = [NSURL URLWithString:AVIAPORT_DIGEST];
    
    feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
    feedParser.delegate = self;
    feedParser.feedParseType = ParseTypeFull; // Parse feed info and all items
    feedParser.connectionType = ConnectionTypeAsynchronously;
    [feedParser parse];
    
    
    
    
}



- (void) dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [[self.cv collectionViewLayout] invalidateLayout];
}

//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//

- (void)updateTableWithParsedItems {
    self.itemsToDisplay = [parsedItems sortedArrayUsingDescriptors:
                           [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"date"
             
                                                                                ascending:NO]]];
    
    self.cellViews = [[NSMutableArray alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
    for (int i = 0; i < self.itemsToDisplay.count; i++) {
        
        
        dispatch_async(dispatch_get_main_queue(), ^{

        NSString * strCurrentPoint = [NSString stringWithFormat:@"%i", i];
        NSString * strTotalPoints = [NSString stringWithFormat:@"%lu", (unsigned long)self.itemsToDisplay.count];
        
        
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                               strCurrentPoint, @"ProgressPoint",
                               strTotalPoints, @"TotalPoints",nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:PROGRESS_UPDATE object:nil userInfo:dict];
            
        });
        
//        [NSThread sleepForTimeInterval:0.17];
        
        MWFeedItem *item = [self.itemsToDisplay objectAtIndex:i];
        NSString * newsTitle = item.title;
        NSString * news_Text = [item.summary stringByConvertingHTMLToPlainText];
        NSString * newsText = [news_Text stringByReplacingOccurrencesOfString:@", Новость:" withString:@":"];
        newsText = [newsText stringByReplacingOccurrencesOfString:@", Пресс-релиз:" withString:@":"];
        newsText = [newsText stringByReplacingOccurrencesOfString:@", Статья:" withString:@":"];


        NSString* linkString = [[item.summary componentsSeparatedByString:@"src=\""] lastObject];
        linkString = [[linkString componentsSeparatedByString:@"\" "] firstObject];
        NSString * height = [[item.summary componentsSeparatedByString:@"height=\""] lastObject];
        height = [[height componentsSeparatedByString:@"\" "] firstObject];
        NSString * width = [[item.summary componentsSeparatedByString:@"width=\""] lastObject];
        width = [[width componentsSeparatedByString:@"\" "] firstObject];
        NSURL * url = [NSURL URLWithString:linkString];
        
        if (url) {
            
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *img = [[UIImage alloc] initWithData:data];
            CGFloat targetWidth = [self getWithCell];
            
            CGFloat scaleFactor = targetWidth / img.size.width;
            CGFloat targetHeight = img.size.height * scaleFactor;
            CGSize targetSize = CGSizeMake(targetWidth, targetHeight);
            
            UIImage *scaledImage = [img resizedImage:targetSize interpolationQuality:kCGInterpolationHigh];
            
            
            
            CGFloat scaleFactorDetailImage = (self.view.frame.size.width - 20.0f)/ img.size.width;
            CGFloat targetHeightDetailImage = img.size.height * scaleFactorDetailImage;
            CGSize targetDetailImageSize = CGSizeMake((self.view.frame.size.width - 20.0f), targetHeightDetailImage);
            UIImage * resizingDetailImage = [img resizedImage:targetDetailImageSize interpolationQuality:kCGInterpolationHigh];;
            
            
            NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   [self getViewForCell:scaledImage Text:newsTitle], CELL_VIEW,
                                   resizingDetailImage, DETAIL_IMAGE,
                                   newsText, DETAIL_TEXT, nil];
            
            [self.cellViews addObject:dict];
            

        }
        
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
            
                CGFloat textHight = [UITextView heightForText:newsTitle View:[[UIView alloc]initWithFrame:CGRectMake(0, 0, [self getWithCell], 10) ] Font:[UIFont fontWithName:MAIN_FONT_LIGHT size:SIZE_FONT_FOR_CELL]];
                CGFloat withCell = [self getWithCell];
                
                UIView * view_Cell = [[UIView alloc] initWithFrame:CGRectMake(0, 0, withCell, textHight)];
                view_Cell.backgroundColor = [UIColor whiteColor];

                
                UITextView * textView_News = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, withCell, textHight)];
                textView_News.text = newsTitle;
                textView_News.font = [UIFont fontWithName:MAIN_FONT_LIGHT size:SIZE_FONT_FOR_CELL];
                textView_News.userInteractionEnabled = NO;
                
                [view_Cell addSubview:textView_News];
                

                 NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   view_Cell, CELL_VIEW,
                                   newsText, DETAIL_TEXT, nil];
                
                [self.cellViews addObject:dict];

            });


        }

       dispatch_async(dispatch_get_main_queue(), ^{

        
        if (self.cellViews.count == self.itemsToDisplay.count) {
            
            NSString * strCurrentPoint = [NSString stringWithFormat:@"%lu", (unsigned long)self.cellViews.count];
            NSString * strTotalPoints = [NSString stringWithFormat:@"%lu", (unsigned long)self.itemsToDisplay.count];
            
            
            NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   strCurrentPoint, @"ProgressPoint",
                                   strTotalPoints, @"TotalPoints",nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:PROGRESS_UPDATE object:nil userInfo:dict];
            
            [self.cv reloadData];

            [[NSNotificationCenter defaultCenter] postNotificationName:NEWS_IS_LOADED object:nil];
            

            [UIView animateWithDuration:0.4 delay:0.4 usingSpringWithDamping:0.7 initialSpringVelocity:0.1 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
                
                CGRect frame_CollectionView = [self.cv frame];
                frame_CollectionView.origin.y = frame_CollectionView.origin.y + 400;
                self.cv.frame = frame_CollectionView;
                self.cv.alpha = 1;
                
                
            } completion:^(BOOL finished) {

                
            }];
        }
            
            });

    
    }
    
    });


}

//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//


#pragma mark -
#pragma mark MWFeedParserDelegate

- (void)feedParserDidStart:(MWFeedParser *)parser {
//    NSLog(@"Started Parsing: %@", parser.url);
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
//    NSLog(@"Parsed Feed Info: “%@”", parser);
    self.title = info.summary;
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
//    NSLog(@"Parsed Feed Item: “%@”", item.summary);
    if (item) [parsedItems addObject:item];
}

- (void)feedParserDidFinish:(MWFeedParser *)parser {
    NSLog(@"Finished Parsing%@", (parser.stopped ? @" (Stopped)" : @""));
    [self updateTableWithParsedItems];
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
    NSLog(@"Finished Parsing With Error: %@", error);
    if (parsedItems.count == 0) {
        self.title = @"Failed"; // Show failed message in title
    } else {
        // Failed but some items parsed, so show and inform of error
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Parsing Incomplete"
                                                        message:@"There was an error during the parsing of this feed. Not all of the feed items could parsed."
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
    }
    [self updateTableWithParsedItems];
}


//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.cellViews.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FRGWaterfallCollectionViewCell *waterfallCell = [collectionView dequeueReusableCellWithReuseIdentifier:WaterfallCellIdentifier
                                                                                             forIndexPath:indexPath];
    waterfallCell.alpha = 0;

    UIView * cellView = [[self.cellViews objectAtIndex:indexPath.row] valueForKey:CELL_VIEW];
    [waterfallCell.contentView addSubview:cellView];
    

    
    CATransition *transitionAnimationPin = [CATransition animation];
    [transitionAnimationPin setType:kCATransitionFade];
//    [transitionAnimationPin setSubtype:kCATransitionFromLeft];
    [transitionAnimationPin setDuration:0.3];
    [transitionAnimationPin setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [transitionAnimationPin setFillMode:kCAFillModeForwards];
    [waterfallCell.layer addAnimation:transitionAnimationPin forKey:@"FromRightAnimation"];
    waterfallCell.alpha = 1;
    
    
    return waterfallCell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(FRGWaterfallCollectionViewLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UIView * cellView = [[self.cellViews objectAtIndex:indexPath.row] valueForKey:CELL_VIEW];
    
    
    return cellView.bounds.size.height;
}

#pragma mark - UICollectionViewDelegate


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
        
    self.atcTransitioningDelegate = [[ATCTransitioningDelegate alloc] initWithPresentationTransition:ATCTransitionAnimationTypeBounce
                                                                                 dismissalTransition:ATCTransitionAnimationTypeBounce
                                                                                           direction:ATCTransitionAnimationDirectionBottom
                                                                                            duration:0.7];
    
    
    DetailNewsViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailNews"];
    UIImage * image = [[self.cellViews objectAtIndex:indexPath.row] valueForKey:DETAIL_IMAGE];
    NSString * textNews = [[self.cellViews objectAtIndex:indexPath.row] valueForKey:DETAIL_TEXT];

    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.transitioningDelegate = self.atcTransitioningDelegate;
    UIView * newsView = [ConstruktorForDetailView getViewDetailNews:image Text:textNews];

    controller.viewN = newsView;
    
    
    [self presentViewController:controller animated:YES completion:nil];
    
    
}


- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    

}




//- (CGFloat)collectionView:(UICollectionView *)collectionView
//                   layout:(FRGWaterfallCollectionViewLayout *)collectionViewLayout
//heightForHeaderAtIndexPath:(NSIndexPath *)indexPath {
//    return (indexPath.section + 1) * 26.0f;
//}



//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
//           viewForSupplementaryElementOfKind:(NSString *)kind
//                                 atIndexPath:(NSIndexPath *)indexPath; {
////    FRGWaterfallHeaderReusableView *titleView =
////    [collectionView dequeueReusableSupplementaryViewOfKind:kind
////                                       withReuseIdentifier:WaterfallHeaderIdentifier
////                                              forIndexPath:indexPath];
////    titleView.lblTitle.text = [NSString stringWithFormat: @"Section %d", indexPath.section];
//    return titleView;
//}








#pragma mark - Constructor View for cell



- (UIView *) getViewForCell : (UIImage *) image Text: (NSString *) text {

    CGFloat textHight = [UITextView heightForText:text View:[[UIView alloc]initWithFrame:CGRectMake(0, 0, [self getWithCell], 10) ] Font:[UIFont fontWithName:MAIN_FONT_LIGHT size:SIZE_FONT_FOR_CELL]];
    CGFloat withCell = [self getWithCell];
   __block UIView * view_Cell = [[UIView alloc] initWithFrame:CGRectMake(0, 0, withCell, image.size.height + textHight)];

    dispatch_async(dispatch_get_main_queue(), ^{
        
    view_Cell.backgroundColor = [UIColor whiteColor];
    view_Cell.tag = CELL_VIEW_TAG;
    
    UIImageView* iimage_News = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, withCell, image.size.height)];
    iimage_News.image = image;
    
    UITextView * textView_News = [[UITextView alloc]initWithFrame:CGRectMake(0, image.size.height, withCell, textHight)];
    textView_News.text = text;
    textView_News.font = [UIFont fontWithName:MAIN_FONT_LIGHT size:SIZE_FONT_FOR_CELL];
    textView_News.userInteractionEnabled = NO;
    textView_News.backgroundColor = [UIColor clearColor];

    [view_Cell addSubview:iimage_News];
    [view_Cell addSubview:textView_News];
        

    });

    return view_Cell;

}



- (CGFloat) getWithCell  {
    CGFloat resultWidthCell = 0;
    CGSize result = [[UIScreen mainScreen] bounds].size;
    if(result.height == 480)
    {
        resultWidthCell = 140.0f;
    }
    else if(result.height == 568)
    {
        resultWidthCell = 140.0f;
    }
    else if (result.height == 667) {
        resultWidthCell = 160.0f;
    }
    else if (result.height == 736) {
        resultWidthCell = 170.0f;
    }
    else if (result.height > 736) {
        
    }
    return resultWidthCell;
}



- (UIImage *) resizing_Image: (UIImage *) image height: (CGFloat) height width: (CGFloat) width {
    
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = width/height;
    
    if(imgRatio!=maxRatio){
        if(imgRatio < maxRatio){
            imgRatio = height / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = height;
        }
        else{
            imgRatio = width / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = width;
        }
    }
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}



#pragma mark - Collection View Animations 


- (void) hideCollView {
    
    CGRect frame_Other = [self.cv frame];
    frame_Other.origin.y = frame_Other.origin.y - 400;
    self.cv.frame = frame_Other;
//    self.cv.alpha = 1;
    
}


- (void) showCollView {
    
    [UIView animateWithDuration:0.3 delay:0.20 usingSpringWithDamping:0.8 initialSpringVelocity:0.3 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        CGRect frame_Other = [self.cv frame];
        frame_Other.origin.y = frame_Other.origin.y + 400;
        self.cv.frame = frame_Other;
        
    } completion:^(BOOL finished) {

    }];
}




@end
