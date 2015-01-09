//
//  DataViewController.m
//  SimpleFlashcardsJP
//
//  Created by Teru on 2015/01/03.
//  CopyDown (c) 2015年 Self. All Downs reserved.
//

#import "DataViewController.h"
#import "CardTableViewController.h"
#import "ScrollViewController.h"
#import "ScrollTwoViewController.h"
#import "CardText.h"
#import "CardNumber.h"

@interface DataViewController ()

@property (nonatomic, strong) CardText *cardTextManager;
@property (nonatomic, strong) CardNumber *dbCardNumber;
@property (nonatomic, strong) NSArray *dbCardNumberInfo;
@property (nonatomic, strong) NSArray *dbCardTextInfo;
@property (nonatomic, strong) NSArray *cardTextCount;
@property (nonatomic, assign) int textNumber;

@property(nonatomic,strong) NSArray *sourceArry;     //数据源
@property(nonatomic,strong) NSMutableArray *passDataArr;
@property(nonatomic,strong) UIPageViewController *pageViewController;   //翻页控制器

@end

@implementation DataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController setNavigationBarHidden:YES];
    
    // Initialize the dbManager object.
    self.cardTextManager = [[CardText alloc] initWithDatabaseFilename:@"CardText.sql"];
    self.dbCardNumber = [[CardNumber alloc] initWithDatabaseFilename:@"CardNumber.sql"];
    
    //クエリー作成。
    NSString *queryLoadCT = [NSString stringWithFormat:@"select cardText from cardTextInfo where textNumber = %d", 0];
    NSString *queryLoadCN = [NSString stringWithFormat:@"select cardNumberInfoID from cardNumberInfo"];
    
    //データを読み込んで配列に追加。
    self.dbCardTextInfo = [[NSArray alloc] initWithArray:[self.cardTextManager loadDataFromDB:queryLoadCT]];
    self.dbCardNumberInfo = [[NSArray alloc] initWithArray:[self.dbCardNumber loadDataFromDB:queryLoadCN]];
    
    //arrColumnNamesでindexを指定。そうすることでSQLの空白と改行をなくせる。
    //NSInteger indexOfText = [self.cardTextManager.arrColumnNames indexOfObject:@"cardText"];
    
    //cardTextのpageIndex番目を表示。
    //NSString *textOne = [NSString stringWithFormat:@"%@", [[self.dbCardTextInfo objectAtIndex:self.pageIndex] objectAtIndex:indexOfText]];
    
    //現在表示しているカード番号と合計数を表示する。
    self.pageCountLabel.text = [NSString stringWithFormat:@"%ld of %ld", self.pageIndex + 1, self.dbCardNumberInfo.count];
    
    //クエリー作成。カード番号のテキストを取得。
    NSString *queryLoadCTC = [NSString stringWithFormat:@"select cardText from cardTextInfo where cardNumber = %@", [self.dbCardNumberInfo objectAtIndex:self.pageIndex]];
    
    //データを読み込んで配列に追加。カードのテキスト数を渡す。
    self.cardTextCount = [[NSArray alloc] initWithArray:[self.cardTextManager loadDataFromDB:queryLoadCTC]];
    
    self.pageControl.numberOfPages = self.cardTextCount.count;
    self.movePageSlider.minimumValue = 1;
    self.movePageSlider.maximumValue = self.dbCardNumberInfo.count;
    
    // NSMutableArrayを初期化。
    self.sourceArry = [[NSMutableArray alloc] init];
    
    //NSMutableArrayにテキストを渡してarrayに格納。
    for (int i = 0; i < self.dbCardNumberInfo.count; i++) {
        // NSMutableArrayを初期化。
        self.passDataArr = [[NSMutableArray alloc] init];
        
        //クエリー作成。カード番号のテキストを取得。
        NSString *queryLoadCTC = [NSString stringWithFormat:@"select cardText from cardTextInfo where cardNumber = %@", [self.dbCardNumberInfo objectAtIndex:i]];
        
        //データを読み込んで配列に追加。カードのテキスト数を渡す。
        self.cardTextCount = [[NSArray alloc] initWithArray:[self.cardTextManager loadDataFromDB:queryLoadCTC]];
        
        //テキスト番号のデータを取得。
        for (int k = 0; k < self.cardTextCount.count; k++) {
            //NSLog(@"k %d, i %d %@", k, i, [self.dbCardNumberInfo objectAtIndex:i]);
            
            //クエリー作成。
            NSString *queryLoadCT = [NSString stringWithFormat:@"select cardText from cardTextInfo where textNumber = %d AND cardNumber = %@", k, [self.dbCardNumberInfo objectAtIndex:i]];
            
            //データを読み込んで配列に追加。
            self.dbCardTextInfo = [[NSArray alloc] initWithArray:[self.cardTextManager loadDataFromDB:queryLoadCT]];
            
            //arrColumnNamesでindexを指定。そうすることでSQLの空白と改行をなくせる。
            NSInteger indexOfText = [self.cardTextManager.arrColumnNames indexOfObject:@"cardText"];
            
            //cardTextのpageIndex番目を表示。
            NSString *dataText = [NSString stringWithFormat:@"%@", [[self.dbCardTextInfo objectAtIndex:0] objectAtIndex:indexOfText]];
            //NSLog(@"%@", dataText);
            
            //テキストデータ格納。
            [self.passDataArr addObject:dataText];
            //NSLog(@"%ld", self.passDataArr.count);
            
        }
        //NSLog(@"i %d", i);
        
        //Arrayにデータを含むMutableArrを渡す。
        NSArray *dataArray = [[NSArray alloc] initWithArray:self.passDataArr];
        //NSLog(@"%ld", dataArray.count);
        
        // 配列に各データを含む配列を追加してsetViewControllers時のエラーを防ぐ。配列と配列の結合。
        self.sourceArry = [self.sourceArry arrayByAddingObjectsFromArray:@[dataArray]];
    }

    // Do any additional setup after loading the view.
    [self.backView addSubview:_backButton];
    [self.backView addSubview:_textView];
    [self.backView addSubview:_gearButton];
    [self.backView addSubview:_stopButton];
    [self.backView addSubview:_playButton];
    [self.backView addSubview:_pauseButton];
    [self.backView addSubview:_moveButton];
    [self.backView addSubview:_horizontalView];
    [self.horizontalView addSubview:_movePageSlider];
    [self.horizontalView addSubview:_crossButton];
    
    self.textNumber = 0;
    //ScrollViewController *VC = [[ScrollViewController alloc] init];
    //VC.textNumber = self.textNumber;
    [self initPageController];
    
    //NSLog(@"%@", self.sourceArry [1][1]);
}

- (void)initPageController
{
    //NSLog(@"%ld", self.sourceArry.count);
    
    ScrollViewController *VC1 = [[ScrollViewController alloc] init];
    //sourceArryの0番目の配列を渡す。
    VC1.sourceArrry = self.sourceArry[0];
    
    UIPageViewController *pageVC = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController = pageVC;
    [pageVC.view setFrame:self.textView.bounds];
    pageVC.delegate = self;
    pageVC.dataSource = self;
    //setViewControllersに中の配列の個数を渡す。
    [pageVC setViewControllers:@[VC1] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
        NSLog(@" 设置完成 ");
    }];
    [self addChildViewController:pageVC];
    [self.textView addSubview:[pageVC view]];
    pageVC.view.layer.borderWidth = 1;
}

- (void)initPageTwoController
{
    //NSLog(@"%ld", self.sourceArry.count);
    
    ScrollTwoViewController *VC2 = [[ScrollTwoViewController alloc] init];
    //sourceArryの0番目の配列を渡す。
    VC2.sourceArrry = self.sourceArry[0];
    
    UIPageViewController *pageVC = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController = pageVC;
    [pageVC.view setFrame:self.textView.bounds];
    pageVC.delegate = self;
    pageVC.dataSource = self;
    //setViewControllersに中の配列の個数を渡す。
    [pageVC setViewControllers:@[VC2] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
        NSLog(@" 设置完成 ");
    }];
    [self addChildViewController:pageVC];
    [self.textView addSubview:[pageVC view]];
    pageVC.view.layer.borderWidth = 1;
}

#pragma mark - PrivateAPI
//
- (ScrollViewController *)controllerWithSourceIndex:(NSInteger)index
{
    if (self.sourceArry.count < index) {
        return nil;
    }
    
    ScrollViewController *VC = [[ScrollViewController alloc] init];
    VC.sourceArrry = _sourceArry[index];
    return VC;
}

//返回当前的索引值
- (NSInteger)indexofController:(ScrollViewController *)viewController
{
    NSInteger index = [self.sourceArry indexOfObject:viewController.sourceArrry];
    return index;
}

#pragma mark - UIPageViewControllerDataSource
//
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = [self indexofController:(ScrollViewController *)viewController];
    if (index == 0 || index == NSNotFound) {
        return nil;
    }
    index--;
    
    self.pageIndex = index;
    
    return [self controllerWithSourceIndex:index];
}

//
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = [self indexofController:(ScrollViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == [self.sourceArry count]) {
        return nil;
    }
    
    self.pageIndex = index;
    
    return [self controllerWithSourceIndex:index];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backAction:(id)sender {
    // 隠していたNavBarを表示。
    [self.navigationController setNavigationBarHidden:NO];
    // コードからNavのBackボタンタップで前画面に戻る。
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textData{
    //ScrollViewController *VC1 = [[ScrollViewController alloc] init];
    
    //クエリー作成。
    NSString *queryLoadCT = [NSString stringWithFormat:@"select cardText from cardTextInfo where textNumber = %d AND cardNumber = %@", self.textNumber, [self.dbCardNumberInfo objectAtIndex:self.pageIndex]];
    //データを読み込んで配列に追加。
    self.dbCardTextInfo = [[NSArray alloc] initWithArray:[self.cardTextManager loadDataFromDB:queryLoadCT]];
    
    //arrColumnNamesでindexを指定。そうすることでSQLの空白と改行をなくせる。
    //NSInteger indexOfText = [self.cardTextManager.arrColumnNames indexOfObject:@"cardText"];
    //cardTextのpageIndex番目を表示。
    //VC1.textView.text = [NSString stringWithFormat:@"%@", [[self.dbCardTextInfo objectAtIndex:0] objectAtIndex:indexOfText]];
    //VC1.textView.text = self.sourceArry[self.pageIndex][self.textNumber];
    
    
    self.pageControl.currentPage = self.textNumber;
}

- (IBAction)changeTextAction:(id)sender {
    //クエリー作成。pageIndexに1を足してcardNumberに合わせる。
    NSString *queryLoadCTC = [NSString stringWithFormat:@"select cardText from cardTextInfo where cardNumber = %@", [self.dbCardNumberInfo objectAtIndex:self.pageIndex]];
    
    //データを読み込んで配列に追加。
    self.cardTextCount = [[NSArray alloc] initWithArray:[self.cardTextManager loadDataFromDB:queryLoadCTC]];
    //NSLog(@"count %ld cardNumber %@", self.cardTextCount.count, [self.dbCardNumberInfo objectAtIndex:self.pageIndex]);
    
    //VC.scrollDelegate = self;
    
    if (self.textNumber == 0) {
        self.textNumber = 1;
        [self initPageTwoController];
        
        [self textData];
        
    }else if (self.textNumber == 1) {
        if (self.cardTextCount.count == 2) {
            self.textNumber = 0;
            [self textData];
            
        }else{
            self.textNumber = 2;
            [self textData];
        }
        
    }else if (self.textNumber == 2) {
        if (self.cardTextCount.count == 3) {
            self.textNumber = 0;
            [self textData];
            
        }else{
            self.textNumber = 3;
            [self textData];
        }
        
    }else if (self.textNumber == 3) {
        if (self.cardTextCount.count == 4) {
            self.textNumber = 0;
            [self textData];
            
        }else{
            self.textNumber = 4;
            [self textData];
        }
        
    }else if (self.textNumber == 4) {
            self.textNumber = 0;
            [self textData];
    }
}

- (IBAction)movePageAction:(id)sender {
    self.horizontalView.hidden = NO;
    self.movePageSlider.hidden = NO;
    self.crossButton.hidden = NO;
    
    ScrollViewController *VC = [self controllerWithSourceIndex:3];
    [self.pageViewController setViewControllers:@[VC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
        NSLog(@" 设置完成 ");
    }];
    
    
    //現在表示しているカード番号と合計数を表示する。
    self.pageCountLabel.text = [NSString stringWithFormat:@"%d of %ld", 4, self.dbCardNumberInfo.count];
    
    self.movePageSlider.value = self.pageIndex + 1;
    
    self.showMoveSlider = 1;
}

- (IBAction)crossAction:(id)sender {
    self.horizontalView.hidden = YES;
    self.movePageSlider.hidden = YES;
    self.crossButton.hidden = YES;
    
    self.showMoveSlider = -1;
}

- (IBAction)playAction:(id)sender {
    self.playButton.hidden = YES;
    self.pauseButton.hidden = NO;
    self.stopButton.hidden = NO;
}

- (IBAction)pauseAction:(id)sender {
    self.pauseButton.hidden = YES;
    self.playButton.hidden = NO;
}

- (IBAction)stopAction:(id)sender {
    self.playButton.hidden = NO;
    self.pauseButton.hidden = YES;
    self.stopButton.hidden = YES;
}

#pragma mark - UIPageViewControllerDelegate
/*即将转换开始的方法
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
       NSLog(@" 开始动画  %@ ",[pendingViewControllers valueForKey:@"sourceArrry"]);
    
    //現在表示しているカード番号と合計数を表示する。
    self.pageCountLabel.text = [NSString stringWithFormat:@"%ld of %ld", self.pageIndex + 1, self.dbCardNumberInfo.count];
    //クエリー作成。カード番号のテキストを取得。
    NSString *queryLoadCTC = [NSString stringWithFormat:@"select cardText from cardTextInfo where cardNumber = %@", [self.dbCardNumberInfo objectAtIndex:self.pageIndex]];
    
    //データを読み込んで配列に追加。カードのテキスト数を渡す。
    self.cardTextCount = [[NSArray alloc] initWithArray:[self.cardTextManager loadDataFromDB:queryLoadCTC]];
    
    self.pageControl.numberOfPages = self.cardTextCount.count;
    self.textNumber = 0;
    self.pageControl.currentPage = self.textNumber;
}*/

//动画结束后回调的方法
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)complete
{
    ScrollViewController *VC = [pageViewController.viewControllers lastObject];
    self.pageIndex = [self indexofController:VC];
        NSLog(@" 动画结束 %@ ",pageViewController.viewControllers);
    
    //現在表示しているカード番号と合計数を表示する。
    self.pageCountLabel.text = [NSString stringWithFormat:@"%ld of %ld", self.pageIndex + 1, self.dbCardNumberInfo.count];
    //クエリー作成。カード番号のテキストを取得。
    NSString *queryLoadCTC = [NSString stringWithFormat:@"select cardText from cardTextInfo where cardNumber = %@", [self.dbCardNumberInfo objectAtIndex:self.pageIndex]];
    
    //データを読み込んで配列に追加。カードのテキスト数を渡す。
    self.cardTextCount = [[NSArray alloc] initWithArray:[self.cardTextManager loadDataFromDB:queryLoadCTC]];
    
    self.pageControl.numberOfPages = self.cardTextCount.count;
    self.textNumber = 0;
    self.pageControl.currentPage = self.textNumber;
}

@end
