//
//  MKPolygon+WMBAdditions.h
//  waimaibiz
//
//  Created by bailu on 5/30/16.
//  Copyright © 2016 meituan. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKPolygon (WMBAdditions)

@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, assign) BOOL isValid;

@end
