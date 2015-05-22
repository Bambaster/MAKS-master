//
//  NewsTableViewCell.m
//  MAKS
//
//  Created by Lowtrack on 13.05.15.
//  Copyright (c) 2015 Vladimir Popov. All rights reserved.
//

#import "NewsTableViewCell.h"
#import "SizeCell.h"

@implementation NewsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void) setup_News_View {

   CGFloat image_nuws_height =  [SizeCell getSize:self.view Width:[self.widthImage floatValue] Height:[self.heightImage floatValue]];
    self.imageView_News = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, image_nuws_height)];
        
    self.textView_News = [[UITextView alloc]initWithFrame:CGRectMake(0, image_nuws_height, self.view.frame.size.width, [SizeCell heightForText:self.view Text:self.string_NewsText])];
    self.textView_News.userInteractionEnabled = NO;
    self.textView_News.text = self.string_NewsText;
    
//    [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:self.string_Link]
//                                                        options:0
//                                                       progress:nil                                                      completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
//     {
//         if (image && finished)
//         {
//             // do something with image
//             
//             dispatch_async(dispatch_get_main_queue(), ^{
//                 self.imageView_News.image = [SizeCell resizing_Image:image height:image_nuws_height width:self.view.frame.size.width];
//                 
//             });
//
//         }
//         
//         
//     }];
    
    
    [self.contentView addSubview:self.imageView_News];
    [self.contentView addSubview:self.textView_News];

}


- (CGFloat) heightForText:(NSString*) text {
    
    CGFloat offset = 5.0;
    
    UIFont* font = [UIFont systemFontOfSize:14];
    
    NSShadow* shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(0, -1);
    shadow.shadowBlurRadius = 0.5;
    
    NSMutableParagraphStyle* paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineBreakMode:NSLineBreakByWordWrapping];
    [paragraph setAlignment:NSTextAlignmentCenter];
    
    NSDictionary* attributes =
    [NSDictionary dictionaryWithObjectsAndKeys:
     font, NSFontAttributeName,
     paragraph, NSParagraphStyleAttributeName,
     shadow, NSShadowAttributeName, nil];
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(self.contentView.frame.size.width - 2 * offset, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:attributes
                                     context:nil];
    
    return CGRectGetHeight(rect) + 2 * offset;
}



- (UIImage *) resizing_Image: (UIImage *) image height: (CGFloat) height width: (CGFloat) width  {
    
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







@end
