//
//  UIImage+uncachedImageNamed.m
//  ballgame
//
//  Created by Nathaniel Symer on 5/18/13.
//  Copyright (c) 2013 Nathaniel Symer. All rights reserved.
//

#import "UIImage+uncachedImageNamed.h"

@implementation UIImage (uncachedImageNamed)

+ (UIImage *)uncachedImageNamed:(NSString *)imageName {
    float scale = [[UIScreen mainScreen]scale];
    NSString *name = nil;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (scale == 2) {
            name = [imageName stringByAppendingString:@"~iPad@2x"];
            if ([[NSBundle mainBundle]pathForResource:name ofType:@"png"].length == 0) {
                name = [imageName stringByAppendingString:@"-iPad@2x"];
            }
        } else {
            name = [imageName stringByAppendingString:@"~iPad"];
            if ([[NSBundle mainBundle]pathForResource:name ofType:@"png"].length == 0) {
                name = [imageName stringByAppendingString:@"-iPad"];
            }
        }
    } else {
        if (scale == 2) {
            if ([[UIScreen mainScreen]bounds].size.height*scale >= 1136) {
                name = [imageName stringByAppendingString:@"-568h@2x"];
                if ([[NSBundle mainBundle]pathForResource:name ofType:@"png"].length == 0) {
                    
                    name = [imageName stringByAppendingString:@"~568h@2x"];
                    
                    if ([[NSBundle mainBundle]pathForResource:name ofType:@"png"].length == 0) {
                        name = [imageName stringByAppendingString:@"@2x"];
                        if ([[NSBundle mainBundle]pathForResource:name ofType:@"png"].length == 0) {
                            name = imageName;
                        }
                    }
                }
            } else {
                name = [imageName stringByAppendingString:@"@2x"];
            }
        } else {
            name = imageName;
        }
    }
    
    NSString *path = [[NSBundle mainBundle]pathForResource:name ofType:@"png"];
    return [UIImage imageWithContentsOfFile:path];
}

@end
