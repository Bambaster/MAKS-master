//
//  MJCollectionViewCell.m
//  RCCPeakableImageSample
//
//  Created by Mayur on 4/1/14.
//  Copyright (c) 2014 RCCBox. All rights reserved.
//

#import "MJCollectionViewCell.h"

@interface MJCollectionViewCell()

@property (nonatomic, strong, readwrite) UIImageView *MJImageView;

@end

@implementation MJCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) [self setupImageView];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) [self setupImageView];
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - Setup Method
- (void)setupImageView
{
    

    
    // Clip subviews
    self.clipsToBounds = YES;
    
    // Add image subview
    self.MJImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, IMAGE_HEIGHT)];
    self.MJImageView.backgroundColor = [UIColor redColor];
    self.MJImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.MJImageView.clipsToBounds = NO;
    
    self.labelTextNews = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.origin.x + 5, self.bounds.origin.y + ((self.bounds.origin.y + self.bounds.size.height) -  60), self.bounds.size.width - 5, 60)];
    
    [self.labelTextNews.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.labelTextNews.layer setShadowOpacity:5.8];
    [self.labelTextNews.layer setShadowRadius:1.0];
    [self.labelTextNews.layer setShadowOffset:CGSizeMake(1.3, 1.3)];
    self.labelTextNews.textColor = [UIColor whiteColor];
    self.labelTextNews.numberOfLines = 2;
    self.labelTextNews.lineBreakMode = NSLineBreakByWordWrapping;


    self.labelTextNews.font = [UIFont fontWithName:@"OpenSans-Bold" size:17];

    
    [self addSubview:self.MJImageView];
    [self addSubview:self.labelTextNews];

}

# pragma mark - Setters

- (void)setImage:(UIImage *)image
{
    // Store image
    self.MJImageView.image = image;
    
    // Update padding
    [self setImageOffset:self.imageOffset];
}

- (void)setImageOffset:(CGPoint)imageOffset
{
    // Store padding value
    _imageOffset = imageOffset;
    
    // Grow image view
    CGRect frame = self.MJImageView.bounds;
    CGRect offsetFrame = CGRectOffset(frame, _imageOffset.x, _imageOffset.y);
    self.MJImageView.frame = offsetFrame;
}

@end
