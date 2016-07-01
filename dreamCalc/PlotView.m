//
//  PlotView.m
//  dreamCalc
//
//  Created by Yura Yasinskyy on 28.06.16.
//  Copyright © 2016 Yura Yasinskyy. All rights reserved.
//

#import "PlotView.h"

@implementation PlotView

@synthesize transferedDataX, transferedDataY, n;
    
float data[] = {0.7, 0.4, 0.9, 1.0, 0.2, 0.85, 0.11, 0.75, 0.53, 0.44};

//for paprabola
//float dataX[] = {-10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
//float dataY[] = {100, 81, 64, 49, 36, 25, 16, 9, 4, 1, 0, 1, 4, 9, 16, 25, 36, 49, 64, 81, 100};
//int n = 21;

//for sqrt
//float dataX[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
//float dataY[] = {0, 1, 1.4, 1.7, 2, 2.2, 2.4, 2.6, 2.8, 3, 3.1};







- (void) drawLineGraphWithContext: (CGContextRef) ctx {
    
    
    
    

    
    
    
    
    CGContextSetLineWidth(ctx, 2.0);
    CGContextSetStrokeColorWithColor(ctx, [[UIColor colorWithRed:1.0 green:0 blue:0 alpha:1.0] CGColor]);

    
    
    //int maxGraphHeight = kGraphHeight - kOffsetY;
    CGContextBeginPath(ctx);
    
    //middle - (450,440)
    
    double startX = 450;
    double startY = 440;
    CGContextMoveToPoint(ctx, startX, startY);
    
    int scale = 5;
    
    
    for (int i = 0; i < n; i++) {
        
        CGContextMoveToPoint(ctx, (startX + [[transferedDataX objectAtIndex:i] doubleValue]*scale), (startY - [[transferedDataY objectAtIndex:i] doubleValue]*scale));
        if (i == n-1) {
            
            break;
        }
        else {
            CGContextAddLineToPoint(ctx, (startX + [[transferedDataX objectAtIndex:i+1] doubleValue]*scale), (startY - [[transferedDataY objectAtIndex:i+1] doubleValue]*scale));
            NSLog(@"dataX[%i]: %g,      dataY[%i]: %g", i, [[transferedDataX objectAtIndex:i] doubleValue], i, [[transferedDataY objectAtIndex:i] doubleValue]);
            NSLog(@"dataX[%i+1]: %g,     dataY[%i+1]: %g", i, [[transferedDataX objectAtIndex:i+1] doubleValue], i, [[transferedDataY objectAtIndex:i+1] doubleValue]);
        }
    }
    
//    for (int i = 0; i < n; i++) {
//        
//        CGContextMoveToPoint(ctx, (startX + dataX[i]*scale), (startY - dataY[i]*scale));
//        if (i == n-1) {
//            
//            break;
//        }
//        else {
//         CGContextAddLineToPoint(ctx, (startX + dataX[i+1]*scale), (startY - dataY[i+1]*scale));
//         NSLog(@"dataX[%i]: %g,      dataY[%i]: %g", i, dataX[i], i, dataY[i]);
//         NSLog(@"dataX[%i+1]: %g,     dataY[%i+1]: %g", i, dataX[i+1], i, dataY[i+1]);
//        }
//    }
    
    
    //for litle circles on the graph - building points
//    CGContextSetFillColorWithColor(ctx, [[UIColor colorWithRed:1.0 green:0 blue:0 alpha:1.0] CGColor]);
//    
//    for (int i = 1; i < sizeof(data) - 1; i++)
//    {
//        float x = kOffsetX + i * kStepX;
//        float y = kGraphHeight - maxGraphHeight * data[i];
//        CGRect rect = CGRectMake(x - kCircleRadius, y - kCircleRadius, 2 * kCircleRadius, 2 * kCircleRadius);
//        CGContextAddEllipseInRect(ctx, rect);
//    }
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
}


- (void) drawRect: (CGRect) rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 0.6);
    CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:0.98 green:0.98 blue:1.00 alpha:1.0] CGColor]);

    
    // How many lines?
    int howMany = (kDefaultGraphWidth - kOffsetX) / kStepX;
    
    // Here vertical lines go
    for (int i = 0; i <= howMany; i++)
    {
        CGContextMoveToPoint(context, kOffsetX + i * kStepX, kGraphTop);
        CGContextAddLineToPoint(context, kOffsetX + i * kStepX, kGraphBottom);
    }
    
    // And horizontal
    int howManyHorizontal = (kGraphBottom - kGraphTop - kOffsetY) / kStepY;
    for (int i = 0; i <= howManyHorizontal; i++)
    {
        CGContextMoveToPoint(context, kOffsetX, kGraphBottom - kOffsetY - i * kStepY);
        CGContextAddLineToPoint(context, kDefaultGraphWidth, kGraphBottom - kOffsetY - i * kStepY);
    }
    
    CGContextStrokePath(context);
    
    
    [self drawLineGraphWithContext:context];
    
    //labels under grid
    CGContextSetTextMatrix(context, CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0));
    
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] CGColor]);
    for (int i = 0; i < sizeof(data); i++)
    {
        NSString *theText = [NSString stringWithFormat:@"%d", i];
        [theText drawAtPoint:CGPointMake((kOffsetX + i * kStepX)+3, kGraphBottom - 25) withAttributes:0];
    }

}

@end
