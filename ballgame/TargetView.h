//
//  TargetView.h
//  ballgame
//
//  Created by Nathaniel Symer on 4/9/13.
//
//

#import <UIKit/UIKit.h>

@interface TargetView : UIView

- (void)redrawWithBackgroundColor:(UIColor *)color vertically:(BOOL)vertically;
- (void)redrawVerticallyWithImage:(UIImage *)image;
- (void)redrawHorizontallyWithImage:(UIImage *)image;
- (void)setImageHidden:(BOOL)shouldHide;

@property (nonatomic, strong) UIImage *image;

@end
