//
//  NSCustomAlertView.m
//  ballgame
//
//  Created by Nathaniel Symer on 1/24/12.
//  Copyright (c) 2012 Nathaniel Symer. All rights reserved.
//

#import "NSCustomAlertView.h"

float UIAlertPosition = 0;

@implementation NSCustomAlertView

- (void)layoutSubviews {
    for (UIView *subview in self.subviews) {
        if ([subview isMemberOfClass:[UIImageView class]]) {
            subview.hidden = YES;
            continue;
        }
        
        if ([subview isKindOfClass:NSClassFromString(@"UIAlertButton")]) {
            UIAlertPosition = subview.frame.origin.y-10;
            continue;
        }
        
        if ([subview isMemberOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)subview;
            label.textColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0f];
            label.shadowColor = [UIColor blackColor];
            label.shadowOffset = CGSizeMake(0.0f, 1.0f);
            continue;
        }
    }
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect activeBounds = self.bounds;
    CGFloat cornerRadius = 10.0f;
    CGFloat inset = 7.0f;
    CGFloat originX = activeBounds.origin.x+inset;
    CGFloat originY = activeBounds.origin.y+inset;
    CGFloat width = activeBounds.size.width-(inset*2.0f);
    CGFloat height = activeBounds.size.height-(inset*2.0f);

    CGPathRef path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(originX, originY, width, height) cornerRadius:cornerRadius].CGPath;

    CGContextAddPath(context, path);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0f].CGColor);
    CGContextSetShadowWithColor(context, CGSizeMake(0.0f, 1.0f), 6.0f, [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f].CGColor);
    CGContextDrawPath(context, kCGPathFill);
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[3] = { 0.0f, 0.57f, 1.0f };
    CGFloat components[12] = {
        70.0f/255.0f, 70.0f/255.0f, 70.0f/255.0f, 1.0f,
        55.0f/255.0f, 55.0f/255.0f, 55.0f/255.0f, 1.0f,
        40.0f/255.0f, 40.0f/255.0f, 40.0f/255.0f, 1.0f
    };
    
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 3);
    CGPoint startPoint = CGPointMake(activeBounds.size.width*0.2f, 0.0f);
    CGPoint endPoint = CGPointMake(activeBounds.size.width*0.2f, activeBounds.size.height);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
    CGFloat buttonOffset = UIAlertPosition;
    CGContextSaveGState(context);
    CGRect hatchFrame = CGRectMake(0.0f, buttonOffset, activeBounds.size.width, (activeBounds.size.height-buttonOffset+1.0f));
    CGContextClipToRect(context, hatchFrame);
    
    CGFloat spacer = 4.0f;
    int rows = (activeBounds.size.width+activeBounds.size.height/spacer);
    CGMutablePathRef hatchPath = CGPathCreateMutable();
    for (int i = 1; i <= rows; i++) {
        CGPathMoveToPoint(hatchPath, nil, spacer*i, 0.0f);
        CGPathAddLineToPoint(hatchPath, nil, 0.0f, spacer*i);
    }
    
    CGContextAddPath(context, hatchPath);
    CGPathRelease(hatchPath);
    
    CGContextSetLineWidth(context, 1.0f);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.15f].CGColor);
    CGContextDrawPath(context, kCGPathStroke);
    CGContextRestoreGState(context);
    
    CGMutablePathRef linePath = CGPathCreateMutable();
    CGPathMoveToPoint(linePath, nil, 0.0f, buttonOffset);
    CGPathAddLineToPoint(linePath, nil, activeBounds.size.width, buttonOffset);
    CGContextAddPath(context, linePath);
    CGPathRelease(linePath);
    CGContextSetLineWidth(context, 1.0f);
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.6f].CGColor);
    CGContextSetShadowWithColor(context, CGSizeMake(0.0f, 1.0f), 0.0f, [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.2f].CGColor);
    CGContextDrawPath(context, kCGPathStroke);
    CGContextRestoreGState(context);

    CGContextAddPath(context, path);
    CGContextSetLineWidth(context, 3.0f);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0f].CGColor);
    CGContextSetShadowWithColor(context, CGSizeMake(0.0f, 0.0f), 6.0f, [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f].CGColor);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextRestoreGState(context);
    CGContextAddPath(context, path);
    CGContextSetLineWidth(context, 3.0f);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0f].CGColor);
    CGContextSetShadowWithColor(context, CGSizeMake(0.0f, 0.0f), 0.0f, [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f].CGColor);
    CGContextDrawPath(context, kCGPathStroke);  
}

@end
