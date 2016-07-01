//
//  PlotView.h
//  dreamCalc
//
//  Created by Yura Yasinskyy on 28.06.16.
//  Copyright © 2016 Yura Yasinskyy. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kGraphHeight 900
#define kDefaultGraphWidth 900

#define kOffsetX 0
#define kStepX 50
#define kGraphBottom 900
#define kGraphTop 0
#define kStepY 50
#define kOffsetY 10

#define kCircleRadius 3

@interface PlotView : UIView

@property (strong, nonatomic) NSMutableArray* transferedDataX;
@property (strong, nonatomic) NSMutableArray* transferedDataY;
@property NSInteger n;

@end
