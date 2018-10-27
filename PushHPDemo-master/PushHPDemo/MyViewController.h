//
//  MyViewController.h
//  DengShi
//
//  Created by MacBook on 2018/10/26.
//  Copyright © 2018年 DS_PD. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, ChangeImageType) {
    ChangerBlackGrandType = 1,
    AddImageType,
};
NS_ASSUME_NONNULL_BEGIN

@interface MyViewController : UIViewController
@property (nonatomic, copy) void (^myBlock)(UIImage *image,ChangeImageType ImageType);
-(void)SetFrame;
@end

NS_ASSUME_NONNULL_END
