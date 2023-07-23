//
//  ImageUtils.h
//  RNSfActionSheet
//
//  Created by Gaauwe on 20/07/2023.
//  Copyright © 2023 Facebook. All rights reserved.
//

#ifndef ImageUtils_h
#define ImageUtils_h
#import <UIKit/UIKit.h>

@class ImageUtils;

@interface ImageUtils : UIImageView

@property (assign) BOOL multicolor;
@property (strong, nonatomic) NSString *weight;
@property (strong, nonatomic) NSString *scale;
@property (strong, nonatomic) NSNumber *size;
@property (strong, nonatomic) UIColor *iconColor;
@property (assign) UIViewContentMode resizeMode;
@property (strong, nonatomic) NSString *systemName;

-(void)updateImage;

@end

#endif /* ImageUtils_h */
