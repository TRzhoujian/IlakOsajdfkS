//
//  XMNSizeView.m
//  XMNSizeTextExample
//
//  Created by shscce on 15/11/26.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import "XMNRotateScaleView.h"


CG_INLINE CGFloat CGPointGetDistance(CGPoint point1, CGPoint point2)
{
    //Saving Variables.
    CGFloat fx = (point2.x - point1.x);
    CGFloat fy = (point2.y - point1.y);
    
    return sqrt((fx*fx + fy*fy));
}

CG_INLINE CGRect CGRectScale(CGRect rect, CGFloat wScale, CGFloat hScale)
{
    return CGRectMake(0, 0 , rect.size.width * wScale, rect.size.height * hScale);
}



@interface XMNRotateScaleView ()
{
    //1.放大手势需要用到的变量
    CGRect  _initalFrame; /**< 放大之前的XMNTextField的frame */
    CGFloat _initalDistance; /**< 放大之前触摸点距离XMNTextField center的距离 */
    CGPoint _initCenter; /**< 放大之前XMNTextField的center */
    CGFloat _initAngle; /**< 旋转之前角度 */
    
    CGPoint _touchStart;
    
    BOOL _moved; /**< touchEnd时根据_moved判断是否移动过,未移动则改写state */
}

@property (nonatomic, strong) UIImageView *rotateScaleIV;
@property (nonatomic, strong) UIImageView *CancelIV;
@property (nonatomic, strong) CAShapeLayer *borderLayer;

@end

@implementation XMNRotateScaleView


#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    
    if ([super initWithFrame:frame]) {
        [self setup];
    }
    return self;
    
}

#pragma mark - Public Methods

/**
 *  重写setBounds方法
 */
- (void)setBounds:(CGRect)bounds {


    //重新计算bounds,缩放到最小的size后,不能继续缩放
    CGRect scaleRect = bounds;
    if (scaleRect.size.width < self.minSize.width && scaleRect.size.height < self.minSize.height) {
        scaleRect= CGRectMake(0, 0, self.minSize.width, self.minSize.height);
    }else if (scaleRect.size.width < self.minSize.width) {
        scaleRect= CGRectMake(0, 0, self.minSize.width, scaleRect.size.height);
    }else if (scaleRect.size.height < self.minSize.height) {
        scaleRect= CGRectMake(0, 0, scaleRect.size.width, self.minSize.height);
    }
    self.borderLayer.path = [UIBezierPath bezierPathWithRect:CGRectInset(scaleRect, kXMNBorderInset, kXMNBorderInset)].CGPath;
    [super setBounds:scaleRect];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    _touchStart = [[touches anyObject] locationInView:self.superview];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if (!_moved) {
        [self setState:!self.state];
    }else {
        [self setState:self.state];
    }
    _moved = NO;
}
-(void)ShowOrHideView:(BOOL)state{
    [self setState:!state];
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    CGPoint touch = [[touches anyObject] locationInView:self.superview];
    [self translateUsingTouchLocation:touch];
    self.rotateScaleIV.hidden = YES;
    self.CancelIV.hidden = YES;
    _touchStart = touch;
    _moved = YES;
}

#pragma mark - Private Methods

- (void)setup {
    
    //1.计算出中心center,为重写计算frame前,用来确定view的位置
    _initCenter = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    //2.初始化默认borderColor,borderWidth
    self.borderColor = [UIColor whiteColor];
    self.borderWidth = 1.0f;
    
    //3.初始化默认最小大小
    self.minSize = CGSizeMake(60, 60);
    
    //4.设置默认状态
    self.state = XMNRotateScaleViewStateNormal;
    
    //5.添加旋转控制IV,边框
    [self addSubview:self.rotateScaleIV];
    [self addSubview:self.CancelIV];
    [self.layer addSublayer:self.borderLayer];
    
    //6.计算当前旋转角度
    _initAngle = atan2(self.frame.origin.y+self.frame.size.height - self.center.y,self.frame.origin.x+self.frame.size.width - self.center.x);

}


- (void)handleRotateScalePan:(UIPanGestureRecognizer *)pan {
    
    CGPoint touchPoint = [pan locationInView:self.superview];
    CGPoint center = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    if (pan.state == UIGestureRecognizerStateBegan) {
        _initAngle = atan2(touchPoint.y-center.y, touchPoint.x-center.x)-atan2(self.transform.b, self.transform.a);
        _initCenter = self.center;
        _initalFrame = self.frame;
        _initalDistance = CGPointGetDistance(center, touchPoint);
    }else if (pan.state == UIGestureRecognizerStateChanged) {
        self.rotateScaleIV.hidden = YES;
        self.CancelIV.hidden = YES;
        /* Rotation */
        float ang = atan2([pan locationInView:self.superview].y - self.center.y,
                          [pan locationInView:self.superview].x - self.center.x);
        float angleDiff = _initAngle - ang;
        self.transform = CGAffineTransformMakeRotation(-angleDiff);
        [self setNeedsDisplay];
        
        double scale = sqrtf(CGPointGetDistance(center, touchPoint)/_initalDistance);
        CGRect scaleRect = CGRectScale(_initalFrame, scale, scale);
        self.bounds = CGRectMake(0, 0, scaleRect.size.width, scaleRect.size.height);
        self.center = _initCenter;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(rotateScaleViewDidRotateAndScale:)]) {
            [self.delegate rotateScaleViewDidRotateAndScale:self];
        }
        
    }else {
        self.rotateScaleIV.hidden = NO;
        self.CancelIV.hidden = NO;
        _initAngle = atan2(self.transform.b, self.transform.a);
    }
}

- (void)translateUsingTouchLocation:(CGPoint)touchPoint {
    CGPoint newCenter = CGPointMake(self.center.x + touchPoint.x - _touchStart.x,
                                    self.center.y + touchPoint.y - _touchStart.y);
    self.center = newCenter;
}

#pragma mark - Setters

- (void)setContentView:(UIView *)contentView {
    [_contentView removeFromSuperview];
    
    _contentView = contentView;
    _contentView.frame = CGRectInset(self.bounds, kXMNInset + kXMNBorderInset, kXMNInset + kXMNBorderInset);
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self addSubview:contentView];
    [self bringSubviewToFront:self.rotateScaleIV];
    [self bringSubviewToFront:self.CancelIV];
}

- (void)setMinSize:(CGSize)minSize {
    _minSize = CGSizeMake(2*(kXMNInset + kXMNBorderInset) + minSize.width, 2*(kXMNInset + kXMNBorderInset) + minSize.height);
    CGRect scaleRect = self.bounds;
    if (scaleRect.size.width < self.minSize.width && scaleRect.size.height < self.minSize.height) {
        scaleRect= CGRectMake(0, 0, self.minSize.width, self.minSize.height);
    }else if (scaleRect.size.width < self.minSize.width) {
        scaleRect= CGRectMake(0, 0, self.minSize.width, scaleRect.size.height);
    }else if (scaleRect.size.height < self.minSize.height) {
        scaleRect= CGRectMake(0, 0, scaleRect.size.width, self.minSize.height);
    }
    self.bounds = scaleRect;
    self.center = _initCenter;
}

- (void)setState:(XMNRotateScaleViewState)state {

    _state = state;
    if (state == XMNRotateScaleViewStateEditing) {
        self.rotateScaleIV.hidden = NO;
        self.CancelIV.hidden = NO;
        self.borderLayer.hidden = NO;
    }else {
        self.rotateScaleIV.hidden = YES;
        self.CancelIV.hidden = YES;
        self.borderLayer.hidden = YES;
    }
}

#pragma mark - Getters

- (UIImageView *)rotateScaleIV {
    if (!_rotateScaleIV) {
        _rotateScaleIV = [[UIImageView alloc] initWithFrame:CGRectMake(self.width-self.height/5, self.height-self.height/5, self.height/5, self.height/5)];
        _rotateScaleIV.image = [UIImage imageNamed:@"icon_zoom"];
        _rotateScaleIV.userInteractionEnabled = YES;
        _rotateScaleIV.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        
        UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotateScalePan:)];
        [_rotateScaleIV addGestureRecognizer:panGes];

    }
    return _rotateScaleIV;
}
- (UIImageView *)CancelIV {
    if (!_CancelIV) {
        _CancelIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.height/5, self.height/5)];
        _CancelIV.image = [UIImage imageNamed:@"icon_close"];
        _CancelIV.userInteractionEnabled = YES;
        _CancelIV.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;

        UITapGestureRecognizer *TapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCancelTap:)];
        [_CancelIV addGestureRecognizer:TapGes];

    }
    return _CancelIV;
}

-(void)handleCancelTap:(UITapGestureRecognizer *)Tap{
    if (self.delegate && [self.delegate respondsToSelector:@selector(CancelImageToView:)]) {
        [self.delegate CancelImageToView:self];
    }
}

- (CAShapeLayer *)borderLayer {
    if (!_borderLayer) {
        _borderLayer = [CAShapeLayer layer];
        _borderLayer.fillColor = nil;
        _borderLayer.lineWidth = self.borderWidth;
//        _borderLayer.lineDashPattern = @[@4, @3];
        _borderLayer.strokeColor = self.borderColor.CGColor;
    }
    return _borderLayer;
}


@end
