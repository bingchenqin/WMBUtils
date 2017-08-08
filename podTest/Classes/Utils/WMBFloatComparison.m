//
//  WMBFloatComparison.m
//  waimaibiz
//
//  Created by liuyanming on 27/03/2017.
//  Copyright © 2017 meituan. All rights reserved.
//

#import "WMBFloatComparison.h"

BOOL WMFloatEqualToFloat(float firstValue, float secondValue)
{
    return fabsf(firstValue - secondValue) < 0.0001;
}

BOOL WMFloatGreaterThanOrEqualToFloat(float firstValue, float secondValue)
{
    return (firstValue > secondValue || WMFloatEqualToFloat(firstValue, secondValue));
}

BOOL WMFloatLessThanOrEqualToFloat(float firstValue, float secondValue)
{
    return (firstValue < secondValue || WMFloatEqualToFloat(firstValue, secondValue));
}

BOOL WMFloatGreaterThanFloat(float firstValue, float secondValue)
{
    return (firstValue > secondValue && !WMFloatEqualToFloat(firstValue, secondValue));
}

BOOL WMFloatLessThanFloat(float firstValue, float secondValue)
{
    return (firstValue < secondValue && !WMFloatEqualToFloat(firstValue, secondValue));
}

BOOL WMDoubleEqualToDouble(double firstValue, double secondValue)
{
    return fabs(firstValue - secondValue) < 0.000001;
}

BOOL WMDoubleGreaterThanOrEqualToDouble(double firstValue, double secondValue)
{
    return (firstValue > secondValue || WMDoubleEqualToDouble(firstValue, secondValue));
}

BOOL WMDoubleLessThanOrEqualToDouble(double firstValue, double secondValue)
{
    return (firstValue < secondValue || WMDoubleEqualToDouble(firstValue, secondValue));
}

BOOL WMDoubleGreaterThanDouble(double firstValue, double secondValue)
{
    return (firstValue > secondValue && !WMDoubleEqualToDouble(firstValue, secondValue));
}

BOOL WMDoubleLessThanDouble(double firstValue, double secondValue)
{
    return (firstValue < secondValue && !WMDoubleEqualToDouble(firstValue, secondValue));
}

BOOL WMMoneyEqualToMoney(WMMoney firstValue, WMMoney secondValue)
{
    return WMDoubleEqualToDouble(firstValue, secondValue);
}

BOOL WMMoneyGreaterThanOrEqualToMoney(WMMoney firstValue, WMMoney secondValue)
{
    return WMDoubleGreaterThanOrEqualToDouble(firstValue, secondValue);
}

BOOL WMMoneyLessThanOrEqualToMoney(WMMoney firstValue, WMMoney secondValue)
{
    return WMDoubleLessThanOrEqualToDouble(firstValue, secondValue);
}

BOOL WMMoneyGreaterThanMoney(WMMoney firstValue, WMMoney secondValue)
{
    return WMDoubleGreaterThanDouble(firstValue, secondValue);
}

BOOL WMMoneyLessThanMoney(WMMoney firstValue, WMMoney secondValue)
{
    return WMDoubleLessThanDouble(firstValue, secondValue);
}

BOOL WMCGFloatEqualToCGFloat(CGFloat firstValue, CGFloat secondValue)
{
#if CGFLOAT_IS_DOUBLE
    return WMDoubleEqualToDouble(firstValue, secondValue);
#else
    return WMFloatEqualToFloat(firstValue, secondValue);
#endif
}

BOOL WMCGFloatGreaterThanOrEqualToCGFloat(CGFloat firstValue, CGFloat secondValue)
{
#if CGFLOAT_IS_DOUBLE
    return WMDoubleGreaterThanOrEqualToDouble(firstValue, secondValue);
#else
    return WMFloatGreaterThanOrEqualToFloat(firstValue, secondValue);
#endif
}

BOOL WMCGFloatLessThanOrEqualToCGFloat(CGFloat firstValue, CGFloat secondValue)
{
#if CGFLOAT_IS_DOUBLE
    return WMDoubleLessThanOrEqualToDouble(firstValue, secondValue);
#else
    return WMFloatLessThanOrEqualToFloat(firstValue, secondValue);
#endif
}

BOOL WMCGFloatGreaterThanCGFloat(CGFloat firstValue, CGFloat secondValue)
{
#if CGFLOAT_IS_DOUBLE
    return WMDoubleGreaterThanDouble(firstValue, secondValue);
#else
    return WMFloatGreaterThanFloat(firstValue, secondValue);
#endif
}

BOOL WMCGFloatLessThanCGFloat(CGFloat firstValue, CGFloat secondValue)
{
#if CGFLOAT_IS_DOUBLE
    return WMDoubleLessThanDouble(firstValue, secondValue);
#else
    return WMFloatLessThanFloat(firstValue, secondValue);
#endif
}
