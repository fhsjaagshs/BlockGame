//
//  NSCustomSegmentedControl.m
//  ballgame
//
//  Created by Nathaniel Symer on 5/28/13.
//  Copyright (c) 2013 Nathaniel Symer. All rights reserved.
//

#import "NSCustomSegmentedControl.h"

@implementation NSCustomSegmentedControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSString *titleSelected = [self titleForSegmentAtIndex:self.selectedSegmentIndex];
    for (UIView *view in self.subviews) {
        for (UIView *viewy in view.subviews) {
            if ([viewy isKindOfClass:NSClassFromString(@"UISegmentLabel")]) {
                viewy.frame = viewy.superview.bounds;
                NSString *title = [(UILabel *)viewy text];
                UILabel *label = (UILabel *)viewy;
                label.textAlignment = UITextAlignmentCenter;
                if ([titleSelected isEqualToString:title]) {
                    label.font = [UIFont boldSystemFontOfSize:14];
                } else {
                    label.font = [UIFont boldSystemFontOfSize:12];
                }
            }
        }
    }
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
