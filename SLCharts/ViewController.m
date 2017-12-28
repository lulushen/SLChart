//
//  ViewController.m
//  SLCharts
//
//  Created by 上海数聚 on 17/5/12.
//  Copyright © 2017年 上海数聚. All rights reserved.
//

#import "ViewController.h"
#import "SLBaseChartView.h"
#import "SLPieChartView.h"
@interface ViewController ()<TouchBaseChartDelegate,TouchPieChartDelegate>
//折线图
@property (nonatomic , strong)SLBaseChartView * lineChart;
@property (nonatomic , strong)SLBaseChartView * barChart;

@property (nonatomic, strong)SLPieChartView * pieChart;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _barChart  = [[SLBaseChartView alloc] init];
    _barChart.frame = CGRectMake(30, 30, self.view.frame.size.width-60, 200);
    _barChart.backgroundColor = [UIColor colorWithRed:64/225.0 green:106/225.0 blue:147/225.0 alpha:1];
    _barChart.delegate = self;
    _barChart.xValuesArray =
    [NSMutableArray arrayWithObjects:@"201606",@"201607",@"201608",@"201609",@"201610",@"201611", nil];
    _barChart.yValuesArray =  [NSMutableArray arrayWithObjects:@"686",@"630",@"760",@"673",@"807",@"856", nil];
//     _barChart.ySecondValuesArray =  [NSMutableArray arrayWithObjects:@"686",@"630",@"760",@"673",@"807",@"856",@"784", nil];
    _barChart.secondBaseChartColor = [UIColor orangeColor];
    _barChart.chartType = SLBaseBarChartType;
    _barChart.yUnitString = @"%";
    _barChart.isAnimation = NO;
    [self.view addSubview:_barChart];

    
    
    _lineChart  = [[SLBaseChartView alloc] init];
    _lineChart.frame = CGRectMake(30, 240, self.view.frame.size.width-60, 200);
    _lineChart.backgroundColor = [UIColor colorWithRed:64/225.0 green:106/225.0 blue:147/225.0 alpha:1];
    _lineChart.delegate = self;
    _lineChart.xValuesArray =
    [NSMutableArray arrayWithObjects:@"201611",@"201611",@"201611",@"201611",@"201611",@"201611", nil];
//    _lineChart.ySecondValuesArray =  [NSMutableArray arrayWithObjects:@"686",@"999999.9",@"760",@"673",@"807",@"856", nil];
    _lineChart.yValuesArray =
//    [NSMutableArray arrayWithObjects:@"5",@"119",@"6",@"3",@"8",@"4", nil];
//    [NSMutableArray arrayWithObjects:@"-30",@"0",@"34", nil];
//    [NSMutableArray arrayWithObjects:@"430330.87", nil];
//    [NSMutableArray arrayWithObjects:@"-490337.687", nil];
//    [NSMutableArray arrayWithObjects:@"50",@"50",@"60",@"30",@"30",@"40", nil];
    [NSMutableArray arrayWithObjects:@"0.422",@"0.403",@"0.345",@"0.390",@"0.398",@"0.457", nil];
//    [NSMutableArray arrayWithObjects:@"-724",@"-686",@"-614",@"-660",@"-673",@"-807", nil];
    _lineChart.circlePointType = CirclePointTypeSolid;
    //724 686 614 660 673 807
    //_lineChart.xUnitString = @"元";
//    _lineChart.ySecondValuesArray =  [NSMutableArray arrayWithObjects:@"0.422",@"2.9",@"2.1",@"0.4",@"0.8",@"3.9", nil];

    _lineChart.yUnitString = @"%";
    _lineChart.secondBaseChartColor = [UIColor orangeColor];

    _lineChart.isAnimation = NO;
    [self.view addSubview:_lineChart];
    // Do any additional setup after loading the view, typically from a nib.
    
    _pieChart = [[SLPieChartView alloc] init];
    _pieChart.frame = CGRectMake(30, 450, self.view.frame.size.width-60, 200);
    _pieChart.backgroundColor = [UIColor colorWithRed:64/225.0 green:106/225.0 blue:147/225.0 alpha:1];
    _pieChart.xValuesArray =
    //    [NSMutableArray arrayWithObjects:@"201611",@"201610", nil];
    [NSMutableArray arrayWithObjects:@"20150923",@"20151029",@"20151130",@"20151218",@"20160119",@"20160228", nil];
    _pieChart.yValuesArray = [NSMutableArray arrayWithObjects:@"4.53",@"4.3",@"3.79",@"4.12",@"4.22",@"5.11", nil];

    _pieChart.yUnitString = @"亿万";
    _pieChart.isAmination = NO;
    _pieChart.backgroundColor = [UIColor colorWithRed:53/255.0 green:167/255.0 blue:93/255.0 alpha:1];
    [self.view addSubview:_pieChart];
    _pieChart.delegate = self;
}


-(void)touchBaseChartXValue:(NSString *)xValue yValue:(NSString *)yValue secondYValue:(NSString *)secondYValue
{
    NSLog(@"------------%@,%@,%@",xValue,yValue,secondYValue);

}
-(void)touchPieChartXValue:(NSString *)xValue yValue:(NSString *)yValue
{
     NSLog(@"-------pie-----%@,%@",xValue,yValue);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
