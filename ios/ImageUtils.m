//
//  ImageUtils.m
//  RNSfActionSheet
//
//  Created by Gaauwe on 20/07/2023.
//  Copyright © 2023 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageUtils.h"

@implementation ImageUtils

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)size {
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    } else {
        UIGraphicsBeginImageContext(size);
    }
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return newImage;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToMaxWidth:(CGFloat)width maxHeight:(CGFloat)height {
    CGFloat oldWidth = image.size.width;
    CGFloat oldHeight = image.size.height;

    CGFloat scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : height / oldHeight;

    CGFloat newHeight = oldHeight * scaleFactor;
    CGFloat newWidth = oldWidth * scaleFactor;
    CGSize newSize = CGSizeMake(newWidth, newHeight);

    return [ImageUtils imageWithImage:image scaledToSize:newSize];
}

- (void) updateImage {
  if (@available(iOS 13.0, *)) {
    UIImageSymbolWeight weight = UIImageSymbolWeightUnspecified;
    UIImageSymbolScale scale = UIImageSymbolScaleDefault;
    CGFloat size = [UIFont systemFontSize];
      
    if (_size != nil) {
      size = [_size doubleValue];
    }

    [self setContentMode:_resizeMode];
      
    if ([_weight isEqualToString:@"ultralight"]) {
      weight = UIImageSymbolWeightUltraLight;
    } else if ([_weight isEqualToString:@"light"]) {
      weight = UIImageSymbolWeightLight;
    } else if ([_weight isEqualToString:@"thin"]) {
      weight = UIImageSymbolWeightThin;
    } else if ([_weight isEqualToString:@"regular"]) {
      weight = UIImageSymbolWeightRegular;
    } else if ([_weight isEqualToString:@"medium"]) {
      weight = UIImageSymbolWeightMedium;
    } else if ([_weight isEqualToString:@"semibold"]) {
      weight = UIImageSymbolWeightSemibold;
    } else if ([_weight isEqualToString:@"bold"]) {
      weight = UIImageSymbolWeightBold;
    } else if ([_weight isEqualToString:@"heavy"]) {
      weight = UIImageSymbolWeightHeavy;
    }

    if ([_scale isEqualToString:@"small"]) {
      scale = UIImageSymbolScaleSmall;
    } else if ([_scale isEqualToString:@"medium"]) {
      scale = UIImageSymbolScaleMedium;
    } else if ([_scale isEqualToString:@"large"]) {
      scale = UIImageSymbolScaleLarge;
    }

    UIImageSymbolConfiguration *configuration = [UIImageSymbolConfiguration configurationWithPointSize:size weight:weight scale:scale];
    UIImage *baseImage = [UIImage systemImageNamed:_systemName withConfiguration:configuration];
      
    // TODO: Make dynamic based on icon size.
    // Some magic here to auto-scale the icon, since not all SF Symbols are the same 🪄
    CGSize newSize = CGSizeMake(34, 30);
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
      UIGraphicsBeginImageContextWithOptions(newSize, NO, [[UIScreen mainScreen] scale]);
    } else {
      UIGraphicsBeginImageContext(newSize);
    }
    float x_pos = (newSize.width - baseImage.size.width) / 2;
    float y_pos = (newSize.height - baseImage.size.height) /2;
    [baseImage drawAtPoint:CGPointMake(x_pos, y_pos) ];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    if (_multicolor) {
      self.tintColor = nil;
      if (_iconColor != nil) {
        self.image = [image imageWithTintColor:_iconColor renderingMode:UIImageRenderingModeAlwaysOriginal];
      } else {
        self.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
      }
    } else {
      self.tintColor = _iconColor;
      self.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
  }
}

@end
