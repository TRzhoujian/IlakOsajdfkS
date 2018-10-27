//
//  TextBtnCollectionViewCell.m
//  DengShi
//
//  Created by MacBook on 2018/10/24.
//  Copyright © 2018年 DS_PD. All rights reserved.
//

#import "TextBtnCollectionViewCell.h"

@implementation TextBtnCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _TextBtn.layer.cornerRadius = _TextBtn.frame.size.height/20;
    _TextBtn.layer.masksToBounds = YES;
    _TextBtn.layer.borderWidth = 0.5;
    _TextBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
}

@end
