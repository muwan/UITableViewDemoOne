//
//  NewSearchViewController.m
//  UITableViewDemoOne
//
//  Created by LHL on 16/5/5.
//
//

#import "NewSearchViewController.h"

@interface NewSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchControllerDelegate,UISearchResultsUpdating>
@property (nonatomic ,strong)UITableView *demoTableView;
@property (nonatomic ,strong)UISearchController *searchVC;
@property (nonatomic ,strong)NSMutableArray *exampleArr;
@property (nonatomic ,strong)NSMutableArray *searchArr;

@end

@implementation NewSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _exampleArr = [NSMutableArray arrayWithCapacity:200];
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    self.demoTableView.frame = CGRectMake(0, rectStatus.size.height, self.view.frame.size.width, self.view.frame.size.height - rectStatus.size.height);
    for (int i = 0; i < 200; i ++) {
        int NUMBER_OF_CHARS = 5;
        char data[NUMBER_OF_CHARS];//生成一个五位数的字符串
        for (int x=0;x<10;data[x++] = (char)('A' + (arc4random_uniform(26))));
        NSString *string = [[NSString alloc] initWithBytes:data length:5 encoding:NSUTF8StringEncoding];//随机给字符串赋值
        [_exampleArr addObject:string];
    }//随机生成200个五位数的字符串
    NSLog(@"%@",_exampleArr);

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath//cell
{
    static NSString *identify = @"cellIdentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    if (!self.searchVC.active) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",_exampleArr[indexPath.row]];
        
    }else
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",_searchArr[indexPath.row]];
        
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchVC.active) {
        return self.searchArr.count;//搜索结果
    }else
    {
        return self.exampleArr.count;//原始数据
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewSearchViewController *vc = [[NewSearchViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = [self.searchVC.searchBar text];
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
    if (self.searchArr!= nil) {
        [self.searchArr removeAllObjects];
    }
    //过滤数据
    self.searchArr= [NSMutableArray arrayWithArray:[_exampleArr filteredArrayUsingPredicate:preicate]];
    //刷新表格
    [self.demoTableView reloadData];
}

- (UITableView *)demoTableView
{
    if (!_demoTableView) {
        _demoTableView = [[UITableView alloc] init];
        _demoTableView.showsVerticalScrollIndicator = YES;
        _demoTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _demoTableView.delegate = self;
        _demoTableView.dataSource = self;
        [self.view addSubview:_demoTableView];
    }
    return _demoTableView;
}

- (UISearchController *)searchVC
{
    if (!_searchVC) {
        
        _searchVC = [[UISearchController alloc]initWithSearchResultsController:nil];
        _searchVC.searchResultsUpdater = self;
        
        _searchVC.dimsBackgroundDuringPresentation = NO;
        
        _searchVC.hidesNavigationBarDuringPresentation = NO;
        
        _searchVC.searchBar.frame = CGRectMake(self.searchVC.searchBar.frame.origin.x, self.searchVC.searchBar.frame.origin.y, self.searchVC.searchBar.frame.size.width, 44.0);
        
        self.demoTableView.tableHeaderView = self.searchVC.searchBar;
    }
    return _searchVC;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
