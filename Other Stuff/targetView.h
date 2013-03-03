//
//  targetView.h
//  ballgame
//
//  Created by Nathaniel Symer on 11/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface targetView : UIView

@property (nonatomic, retain) NSString *namingString;

@property (nonatomic, retain) UIImage *targetImage;

- (void)targetViewForNamingString:(NSString* )targetString;

- (void)finalizeImage;

@end
