//
//  main.m
//  convertIPTo32Integer
//
//  Created by MXX on 2018/10/17.
//  Copyright © 2018年 MFX. All rights reserved.
//

#import <Foundation/Foundation.h>

uint32 convertIPToNumber(char *IPString) {
    if (*IPString < '0' || *IPString > '9') {
        return 0;
    }
    BOOL dotFlag = false;
    BOOL spaceFlag = false;
    int numberOfDot = 0;
    float a[4] = {0,0,0,0};
    float *p = a;
    while (*IPString != '\0') {
        if (*IPString >= '0' && *IPString <= '9') {
            if (spaceFlag && !dotFlag) {
                return 0;
            }
            *p = (*p * 10) + (*IPString - '0');
            dotFlag = false;
            spaceFlag = false;
        } else if (*IPString == '.' ) {
            dotFlag = true;
            if (*p > 255) {
                return 0;
            }
            if (numberOfDot >= 3) {
                return 0;
            } else {
                numberOfDot ++;
            }
            p++;
        } else if (*IPString == ' ') {
            spaceFlag = true;
        } else {
            return 0;
        }
        IPString ++;
    }
    if (*p > 255) {
        return 0;
    }
    uint32 result = pow(2, 24) * a[0] + pow(2, 16) * a[1] + pow(2, 8) * a[2] + 1 * a[3];
    return result;
}

void unitTest(NSString* caseDescription, uint32 result, uint32 expectedResult) {
    if (expectedResult == result) {
        NSLog(@"%@ PASSED", caseDescription);
    } else {
        NSLog(@"%@ FAILED", caseDescription);
    }
}

int main(int argc, const char * argv[]) {
    // Normal Case
    char *normalCase = "172.168.5.1";
    uint32 normalCaseResult = convertIPToNumber(normalCase);
    unitTest(@"Normal Case", 2896692481, normalCaseResult);
    
    char *IP = "172 .168.5.1";
    uint32 result = convertIPToNumber(IP);
    unitTest(@"Space Case", 2896692481, result);
    
    char *twoSpaceIP = "172  .168.5.1";
    uint32 twoSpaceResult = convertIPToNumber(twoSpaceIP);
    unitTest(@"Two Space Case", 2896692481, twoSpaceResult);
    
    char *invalidIP = "1 72.168.5.1";
    uint32 invalidResult = convertIPToNumber(invalidIP);
    unitTest(@"Invalid Case", 0, invalidResult);
    
    char *invalidIPForLargeNumber = "172.168.5.1068";
    uint32 invalidIPForLargeNumberResult = convertIPToNumber(invalidIPForLargeNumber);
    unitTest(@"Invalid Case For Large Number", 0, invalidIPForLargeNumberResult);
    
    char *invalidIPForInnerLargeNumber = "172.1681.5.1";
    uint32 invalidIPForInnerLargeNumberResult = convertIPToNumber(invalidIPForInnerLargeNumber);
    unitTest(@"Invalid Case For Inner Large Number", 0, invalidIPForInnerLargeNumberResult);
    
    char *invalidIPForMoreNumber = "172.168.5.1.1";
    uint32 invalidIPForMoreNumberResult = convertIPToNumber(invalidIPForMoreNumber);
    unitTest(@"Invalid Case For More Number", 0, invalidIPForMoreNumberResult);
    
    char *invalidIPForOtherCharacter = "o172.168.5.1";
    uint32 invalidIPForOtherCharacterResult = convertIPToNumber(invalidIPForOtherCharacter);
    unitTest(@"Invalid Case For Other Character First", 0, invalidIPForOtherCharacterResult);
    
    char *invalidIPForOtherCharacterMiddle = "172.16o8.5.1.1";
    uint32 invalidIPForOtherCharacterMiddleResult = convertIPToNumber(invalidIPForOtherCharacterMiddle);
    unitTest(@"Invalid Case For Other Character Middle", 0, invalidIPForOtherCharacterMiddleResult);
    
    char *invalidIPForOtherCharacterLast = "172.168.5.1o";
    uint32 invalidIPForOtherCharacterLastResult = convertIPToNumber(invalidIPForOtherCharacterLast);
    unitTest(@"Invalid Case For Other Character Last", 0, invalidIPForOtherCharacterLastResult);
    
    return 0;
}
