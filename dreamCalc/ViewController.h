//
//  ViewController.h
//  dreamCalc
//
//  Created by Yura Yasinskyy on 15.06.16.
//  Copyright © 2016 Yura Yasinskyy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalcModel.h"
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import "UIDesign.h"
#import "SecondViewController.h"




@interface ViewController : UIViewController

@property (strong, nonatomic) NSMutableArray* transferingDataX;
@property (strong, nonatomic) NSMutableArray* transferingDataY;

@property (weak, nonatomic) IBOutlet UIButton *buttonTabulate;


@property (strong, nonatomic) UIDesign* myUI;

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

//Scientific circle of buttons

@property (weak, nonatomic) IBOutlet UIButton *buttonSin;

@property (weak, nonatomic) IBOutlet UIButton *buttonCos;

@property (weak, nonatomic) IBOutlet UIButton *buttonTan;

@property (weak, nonatomic) IBOutlet UIButton *buttonCtg;


- (IBAction)buttonSinTouch:(id)sender;

- (IBAction)buttonCosTouch:(id)sender;

- (IBAction)buttonTanTouch:(id)sender;

- (IBAction)buttonCtgTouch:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *buttonPower;


- (IBAction)buttonPowerTouch:(id)sender;


//Other components
@property (nonatomic) CGFloat radius;

@property (nonatomic) CGRect screenBound;

@property (nonatomic) CGFloat screenWidth;

@property (nonatomic) CGFloat screenHeight;

@property (nonatomic) NSInteger buttonsCenterOffset;

@property (weak, nonatomic) IBOutlet UILabel *dreamLabel;

@property (weak, nonatomic) IBOutlet UIButton *buttonEquals;

- (IBAction)buttonEqualTouch:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *inputLabel;

@property (weak, nonatomic) IBOutlet UISegmentedControl *algorithmChanger;

@property (weak, nonatomic) IBOutlet UIButton *styleChanger;

- (IBAction)styleChanger:(id)sender;


//And a bit more other components
@property (nonatomic) NSInteger countOfLeftBrackets;

@property (nonatomic) NSInteger countOfRightBrackets;

@property BOOL styleChangeButtonPressed;

@property (weak, nonatomic) IBOutlet UISwitch *scientificSwitch;

- (IBAction)scientificFunctionsEnabler:(id)sender;

@property (strong, nonatomic) NSMutableArray* upperScientificFunctions;

@property (weak, nonatomic) IBOutlet UILabel *turboModeLabel;

@property (strong, nonatomic) NSString* tempInputBuffer;

@property BOOL isSinPressed;
@property BOOL isCosPressed;
@property BOOL isTanPressed;
@property BOOL isCtgPressed;


@property (weak, nonatomic) IBOutlet UIButton *buttonSecondView;

- (IBAction)showSecondView:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *buttonX;

- (IBAction)buttonXTouch:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *buttonY;

- (IBAction)buttonYTouch:(id)sender;




- (IBAction)tabulateButtonTouch:(id)sender;





@property BOOL isYPressed;



@end

