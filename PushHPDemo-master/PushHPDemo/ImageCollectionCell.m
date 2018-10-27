//
//  ImageCollectionCell.m
//  DengShi
//
//  Created by MacBook on 2018/10/24.
//  Copyright © 2018年 DS_PD. All rights reserved.
//

#import "ImageCollectionCell.h"

@implementation ImageCollectionCell
- (void)awakeFromNib {
    [super awakeFromNib];
    _ImageView.layer.cornerRadius = _ImageView.frame.size.height/160;
    _ImageView.layer.masksToBounds = YES;
    _ImageView.layer.borderWidth = 1.5;
    _ImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
}

@end
