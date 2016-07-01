//
//  CalcModel.h
//  dreamCalc
//
//  Created by Yura Yasinskyy on 17.06.16.
//  Copyright © 2016 Yura Yasinskyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CalcModel : NSObject


@property (strong, nonatomic) NSMutableArray* tabulatedXdata;
@property (strong, nonatomic) NSMutableArray* tabulatedYdata;


- (NSString*) regexSyntaxCheker: (NSString*) inputText;

- (void) functionTabulator: (NSString*) inputStringFunction andRange: (NSInteger) rangeStart andEnd: (NSInteger) rangeEnd  andStep: (CGFloat) tabulationStep;

- (NSString*) parseUserInputFromLabel: (NSString*) text; //parsing input expression

- (NSNumber*) resultWithNSExpression: (NSString*) inputString;

- (NSMutableArray*) prepareToBackPolishing: (NSString*) inputString;

- (NSMutableArray*) backPolishing: (NSMutableArray*) preparedArray;

- (CGFloat) calculatingResult: (NSMutableArray*) backPolishNotation;


@end
