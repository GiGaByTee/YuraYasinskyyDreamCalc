//
//  PlotView.h
//  dreamCalc
//
//  Created by Yura Yasinskyy on 28.06.16.
//  Copyright © 2016 Yura Yasinskyy. All rights reserved.
//

#import <UIKit/UIKit.h>


static const NSInteger defaultGraphHeight = 900;
static const NSInteger defaultGraphWidth = 900;
static const NSInteger offsetX = 0;
static const NSInteger stepX = 50;
static const NSInteger graphBottom = 900;
static const NSInteger graphTop = 0;
static const NSInteger stepY = 50;
static const NSInteger offsetY = 0;


@interface PlotView : UIView


@property (strong, nonatomic) NSArray* transferedDataX;

@property (strong, nonatomic) NSArray* transferedDataY;

@property NSInteger countOfElements;


@end
