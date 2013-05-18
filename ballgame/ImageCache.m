//
//  ImageCache.m
//  ballgame
//
//  Created by Nathaniel Symer on 5/17/13.
//  Copyright (c) 2013 Nathaniel Symer. All rights reserved.
//

#import "ImageCache.h"

@implementation ImageCache

+ (ImageCache *)sharedInstance {
    static ImageCache *anImageCache;
    if (anImageCache) {
        anImageCache = [[ImageCache alloc]init];
    }
    return anImageCache;
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key {
    [self setObject:image forKey:key];
}

@end
