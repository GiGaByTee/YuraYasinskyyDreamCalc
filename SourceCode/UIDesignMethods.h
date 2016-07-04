//
//  UIDesign.h
//  dreamCalc
//
//  Created by Yura Yasinskyy on 23.06.16.
//  Copyright © 2016 Yura Yasinskyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIDesignMethods : NSObject


- (UIImage* ) blurWithCoreImage: (UIImage* ) sourceImage andUIView: (UIView*) viewToChange;

- (UIImage* ) screenshotTaker: (UIView* ) viewToTakeScreenshot;

- (void) parallaxImplementor: (NSArray* ) arrayOfViews;

- (void) positioningObjectsInCircle: (NSArray*) buttonsArray andPreferedRadius: (CGFloat) radius andScreenBounds: (CGRect* ) bounds andVerticalOffset: (NSInteger) offset;

- (void) animationsMaker: (UIView* ) myView duration: (CGFloat) duration speed: (CGFloat) speed;


@end
