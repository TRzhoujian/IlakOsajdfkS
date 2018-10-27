//
//  DDDViewController.m
//  DengShi
//
//  Created by MacBook on 2018/10/25.
//  Copyright © 2018年 DS_PD. All rights reserved.
//

#import "DDDViewController.h"
#import "TextBtnCollectionViewCell.h"
@interface DDDViewController ()

@property (strong, nonatomic) UIButton *FirstSelebtn;
@end

@implementation DDDViewController
{
    float firstSection;
    float thirdSection;
    float CollectionSpacing;
    float ItemWidth;
    float ItemHeight;
    UIImage *image;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    firstSection = 5;
    thirdSection = 6;
    self.view.frame = CGRectMake(0, 0, SHOWVIEW_WIDTH, ZN_SCREEN_HEIGHT);
    [_collectionView registerNib:[UINib nibWithNibName:@"TextBtnCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TextBtnCellID"];

    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    ItemWidth = (self.view.frame.size.width - 3*thirdSection)/2;
    ItemHeight = ItemWidth;
    image = [UIImage imageNamed:@"deng1"];
}

// 返回分区数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
// 每个分区多少个item
- (NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else {
        return 5;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TextBtnCollectionViewCell *cell= [collectionView dequeueReusableCellWithReuseIdentifier:@"TextBtnCellID" forIndexPath:indexPath];
        [cell.TextBtn addTarget:self action:@selector(textButton:) forControlEvents:UIControlEventTouchUpInside];
        cell.TextBtn.tag = indexPath.row;
        return cell;


}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{


    //    if([self.delegate respondsToSelector:@selector(didSelectItemAtIndexPath:cell:)]) {
    //        [self.delegate didSelectItemAtIndexPath:indexPath.row cell:self];
    //    }
}
-(void)textButton:(UIButton *)btn{
    if( ![_FirstSelebtn isEqual: btn]){
        btn.backgroundColor = [UIColor whiteColor];
        btn.selected = !btn.selected;
        _FirstSelebtn.backgroundColor = [UIColor clearColor];
        _FirstSelebtn.selected = !_FirstSelebtn.selected;
        _FirstSelebtn = btn;
    }

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        float ItemWidth = (self.view.frame.size.width - 9*firstSection)/2;
        return CGSizeMake(ItemWidth-0.5 , ItemWidth/4);
    }

    return CGSizeMake(ItemWidth-0.5 , ItemHeight);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return UIEdgeInsetsMake(firstSection*4, firstSection*4,firstSection*4, firstSection*4);
    }
    return UIEdgeInsetsMake(thirdSection, thirdSection,thirdSection, thirdSection);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return firstSection;
    }
    return thirdSection;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return firstSection;
    }
    return thirdSection;
}


@end
