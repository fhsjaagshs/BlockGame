//
//  ImageCache.h
//  ballgame
//
//  Created by Nathaniel Symer on 5/17/13.
//  Copyright (c) 2013 Nathaniel Symer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageCache : NSMutableDictionary

+ (ImageCache *)sharedInstance;

@end
