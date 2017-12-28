//
//  SLPieChartView.h
//  SLCharts
//
//  Created by 上海数聚 on 17/6/1.
//  Copyright © 2017年 上海数聚. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TouchPieChartDelegate <NSObject>
@required
-(void)touchPieChartXValue:(NSString*)xValue yValue:(NSString*)yValue;
@end

@interface SLPieChartView : UIView
@property (nonatomic, weak) id<TouchPieChartDelegate> delegate;

// x,y值数组
@property (nonatomic , strong)NSMutableArray * xValuesArray;
@property (nonatomic , strong)NSMutableArray * yValuesArray;

//y值单位字体颜色大小,默认13.0f,白色
@property (nonatomic , strong)NSString * yUnitString;
//显示标示默认白色
@property (nonatomic , strong)UIColor * displayMarkLabelTextColor;
//设置显示label背景色同时也可以设置透明度，这样设置透明度，字体的透明度不变 默认黑色，透明度：0.5
@property (nonatomic , strong)UIColor * displayMarkLabelBGColor;
//默认13.0f
@property (nonatomic , assign)CGFloat   displayMarkLabelTextFontSize;


//扇形颜色数组,默认有六种颜色
@property (nonatomic , strong)NSMutableArray * pieColorArray;
//是否有动画默认有动画， 默认动画时间0.8
@property (nonatomic , assign)BOOL isAmination;
@property (nonatomic , assign)CGFloat     animationTime;

//标示x值的颜色及字体大小 默认白色，大小13.0f
@property (nonatomic , strong)UIColor * labelTextColor;
@property (nonatomic , assign)CGFloat labelTextFontSize;


@end
