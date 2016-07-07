//
//  SecondViewController.h
//  dreamCalc
//
//  Created by Yura Yasinskyy on 27.06.16.
//  Copyright © 2016 Yura Yasinskyy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import "CalculatorModel.h"
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import "UIDesignMethods.h"
#import "PlotView.h"

#import <AVFoundation/AVFoundation.h>

@interface SecondViewController : UIViewController


@property (strong ,nonatomic) NSString* labelTextFromFirstView;

@property (weak, nonatomic) IBOutlet UILabel *inputLabel;

@property (weak, nonatomic) IBOutlet UIButton *wallpaperButton;

@property (weak, nonatomic) IBOutlet UILabel *dreamLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *plotScrollView;

@property (weak, nonatomic) IBOutlet UIButton *buttonFirstView;

@property (nonatomic) CGRect screenBound;


- (IBAction)buttonFirstViewTouch:(id)sender;

- (IBAction)styleChanger:(id)sender;



@property (weak, nonatomic) IBOutlet UIView *dreamLabelAndStChanger;




@end