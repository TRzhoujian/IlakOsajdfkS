//
//  ViewController.m
//  CMuneBarDemo
//
//  Created by macairwkcao on 16/1/28.
//  Copyright © 2016年 CWK. All rights reserved.
//

#import "MainViewController.h"
#import "ShowView.h"
#import "CMuneBar.h"
#import "AAAViewController.h"
#import "BBBViewController.h"
#import "CCCViewController.h"
#import "DDDViewController.h"
#import "AppDelegate.h"
#import "XMNRotateScaleView.h"
@interface MainViewController ()<CMuneBarDelegate,XMNRotateScaleViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property(nonatomic,strong)CMuneBar *muneBar;
@property(nonatomic,strong)ShowView *showView;
@property(nonatomic,strong)AAAViewController *AAA;
@property(nonatomic,strong)BBBViewController *BBB;
@property(nonatomic,strong)CCCViewController *CCC;
@property(nonatomic,strong)DDDViewController *DDD;
@property(nonatomic,strong)CCCViewController *EEE;
@property(nonatomic,assign) CGRect BottomViewFrame;
@property(nonatomic,assign) CGRect ShowViewFrame;
@property (strong, nonatomic) IBOutlet UIButton *TapBtn;
@property (strong, nonatomic) IBOutlet UIView *ProductMessageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *BackBtnTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *BackBtnLeft;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *ProductMessageWithBackBtnLeft;
@property (strong, nonatomic) IBOutlet UIImageView *BeiJingView;
@property (strong, nonatomic) IBOutlet MyButton *BackButton;
@property(nonatomic,assign) BOOL isShow;
@property(nonatomic,assign) BOOL ViewBtnIsShow;
@end
@implementation MainViewController
{
    NSInteger Index;
    NSMutableArray *ViewArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
     ViewArr = [NSMutableArray array];
    _BackBtnTop.constant = ZN_SCREEN_HEIGHT/45;
    _BackBtnLeft.constant = ZN_SCREEN_HEIGHT/40;
    _ProductMessageWithBackBtnLeft.constant = _BackBtnLeft.constant;
    _ProductMessageView.layer.cornerRadius = _ProductMessageView.frame.size.height/15;
    _ProductMessageView.layer.masksToBounds = YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if([[UIDevice currentDevice]respondsToSelector:@selector(setOrientation:)]) {

        SEL selector = NSSelectorFromString(@"setOrientation:");

        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];

        [invocation setSelector:selector];

        [invocation setTarget:[UIDevice currentDevice]];

        int val = UIInterfaceOrientationLandscapeLeft;//横屏

        [invocation setArgument:&val atIndex:2];

        [invocation invoke];

    }

    _BottomViewFrame = _bottomView.frame;
    self.muneBar = [[CMuneBar alloc] initWithItems:@[@"icon_help",@"icon_history",@"icon_cart",@"icon_lights",@"icon_scene"] size:CGSizeMake(MuneBtnWidth, MuneBtnWidth) type:kMuneBarTypeLineBottom];
    _muneBar.delegate = self;
    [self.view addSubview:_muneBar];


    _showView =  [[[NSBundle mainBundle] loadNibNamed:@"ShowView"owner:self options:nil] objectAtIndex:0];
    _showView.frame = CGRectMake(ZN_SCREEN_WIDTH, 0, SHOWVIEW_WIDTH, ZN_SCREEN_HEIGHT);

    [self.view addSubview:_showView];
    _ShowViewFrame = _showView.frame;
    [self setShowSubView];


}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
//支持的方向
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft;
}

//是否可以旋转
-(BOOL)shouldAutorotate
{
    return YES;
}
- (IBAction)Back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)setShowSubView{
    __weak __typeof__(self) weakSelf = self;
    _AAA = [AAAViewController new];
    _AAA.myBlock = ^(UIImage * _Nonnull image, ChangeImageType ImageType) {
        weakSelf.BeiJingView.image = image;
    };
    [self addChildViewController:_AAA];
    _BBB = [BBBViewController new];
    _BBB.myBlock= ^(UIImage * _Nonnull image, ChangeImageType ImageType) {
        [weakSelf addImageView:image];
    };
    [self addChildViewController:_BBB];
    _EEE = [CCCViewController new];
    [self addChildViewController:_EEE];
    _CCC = [CCCViewController new];
    _CCC.myBlock = ^(UIImage * _Nonnull image, ChangeImageType ImageType) {
        if (ImageType == AddImageType) {
            [weakSelf addImageView:image];
        }else{
            weakSelf.BeiJingView.image = image;
        }
    };
    [self addChildViewController:_CCC];
    _DDD = [DDDViewController new];
    [self addChildViewController:_DDD];

    [ViewArr addObjectsFromArray:@[_DDD,_CCC,_EEE,_BBB,_AAA]];
}


-(void)addImageView:(UIImage *)image{
    __weak __typeof__(self) weakSelf = self;
    XMNRotateScaleView *rotateScaleView = [[XMNRotateScaleView alloc] initWithFrame:CGRectMake(ZN_SCREEN_WIDTH/2 - ZN_SCREEN_HEIGHT/6, ZN_SCREEN_HEIGHT/2-ZN_SCREEN_HEIGHT/6, ZN_SCREEN_HEIGHT/3, ZN_SCREEN_HEIGHT/3)];
    rotateScaleView.delegate = weakSelf;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    rotateScaleView.contentView = imageView;
    [weakSelf.TapBtn addSubview:rotateScaleView];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:weakSelf action:@selector(btnLong:)];
    longPress.minimumPressDuration = 0.5; //定义按的时间
    [rotateScaleView addGestureRecognizer:longPress];
}



-(void)CancelImageToView:(UIView *)RotateScaleView{
    [RotateScaleView removeFromSuperview];
}

-(void)btnLong:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        _ProductMessageView.hidden = NO;
        [UIView animateWithDuration:0.5 animations:^{
            _ProductMessageView.alpha = 0.7;
        }];
    }
}

-(void)muneBarselected:(NSInteger)index{
    if (index != 2) {
        if (Index == index || _isShow == NO) {
            _isShow = !_isShow;
        }
        Index = index;
        for (int i = 0; i < ViewArr.count; i++) {
            MyViewController *VC  = ViewArr[i];
            if (i != index) {
                VC.view.hidden = YES;
            }
        }
        MyViewController *VC  = ViewArr[index];
        VC.view.hidden = NO;
        [_showView addSubview:VC.view];
        [self MovedMuneBer:_isShow MuneBarMinX:ZN_SCREEN_WIDTH - SHOWVIEW_WIDTH - MuneBtnWidth -10];
        [VC SetFrame];
    }
}


-(void)MovedMuneBer:(BOOL)Show MuneBarMinX:(float)MuneBarMinX{
    if (_showView.height != ZN_SCREEN_HEIGHT) {
        _showView.height = ZN_SCREEN_HEIGHT;
    }
    if (Show == YES) {
         __weak __typeof__(self) weakSelf = self;
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.muneBar.x = MuneBarMinX;
            weakSelf.showView.frame = CGRectMake(ZN_SCREEN_WIDTH - SHOWVIEW_WIDTH, 0, SHOWVIEW_WIDTH, ZN_SCREEN_HEIGHT);
            CGRect frame = weakSelf.bottomView.frame;
            if (MuneBarMinX > CGRectGetMinX(frame)) {
                [weakSelf.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(weakSelf.view).offset(-(ZN_SCREEN_WIDTH/2 - weakSelf.muneBar.x + weakSelf.bottomView.width/2 + 10));
                }];

                [weakSelf.bottomView.superview layoutIfNeeded];
            }
        }];

    }else{
//        [self hideShowView];
    }
}

- (IBAction)TapClick:(id)sender {
    _isShow = YES;
    Index = -1;
    [self hideShowView];

    [UIView animateWithDuration:0.5 animations:^{
        _ProductMessageView.alpha = 0;
    } completion:^(BOOL finished) {
        _ProductMessageView.hidden = YES;
    }];
}

- (IBAction)DoubleTap:(UITapGestureRecognizer *)sender {
    _ViewBtnIsShow = !_ViewBtnIsShow;
    if (_ViewBtnIsShow == YES) {
        [UIView animateWithDuration:0.5 animations:^{
            _muneBar.alpha = 0;
            _bottomView.alpha = 0;
            _BackButton.alpha = 0;
            _showView.alpha = 0;
            _ProductMessageView.alpha = 0;
        }];

    }else{
        [UIView animateWithDuration:0.5 animations:^{
            _muneBar.alpha = 1;
            _bottomView.alpha = 1;
            _BackButton.alpha = 1;
            _showView.alpha = 0.75;
            if (_ProductMessageView.hidden == YES) {
                _ProductMessageView.alpha = 0.7;
            }

        }];

    }
}

-(void)hideShowView{
    __weak __typeof__(self) weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.muneBar.frame = CGRectMake(ZN_SCREEN_WIDTH - MuneBtnWidth -10, ZN_SCREEN_HEIGHT/30, MuneBtnWidth, MuneBtnWidth);
        [weakSelf.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.view);

        }];
        [weakSelf.bottomView.superview layoutIfNeeded];
        weakSelf.showView.frame = weakSelf.ShowViewFrame;
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
