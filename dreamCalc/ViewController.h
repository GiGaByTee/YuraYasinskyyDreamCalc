//
//  ViewController.h
//  dreamCalc
//
//  Created by Yura Yasinskyy on 15.06.16.
//  Copyright © 2016 Yura Yasinskyy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalcModel.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *dreamLabel;


/* --- inner circle --- */

@property (weak, nonatomic) IBOutlet UIButton *buttonEquals;

@property (weak, nonatomic) IBOutlet UIButton *buttonPlus;

@property (weak, nonatomic) IBOutlet UIButton *buttonMinus;

@property (weak, nonatomic) IBOutlet UIButton *buttonMultiply;

@property (weak, nonatomic) IBOutlet UIButton *buttonDivide;

@property (weak, nonatomic) IBOutlet UIButton *buttonComma;

@property (weak, nonatomic) IBOutlet UIButton *buttonErase;

@property (weak, nonatomic) IBOutlet UIButton *buttonBracketRight;

@property (weak, nonatomic) IBOutlet UIButton *buttonBracketLeft;

/* ------------------ */


/* --- outer circle --- */

@property (weak, nonatomic) IBOutlet UIButton *buttonTwo;

@property (weak, nonatomic) IBOutlet UIButton *buttonThree;

@property (weak, nonatomic) IBOutlet UIButton *buttonFour;

@property (weak, nonatomic) IBOutlet UIButton *buttonFive;

@property (weak, nonatomic) IBOutlet UIButton *buttonSix;

@property (weak, nonatomic) IBOutlet UIButton *buttonSeven;

@property (weak, nonatomic) IBOutlet UIButton *buttonEight;

@property (weak, nonatomic) IBOutlet UIButton *buttonNine;

@property (weak, nonatomic) IBOutlet UIButton *buttonZero;

@property (weak, nonatomic) IBOutlet UIButton *buttonOne;

/* -------------------- */



@property (nonatomic) double alpha;

@property (nonatomic) double radius;

@property (nonatomic) int numberOfButtons;

@property (nonatomic) CGRect screenBound;

@property (nonatomic) CGFloat screenWidth;

@property (nonatomic) CGFloat screenHeight;

@property (nonatomic) double previousX;

@property (nonatomic) double previousY;

@property (nonatomic) double calculatedX;

@property (nonatomic) double calculatedY;

- (void) calculateXY: (NSMutableArray*) buttonsArray andArraySize: (int) arraySize; //making buttons stay radially



/* --- proccessing user input expression -- */
@property (weak, nonatomic) IBOutlet UILabel *inputLabel;

- (NSString*) parseUserInputFromLabel: (NSString*) text; //parsing input expression

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


- (IBAction)buttonPlusTouch:(id)sender;

- (IBAction)buttonMinusTouch:(id)sender;

- (IBAction)buttonMultiplyTouch:(id)sender;

- (IBAction)buttonDivideTouch:(id)sender;

- (IBAction)buttonCommaTouch:(id)sender;

- (IBAction)buttonClearTouch:(id)sender;

- (IBAction)buttonRightBracketTouch:(id)sender;

- (IBAction)buttonLeftBracketTouch:(id)sender;


- (IBAction)buttonEqualTouch:(id)sender;

//@property (strong, nonatomic) CalcModel* myModel;

@property (nonatomic) int countOfLeftBrackets;

@property (nonatomic) int countOfRightBrackets;

@property (nonatomic) BOOL isResultDisplayed;

@property (strong, nonatomic) NSString* tempInput;


@property (weak, nonatomic) IBOutlet UISegmentedControl *algorithmChanger;


- (IBAction)styleChanger:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *styleChanger;

@property BOOL buttonPressed;



@end

