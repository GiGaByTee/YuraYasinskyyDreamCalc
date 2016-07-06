//
//  ViewController.h
//  dreamCalc
//
//  Created by Yura Yasinskyy on 15.06.16.
//  Copyright © 2016 Yura Yasinskyy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculatorModel.h"
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import "UIDesignMethods.h"
#import "SecondViewController.h"


@interface ViewController : UIViewController


@property (strong, nonatomic) NSArray* transferingDataX;
@property (strong, nonatomic) NSArray* transferingDataY;

@property (weak, nonatomic) IBOutlet UIButton *buttonTabulate;


//Inner circle of buttons
@property (weak, nonatomic) IBOutlet UIButton *buttonPlus;

@property (weak, nonatomic) IBOutlet UIButton *buttonMinus;

@property (weak, nonatomic) IBOutlet UIButton *buttonMultiply;

@property (weak, nonatomic) IBOutlet UIButton *buttonDivide;

@property (weak, nonatomic) IBOutlet UIButton *buttonComma;

@property (weak, nonatomic) IBOutlet UIButton *buttonErase;

@property (weak, nonatomic) IBOutlet UIButton *buttonBracketRight;

@property (weak, nonatomic) IBOutlet UIButton *buttonBracketLeft;


- (IBAction)buttonPlusTouch:(id)sender;

- (IBAction)buttonMinusTouch:(id)sender;

- (IBAction)buttonMultiplyTouch:(id)sender;

- (IBAction)buttonDivideTouch:(id)sender;

- (IBAction)buttonCommaTouch:(id)sender;

- (IBAction)buttonClearTouch:(id)sender;

- (IBAction)buttonRightBracketTouch:(id)sender;

- (IBAction)buttonLeftBracketTouch:(id)sender;


//Outer circle of buttons
@property (weak, nonatomic) IBOutlet UIButton *buttonOne;

@property (weak, nonatomic) IBOutlet UIButton *buttonTwo;

@property (weak, nonatomic) IBOutlet UIButton *buttonThree;

@property (weak, nonatomic) IBOutlet UIButton *buttonFour;

@property (weak, nonatomic) IBOutlet UIButton *buttonFive;

@property (weak, nonatomic) IBOutlet UIButton *buttonSix;

@property (weak, nonatomic) IBOutlet UIButton *buttonSeven;

@property (weak, nonatomic) IBOutlet UIButton *buttonEight;

@property (weak, nonatomic) IBOutlet UIButton *buttonNine;

@property (weak, nonatomic) IBOutlet UIButton *buttonZero;


- (IBAction)buttonOneTouch:(id)sender;

- (IBAction)buttonTwoTouch:(id)sender;

- (IBAction)buttonThreeTouch:(id)sender;

- (IBAction)buttonFourTouch:(id)sender;

- (IBAction)buttonFiveTouch:(id)sender;

- (IBAction)buttonSixTouch:(id)sender;

- (IBAction)buttonSevenTouch:(id)sender;

- (IBAction)buttonEightTouch:(id)sender;

- (IBAction)buttonNineTouch:(id)sender;

- (IBAction)buttonZeroTouch:(id)sender;


//Scientific buttons
@property (weak, nonatomic) IBOutlet UIButton *buttonSin;

@property (weak, nonatomic) IBOutlet UIButton *buttonCos;

@property (weak, nonatomic) IBOutlet UIButton *buttonTan;

@property (weak, nonatomic) IBOutlet UIButton *buttonCtg;

@property (weak, nonatomic) IBOutlet UIButton *buttonPower;

@property (weak, nonatomic) IBOutlet UISwitch *scientificSwitch;

@property (weak, nonatomic) IBOutlet UILabel *turboModeLabel;

@property (weak, nonatomic) IBOutlet UIButton *buttonSecondView;

@property (weak, nonatomic) IBOutlet UIButton *buttonX;

@property (weak, nonatomic) IBOutlet UIButton *buttonY;


- (IBAction)buttonSinTouch:(id)sender;

- (IBAction)buttonCosTouch:(id)sender;

- (IBAction)buttonTanTouch:(id)sender;

- (IBAction)buttonCtgTouch:(id)sender;

- (IBAction)buttonPowerTouch:(id)sender;

- (IBAction)scientificFunctionsEnabler:(id)sender;

- (IBAction)showSecondView:(id)sender;

- (IBAction)buttonXTouch:(id)sender;

- (IBAction)buttonYTouch:(id)sender;


//Other components
@property (nonatomic) CGRect screenBound;

@property (weak, nonatomic) IBOutlet UILabel *dreamLabel;

@property (weak, nonatomic) IBOutlet UIButton *buttonEquals;

@property (weak, nonatomic) IBOutlet UILabel *inputLabel;

@property (weak, nonatomic) IBOutlet UISegmentedControl *algorithmChanger;

@property (weak, nonatomic) IBOutlet UIButton *styleChanger;


- (IBAction)buttonEqualTouch:(id)sender;

- (IBAction)styleChanger:(id)sender;

- (IBAction)tabulateButtonTouch:(id)sender;

- (IBAction)goToLandscapeButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *goToLandscapeButton;



@end

