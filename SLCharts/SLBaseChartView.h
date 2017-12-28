//
//  SLLineChart.h
//  SLCharts
//
//  Created by 上海数聚 on 17/5/12.
//  Copyright © 2017年 上海数聚. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TouchBaseChartDelegate <NSObject>
@required
-(void)touchBaseChartXValue:(NSString*)xValue yValue:(NSString*)yValue secondYValue:(NSString*)secondYValue;
@end
@interface SLBaseChartView : UIView

@property (nonatomic, weak) id<TouchBaseChartDelegate> delegate;

//枚举型，图表类型，默认是折线图
typedef NS_ENUM (NSInteger, ChartType)   {
    SLBaseLineChartType  = 0,  // 折线图
    SLBaseBarChartType   = 1,  // 柱状图
    LineANDBarType = 2,  // 折线图和柱状图同时存在
};
@property (nonatomic , assign)ChartType  chartType;

//-----------------------坐标x,y轴上相关的属性及公共属性---------------------------

//x,y轴宽度，颜色，默认是 2.0f，白色
@property (nonatomic , assign)CGFloat   axisWidth;
@property (nonatomic , strong)UIColor * axisColor;

//y轴分成段数，默认5段
@property (nonatomic , assign)NSInteger yAxisLabelCount;

//x,y轴上点的长度,默认是x,y轴宽度axisWidth的二分之一
@property (nonatomic , assign)CGFloat   axisPointLenght;

//所画图与所在的图的上下左右距离，默认是25.0f,35.0f,50.0f,20.0f
@property (nonatomic , assign)CGFloat   topDistance;
@property (nonatomic , assign)CGFloat   bottomDistance;
@property (nonatomic , assign)CGFloat   leftDistance;
@property (nonatomic , assign)CGFloat   rightDistance;

//x,y轴是否有尖角,默认没有箭头  NO没有箭头，YES有箭头
@property (nonatomic , assign)BOOL      isArrowPointBOOL;
//x轴，y轴上的点是否在x,y轴内部 默认YES，YES在内部，NO在外部
@property (nonatomic , assign)BOOL      isXAxisPointInsideBOOL;
@property (nonatomic , assign)BOOL      isYAxisPointInsideBOOL;

//x，y轴上x，y值的数组
@property (nonatomic , strong)NSMutableArray * xValuesArray;
@property (nonatomic , strong)NSMutableArray * yValuesArray;
@property (nonatomic , strong)NSMutableArray * ySecondValuesArray;
//x, y轴上的单位及字体大小、颜色,默认12.0f，默认与x,y轴同色
@property (nonatomic , strong)NSString * xUnitString;
@property (nonatomic , strong)NSString * yUnitString;
@property (nonatomic , assign)CGFloat    xUnitStringFont;
@property (nonatomic , assign)CGFloat    yUnitStringFont;
@property (nonatomic , strong)UIColor  * unitStringFontColor;

//x,y轴上label的背景色及字体颜色,背景色默认为透明色，字体颜色默认与x,y轴同色
@property (nonatomic , strong)UIColor  * xyLabelBGColor;
@property (nonatomic , strong)UIColor  * xyLabelTextColor;
//x,y轴label的字体大小,默认 11.0f
@property (nonatomic , assign)CGFloat   xLabelTextFontSize;
@property (nonatomic , assign)CGFloat   yLabelTextFontSize;

//x,y轴label与x,y轴的距离,默认5.0f
@property (nonatomic , assign)CGFloat   xLabelAndxAxisDistance;
@property (nonatomic , assign)CGFloat   yLabelAndyAxisDistance;

//x,y轴上label的倾斜角度，默认-M_PI_2/6弧度 -30度
@property (nonatomic , assign)CGFloat   xlabelDegree;
@property (nonatomic , assign)CGFloat   ylabelDegree;
//折线上点的位置是不是在x轴上面两点的中心,默认是YES在中心点
@property (nonatomic , assign)BOOL      isXYValueCenterPoint;

// 画折线图或者柱状图是否有动画，默认yes 动画 时间默认0.8
@property (nonatomic , assign)BOOL      isAnimation;
@property (nonatomic , assign)CGFloat   animationTime;

//第一条折线或柱状图的颜色,默认与x,y轴同色
@property (nonatomic , strong)UIColor * baseChartColor;
//第二条折线或柱状图的颜色,默认橘色
@property (nonatomic , strong)UIColor * secondBaseChartColor;


//-----------------------坐标y轴上分割线的属性---------------------------
//y轴分割虚线宽度，默认1.0f
@property (nonatomic , assign)CGFloat   yDottedLineWidth;
//y轴分割虚线的颜色，默认与x,y轴同色
@property (nonatomic , strong)UIColor * yDottedLineColor;
//y轴分割线虚线每个小虚线长度以及虚线之间的间距 默认都是5个点   设置为1的时候可以表示实线
@property (nonatomic , assign)CGFloat   yDottedLineLength;


//-----------------------折线图上点属性--------------------------------

//枚举型，折线点的类型 默认是实心
typedef NS_ENUM (NSInteger, CirclePointType)   {
    CirclePointTypeNO     = 0,// 没有类型
    CirclePointTypeSolid  = 1,// 实心
    CirclePointTypeHollow = 2// 空心
};
@property (nonatomic , assign)CirclePointType  circlePointType;
//折线点的颜色，默认与图轴同色
@property (nonatomic , strong)UIColor * circlePointColor;
//第二条折线上圆圈的颜色,默认与图同色
@property (nonatomic , strong)UIColor * secondCirclePointColor;

//圆点的直径 ,默认5（lineWidth的2.5倍）
@property (nonatomic , assign)CGFloat   circlePointDiameter;
//空心圆的半径
@property (nonatomic , assign)CGFloat   hollowCirclePointRadii;
//内部折线图的宽及颜色,默认2.0 默认与x,y轴同色
@property (nonatomic , assign)CGFloat   lineChartWidth;


//触碰到点的x会画出x轴的标示虚线和label 默认YES 宽：2.5 颜色RGB： 39 96 104
@property (nonatomic , assign)BOOL      isXValueMarkLineBOOL;
@property (nonatomic , assign)CGFloat   xValueMarkLineWidth;
@property (nonatomic , strong)UIColor * xValueMarkLineColor;
//默认白色
@property (nonatomic , strong)UIColor * displayMarkLabelTextColor;
//设置显示label背景色同时也可以设置透明度，这样设置透明度，字体的透明度不变 默认黑色，透明度：0.5
@property (nonatomic , strong)UIColor * displayMarkLabelBGColor;
//默认13.0f
@property (nonatomic , assign)CGFloat   displayMarkLabelTextFontSize;


//-----------------------柱状图上点属性--------------------------------
//内部柱状图,默认2.0
@property (nonatomic , assign)CGFloat   barChartWidth;


@end
