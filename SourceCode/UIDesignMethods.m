//
//  UIDesign.m
//  dreamCalc
//
//  Created by Yura Yasinskyy on 23.06.16.
//  Copyright © 2016 Yura Yasinskyy. All rights reserved.
//

#import "UIDesignMethods.h"

@implementation UIDesignMethods

- (UIImage *) blurWithCoreImage: (UIImage* ) sourceImage andUIView: (UIView* ) viewToChange {
    
    CIImage *inputImage = [CIImage imageWithCGImage:sourceImage.CGImage];
    
    //Apply Affine-Clamp filter to stretch the image so that it does not
    //look shrunken when gaussian blur is applied
    CGAffineTransform transform = CGAffineTransformIdentity;
    CIFilter *clampFilter = [CIFilter filterWithName:@"CIAffineClamp"];
    [clampFilter setValue:inputImage forKey:@"inputImage"];
    [clampFilter setValue:[NSValue valueWithBytes:&transform objCType:@encode(CGAffineTransform)] forKey:@"inputTransform"];
    
    //Apply gaussian blur filter with radius of 30
    CIFilter *gaussianBlurFilter = [CIFilter filterWithName: @"CIGaussianBlur"];
    [gaussianBlurFilter setValue:clampFilter.outputImage forKey: @"inputImage"];
    [gaussianBlurFilter setValue:@15 forKey:@"inputRadius"];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:gaussianBlurFilter.outputImage fromRect:[inputImage extent]];
    
    //Set up output context.
    UIGraphicsBeginImageContext(viewToChange.frame.size);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    
    //Invert image coordinates
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -viewToChange.frame.size.height);
    
    //Draw base image.
    CGContextDrawImage(outputContext, viewToChange.frame, cgImage);
    
    //Apply white tint
    CGContextSaveGState(outputContext);
    CGImageRelease(cgImage);
    CGContextSetFillColorWithColor(outputContext, [UIColor colorWithWhite:1 alpha:0.001].CGColor);
    CGContextFillRect(outputContext, viewToChange.frame);
    CGContextRestoreGState(outputContext);
    
    //Output image is ready.
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}

- (UIImage* ) screenshotTaker: (UIView* ) viewToTakeScreenshot {
    
    //Takes screenshot
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        
        UIGraphicsBeginImageContextWithOptions(viewToTakeScreenshot.bounds.size, NO, [UIScreen mainScreen].scale);
        
    }
    else {
        
        UIGraphicsBeginImageContext(viewToTakeScreenshot.bounds.size);
        
    }

    [viewToTakeScreenshot.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
    
}

- (void) parallaxImplementor: (NSArray* ) arrayOfViews {
    
    // Set vertical effect
    UIInterpolatingMotionEffect *verticalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.y"
     type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-25);
    verticalMotionEffect.maximumRelativeValue = @(25);
    
    // Set horizontal effect
    UIInterpolatingMotionEffect *horizontalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.x"
     type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-25);
    horizontalMotionEffect.maximumRelativeValue = @(25);
    
    // Create group to combine both
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    
    // Add both effects to your views
    for (NSInteger i = 0; i < arrayOfViews.count; i++) {
        
        [[arrayOfViews objectAtIndex: i] addMotionEffect: group];
    }
    
}

- (void) positioningObjectsInCircle: (NSArray*) buttonsArray andPreferedRadius: (CGFloat) radius andScreenBounds: (CGRect* ) bounds andVerticalOffset: (NSInteger) offset {
    
    CGFloat rX, rY, c, s;
    CGRect screenBound = *bounds;
    CGFloat screenWidth = CGRectGetWidth(screenBound);
    CGFloat screenHeight = CGRectGetHeight(screenBound);
    NSLog(@"Screen width: %g", screenWidth);
    NSLog(@"Screen height: %g", screenHeight); //just to see
    NSInteger numberOfButtons = (NSInteger)buttonsArray.count;
    CGFloat alpha = 6.2831/numberOfButtons;
    CGFloat previousX = screenWidth/2;
    CGFloat previousY = screenHeight/2 - radius;
    CGFloat calculatedX;
    CGFloat calculatedY;
    
    for (NSInteger i = 1; i < buttonsArray.count; i++) {
        
        rX = previousX - screenWidth/2;
        rY = previousY - screenHeight/2;
        c = cos(alpha);
        s = sin(alpha);
        calculatedX = screenWidth/2 + rX*c - rY*s;
        calculatedY = screenHeight/2 + rX*s + rY*c;
        previousX = calculatedX;
        previousY = calculatedY;
        NSLog(@"Calculated X: %g Y: %g", calculatedX, calculatedY);
        CGPoint centerPoint = {calculatedX, calculatedY+offset};
        [[buttonsArray objectAtIndex: i] setCenter:(centerPoint)];
        
    }
    
}

- (void) animationsMaker: (UIView* ) myView duration: (CGFloat) duration speed: (CGFloat) speed {
    
    CATransition *transition = [CATransition animation];
    transition.duration = duration;
    transition.speed = speed;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFromLeft;
    transition.delegate = self;
    [myView.layer addAnimation:transition forKey:nil];
    
}

@end
