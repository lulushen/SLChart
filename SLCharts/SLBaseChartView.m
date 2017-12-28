//
//  SLLineChart.m
//  SLCharts
//
//  Created by 上海数聚 on 17/5/12.
//  Copyright © 2017年 上海数聚. All rights reserved.
//

#import "SLBaseChartView.h"

@interface SLBaseChartView (){
    
    //y轴点与点的距离高
    CGFloat  _yStepHeight;
    CGFloat  _xStepHeight;
    NSInteger _yMaxIntValueAxsi;//y轴上最大标示数值
    NSInteger _yMinIntValueAxsi;//y轴上最小标示数值
    NSInteger _yAxisAverage;//y轴上两点之间的平均数值
    CGContextRef context;
    CAShapeLayer * _dotteLine;//x值的 虚线
    UILabel * _displayMarkLabel;//x值的label
}

@end
#define _yAxisHight (CGRectGetHeight(self.frame) - _topDistance -_bottomDistance)
#define _xAxisWidth (CGRectGetWidth(self.frame) - _leftDistance - _rightDistance)

@implementation SLBaseChartView
#pragma mark initialization
- (id)initWithCoder:(NSCoder *)coder {
    
    self = [super initWithCoder:coder];
    
    if (self) {
        [self setupDefaultValues];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupDefaultValues];
    }
    return self;
}
- (void)setupDefaultValues
{
    self.backgroundColor = [UIColor clearColor];
    //y轴label数量分成5段,x轴label的数量根据x值的数量确定
    _yAxisLabelCount = 5;
    // x,y轴颜色，默认是白色
    _axisColor = [UIColor whiteColor];
    _xyLabelBGColor = [UIColor clearColor];
    _xyLabelTextColor = _axisColor;
    _axisWidth = 2.0f;
    _axisPointLenght = _axisWidth/2.0;
    
    _topDistance = 25.0f;
    _bottomDistance = 35.0f;
    _leftDistance = 50.0f;
    _rightDistance = 20.0f;
    //是否有箭头
    _isArrowPointBOOL = NO;
    
    _xLabelAndxAxisDistance = 5.0f;
    _yLabelAndyAxisDistance = 5.0f;
    
    _xlabelDegree = - M_PI/6;
    _ylabelDegree = 0;
    
    //x,y轴labelText的字体大小以及x,y轴单位字体大小颜色
    _xLabelTextFontSize = 11.0f;
    _yLabelTextFontSize = 11.0f;
    _xUnitStringFont = 13.0f;
    _yUnitStringFont = 13.0f;
    _unitStringFontColor = _axisColor;
    
    _isXYValueCenterPoint = YES;
    _isXAxisPointInsideBOOL = NO;
    _isYAxisPointInsideBOOL = YES;
    
    _isAnimation = YES;
    
    //虚线宽\颜色\长度
    _yDottedLineWidth = 1.0f;
    _yDottedLineColor = _axisColor;
    _yDottedLineLength = 5;
    
    
    _lineChartWidth = 2.0f;
    _circlePointType = CirclePointTypeSolid;
    _baseChartColor = _axisColor;
    _secondBaseChartColor = [UIColor orangeColor];
    _circlePointColor = _baseChartColor;
    _secondCirclePointColor = _secondBaseChartColor;
    _chartType = SLBaseLineChartType;
    _circlePointDiameter = _lineChartWidth*1.2;
    _hollowCirclePointRadii = 2.0f;
    
    
    //x轴标示线
    _isXValueMarkLineBOOL = YES;
    _xValueMarkLineColor =[UIColor colorWithRed:39/225.0 green:96/225.0 blue:104/225.0 alpha:1];
    _xValueMarkLineWidth = 2.5f;
    
    _displayMarkLabelBGColor = [UIColor colorWithRed:0 green:0 blue:0  alpha:0.5];
    _displayMarkLabelTextColor = [UIColor whiteColor];
    _displayMarkLabelTextFontSize = 13.0f;
    
    
    _dotteLine =  [CAShapeLayer layer];
    _displayMarkLabel = [[UILabel alloc] init];
    
    //柱状图属性
    _animationTime = 0.8;
    
    _yUnitString = @"";
    _xUnitString = @"";
}
//根据y轴上数据的内容确定label的高，但是宽度有固定值（就是y轴距离视图的距离－y轴label与y轴的距离：）;
- (void)makeYLabels
{
    //    NSMutableArray * yValueArray = [NSMutableArray arrayWithObjects:@"30",@"36",@"42",@"48",@"54",@"60", nil];
    //@"50",@"50",@"60",@"30",@"30",@"40"  ping: 43
    //y:600 660 720 780 840 900
    //yshi: 724 686 614 660 673 807   ping:697
    
    
    //算法 ：获得所有y值之中的最大值和最小值，根据最大值获得y轴上的最大标示（根据位数获得最相近的最大最小位数整数 例如，y值数组中最大值是807，最小值是614，那么y轴上的最大标示值就是900，最小标示值是600)
    if (_yValuesArray.count > 0) {
        CGFloat yMaxFirstValue = [[_yValuesArray valueForKeyPath:@"@max.floatValue"] floatValue];
        CGFloat yMinFirstValue = [[_yValuesArray valueForKeyPath:@"@min.floatValue"] floatValue];
        CGFloat  yMaxValue = yMaxFirstValue;
        CGFloat  yMinValue = yMinFirstValue;
        
        if ((_yValuesArray.count > 0)&&(_ySecondValuesArray.count >0)) {
            CGFloat yMaxSecondValue = [[_ySecondValuesArray valueForKeyPath:@"@max.floatValue"] floatValue];
            CGFloat yMinSecondValue = [[_ySecondValuesArray valueForKeyPath:@"@min.floatValue"] floatValue];
            yMaxValue = (yMaxFirstValue > yMaxSecondValue ? yMaxFirstValue : yMaxSecondValue);
            yMinValue = (yMinFirstValue < yMinSecondValue ? yMinFirstValue : yMinSecondValue);
            
        }
        
        if (yMaxValue == yMinValue){
            if (yMaxValue>0) {
                _yMaxIntValueAxsi = [self makeYAxisMax:yMaxValue];
                
                _yMinIntValueAxsi = [self makeYAxisMin:_yMaxIntValueAxsi/_yAxisLabelCount];
                
            }else if (yMaxValue == 0){
                _yMaxIntValueAxsi = 100;
                _yMinIntValueAxsi = 0;
                
            }else{
                _yMaxIntValueAxsi = - ([self makeYAxisMin: fabs(yMaxValue)]);
                _yMinIntValueAxsi = - ([self makeYAxisMax: labs(_yMaxIntValueAxsi*2)]);
                
            }
            
            _yAxisAverage = (_yMaxIntValueAxsi - _yMinIntValueAxsi)/_yAxisLabelCount;
        }else{
            _yMaxIntValueAxsi = [self makeYAxisMax:yMaxValue];
            _yMinIntValueAxsi = [self makeYAxisMin:yMinValue];
            if (yMaxValue < 0) {
                _yMaxIntValueAxsi = - ([self makeYAxisMin:fabs(yMaxValue) ]);
            }
            if (yMinValue < 0){
                _yMinIntValueAxsi = - ([self makeYAxisMax:fabs(yMinValue)]);
            }
            
            _yAxisAverage = labs((_yMaxIntValueAxsi - _yMinIntValueAxsi)/_yAxisLabelCount);
        }
    }else{
        
        _yMaxIntValueAxsi = 100;
        _yMinIntValueAxsi = 0;
        _yAxisAverage = (_yMaxIntValueAxsi - _yMinIntValueAxsi)/_yAxisLabelCount;
        
    }
    
    if (_yAxisAverage == 0) {
        _yAxisAverage = 1;
        _yMaxIntValueAxsi = _yMinIntValueAxsi+_yAxisAverage*_yAxisLabelCount;
    }
    
    for (int i = 0 ; i <= _yAxisLabelCount ; i++) {
        UILabel * yLabel = [[UILabel alloc] init];
        NSString * ylabelTextStr = [NSString stringWithFormat:@"%ld",(long)(_yMinIntValueAxsi + i*_yAxisAverage)];
        yLabel.text = ylabelTextStr;
        yLabel.font = [UIFont boldSystemFontOfSize:_yLabelTextFontSize];
        
        CGFloat yLabelWidth = _leftDistance - _yLabelAndyAxisDistance;
        CGFloat yLabelHight = _yAxisHight/_yAxisLabelCount;
        
        CGSize valueSize = [yLabel.text boundingRectWithSize:CGSizeMake(yLabelWidth, yLabelHight) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:yLabel.font} context:nil].size;
        if (i == 0) {
            yLabel.frame = CGRectMake(0,_topDistance+_yAxisHight - valueSize.height/3.0f*2, yLabelWidth, valueSize.height);
            yLabel.backgroundColor = [UIColor redColor];
        }else if (i == _yAxisLabelCount){
            yLabel.frame = CGRectMake(0,_topDistance- valueSize.height/3.0, yLabelWidth, valueSize.height);
        }else{
            yLabel.frame = CGRectMake(0,_topDistance+_yAxisHight - (i * _yStepHeight) - valueSize.height/2.0, yLabelWidth, valueSize.height);
        }
        yLabel.numberOfLines = 0;
        yLabel.backgroundColor = _xyLabelBGColor;
        yLabel.textColor = _xyLabelTextColor;
        yLabel.textAlignment = NSTextAlignmentRight;
        
        [self addSubview:yLabel];
        
    }
}
- (NSInteger)makeYAxisMax:(CGFloat)yAxisValue
{
    NSInteger tempYAxisValue = 0;
    NSInteger temp = 0;
    
    int j=0;//位数
    NSInteger remainder = 0;//余数，获得最高位数的值
    NSInteger remainderMid = 0;
    NSInteger yAxisMaxValue = 0;
    //后几位的和
    NSInteger xiaosum =0;
    //获得最大值是几位数
    tempYAxisValue = ceilf(fabs(yAxisValue)) ;
    while (tempYAxisValue > 0) {
        remainder = tempYAxisValue%10;
        tempYAxisValue = tempYAxisValue/10.0;
        j++;
    }
    
    tempYAxisValue = ceilf(fabs(yAxisValue)) ;
    
    //小于三位数
    if (j<3) {
        
        if(tempYAxisValue%10*pow(10, j-1) == 0)
            yAxisMaxValue = remainder*pow(10, j-1);
        else
            yAxisMaxValue = (remainder+1)*pow(10, j-1);
        
    }else{
        //大于三位数
        for (int i=1; i<=j; i++) {
            
            remainderMid = tempYAxisValue%10;
            tempYAxisValue = tempYAxisValue/10.0;
            xiaosum = xiaosum + remainderMid *powf(10, i-1);
            NSLog(@"后面位数的和：%ld",(long)xiaosum);
            temp = ceilf(fabs(yAxisValue)) - xiaosum;
            
            if(i > 1) {
                yAxisMaxValue = temp + powf(10, i);
                if (yAxisMaxValue >= yAxisValue){
                    return yAxisMaxValue;
                }
            }
            
        }
    }
    
    return yAxisMaxValue;
}
- (NSInteger)makeYAxisMin:(CGFloat)yAxisValue
{
    NSInteger tempYAxisValue = 0;
    NSInteger temp = 0;
    
    int j=0;//位数
    NSInteger remainder = 0;//余数，获得最高位数的值
    NSInteger remainderMid = 0;
    NSInteger yAxisMinValue = 0;
    //后几位的和
    NSInteger xiaosum =0;
    //获得最大值是几位数
    tempYAxisValue = floor(fabs(yAxisValue)) ;
    while (tempYAxisValue > 0) {
        remainder = tempYAxisValue%10;
        tempYAxisValue = tempYAxisValue/10.0;
        j++;
    }
    tempYAxisValue = floor(fabs(yAxisValue));
    //小于三位数
    if (j<3) {
        
        if(tempYAxisValue%10*pow(10, j-1) == 0)
            yAxisMinValue = remainder*pow(10, j-1);
        else
            yAxisMinValue = (remainder-1)*pow(10, j-1);
        
    }else{
        //大于三位数
        for (int i=1; i<=j; i++) {
            
            remainderMid = tempYAxisValue%10;
            tempYAxisValue = tempYAxisValue/10.0;
            xiaosum = xiaosum + remainderMid *powf(10, i-1);
            NSLog(@"后面位数的和：%ld",(long)xiaosum);
            temp = ceilf(fabs(yAxisValue)) - xiaosum;
            
            
            if(i > 1) {
                yAxisMinValue = temp;
                if(yAxisMinValue <= yAxisValue){
                    
                    return yAxisMinValue;
                }
            }
            
        }
    }
    
    return yAxisMinValue;
}
- (void)makeXLabels
{
    
    if (_isXYValueCenterPoint==YES) {
        for (int i = 0; i < _xValuesArray.count; i++) {
            NSString * vauleStr = _xValuesArray[i];
            UILabel * xLabel = [[UILabel alloc] init];
            xLabel.font = [UIFont boldSystemFontOfSize:_xLabelTextFontSize];
            xLabel.text = vauleStr;
            CGSize valueSize = [xLabel.text boundingRectWithSize:CGSizeMake(1000, _bottomDistance) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:xLabel.font} context:nil].size;
            float height;
            if (_xlabelDegree == 0){
                height =  _xLabelAndxAxisDistance;
                xLabel.frame = CGRectMake(_leftDistance + _xStepHeight*i, self.frame.size.height-_bottomDistance +height, valueSize.width, valueSize.height);
            }else{
                //邻边  sin()＝ 对边／斜边，这里对边指label与x轴的距离
                height = (valueSize.width/2.0f)*(sin(fabs(M_PI_2 - fabs(_xlabelDegree))))-_xLabelAndxAxisDistance;
                
                //xlabel的最后点在x轴两点的中心上
                xLabel.frame = CGRectMake(_leftDistance + _xStepHeight*i-(valueSize.width - _xStepHeight/2.0f), self.frame.size.height-_bottomDistance + height, valueSize.width, valueSize.height);
                //中心点的变化
                // 邻边    cos()= 邻边／斜边
                CGFloat adjacentSide = tan(fabs(_xlabelDegree)) * valueSize.height;
                xLabel.center = CGPointMake(xLabel.center.x + adjacentSide, xLabel.center.y);
            }
            xLabel.transform = CGAffineTransformMakeRotation(_xlabelDegree);
            xLabel.numberOfLines = 0;
            xLabel.backgroundColor = _xyLabelBGColor;
            xLabel.textColor = _xyLabelTextColor;
            
            [self addSubview:xLabel];
        }
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    //draw  x,y Axis
    [self makeXAndYAxis];
    
    switch (_chartType) {
            
        case SLBaseLineChartType:{
            
            
            if (_yValuesArray.count>0) {
                [self makeLine:_yValuesArray color:_baseChartColor circleColor:_circlePointColor];
            }
            if (_ySecondValuesArray.count > 0){
                
                [self makeLine:_ySecondValuesArray color:_secondBaseChartColor circleColor:_secondCirclePointColor];
            }
            
            break;
        }
        case SLBaseBarChartType:{
            
            if ((_yValuesArray.count>0 && _ySecondValuesArray.count == 0) | (_ySecondValuesArray.count>0 && _yValuesArray.count == 0)) {
                _barChartWidth = _xStepHeight/2.0;
                if (_yValuesArray.count > 0) {
                    [self makeBar:_yValuesArray color:_baseChartColor startChange:0.0];
                }
                if (_ySecondValuesArray.count > 0) {
                    [self makeBar:_ySecondValuesArray color:_secondBaseChartColor startChange:0.0];
                }
            }
            if ((_ySecondValuesArray.count) > 0 && (_yValuesArray.count > 0)){
                _barChartWidth = _xStepHeight/4.0;
                if (_yValuesArray.count > 0) {
                    [self makeBar:_yValuesArray color:_baseChartColor startChange:_axisWidth+_xValueMarkLineWidth];
                }
                if (_ySecondValuesArray.count > 0) {
                    [self makeBar:_ySecondValuesArray color:_secondBaseChartColor startChange:_axisWidth+_barChartWidth +_xValueMarkLineWidth];
                }
            }
            
            
            break;
        }
        case LineANDBarType:{
            
            break;
        }
        default:{
            break;
        }
            
    }
    [self.layer addSublayer:_dotteLine];
    [self addSubview:_displayMarkLabel];
}
- (void)makeXAndYAxis
{
    //画x，y轴
    context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, _axisWidth);  //线宽
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetStrokeColorWithColor(context, [self.axisColor CGColor]);  //线的颜色
    CGContextMoveToPoint(context, self.frame.size.width-_rightDistance, self.frame.size.height - _bottomDistance);   //起点坐标
    CGContextAddLineToPoint(context, _leftDistance, self.frame.size.height - _bottomDistance);
    CGContextAddLineToPoint(context, _leftDistance, _topDistance);   //终点坐标
    CGContextStrokePath(context);
    
    if (_isArrowPointBOOL == YES) {
        //x箭头
        CGContextMoveToPoint(context, self.frame.size.width-_rightDistance, self.frame.size.height - _bottomDistance+3);
        CGContextAddLineToPoint(context, self.frame.size.width-_rightDistance + 5, self.frame.size.height - _bottomDistance);
        CGContextAddLineToPoint(context, self.frame.size.width-_rightDistance, self.frame.size.height - _bottomDistance-3);
        CGContextStrokePath(context);
        //y箭头
        CGContextMoveToPoint(context, _leftDistance-3, _topDistance);
        CGContextAddLineToPoint(context, _leftDistance, _topDistance-5);
        CGContextAddLineToPoint(context, _leftDistance+3 , _topDistance);
        CGContextStrokePath(context);
    }
    //x轴上的点
    CGPoint xPoint;
    NSMutableArray * tempArray = [NSMutableArray array];
    if (_ySecondValuesArray.count > _yValuesArray.count && _ySecondValuesArray.count>_xValuesArray.count) {
        tempArray = _ySecondValuesArray;
    }else if (_ySecondValuesArray.count < _yValuesArray.count && _ySecondValuesArray.count >_xValuesArray.count){
        tempArray = _yValuesArray;
    }else {
        tempArray = _xValuesArray;
    }
    if (_isArrowPointBOOL)
        _xStepHeight = (_xAxisWidth-tempArray.count-1) / tempArray.count;
    else
        _xStepHeight = _xAxisWidth / tempArray.count;
    
    for (NSUInteger i = 0; i <= [tempArray count] ; i++) {
        if (_isXAxisPointInsideBOOL) {
            xPoint = CGPointMake((CGFloat)i * _xStepHeight + _leftDistance, _yAxisHight+_topDistance-_axisWidth);
            CGContextMoveToPoint(context, xPoint.x, xPoint.y);
            CGContextAddLineToPoint(context, xPoint.x, xPoint.y-_axisPointLenght);
        }else{
            xPoint = CGPointMake((CGFloat)i * _xStepHeight + _leftDistance, _yAxisHight+_topDistance+_axisWidth);
            CGContextMoveToPoint(context, xPoint.x, xPoint.y);
            CGContextAddLineToPoint(context, xPoint.x, xPoint.y+_axisPointLenght);
        }
        CGContextStrokePath(context);
    }
    // y轴上的点
    CGPoint yPoint;
    if (_isArrowPointBOOL)
        _yStepHeight = (_yAxisHight-_yAxisLabelCount) / _yAxisLabelCount;
    else
        _yStepHeight = _yAxisHight / _yAxisLabelCount;
    
    for (NSUInteger i = 0; i <= self.yAxisLabelCount; i++) {
        
        if (_isYAxisPointInsideBOOL) {
            yPoint = CGPointMake(_leftDistance+_axisWidth, _topDistance+_yAxisHight - (i * _yStepHeight));
            CGContextMoveToPoint(context, yPoint.x, yPoint.y);
            CGContextAddLineToPoint(context, yPoint.x + _axisPointLenght, yPoint.y);
        }else{
            yPoint = CGPointMake(_leftDistance-_axisWidth, _topDistance+_yAxisHight - (i * _yStepHeight));
            CGContextMoveToPoint(context, yPoint.x, yPoint.y);
            CGContextAddLineToPoint(context, yPoint.x-_axisPointLenght, yPoint.y);
        }
        CGContextStrokePath(context);
        
        //y轴 折线分割虚线
        // 设置线条的样式
        CGContextSetLineCap(context, kCGLineCapRound);
        // 绘制线的宽度
        CGContextSetLineWidth(context, _yDottedLineWidth);
        // 线的颜色
        CGContextSetStrokeColorWithColor(context, _yDottedLineColor.CGColor);
        // 设置虚线绘制起点
        CGContextMoveToPoint(context, yPoint.x, yPoint.y);
        // lengths的值｛10,10｝表示先绘制10个点，再跳过10个点，如此反复
        CGFloat lengths[] = {_yDottedLineLength,_yDottedLineLength};
        // 虚线的起始点
        CGContextSetLineDash(context, 0,lengths,2);
        // 绘制虚线的终点
        CGContextAddLineToPoint(context, yPoint.x+_xAxisWidth,yPoint.y);
        // 绘制
        CGContextStrokePath(context);
    }
    
    // draw y unit
    if ([_yUnitString length]) {
        
        NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        NSDictionary*attribute = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:_xUnitStringFont],NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:_unitStringFontColor};
        CGSize size = [_yUnitString boundingRectWithSize:CGSizeMake(_xAxisWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
        
        if (_isArrowPointBOOL) {
            [_yUnitString drawWithRect:CGRectMake(_leftDistance+_axisWidth+3, _topDistance-size.height-2,_xAxisWidth, size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
        }else{
            [_yUnitString drawWithRect:CGRectMake(_leftDistance-size.width/2.0, _topDistance-size.height-3-2,_xAxisWidth, size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
        }
    }
    
    // draw x unit
    if ([_xUnitString length]) {
        
        NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        NSDictionary*attribute = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:_xUnitStringFont],NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:_unitStringFontColor};
        CGSize size = [_xUnitString boundingRectWithSize:CGSizeMake(_xAxisWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
        
        if (_isArrowPointBOOL) {
            [_xUnitString drawWithRect:CGRectMake(self.frame.size.width-_rightDistance-3, self.frame.size.height-_bottomDistance+3,_xAxisWidth, size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
        }else{
            [_xUnitString drawWithRect:CGRectMake(self.frame.size.width-_rightDistance, self.frame.size.height-_bottomDistance+3,_xAxisWidth, size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];}
        
    }
    [self makeXLabels];
    [self makeYLabels];
    
    CGFloat lengths[] = {1,1};
    // 虚线的起始点
    CGContextSetLineDash(context, 0,lengths,2);
    
}
- (void)makeLine:(NSMutableArray *)yValueArray color:(UIColor*)lineColor circleColor:(UIColor*)circleColor
{
    
    switch (_circlePointType) {
            
        case CirclePointTypeNO:{
            
            break;
        }
        case CirclePointTypeSolid:{
            //实心圆
            for (int i = 0; i< yValueArray.count; i++) {
                if ( [NSString stringWithFormat:@"%@",yValueArray[0]].length != 0) {
                    CAShapeLayer *solidLayer =  [CAShapeLayer layer];
                    solidLayer.frame = CGRectMake(_leftDistance + _xStepHeight*i + _xStepHeight/2.0-_circlePointDiameter/2.0, _topDistance +  (((_yMaxIntValueAxsi - [yValueArray[i] floatValue])/(_yMaxIntValueAxsi-_yMinIntValueAxsi))*_yAxisHight)-_circlePointDiameter/2.0, _circlePointDiameter, _circlePointDiameter);
                    solidLayer.backgroundColor = [UIColor redColor].CGColor;
                    CGMutablePathRef solidPath =  CGPathCreateMutable();
                    solidLayer.lineWidth = _circlePointDiameter ;
                    solidLayer.strokeColor = circleColor.CGColor;
                    solidLayer.fillColor = circleColor.CGColor;
                    CGPathAddEllipseInRect(solidPath, nil, CGRectMake(0, 0, solidLayer.frame.size.width, solidLayer.frame.size.height));
                    solidLayer.path = solidPath;
                    CGPathRelease(solidPath);
                    [self.layer addSublayer:solidLayer];
                    if (_isAnimation == YES) {
                        CABasicAnimation * scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                        scaleAnimation.fromValue = [NSNumber numberWithFloat:0.0];
                        scaleAnimation.toValue = [NSNumber numberWithFloat:1.0];                    scaleAnimation.removedOnCompletion = YES;
                        scaleAnimation.duration = _animationTime;
                        [solidLayer addAnimation:scaleAnimation forKey:@"transformLayer"];
                    }
                }
                
            }
            
            break;
        }
        case CirclePointTypeHollow:{
            
            for (int i = 0; i< yValueArray.count; i++) {
                if ( [NSString stringWithFormat:@"%@",yValueArray[0]].length != 0) {
                    CAShapeLayer *solidLayer =  [CAShapeLayer layer];
                    
                    solidLayer.frame = CGRectMake(_leftDistance + _xStepHeight*i + _xStepHeight/2.0-_circlePointDiameter/2.0, _topDistance +  (((_yMaxIntValueAxsi - [yValueArray[i] floatValue])/(_yMaxIntValueAxsi-_yMinIntValueAxsi))*_yAxisHight)-_circlePointDiameter/2.0, _circlePointDiameter*1.3, _circlePointDiameter*1.3);
                    CGMutablePathRef solidPath =  CGPathCreateMutable();
                    solidLayer.lineWidth =  _lineChartWidth;
                    solidLayer.strokeColor = circleColor.CGColor;
                    solidLayer.fillColor = [UIColor clearColor].CGColor;
                    CGPathAddEllipseInRect(solidPath, nil, CGRectMake(0, 0, solidLayer.frame.size.width, solidLayer.frame.size.height));
                    solidLayer.path = solidPath;
                    CGPathRelease(solidPath);
                    [self.layer addSublayer:solidLayer];
                    if (_isAnimation == YES) {
                        CABasicAnimation * scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                        scaleAnimation.fromValue = [NSNumber numberWithFloat:0.0];
                        scaleAnimation.toValue = [NSNumber numberWithFloat:1.0];                    scaleAnimation.removedOnCompletion = YES;
                        scaleAnimation.duration = _animationTime;
                        [solidLayer addAnimation:scaleAnimation forKey:@"transformLayer"];
                    }
                    
                }
            }
            
            break;
        }
            
        default:{
            break;
        }
    }
    for (NSInteger i = 0; i< yValueArray.count-1; i++) {
        CGPoint startPoint;
        CGPoint movePoint;
        
        if (_circlePointType == CirclePointTypeHollow) {
            startPoint = CGPointMake(_leftDistance + _xStepHeight*i + _xStepHeight/2.0, _topDistance +  (((_yMaxIntValueAxsi - [yValueArray[i] floatValue])/(_yMaxIntValueAxsi-_yMinIntValueAxsi))*_yAxisHight));
            //起点变化
            CGFloat x1 = _xStepHeight;
            
            CGFloat y1 = fabs(([yValueArray[i] floatValue]-[yValueArray[i+1] floatValue]))/(_yMaxIntValueAxsi-_yMinIntValueAxsi)*_yAxisHight;
            CGFloat c1 = sqrtf(powf(x1, 2) + powf(y1, 2));
            CGFloat c;
            if (_hollowCirclePointRadii > _lineChartWidth) {
                c = _hollowCirclePointRadii;//(_lineChartWidth这里表示半径和圆圈线宽)
            }else{
                c = _lineChartWidth;//(_lineChartWidth这里表示半径和圆圈线宽)
            }
            CGFloat x = (x1/c1)*c;
            CGFloat y = (y1/c1)*c;
            
            if (([yValueArray[i] floatValue]-[yValueArray[i+1] floatValue])>=0) {
                //起点
                startPoint = CGPointMake(startPoint.x+x, startPoint.y+y);
                //终点
                movePoint = CGPointMake(_leftDistance + _xStepHeight*(i+1)+_xStepHeight/2.0 - x, _topDistance +  (((_yMaxIntValueAxsi - [yValueArray[i+1] floatValue])/(_yMaxIntValueAxsi-_yMinIntValueAxsi))*_yAxisHight-y));
            }else{
                //起点
                startPoint = CGPointMake(startPoint.x+x, startPoint.y-y);
                //终点
                movePoint = CGPointMake(_leftDistance + _xStepHeight*(i+1)+_xStepHeight/2.0 - x, _topDistance +  (((_yMaxIntValueAxsi - [yValueArray[i+1] floatValue])/(_yMaxIntValueAxsi-_yMinIntValueAxsi))*_yAxisHight+y));
            }
            
        }else{
            
            startPoint =CGPointMake(_leftDistance + _xStepHeight*i + _xStepHeight/2.0, _topDistance +  (((_yMaxIntValueAxsi - [yValueArray[i] floatValue])/(_yMaxIntValueAxsi-_yMinIntValueAxsi))*_yAxisHight));
            
            movePoint = CGPointMake(_leftDistance + _xStepHeight*(i+1) + _xStepHeight/2.0, _topDistance +  (((_yMaxIntValueAxsi - [yValueArray[i+1] floatValue])/(_yMaxIntValueAxsi-_yMinIntValueAxsi))*_yAxisHight));
            
        }
        
        [self makeLayerAndAnimationWithStart:startPoint withMovePoint:movePoint WithLineWidth:_lineChartWidth withColor:lineColor];
        
    }
}
-(void)makeBar:(NSMutableArray *)yValueArray color:(UIColor *)color startChange:(CGFloat)startChange{
    
    for (int i = 0; i < yValueArray.count; i++) {
        CGPoint startPoint = CGPointMake(_leftDistance  + _barChartWidth + _xStepHeight*i + startChange, _topDistance + _yAxisHight-_axisWidth/2.0);
        CGPoint movePoint = CGPointMake(_leftDistance  + _barChartWidth + _xStepHeight*i + startChange, _topDistance +  (((_yMaxIntValueAxsi - [yValueArray[i] floatValue])/(_yMaxIntValueAxsi-_yMinIntValueAxsi))*_yAxisHight));
        [self makeLayerAndAnimationWithStart:startPoint withMovePoint:movePoint WithLineWidth:_barChartWidth withColor:color];
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (_isXValueMarkLineBOOL == YES) {
        
        NSSet * allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
        UITouch *touch = [allTouches anyObject];   //视图中的所有对象
        CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
        
        if ((point.x > _leftDistance) && ( point.x < _leftDistance + _xAxisWidth)) {
            _displayMarkLabel.alpha = 1;
            //画所在点的虚线
            CGMutablePathRef dottePath =  CGPathCreateMutable();
            _dotteLine.lineWidth = _xValueMarkLineWidth ;
            _dotteLine.strokeColor = _xValueMarkLineColor.CGColor;
            _dotteLine.fillColor = [UIColor clearColor].CGColor;
            _dotteLine.lineDashPhase = 1.0;
            NSArray *arr = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:10],[NSNumber numberWithInt:8], nil];
            _dotteLine.lineDashPattern = arr;
            CGFloat x = ((NSInteger)((point.x-_leftDistance)/_xStepHeight) + 0.5)*_xStepHeight+_leftDistance;
            CGPathMoveToPoint(dottePath, NULL, x,_topDistance);
            CGPathAddLineToPoint(dottePath, NULL, x, _topDistance + _yAxisHight-_lineChartWidth);
            [_dotteLine setPath:dottePath];
            CGPathRelease(dottePath);
            if (_yUnitString.length==0) {
                _yUnitString = @"";
            }
            _displayMarkLabel.numberOfLines = 0;//根据最大行数需求来设置
            
            int i = (int)((point.x-_leftDistance)/_xStepHeight);
            
            NSMutableArray * tempXArray = [NSMutableArray array];
            NSMutableArray * tempYArray = [NSMutableArray array];
            NSMutableArray * tempSecondYArray = [NSMutableArray array];
            tempXArray = _xValuesArray;
            tempYArray = _yValuesArray;
            tempSecondYArray = _ySecondValuesArray;
            
            //------防止x,y值数量不一致导致的bug闪退，xy值不是一一对应关系的情况概率很小
            if (_ySecondValuesArray.count > _yValuesArray.count && _yValuesArray.count >= _xValuesArray.count) {
                for (int i = 0; i < _ySecondValuesArray.count-_xValuesArray.count; i++) {
                    [tempXArray addObject:@""];
                }
                for (int i = 0; i < _ySecondValuesArray.count-_yValuesArray.count; i++) {
                    [tempYArray addObject:@""];
                }
            }else if (_ySecondValuesArray.count < _yValuesArray.count && _ySecondValuesArray.count >=_xValuesArray.count){
                for (int i = 0; i < _yValuesArray.count-_xValuesArray.count; i++) {
                    [tempXArray addObject:@""];
                }
                for (int i = 0; i < _yValuesArray.count-_ySecondValuesArray.count; i++) {
                    [tempSecondYArray addObject:@""];
                }
                
                
            }else {
                for (int i = 0; i < _xValuesArray.count-_yValuesArray.count; i++) {
                    [tempYArray addObject:@""];
                }
                for (int i = 0; i < _xValuesArray.count-_ySecondValuesArray.count; i++) {
                    [tempSecondYArray addObject:@""];
                }
            }
            //--------------------------------------------------------
            if ((_ySecondValuesArray.count == 0)&&(_yValuesArray.count != 0)&&(_xValuesArray.count != 0)) {
                _displayMarkLabel.text = [NSString stringWithFormat:@" %@ : %@ %@",tempXArray[i],tempYArray[i],_yUnitString];
                if ([self.delegate respondsToSelector:@selector(touchBaseChartXValue:yValue:secondYValue:)]) {
                    [self.delegate touchBaseChartXValue:tempXArray[i]  yValue:tempYArray[i] secondYValue:nil];
                }
            }else if((_ySecondValuesArray.count != 0)&&(_xValuesArray.count != 0)&&(_yValuesArray.count == 0)){
                _displayMarkLabel.text = [NSString stringWithFormat:@" %@ : %@ %@",tempXArray[i],tempSecondYArray[i],_yUnitString];
                if ([self.delegate respondsToSelector:@selector(touchBaseChartXValue:yValue:secondYValue:)]) {
                    [self.delegate touchBaseChartXValue:tempXArray[i]  yValue:tempYArray[i] secondYValue:nil];
                }
            }else if((_ySecondValuesArray.count != 0)&&(_xValuesArray.count != 0)&&(_yValuesArray.count != 0)){
                _displayMarkLabel.text = [NSString stringWithFormat:@" %@ : %@ %@ \n %@ : %@ %@",tempXArray[i],tempYArray[i],_yUnitString,tempXArray[i],tempSecondYArray[i],_yUnitString];
                if ([self.delegate respondsToSelector:@selector(touchBaseChartXValue:yValue:secondYValue:)]) {
                    [self.delegate touchBaseChartXValue:tempXArray[i] yValue:tempYArray[i] secondYValue:tempSecondYArray[i]];
                }
                
            }
            
            _displayMarkLabel.font =[UIFont systemFontOfSize:_displayMarkLabelTextFontSize];
            _displayMarkLabel.backgroundColor = _displayMarkLabelBGColor;
            _displayMarkLabel.textColor = _displayMarkLabelTextColor;
            
            _displayMarkLabel.clipsToBounds = YES;
            _displayMarkLabel.layer.cornerRadius = 6;
            _displayMarkLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            
            CGSize maximumLabelSize = CGSizeMake(_xAxisWidth/2.0, _xAxisWidth);//labelsize的最大值
            
            //关键语句
            CGSize expectSize = [_displayMarkLabel sizeThatFits:maximumLabelSize];
            
            //别忘了把frame给回label，如果用xib加了约束的话可以只改一个约束的值
            
            if (i*(_xStepHeight+0.5) < expectSize.width+15) {
                
                _displayMarkLabel.frame = CGRectMake(x+10, point.y, expectSize.width+5, expectSize.height+10);
            }else{
                
                _displayMarkLabel.frame = CGRectMake(x-10-(expectSize.width+5), point.y, expectSize.width+5, expectSize.height+10);
            }
            
        }else{
            
            _dotteLine.strokeColor = [UIColor clearColor].CGColor;
            _displayMarkLabel.alpha = 0;
            _displayMarkLabel.textColor = [UIColor clearColor];
            if (_yValuesArray.count !=0 && _yValuesArray.count !=0) {
                if ([self.delegate respondsToSelector:@selector(touchBaseChartXValue:yValue:secondYValue:)]) {
                    [self.delegate touchBaseChartXValue:_xValuesArray[0]  yValue:_yValuesArray[0] secondYValue:nil];
                }
            }else{
                if ([self.delegate respondsToSelector:@selector(touchBaseChartXValue:yValue:secondYValue:)]) {
                    
                    [self.delegate touchBaseChartXValue:nil  yValue:nil secondYValue:nil];
                }
                
            }
            
        }
        
        
    }
    
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
}

//公共画图及动画
-(void)makeLayerAndAnimationWithStart:(CGPoint)startpoint withMovePoint:(CGPoint)movePoint WithLineWidth:(CGFloat)lineWidth withColor:(UIColor*)color
{
    UIBezierPath *progressline = [UIBezierPath bezierPath];
    [progressline moveToPoint:startpoint];
    [progressline addLineToPoint:movePoint];
    
    [progressline setLineCapStyle:kCGLineCapSquare];
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.lineWidth = lineWidth;
    layer.path = progressline.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = color.CGColor;
    [self.layer addSublayer:layer];
    layer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    if (_isAnimation == YES) {
        if (_chartType == SLBaseBarChartType) {
            CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            pathAnimation.duration = _animationTime;
            pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
            pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
            pathAnimation.autoreverses = NO;
            [layer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
            layer.strokeEnd = 2.0;
            
        }else{
            //缩放变化
            CABasicAnimation * scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
            scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 0.8, 1)];
            scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
            scaleAnimation.removedOnCompletion = YES;
            scaleAnimation.duration = _animationTime;
            [layer addAnimation:scaleAnimation forKey:@"transform"];
        }
    }
    
}
@end
