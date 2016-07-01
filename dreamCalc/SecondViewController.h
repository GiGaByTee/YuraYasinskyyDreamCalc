//
//  SecondViewController.h
//  dreamCalc
//
//  Created by Yura Yasinskyy on 27.06.16.
//  Copyright © 2016 Yura Yasinskyy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import "CalcModel.h"
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import "UIDesign.h"
#import "PlotView.h"

@interface SecondViewController : UIViewController


@property (strong, nonatomic) NSMutableArray* dataToTransferX;
@property (strong, nonatomic) NSMutableArray* dataToTransferY;
@property NSInteger dataLength;

@property (strong ,nonatomic) NSString* labelTextTransfer;


@property (strong, nonatomic) UIDesign* myUI;


@property (weak, nonatomic) IBOutlet UILabel *inputLabel;

- (IBAction)styleChanger:(id)sender;


@property (weak, nonatomic) IBOutlet UIScrollView *plotScrollView;


@property (weak, nonatomic) IBOutlet UIButton *buttonFirstView;


- (IBAction)buttonFirstViewTouch:(id)sender;

@property (strong, nonatomic) PlotView* graphView;

@property (weak, nonatomic) IBOutlet UIButton *wallpaperButton;

@property (weak, nonatomic) IBOutlet UILabel *dreamLabel;


@end
