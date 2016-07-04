//
//  PlotView.m
//  dreamCalc
//
//  Created by Yura Yasinskyy on 28.06.16.
//  Copyright © 2016 Yura Yasinskyy. All rights reserved.
//

#import "PlotView.h"

@implementation PlotView
    

- (void) drawRect: (CGRect) rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 0.6);
    
    
    CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:0.98 green:0.98 blue:1.00 alpha:1.0] CGColor]);

    
    // How many lines to draw?
    NSInteger howMany = (defaultGraphWidth - offsetX) / stepX;
    // Here vertical lines go
    for (NSInteger i = 0; i <= howMany; i++) {
        
        if (i == howMany/2) {
            
            continue;
        }
        
        CGContextMoveToPoint(context, offsetX + i * stepX, graphTop);
        CGContextAddLineToPoint(context, offsetX + i * stepX, graphBottom);
        
    }
    
    // And horizontal
    NSInteger howManyHorizontal = (graphBottom - graphTop - offsetY) / stepY;
    for (NSInteger i = 0; i <= howManyHorizontal; i++)
    {
        
        if (i == howManyHorizontal/2) {
            
            CGContextStrokePath(context);
            CGContextBeginPath(context);
            CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:0.47 green:0.21 blue:0.07 alpha:1.0] CGColor]);
            CGContextMoveToPoint(context, offsetX, graphBottom - offsetY - i * stepY);
            CGContextAddLineToPoint(context, defaultGraphWidth, graphBottom - offsetY - i * stepY);
            CGContextStrokePath(context);
            CGContextBeginPath(context);
            CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:0.98 green:0.98 blue:1.00 alpha:1.0] CGColor]);
            continue;
        }
        
        CGContextMoveToPoint(context, offsetX, graphBottom - offsetY - i * stepY);
        CGContextAddLineToPoint(context, defaultGraphWidth, graphBottom - offsetY - i * stepY);
    }
    
    
    CGContextStrokePath(context);
    CGContextBeginPath(context);
    CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:0.47 green:0.21 blue:0.07 alpha:1.0] CGColor]);
    CGContextMoveToPoint(context, offsetX + howMany/2 * stepX, graphTop);
    CGContextAddLineToPoint(context, offsetX + howMany/2 * stepX, graphBottom);
    CGContextStrokePath(context);
    CGContextBeginPath(context);
    CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:0.98 green:0.98 blue:1.00 alpha:1.0] CGColor]);
    
    
    CGContextStrokePath(context);
    
    [self drawLineGraphWithContext:context];
    
    //labels under grid
    CGContextSetTextMatrix(context, CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0));
    
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] CGColor]);
    for (NSInteger i = 0; i < self.countOfElements; i++)
    {
        if (i == ((defaultGraphWidth - offsetX) / stepX)/2) {
            NSString *labelsText = [NSString stringWithFormat:@"%@", @"0"];
            [labelsText drawAtPoint:CGPointMake((offsetX + i * stepX)+3, graphBottom - defaultGraphHeight/2) withAttributes:0];
        }
//        NSString *labelsText = [NSString stringWithFormat:@"%d", i];
//        [labelsText drawAtPoint:CGPointMake((offsetX + i * stepX)+3, graphBottom - defaultGraphHeight/2) withAttributes:0];
    }

}

- (void) drawLineGraphWithContext: (CGContextRef) context {
    
    
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:1.0 green:0 blue:0 alpha:1.0] CGColor]);
    
    
    CGContextBeginPath(context);
    
    //Move to the middle of the area
    CGFloat startX = defaultGraphWidth/2;
    CGFloat startY = defaultGraphHeight/2;
    CGContextMoveToPoint(context, startX, startY);
    
    NSInteger scale = 35;
    
    for (NSInteger i = 0; i < self.countOfElements; i++) {
        
        if ([[self.transferedDataY objectAtIndex:i] isEqual: [NSNumber numberWithDouble:INFINITY]]) {
            
            continue;
        }
        
        CGContextMoveToPoint(context, (startX + [[self.transferedDataX objectAtIndex:i] doubleValue]*scale), (startY - [[self.transferedDataY objectAtIndex:i] doubleValue]*scale));
        if (i == self.countOfElements-1) {
            
            break;
        }
        else {
            CGContextAddLineToPoint(context, (startX + [[self.transferedDataX objectAtIndex:i+1] doubleValue]*scale), (startY - [[self.transferedDataY objectAtIndex:i+1] doubleValue]*scale));
            NSLog(@"dataX[%li]: %g, dataY[%li]: %g", (long)i, [[self.transferedDataX objectAtIndex:i] doubleValue], (long)i, [[self.transferedDataY objectAtIndex:i] doubleValue]);
        }
    }
    
    CGContextDrawPath(context, kCGPathFillStroke);
    
}


@end
