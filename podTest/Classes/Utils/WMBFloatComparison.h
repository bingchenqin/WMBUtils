//
//  WMBFloatComparison.h
//  waimaibiz
//
//  Created by liuyanming on 27/03/2017.
//  Copyright © 2017 meituan. All rights reserved.
//

#import <Foundation/Foundation.h>

/// copied from waimai_ios

typedef double WMMoney;

/**
 *  float类型的关系对比
 */
BOOL WMFloatEqualToFloat(float firstValue, float secondValue);
BOOL WMFloatGreaterThanOrEqualToFloat(float firstValue, float secondValue);
BOOL WMFloatLessThanOrEqualToFloat(float firstValue, float secondValue);
BOOL WMFloatGreaterThanFloat(float firstValue, float secondValue);
BOOL WMFloatLessThanFloat(float firstValue, float secondValue);

/**
 *  double类型的关系对比
 *  比较时差值绝对值为0.000001（小数点后5个0）。这样的比较方式能够确保在double情况下，整数部分最大能够取到999999999（10位）时没有误差
 */
BOOL WMDoubleEqualToDouble(double firstValue, double secondValue);
BOOL WMDoubleGreaterThanOrEqualToDouble(double firstValue, double secondValue);
BOOL WMDoubleLessThanOrEqualToDouble(double firstValue, double secondValue);
BOOL WMDoubleGreaterThanDouble(double firstValue, double secondValue);
BOOL WMDoubleLessThanDouble(double firstValue, double secondValue);

/**
 *  WMMoney类型的关系对比
 *  与double对比精度相同
 */
BOOL WMMoneyEqualToMoney(WMMoney firstValue, WMMoney secondValue);
BOOL WMMoneyGreaterThanOrEqualToMoney(WMMoney firstValue, WMMoney secondValue);
BOOL WMMoneyLessThanOrEqualToMoney(WMMoney firstValue, WMMoney secondValue);
BOOL WMMoneyGreaterThanMoney(WMMoney firstValue, WMMoney secondValue);
BOOL WMMoneyLessThanMoney(WMMoney firstValue, WMMoney secondValue);

/**
 *  CGFloat类型的关系对比
 */
BOOL WMCGFloatEqualToCGFloat(CGFloat firstValue, CGFloat secondValue);
BOOL WMCGFloatGreaterThanOrEqualToCGFloat(CGFloat firstValue, CGFloat secondValue);
BOOL WMCGFloatLessThanOrEqualToCGFloat(CGFloat firstValue, CGFloat secondValue);
BOOL WMCGFloatGreaterThanCGFloat(CGFloat firstValue, CGFloat secondValue);
BOOL WMCGFloatLessThanCGFloat(CGFloat firstValue, CGFloat secondValue);
