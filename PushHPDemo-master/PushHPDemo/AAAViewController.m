//
//  AAAViewController.m
//  DengShi
//
//  Created by MacBook on 2018/10/24.
//  Copyright © 2018年 DS_PD. All rights reserved.
//

#import "AAAViewController.h"
#import "ImageCollectionCell.h"
#import "TextBtnCollectionViewCell.h"
@interface AAAViewController ()
@property (strong, nonatomic) IBOutlet UIView *BottomView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *CollectionHeight;

@property (strong, nonatomic) UIButton *FirstSelebtn;
@property (strong, nonatomic) UIButton *SecondSelebtn;
@end

@implementation AAAViewController
{

    float firstSection;
    float SecondSection;
    float thirdSection;
    int secondNumber;
    UIImage *image;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    image = [UIImage imageNamed:@"beijing"];

    firstSection = 5;
    SecondSection = 10;
    thirdSection = 6;
    secondNumber = 5;


    [_collectionView registerNib:[UINib nibWithNibName:@"ImageCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"ImageCellID"];
    [_collectionView registerNib:[UINib nibWithNibName:@"TextBtnCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TextBtnCellID"];




}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.frame = CGRectMake(0, 0, SHOWVIEW_WIDTH, ZN_SCREEN_HEIGHT);
}


// 返回分区数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}
// 每个分区多少个item
- (NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else if (section == 1){
        return secondNumber;
    }else{
        return 5;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==2) {
        ImageCollectionCell *cell= [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCellID" forIndexPath:indexPath];
        cell.ImageView.image = image;
        return cell;
    }else{
        TextBtnCollectionViewCell *cell= [collectionView dequeueReusableCellWithReuseIdentifier:@"TextBtnCellID" forIndexPath:indexPath];
        if (indexPath.section == 0) {
            [cell.TextBtn addTarget:self action:@selector(AtextButton:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [cell.TextBtn addTarget:self action:@selector(BtextButton:) forControlEvents:UIControlEventTouchUpInside];
        }
        cell.TextBtn.tag = indexPath.row;
        return cell;
    }

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        ImageCollectionCell *cell = (ImageCollectionCell *) [collectionView cellForItemAtIndexPath:indexPath];
        self.myBlock(cell.ImageView.image,AddImageType);
    }
}
-(void)AtextButton:(UIButton *)btn{
    if(![_FirstSelebtn isEqual: btn]){
        btn.backgroundColor = [UIColor whiteColor];
        btn.selected = !btn.selected;
        _FirstSelebtn.backgroundColor = [UIColor clearColor];
        _FirstSelebtn.selected = !_FirstSelebtn.selected;
        _FirstSelebtn = btn;
        if (_FirstSelebtn && _SecondSelebtn) {
            if (_FirstSelebtn.tag == 0 && _SecondSelebtn.tag == 3) {
                image = [UIImage imageNamed:@"beijing2"];
            }else{
                image = [UIImage imageNamed:@"beijing"];
            }
            [_collectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
        }

    }

}
-(void)BtextButton:(UIButton *)btn{
    if( ![_SecondSelebtn isEqual:btn]  ){
        btn.backgroundColor = [UIColor whiteColor];
        btn.selected = !btn.selected;
        _SecondSelebtn.backgroundColor = [UIColor clearColor];
        _SecondSelebtn.selected = !_SecondSelebtn.selected;
        _SecondSelebtn = btn;
        if (_FirstSelebtn && _SecondSelebtn) {
            if (_FirstSelebtn.tag == 0 && _SecondSelebtn.tag == 3) {
                image = [UIImage imageNamed:@"beijing2"];
            }else{
                image = [UIImage imageNamed:@"beijing"];
            }
            [_collectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
        }

    }

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        float ItemWidth = (self.view.frame.size.width - 6*firstSection)/3;
        return CGSizeMake(ItemWidth-0.5 , ItemWidth/3);
    }else if (indexPath.section == 1){
        float ItemWidth = (self.view.frame.size.width - 5*SecondSection)/4;
        return CGSizeMake(ItemWidth-0.5 , ItemWidth/3);
    }
    float ItemWidth = (self.view.frame.size.width - 3*thirdSection)/2;
    return CGSizeMake(ItemWidth-0.5 , ItemWidth*2.5/4);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
       return UIEdgeInsetsMake(firstSection*4, firstSection*2,firstSection*4, firstSection*2);
    }else if (section == 1){
        return UIEdgeInsetsMake(0, SecondSection,SecondSection, SecondSection);;
    }
    return UIEdgeInsetsMake(thirdSection, thirdSection,thirdSection, thirdSection);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return firstSection;
    }else if (section == 1){
        return SecondSection;
    }
    return thirdSection;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return firstSection;
    }else if (section == 1){
        return SecondSection;
    }
    return thirdSection;
}
@end
