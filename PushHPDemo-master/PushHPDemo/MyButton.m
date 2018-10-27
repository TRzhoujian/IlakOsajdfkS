//
//  MyButton.m
//  DengShi
//
//  Created by MacBook on 2018/10/24.
//  Copyright © 2018年 DS_PD. All rights reserved.
//

#import "MyButton.h"

@implementation MyButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, 0, contentRect.size.width, contentRect.size.width);

}
@end
