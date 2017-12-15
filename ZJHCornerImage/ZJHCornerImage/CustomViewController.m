//
//  ViewController.m
//  ZJHCornerImage
//
//  Created by ZhangJingHao2345 on 2017/12/5.
//  Copyright © 2017年 ZhangJingHao2345. All rights reserved.
//

#import "CustomViewController.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "CustomCell.h"
#import "FPSIndicatorMgr.h"

// cell每行个数
#define kCollectionCellLineCount 2
// 请求每页个数
#define kLoadPageCount 50

@interface CustomViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, weak  ) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) AFHTTPSessionManager *sessionMgr;
@property (nonatomic, assign) NSInteger currPage;

@end

@implementation CustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self bindRefresh];
}

- (void)setupUI {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat width = self.view.frame.size.width;
    CGFloat distance = 5;
    NSInteger itemCount = kCollectionCellLineCount;
    CGFloat itemW = (width - distance * (itemCount + 1)) / itemCount;
    CGFloat itemH = itemW * 1.2;
    layout.itemSize = CGSizeMake(itemW, itemH);
    layout.sectionInset = UIEdgeInsetsMake(distance, distance, distance, distance);
    layout.minimumInteritemSpacing = distance;
    layout.minimumLineSpacing = distance;
    
    UICollectionView *collectionView =
    [[UICollectionView alloc] initWithFrame:self.view.bounds
                       collectionViewLayout:layout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:NSClassFromString(self.cellName)
       forCellWithReuseIdentifier:self.cellName];
    collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    if (@available(iOS 11.0, *)) {
        if ([UIScreen mainScreen].bounds.size.height == 812) {
            collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            collectionView.contentInset = UIEdgeInsetsMake(88, 0, 0, 0);
            collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(88, 0, 0, 0);
        }
    }
}

- (void)bindRefresh {
    __weak typeof(self)wkSelf = self;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [wkSelf requestData];
    }];
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [wkSelf loadMoreData];
    }];
    
    self.dataArr = [NSMutableArray array];
    [self.collectionView.mj_header beginRefreshing];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:self.cellName forIndexPath:indexPath];
    [cell bindModel:self.dataArr[indexPath.row]];
    return cell;
}

- (void)requestData {
    self.currPage = 1;
    NSInteger per_page = kLoadPageCount;
    NSDictionary *param =@{@"page" : @(self.currPage), @"per_page" : @(per_page)};
    NSString *url = @"https://api.dribbble.com/v1/shots";
    __weak typeof(self)wkSelf = self;
    [self.sessionMgr GET:url
              parameters:param
                progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     if (responseObject) {
                         [wkSelf.dataArr addObjectsFromArray:responseObject];
                     }
                     [wkSelf.collectionView.mj_header endRefreshing];
                     
                     [wkSelf.collectionView reloadData];
                 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     NSLog(@"error : %@",error);
                     [wkSelf.collectionView.mj_header endRefreshing];
                 }];
}

- (void)loadMoreData {
    self.currPage++;
    NSInteger per_page = kLoadPageCount;
    NSDictionary *param =@{@"page" : @(self.currPage), @"per_page" : @(per_page)};
    NSString *url = @"https://api.dribbble.com/v1/shots";
    __weak typeof(self)wkSelf = self;
    [self.sessionMgr GET:url
              parameters:param
                progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     if (responseObject) {
                         [wkSelf.dataArr addObjectsFromArray:responseObject];
                     }
                     if (responseObject && ((NSArray *)responseObject).count == per_page) {
                         [wkSelf.collectionView.mj_footer endRefreshing];
                     } else {
                         [wkSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
                     }
                     [wkSelf.collectionView reloadData];
                 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     NSLog(@"error : %@",error);
                     [wkSelf.collectionView.mj_footer endRefreshing];
                 }];
}

- (AFHTTPSessionManager *)sessionMgr {
    if (!_sessionMgr) {
        _sessionMgr = [AFHTTPSessionManager manager];
        _sessionMgr.requestSerializer = [AFHTTPRequestSerializer serializer];
        [_sessionMgr.requestSerializer setValue:@"Bearer deeb37c0823d3866650db12df9e36730a0453a5a7b8e6493e0ac5ece15929613"
                             forHTTPHeaderField:@"Authorization"];
    }
    return _sessionMgr;
}

@end




