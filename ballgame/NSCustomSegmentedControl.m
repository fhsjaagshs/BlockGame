//
//  NSCustomSegmentedControl.m
//  ballgame
//
//  Created by Nathaniel Symer on 5/28/13.
//  Copyright (c) 2013 Nathaniel Symer. All rights reserved.
//

#import "NSCustomSegmentedControl.h"

@implementation NSCustomSegmentedControl

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
                    label.font = [UIFont boldSystemFontOfSize:15];
                } else {
                    label.font = [UIFont boldSystemFontOfSize:12];
                }
            }
        }
    }
}

@end
