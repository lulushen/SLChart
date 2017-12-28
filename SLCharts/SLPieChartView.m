//
//  SLPieChartView.m
//  SLCharts
//
//  Created by 上海数聚 on 17/6/1.
//  Copyright © 2017年 上海数聚. All rights reserved.
//

#import "SLPieChartView.h"

@interface SLPieChartView (){
    CGPoint pieCenterPoint;//饼图中心点
    CGFloat radius;//半径
    NSMutableArray * startAngleArray;
    NSMutableArray * endAngleArray;
    UILabel * _displayMarkLabel;
    CGRect   tempRect;
    UIView * _pieView;
    CAShapeLayer *_pieSelectLayer;
}

@property (nonatomic , strong)NSMutableArray * scaleArray;

@property (nonatomic , strong)NSMutableArray * angleArray;

@end

@implementation SLPieChartView


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setupDefaultValues];
    }
    return self;
}
-(void)setupDefaultValues
{
    self.backgroundColor = [UIColor clearColor];
    _labelTextColor = [UIColor whiteColor];
    _labelTextFontSize = 13.0f;
    _isAmination = YES;
    _animationTime = 0.8;
    
    startAngleArray = [NSMutableArray array];
    endAngleArray  = [NSMutableArray array];
   
    _displayMarkLabel = [[UILabel alloc] init];
    _yUnitString = @"";
    _displayMarkLabelBGColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _displayMarkLabelTextColor = [UIColor whiteColor];
    _displayMarkLabelTextFontSize = 13.0f;
    tempRect = CGRectMake(self.frame.origin.x/2.0, self.frame.origin.y/2.0, 0, 0);
   
    UIColor * color1 = [UIColor whiteColor];
    UIColor * color2 = [UIColor colorWithRed:167/255.0 green:186/255.0 blue:40/255.0 alpha:1];
    UIColor * color3 = [UIColor colorWithRed:251/255.0 green:198/255.0 blue:17/255.0 alpha:1];
    UIColor * color4 = [UIColor colorWithRed:225/255.0 green:104/255.0 blue:14/255.0 alpha:1];
    UIColor * color5 = [UIColor colorWithRed:32/255.0 green:94/255.0 blue:104/255.0 alpha:1];
    UIColor * color6 = [UIColor colorWithRed:252/255.0 green:110/255.0 blue:81/255.0 alpha:1];
    _pieColorArray = [NSMutableArray arrayWithObjects:color1,color2,color3,color4,color5,color6, nil];
   
    _pieView = [[UIView alloc] init];
    _pieView.backgroundColor = [UIColor clearColor];
    [self addSubview:_pieView];
    _pieSelectLayer = [[CAShapeLayer alloc] init];
}
- (void)setYValueAndScaleAngle
{
    CGFloat sum = 0;
    
    for (int i = 0 ; i < _yValuesArray.count; i++) {
        
        sum = sum + [_yValuesArray[i] floatValue];
    }
    CGFloat scaleNumber = 0;
    _scaleArray = [NSMutableArray array];
    _angleArray = [NSMutableArray array];
    
    if (sum != 0) {
        for (int i = 0; i < _yValuesArray.count; i++) {
            
            scaleNumber = [_yValuesArray[i] floatValue]/sum;
            
            [_scaleArray addObject:[NSNumber numberWithFloat:scaleNumber]];
            [_angleArray addObject: [NSNumber numberWithFloat:scaleNumber * (M_PI*2)]];
        }
    }
}
-(void)drawRect:(CGRect)rect
{
    _pieView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    if (_yValuesArray.count > 6) {
        
        for (int i = 0 ; i < _yValuesArray.count-6; i++) {
            UIColor * color =  [UIColor colorWithRed:arc4random_uniform(254)/255.0 green:arc4random_uniform(254)/255.0 blue:arc4random_uniform(254)/255.0 alpha:1];
            [_pieColorArray addObject:color];

        }
    }

    if (_xValuesArray.count !=0 && _yValuesArray.count != 0) {
        [self setYValueAndScaleAngle];
        pieCenterPoint= CGPointMake(self.frame.size.width/2.0  , self.frame.size.height/2.0);
        //_bezierPath形成闭合的扇形路径
        radius = MIN((self.frame.size.width-40)/2.0, (self.frame.size.height-40)/2.0);
        
        
        CGFloat startAngle = -M_PI_2;
        CGFloat endAngle = M_PI_2 * 3;
        CGFloat  midAngle = 0.0;
        UIBezierPath *bgPath = [UIBezierPath bezierPathWithArcCenter:pieCenterPoint radius:radius/2.0 startAngle:startAngle endAngle:endAngle clockwise:YES];
        CAShapeLayer *bgLayer = [[CAShapeLayer alloc] init];
        if (_isAmination == YES) {
            //扇形动画从头到尾
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            animation.duration  = _animationTime;
            animation.fromValue = @0.0f;
            animation.toValue   = @1.0f;
            [bgLayer addAnimation:animation forKey:@"circleAnimation"];
            [_pieView.layer addSublayer:bgLayer];

        }
        bgLayer.fillColor   = [UIColor clearColor].CGColor;
        bgLayer.strokeColor = [UIColor lightGrayColor].CGColor;
        bgLayer.strokeStart = 0.0f;
        bgLayer.strokeEnd   = 1.0f;
        bgLayer.lineWidth   = radius;
        bgLayer.path        = bgPath.CGPath;
        _pieView.layer.mask = bgLayer;
        UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:pieCenterPoint
                                                                 radius:radius
                                                             startAngle:startAngle
                                                               endAngle:endAngle
                                                              clockwise:YES];
        endAngle = 0.0;
    for (int i = 0 ; i < _scaleArray.count; i++) {
            
            endAngle = startAngle + [_angleArray[i] floatValue] ;
            midAngle = startAngle + [_angleArray[i] floatValue]/2.0 ;
      
            path = [UIBezierPath bezierPathWithArcCenter:pieCenterPoint
                                              radius:radius
                                          startAngle:startAngle
                                            endAngle:endAngle
                                           clockwise:YES];
            [path addLineToPoint:pieCenterPoint];
            CAShapeLayer *pieLayer = [[CAShapeLayer alloc] init];
            [_pieView.layer addSublayer:pieLayer];
            pieLayer.fillColor = ((UIColor*)_pieColorArray[i]).CGColor;
            pieLayer.path = path.CGPath;
            [startAngleArray addObject:[NSNumber numberWithFloat:startAngle]];
            [endAngleArray addObject:[NSNumber numberWithFloat:endAngle]];
            startAngle = endAngle;

            if (_isAmination == YES) {

                //旋转动画
                CABasicAnimation * rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
                rotateAnimation.fromValue = [NSNumber numberWithFloat:-2];
                rotateAnimation.toValue =  [NSNumber numberWithFloat:0];
                rotateAnimation.duration = _animationTime;
                
                rotateAnimation.repeatCount = 1;
                [_pieView.layer addAnimation:rotateAnimation forKey:@"transformRotation"];
                //设定为缩放动画
                CABasicAnimation * zoomAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                zoomAnimation.fromValue = [NSNumber numberWithFloat:0.5f];;
                zoomAnimation.toValue = [NSNumber numberWithFloat:1.f];;
                zoomAnimation.duration = _animationTime;
                zoomAnimation.repeatCount = 1;
                [_pieView.layer addAnimation:zoomAnimation forKey:@"transformScale"];
            }
            //画标示线和标示label
            CGFloat tempAngle = 0.0;
            tempAngle = fabs(midAngle);
            UIBezierPath *linePath = [UIBezierPath bezierPathWithArcCenter:pieCenterPoint radius:radius startAngle:midAngle-M_PI/180 endAngle:midAngle clockwise:YES];
            UIBezierPath* linePathTwo = [UIBezierPath bezierPathWithArcCenter:pieCenterPoint radius:radius+10 startAngle:midAngle-M_PI/180 endAngle:midAngle clockwise:YES];
            [linePath addLineToPoint:linePathTwo.currentPoint];
            CGPoint tempPoint ;
            if (linePathTwo.currentPoint.x < pieCenterPoint.x) {
                tempPoint = CGPointMake(linePathTwo.currentPoint.x-15, linePathTwo.currentPoint.y);
            }else{
                tempPoint = CGPointMake(linePathTwo.currentPoint.x+15, linePathTwo.currentPoint.y);
            }
            [linePath addLineToPoint:tempPoint];
            CAShapeLayer *lineLayer = [[CAShapeLayer alloc] init];
            lineLayer.lineWidth = 1;
            lineLayer.frame = self.bounds;
            lineLayer.path = linePath.CGPath;
            lineLayer.fillColor = [UIColor clearColor].CGColor;
            lineLayer.strokeColor = ((UIColor*)_pieColorArray[i]).CGColor;
            lineLayer.frame = self.bounds;
            [self.layer addSublayer:lineLayer];
            if (_isAmination == YES) {
                //缩放变化
                CABasicAnimation * lineAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
                lineAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 0, 1)];
                lineAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
                lineAnimation.removedOnCompletion = YES;
                lineAnimation.duration = _animationTime;
                [lineLayer addAnimation:lineAnimation forKey:@"transform"];

            }
            UILabel * markLabel = [[UILabel alloc] init];
            if (_xValuesArray.count-1 >= i) {
                NSString * labelTextString = [NSString stringWithFormat:@"%@",_xValuesArray[i]];
                markLabel.numberOfLines = 0;
                markLabel.text = labelTextString;
                if (labelTextString.length == 0) {
                    labelTextString = @"";
                }
                markLabel.font = [UIFont systemFontOfSize:_labelTextFontSize];
                markLabel.textColor = _labelTextColor;
                [self addSubview:markLabel];
                CGRect sizeToFit = [labelTextString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSForegroundColorAttributeName:_labelTextColor,NSFontAttributeName:markLabel.font } context:nil];
                if (linePathTwo.currentPoint.x < pieCenterPoint.x) {
                    if (tempPoint.x-5.0-sizeToFit.size.width < 0) {
                        sizeToFit = [labelTextString boundingRectWithSize:CGSizeMake(45, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSForegroundColorAttributeName:_labelTextColor,NSFontAttributeName:markLabel.font } context:nil];
                    }
                    if (_isAmination == YES) {
                        markLabel.frame = CGRectMake(-sizeToFit.size.width, tempPoint.y- sizeToFit.size.height/2.0, sizeToFit.size.width, sizeToFit.size.height);
                        
                        [UIView animateWithDuration:_animationTime animations:^{
                            markLabel.frame = CGRectMake(tempPoint.x-sizeToFit.size.width-5.0, tempPoint.y- sizeToFit.size.height/2.0, sizeToFit.size.width, sizeToFit.size.height);
                        }];
                    }else{
                        markLabel.frame = CGRectMake(tempPoint.x-sizeToFit.size.width-5.0, tempPoint.y- sizeToFit.size.height/2.0, sizeToFit.size.width, sizeToFit.size.height);
 
                    }
                }else{
                    
                    if(tempPoint.x+5.0+sizeToFit.size.width > self.frame.size.width){
                        sizeToFit = [labelTextString boundingRectWithSize:CGSizeMake(45, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSForegroundColorAttributeName:_labelTextColor,NSFontAttributeName:markLabel.font } context:nil];
                    }
                    if (_isAmination == YES ) {
                        markLabel.frame = CGRectMake(self.frame.size.width, tempPoint.y- sizeToFit.size.height/2.0, sizeToFit.size.width, sizeToFit.size.height);
                        [UIView animateWithDuration:_animationTime animations:^{
                            markLabel.frame = CGRectMake(tempPoint.x+5.0, tempPoint.y- sizeToFit.size.height/2.0, sizeToFit.size.width, sizeToFit.size.height);
                        }];
                    }else{
                        markLabel.frame = CGRectMake(tempPoint.x+5.0, tempPoint.y- sizeToFit.size.height/2.0, sizeToFit.size.width, sizeToFit.size.height);

                    }
                   
                    
                }
            }
        }
       
       //添加选中layer
        [self addSubview:_displayMarkLabel];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSSet * allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标

   
    CGFloat a = fabs(point.x- pieCenterPoint.x);
    CGFloat b = fabs(point.y- pieCenterPoint.y);
    CGFloat c = sqrtf((powf(a, 2) + powf(b, 2)));
    if (c <= radius) {
        //所在点的角度
        CGFloat height = point.y - pieCenterPoint.y;
        CGFloat width = point.x - pieCenterPoint.x;
        CGFloat rads = atan(height/width);
        if (point.x < pieCenterPoint.x) {
            rads = rads + M_PI;
        }
       
        for (int i = 0; i < _xValuesArray.count; i++) {
            
            if (startAngleArray.count > 0 && endAngleArray.count >0) {
                if ( rads > [startAngleArray[i] floatValue] && rads <= [endAngleArray[i] floatValue]) {
                    //添加朦板
                    UIBezierPath* pathSelect = [UIBezierPath bezierPathWithArcCenter:pieCenterPoint
                                                                              radius:radius
                                                                          startAngle:[startAngleArray[i] floatValue]
                                                                            endAngle:[endAngleArray[i] floatValue]
                                                                           clockwise:YES];
                    [pathSelect addLineToPoint:pieCenterPoint];                    
                    _pieSelectLayer.fillColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2].CGColor;
                    _pieSelectLayer.path = pathSelect.CGPath;
                     //显示提示标签
                    _displayMarkLabel.alpha = 1;
                    NSString * scaleString = [NSString stringWithFormat:@"%0.2f%%",[_scaleArray[i] floatValue]*100.0];
                    _displayMarkLabel.text = [NSString stringWithFormat:@" %@ : %@ %@,%@",_xValuesArray[i],_yValuesArray[i],_yUnitString,scaleString];
                    if ([self.delegate respondsToSelector:@selector(touchPieChartXValue:yValue:)]) {
                        [self.delegate touchPieChartXValue:_xValuesArray[i] yValue:_yValuesArray[i]];
                    }
                    _displayMarkLabel.textColor = _displayMarkLabelTextColor;
                    _displayMarkLabel.font = [UIFont systemFontOfSize:_displayMarkLabelTextFontSize];
                    _displayMarkLabel.backgroundColor = _displayMarkLabelBGColor;
                    _displayMarkLabel.clipsToBounds = YES;
                    _displayMarkLabel.layer.cornerRadius = 6;
                    _displayMarkLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                    CGSize maximumLabelSize = CGSizeMake(self.frame.size.width/2, self.frame.size.height-20);//labelsize的最大值
                    CGSize expectSize = [_displayMarkLabel sizeThatFits:maximumLabelSize];
                    if (point.x > (expectSize.width+5)){
                        
                        [UIView animateWithDuration:0.5 animations:^{
                            
                            if (point.x >= (expectSize.width+5)) {
                                _displayMarkLabel.frame = CGRectMake(point.x-(expectSize.width+5)-5, point.y-20, expectSize.width+5,expectSize.height+10);
                            }else if(point.x < (expectSize.width+5)){
                                
                                _displayMarkLabel.frame = CGRectMake(5, point.y-20, expectSize.width+5,expectSize.height+10);
                            }
                            
                        }];
                        
                    }else if(point.x < (expectSize.width+5)){
                        
                        [UIView animateWithDuration:0.5 animations:^{
                            
                            if (self.frame.size.width - point.x >= (expectSize.width+5)) {
                                _displayMarkLabel.frame = CGRectMake(point.x+10, point.y-20, expectSize.width+5,expectSize.height+10);
                            }else if(self.frame.size.width - point.x < (expectSize.width+5)){
                                
                                _displayMarkLabel.frame = CGRectMake(self.frame.size.width-(expectSize.width+5), point.y-20, expectSize.width+5,expectSize.height+10);
                            }
                            
                        }];
                    }
                }
                
            }
        
        }
    }else{
        //在饼图外部
        _displayMarkLabel.alpha = 0;
        _pieSelectLayer.fillColor = [UIColor clearColor].CGColor;
        if (_yValuesArray.count !=0 && _yValuesArray.count !=0) {
            if ([self.delegate respondsToSelector:@selector(touchPieChartXValue:yValue:)]) {
                [self.delegate touchPieChartXValue:_xValuesArray[0] yValue:_yValuesArray[0]];
            }
        }else{
            if ([self.delegate respondsToSelector:@selector(touchPieChartXValue:yValue:)]) {
                [self.delegate touchPieChartXValue:nil yValue:nil];
            }
 
        }

    }
    
    [_pieView.layer addSublayer:_pieSelectLayer];

}

@end
