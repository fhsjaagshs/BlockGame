//
//  asdf.m
//  ballgame
//
//  Created by Nathaniel Symer on 5/20/13.
//  Copyright (c) 2013 Nathaniel Symer. All rights reserved.
//

#import "CGRectFunctions.h"

// one - "bigger"
// two - "Smaller"
BOOL CGRectCompletelyContainsRect(CGRect one, CGRect two) {
    float oneTotalX = one.origin.x+one.size.width;
    float twoTotalX = two.origin.x+two.size.width;
    float oneTotalY = one.origin.y+one.size.height;
    float twoTotalY = two.origin.y+two.size.height;
    BOOL widthContained = twoTotalX <= oneTotalX && twoTotalX >= one.origin.x;
    BOOL heightContained = twoTotalY <= oneTotalY && twoTotalY >= one.origin.y;
    return (widthContained && heightContained);
}
