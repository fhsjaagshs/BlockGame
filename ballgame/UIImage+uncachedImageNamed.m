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
    NSString *name = nil;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if ([[UIScreen mainScreen]scale] == 2) {
            name = [imageName stringByAppendingString:@"~iPad@2x"];
            if ([[NSBundle mainBundle]pathForResource:name ofType:@"png"].length == 0) {
                name = [imageName stringByAppendingString:@"-iPad@2x"];
                
                if ([[NSBundle mainBundle]pathForResource:name ofType:@"png"].length == 0) {
                    name = [imageName stringByAppendingString:@"~iPad"];
                    if ([[NSBundle mainBundle]pathForResource:name ofType:@"png"].length == 0) {
                        name = [imageName stringByAppendingString:@"-iPad"];
                        if ([[NSBundle mainBundle]pathForResource:name ofType:@"png"].length == 0) {
                            name = imageName;
                        }
                    }
                }
            }
        } else {
            name = [imageName stringByAppendingString:@"~iPad"];
            if ([[NSBundle mainBundle]pathForResource:name ofType:@"png"].length == 0) {
                name = [imageName stringByAppendingString:@"-iPad"];
                
                if ([[NSBundle mainBundle]pathForResource:name ofType:@"png"].length == 0) {
                    name = imageName;
                }
            }
        }
    } else {
        if ([[UIScreen mainScreen]scale] == 2) {
            if ([[UIScreen mainScreen]bounds].size.height*2 >= 1136) {
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
                if ([[NSBundle mainBundle]pathForResource:name ofType:@"png"].length == 0) {
                    name = imageName;
                }
            }
        } else {
            name = imageName;
        }
    }
    
    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:name ofType:@"png"]];
}

@end
