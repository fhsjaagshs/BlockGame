//
//  targetView.m
//  ballgame
//
//  Created by Nathaniel Symer on 11/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "targetView.h"

@implementation targetView

@synthesize namingString, targetImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)targetViewForNamingString:(NSString* )targetString {
    //get the number of target views
}

- (void)finalizeImage {
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.frame];
    [imageView setImage:targetImage];
    [imageView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:imageView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
