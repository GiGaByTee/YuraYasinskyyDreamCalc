//
//  CalcModel.m
//  dreamCalc
//
//  Created by Yura Yasinskyy on 17.06.16.
//  Copyright © 2016 Yura Yasinskyy. All rights reserved.
//

#import "CalculatorModel.h"

@implementation CalculatorModel


- (NSString*) regexSyntaxCheker: (NSString*) inputText {
    
    NSString* myEquation = inputText;
    
    NSString* pattern = @"(?:\\*|\\/|\\+|\\-|\\.|\\^)[\\*\\/\\+\\-\\.\\^]|\\([\\)\\*\\/\\+\\-\\.\\^]|(?:\\*|\\/|\\+|\\-|\\.\\^)[\\)]|\\)[\\.\\(]|xx|\\(\\d{1,10}\\)\\d{1,10}|\\d{1,10}\\(\\d{1,10}\\)|\\d{1,10}\\.\\d{1,10}\\.|\\d{1,10}\\/0{1,10}\\d{1,10}|[\\*\\/\\+\\-\\.\\^]$";

    NSError* regexError = nil;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&regexError];
    
    if (regexError) {
        
        NSLog(@"Regex creation failed with error: %@", [regexError description]);
        return @"Sorry, something's wrong with regex :(";
    }
    
    NSArray* matches = [regex matchesInString: myEquation options:NSMatchingWithoutAnchoringBounds range:NSMakeRange(0, myEquation.length)];
    if (matches.count != 0) {
        
        NSLog(@"REGEX: matches found!");
        return @"Are you sure everything is ok?";
    }
    else {
        
        NSLog(@"REGEX: found no matches!");
        return myEquation;
    }
    
}


//String should be without y= like this: y=x -> x+2
- (void) functionTabulator: (NSString*) inputStringFunction andRange: (CGFloat) rangeStart andEnd: (CGFloat) rangeEnd  andStep: (CGFloat) tabulationStep {
    
    NSString* functionToTabulate;
    NSNumber* resultYforX;
    CGFloat step = tabulationStep;
    
    NSMutableArray* xData = [[NSMutableArray alloc] init];
    NSMutableArray* yData = [[NSMutableArray alloc] init];
    
    
    NSLog(@"Function y=%@ is tabulated with data:", inputStringFunction);
    
    for (CGFloat i = rangeStart; i <= rangeEnd; i+=step) {
        
        functionToTabulate = [inputStringFunction stringByReplacingOccurrencesOfString:@"x" withString:[NSString stringWithFormat:@"%g", i]];
        [xData addObject:[NSNumber numberWithDouble:i]]; // x values

        resultYforX = [NSNumber numberWithDouble:[self calculatingResultFromRPN: [self reversePolishNotation: [self prepareToRPN: functionToTabulate]]]];
        [yData addObject:resultYforX]; // y values
        
        NSLog(@"x: %g y: %g", i, [resultYforX doubleValue]);
        
        self.tabulatedXdata = [xData copy];
        self.tabulatedYdata = [yData copy];
        
    }
    
}

//For example labelInput = @"77.0+(55-2)*4"; after parsing should be 77.0 + ( 55 - 2 ) * 4
- (NSString*) parseUserInputFromLabel: (NSString*) inputText {
    
    NSString* labelInput;
    NSString* parsedString = @"";
    
    labelInput = inputText;
    NSLog(@"Text from input %@", labelInput);
    
    for (NSInteger i = 0; i < labelInput.length; i++) {
        
        if ([[NSString stringWithFormat:@"%c", [labelInput characterAtIndex:i]]  isEqualToString: @"("] || [[NSString stringWithFormat:@"%c", [labelInput characterAtIndex:i]]  isEqualToString: @")"] || [[NSString stringWithFormat:@"%c", [labelInput characterAtIndex:i]]  isEqualToString: @"+"] || [[NSString stringWithFormat:@"%c", [labelInput characterAtIndex:i]]  isEqualToString: @"-"] || [[NSString stringWithFormat:@"%c", [labelInput characterAtIndex:i]]  isEqualToString: @"*"] || [[NSString stringWithFormat:@"%c", [labelInput characterAtIndex:i]]  isEqualToString: @"/"] || [[NSString stringWithFormat:@"%c", [labelInput characterAtIndex:i]]  isEqualToString: @"^"]) {
            
            if (i == 0) {
                parsedString = [NSString stringWithFormat:@"%@%c", parsedString, [labelInput characterAtIndex:i]];
            }
            else {
                parsedString = [NSString stringWithFormat:@"%@ %c", parsedString, [labelInput characterAtIndex:i]];
            }
            continue;
        }
        else {
            
            if (i == 0) {
                
                parsedString = [NSString stringWithFormat:@"%@%c", parsedString, [labelInput characterAtIndex:i]];
            }
            else {
                if ([[NSString stringWithFormat:@"%c",[labelInput characterAtIndex: i-1]] isEqual:@"("] || [[NSString stringWithFormat:@"%c",[labelInput characterAtIndex: i-1]] isEqual:@")"] || [[NSString stringWithFormat:@"%c",[labelInput characterAtIndex: i-1]] isEqual:@"+"] || [[NSString stringWithFormat:@"%c",[labelInput characterAtIndex: i-1]] isEqual:@"-"] || [[NSString stringWithFormat:@"%c",[labelInput characterAtIndex: i-1]] isEqual:@"*"] || [[NSString stringWithFormat:@"%c",[labelInput characterAtIndex: i-1]] isEqual:@"/"] || [[NSString stringWithFormat:@"%c",[labelInput characterAtIndex: i-1]] isEqual:@"^"]) {
                    
                    parsedString = [NSString stringWithFormat:@"%@ %c", parsedString, [labelInput characterAtIndex:i]];
                }
                else {
                    
                    parsedString = [NSString stringWithFormat:@"%@%c", parsedString, [labelInput characterAtIndex:i]];
                }
            }
            
        }
    }
    
    NSLog(@"Parsed string: %@", parsedString);
    
    return parsedString;
}

- (CGFloat) resultWithNSExpression: (NSString*) inputString {
    
    NSString *numericExpression = inputString;
    NSExpression *expression = [NSExpression expressionWithFormat:numericExpression];
    NSNumber *result = [expression expressionValueWithObject:nil context:nil];
    CGFloat resultFromNSexpression = [result doubleValue];
    
    NSLog(@"The result is: %g\n\n", resultFromNSexpression);
    
    return resultFromNSexpression;
}

//Separating numbers and operators from input string and putting them into NSArray
- (NSArray*) prepareToRPN: (NSString*) inputString {
    
    NSString* stringToProcess = inputString; //input string that will be proccessed
    stringToProcess = [NSString stringWithFormat:@"%@ ", stringToProcess];
    NSMutableArray *daraPreparedToRPN = [[NSMutableArray alloc] init];
    NSString* tempString = @"";
    
    for (NSInteger i = 0; i < stringToProcess.length; i++) {

        if ([[NSString stringWithFormat:@"%c", [stringToProcess characterAtIndex: i]]  isEqual: @" "]) {
            
            [daraPreparedToRPN addObject: tempString];
            tempString = @"";
            continue;
        }
        else {
            
            tempString = [NSString stringWithFormat:@"%@%c", tempString, [stringToProcess characterAtIndex: i]];
        }
    }
    
    return [daraPreparedToRPN copy];
}

- (NSArray*) reversePolishNotation: (NSArray*) preparedArray {
    
    NSArray *dataPreparedToRPN;
    dataPreparedToRPN = preparedArray;
    NSMutableArray *rpnOutputString = [[NSMutableArray alloc] init]; //output string
    NSMutableArray *rpnResultStack = [[NSMutableArray alloc] init]; //stack
    CGFloat numberFromPreparedToRPN;
    NSString* tempString;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    [numberFormatter setDecimalSeparator:@"."];
    
    
    for (NSInteger i = 0; i < dataPreparedToRPN.count; i++) {
        
        tempString = [NSString stringWithFormat:@"%@", [dataPreparedToRPN objectAtIndex: i]];
        numberFromPreparedToRPN = [[numberFormatter numberFromString: tempString] doubleValue];
        
        if (numberFromPreparedToRPN == 0) {
            
            if ([tempString isEqual: @"^"]) {
                
                while ([rpnResultStack.lastObject isEqual:@"^"]) {
                    
                    [rpnOutputString addObject: rpnResultStack.lastObject];
                    [rpnResultStack removeLastObject];
                }
                
                [rpnResultStack addObject: tempString];
                NSLog(@"^ recognized");
            }
            else
            
            if ([tempString isEqualToString: @"*"]) {
                
                while ([rpnResultStack.lastObject isEqual:@"*"] || [rpnResultStack.lastObject isEqual:@"/"] || [rpnResultStack.lastObject isEqual:@"^"]) {
                    
                    [rpnOutputString addObject: rpnResultStack.lastObject];
                    [rpnResultStack removeLastObject];
                }
                
                [rpnResultStack addObject: tempString];
                NSLog(@"* recognized");
            }
            else if ([tempString isEqualToString: @"/"])
            {
                
                while ([rpnResultStack.lastObject isEqual:@"*"] || [rpnResultStack.lastObject isEqual:@"/"] || [rpnResultStack.lastObject isEqual:@"^"]) {
                    
                    [rpnOutputString addObject: rpnResultStack.lastObject];
                    [rpnResultStack removeLastObject];
                }
                
                [rpnResultStack addObject: tempString];
                NSLog(@"/ recognized");
            }
            else if ([tempString isEqualToString: @"+"])
            {
                while ([rpnResultStack.lastObject isEqual:@"*"] || [rpnResultStack.lastObject isEqual:@"/"] || [rpnResultStack.lastObject isEqual:@"+"] || [rpnResultStack.lastObject isEqual:@"-"] || [rpnResultStack.lastObject isEqual:@"sin"] || [rpnResultStack.lastObject isEqual:@"cos"]|| [rpnResultStack.lastObject isEqual:@"tan"] || [rpnResultStack.lastObject isEqual:@"ctg"] || [rpnResultStack.lastObject isEqual:@"^"]) {
                    
                    [rpnOutputString addObject: rpnResultStack.lastObject];
                    [rpnResultStack removeLastObject];
                }
                
                [rpnResultStack addObject: tempString];
                NSLog(@"+ recognized");
            }
            else if ([tempString isEqualToString: @"-"])
            {
                while ([rpnResultStack.lastObject isEqual:@"*"] || [rpnResultStack.lastObject isEqual:@"/"] || [rpnResultStack.lastObject isEqual:@"+"] || [rpnResultStack.lastObject isEqual:@"-"] || [rpnResultStack.lastObject isEqual:@"sin"] || [rpnResultStack.lastObject isEqual:@"cos"]|| [rpnResultStack.lastObject isEqual:@"tan"] || [rpnResultStack.lastObject isEqual:@"ctg"] || [rpnResultStack.lastObject isEqual:@"^"]) {
                    
                    [rpnOutputString addObject: rpnResultStack.lastObject];
                    [rpnResultStack removeLastObject];
                }
                
                [rpnResultStack addObject: tempString];
                NSLog(@"- recognized");
            }
            else if ([tempString isEqualToString: @"sin"])
            {
                
                [rpnResultStack addObject:@"sin"];
                NSLog(@"sin recognized");
            }
            else if ([tempString isEqualToString: @"cos"])
            {
                
                [rpnResultStack addObject:@"cos"];
                NSLog(@"sin recognized");
            }
            else if ([tempString isEqualToString: @"tan"])
            {
                
                [rpnResultStack addObject:@"tan"];
                NSLog(@"sin recognized");
            }
            else if ([tempString isEqualToString: @"ctg"])
            {
                
                [rpnResultStack addObject:@"ctg"];
                NSLog(@"sin recognized");
            }
            else if ([tempString isEqualToString: @"("])
            {
                
                [rpnResultStack addObject: tempString];
                NSLog(@"( recognized");
            }
            else if ([tempString isEqualToString: @")"])
            {
                while (![rpnResultStack.lastObject isEqual:@"("]) {
                    
                    [rpnOutputString addObject: rpnResultStack.lastObject];
                    [rpnResultStack removeLastObject];
                }
                
                [rpnResultStack removeLastObject];
                NSLog(@") recognized");
                
            }
            else {
                
                [rpnOutputString addObject: [NSNumber numberWithDouble: 0]];
            }
            
        }
        else {
            
            [rpnOutputString addObject: [NSNumber numberWithDouble: numberFromPreparedToRPN]];
            NSLog(@"number recognized: %f", numberFromPreparedToRPN);
        }
        
    } //end of for loop
    while (rpnResultStack.count != 0) {
        
        [rpnOutputString addObject: rpnResultStack.lastObject];
        [rpnResultStack removeLastObject];
    }
    
    return [rpnOutputString copy];
}

- (CGFloat) calculatingResultFromRPN: (NSArray*) rpnOutputString {
    
    NSArray* dataAfterRPN;
    dataAfterRPN = rpnOutputString;
    
    NSMutableArray *resultStack = [[NSMutableArray alloc] init];
    CGFloat tempNumber;
    CGFloat finalResult;
    
    for (NSInteger i = 0; i < dataAfterRPN.count; i++) {
        
        if ([[dataAfterRPN objectAtIndex: i] isEqual:@"^"]) {
            
            tempNumber = pow([[resultStack objectAtIndex: (resultStack.count-2)] doubleValue], [[resultStack objectAtIndex: (resultStack.count-1)] doubleValue]);
            [resultStack removeLastObject];
            [resultStack removeLastObject];
            [resultStack addObject: [NSNumber numberWithDouble:tempNumber]];
            
        } else if ([[dataAfterRPN objectAtIndex: i] isEqual:@"+"]) {
            
            tempNumber = [[resultStack objectAtIndex: resultStack.count-1] doubleValue] + [[resultStack objectAtIndex: resultStack.count-2] doubleValue];
            [resultStack removeLastObject];
            [resultStack removeLastObject];
            [resultStack addObject: [NSNumber numberWithDouble:tempNumber]];
            
        } else if ([[dataAfterRPN objectAtIndex: i] isEqual:@"-"]) {
            
            tempNumber = [[resultStack objectAtIndex: (resultStack.count-2)] doubleValue] - [[resultStack objectAtIndex: (resultStack.count-1)] doubleValue];
            [resultStack removeLastObject];
            [resultStack removeLastObject];
            [resultStack addObject: [NSNumber numberWithDouble:tempNumber]];
            
        } else if ([[dataAfterRPN objectAtIndex: i] isEqual:@"*"]) {
            
            tempNumber = [[resultStack objectAtIndex: (resultStack.count-1)] doubleValue] * [[resultStack objectAtIndex: (resultStack.count-2)] doubleValue];
            [resultStack removeLastObject];
            [resultStack removeLastObject];
            [resultStack addObject: [NSNumber numberWithDouble:tempNumber]];
            
        } else if ([[dataAfterRPN objectAtIndex: i] isEqual:@"/"]) {
            
            tempNumber = [[resultStack objectAtIndex: (resultStack.count-2)] doubleValue] / [[resultStack objectAtIndex: (resultStack.count-1)] doubleValue];
            [resultStack removeLastObject];
            [resultStack removeLastObject];
            [resultStack addObject: [NSNumber numberWithDouble:tempNumber]];
            
        } else if ([[dataAfterRPN objectAtIndex: i] isEqual:@"sin"]) {
            
            tempNumber = sin([[resultStack objectAtIndex: (resultStack.count-1)] doubleValue]);
            [resultStack removeLastObject];
            [resultStack addObject: [NSNumber numberWithDouble:tempNumber]];
            
        } else if ([[dataAfterRPN objectAtIndex: i] isEqual:@"cos"]) {
            
            tempNumber = cos([[resultStack objectAtIndex: (resultStack.count-1)] doubleValue]);
            [resultStack removeLastObject];
            [resultStack addObject: [NSNumber numberWithDouble:tempNumber]];
            
        } else if ([[dataAfterRPN objectAtIndex: i] isEqual:@"tan"]) {
            
            tempNumber = tan([[resultStack objectAtIndex: (resultStack.count-1)] doubleValue]);
            [resultStack removeLastObject];
            [resultStack addObject: [NSNumber numberWithDouble:tempNumber]];
            
        } else if ([[dataAfterRPN objectAtIndex: i] isEqual:@"ctg"]) {
            
            tempNumber = pow(tan(([[resultStack objectAtIndex: (resultStack.count-1)] doubleValue])), -1);
            [resultStack removeLastObject];
            [resultStack addObject: [NSNumber numberWithDouble:tempNumber]];
            
        }
        else {
            
            [resultStack addObject:[dataAfterRPN objectAtIndex: i]];
            
        }
        
    } //end of for loop

    
    finalResult = [[resultStack objectAtIndex:0] doubleValue];
    NSLog(@"The result is: %g\n\n", finalResult);
    
    return finalResult;
}

@end
