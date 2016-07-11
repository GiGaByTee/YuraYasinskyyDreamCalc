//
//  CalcModel.h
//  dreamCalc
//
//  Created by Yura Yasinskyy on 17.06.16.
//  Copyright © 2016 Yura Yasinskyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CalculatorModel : NSObject

@property(strong, nonatomic) NSArray* tabulatedXdata;
@property(strong, nonatomic) NSArray* tabulatedYdata;

- (NSString*)regexSyntaxCheker:(NSString*)inputText;

- (void)functionTabulator:(NSString*)inputStringFunction
                 andRange:(CGFloat)rangeStart
                   andEnd:(CGFloat)rangeEnd
                  andStep:(CGFloat)tabulationStep;

- (NSString*)parseUserInputFromLabel:
    (NSString*)inputText;  // parsing input expression

- (CGFloat)resultWithNSExpression:(NSString*)inputString;

- (NSArray*)prepareToRPN:(NSString*)inputString;

- (NSArray*)reversePolishNotation:(NSArray*)preparedArray;

- (CGFloat)calculatingResultFromRPN:(NSArray*)rpnOutputString;

@end
