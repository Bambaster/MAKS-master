//
//  SizeCell.m
//  MAKS
//
//  Created by Lowtrack on 14.05.15.
//  Copyright (c) 2015 Vladimir Popov. All rights reserved.
//

#import "SizeCell.h"

@implementation SizeCell


+ (CGFloat) getSize: (UIView *) view Width:(CGFloat)width Height:(CGFloat) height {
    
    CGFloat prportion;
    CGFloat image_nuws_height;

    if (width > view.frame.size.width) {
        if (height > width) {
            prportion = height/width;
            image_nuws_height = view.frame.size.width * prportion;
        }
        else {
            prportion = width/height;
            image_nuws_height = view.frame.size.width / prportion;
            
        }
        
    }
    
    else {
        
        if (width < view.frame.size.width) {
            prportion = view.frame.size.width - width;
            image_nuws_height = height + prportion;
        }
        else  {
            image_nuws_height = height;
            
        }
        
    }

        return image_nuws_height;
}



+ (UIImage *) resizing_Image: (UIImage *) image height: (CGFloat) height width: (CGFloat) width {
    
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



+ (CGFloat) heightForText:(UIView *) view Text: (NSString*) text {
    
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
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(view.frame.size.width - 2 * offset, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:attributes
                                     context:nil];
    
    return CGRectGetHeight(rect) + 2 * offset;
}
@end
