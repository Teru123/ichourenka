//
//  DataViewController.m
//  SimpleFlashcardsJP
//
//  Created by Teru on 2015/01/03.
//  CopyDown (c) 2015年 Self. All Downs reserved.
//

#import "DataViewController.h"
#import "CardTableViewController.h"
#import "CardText.h"
#import "CardNumber.h"
#import "Options.h"

@interface DataViewController ()

@property (nonatomic, strong) CardText *cardTextManager;
@property (nonatomic, strong) CardNumber *dbCardNumber;
@property (nonatomic, strong) Options *dbOptions;
@property (nonatomic, strong) NSArray *dbOptionInfo;
@property (nonatomic, strong) NSArray *dbCardNumberInfo;
@property (nonatomic, strong) NSArray *dbCardTextInfo;
@property (nonatomic, strong) NSArray *cardTextCount;
@property (nonatomic, strong) NSArray *checkTheSecondTxt;
@property (nonatomic, strong) NSString *secondText;
@property (nonatomic, strong) NSString *fileIDStr;
@property (nonatomic, assign) int textNumber;
@property (nonatomic, assign) BOOL randomSwitch;

@property(nonatomic,strong) NSArray *sourceArry;     //数据源
@property(nonatomic,strong) NSMutableArray *passDataArr;
@property(nonatomic,strong) NSMutableArray *randomIndex;

@end

@implementation DataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController setNavigationBarHidden:YES];
    
    self.fileIDStr = [NSString stringWithFormat:@"%ld", self.fileID];
    NSLog(@"fileIDStr %@", self.fileIDStr);
    
    // Initialize the dbManager object.
    self.cardTextManager = [[CardText alloc] initWithDatabaseFilename:@"CardText.sql"];
    self.dbCardNumber = [[CardNumber alloc] initWithDatabaseFilename:@"CardNumberDB.sql"];
    
    //クエリー作成。
    NSString *queryLoadCT = [NSString stringWithFormat:@"select cardText from cardTextInfo where textNumber = %d AND filename = '%@' ", 0, self.fileIDStr];
    NSString *queryLoadCN = [NSString stringWithFormat:@"select cardNumberInfoID from cardNumberInfo where filename = '%@' ", self.fileIDStr];
    
    //データを読み込んで配列に追加。
    self.dbCardTextInfo = [[NSArray alloc] initWithArray:[self.cardTextManager loadDataFromDB:queryLoadCT]];
    self.dbCardNumberInfo = [[NSArray alloc] initWithArray:[self.dbCardNumber loadDataFromDB:queryLoadCN]];
    
    NSLog(@"count txtinfo %ld, cninfo %ld", self.dbCardTextInfo.count, self.dbCardNumberInfo.count);
    
    if (self.dbCardTextInfo.count == 0) {
        NSLog(@"STOP");
        self.pageCountLabel.text = @"1 of 1";
        self.textView.text = @"'カードを編集'でカードを追加してください。";
        self.pageControl.numberOfPages = 1;
        self.movePageSlider.minimumValue = 0;
        self.movePageSlider.maximumValue = 0;
        
    }else{
        //現在表示しているカード番号と合計数を表示する。
        self.pageCountLabel.text = [NSString stringWithFormat:@"%ld of %ld", self.pageIndex + 1, self.dbCardNumberInfo.count];
        
        //クエリー作成。カード番号のテキストを取得。
        NSString *queryLoadCTC = [NSString stringWithFormat:@"select cardText from cardTextInfo where cardNumber = %@ AND filename = '%@' ", [self.dbCardNumberInfo objectAtIndex:self.pageIndex], self.fileIDStr];
        
        //データを読み込んで配列に追加。カードのテキスト数を渡す。
        self.cardTextCount = [[NSArray alloc] initWithArray:[self.cardTextManager loadDataFromDB:queryLoadCTC]];
        
        //カード2番目のテキストをチェック。
        [self checkTheSecondText];
        
        //カード2番目のテキストが空欄の場合はドット表示は1Pageのみ。
        if ([self.secondText isEqualToString:@""]) {
            self.pageControl.numberOfPages = 1;
        }else{
            self.pageControl.numberOfPages = self.cardTextCount.count;
        }
        
        self.movePageSlider.minimumValue = 0;
        //countは1から数えるので-1をする。
        self.movePageSlider.maximumValue = self.dbCardNumberInfo.count - 1;
        // 値が変更された時にsliderValueメソッドを呼び出す
        [self.movePageSlider addTarget:self action:@selector(sliderValue:) forControlEvents:UIControlEventValueChanged];
        
        // NSMutableArrayを初期化。
        self.sourceArry = [[NSMutableArray alloc] init];
        
        //NSMutableArrayにテキストを渡してarrayに格納。
        for (int i = 0; i < self.dbCardNumberInfo.count; i++) {
            // NSMutableArrayを初期化。
            self.passDataArr = [[NSMutableArray alloc] init];
            
            //クエリー作成。カード番号のテキストを取得。
            NSString *queryLoadCTC = [NSString stringWithFormat:@"select cardText from cardTextInfo where cardNumber = %@ AND filename = '%@' ", [self.dbCardNumberInfo objectAtIndex:i], self.fileIDStr];
            
            //データを読み込んで配列に追加。カードのテキスト数を渡す。
            self.cardTextCount = [[NSArray alloc] initWithArray:[self.cardTextManager loadDataFromDB:queryLoadCTC]];
            
            //テキスト番号のデータを取得。
            for (int k = 0; k < self.cardTextCount.count; k++) {
                //NSLog(@"k %d, i %d %@", k, i, [self.dbCardNumberInfo objectAtIndex:i]);
                
                //クエリー作成。
                NSString *queryLoadCT = [NSString stringWithFormat:@"select cardText from cardTextInfo where textNumber = %d AND cardNumber = %@ AND filename = '%@' ", k, [self.dbCardNumberInfo objectAtIndex:i], self.fileIDStr];
                
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
        
        /* 左スワイプ */
        UISwipeGestureRecognizer* swipeLeftGesture =
        [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(view_SwipeLeft:)];
        swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
        
        [self.view addGestureRecognizer:swipeLeftGesture];
        
        /* 右スワイプ */
        UISwipeGestureRecognizer* swipeRightGesture =
        [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(view_SwipeRight:)];
        swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
        
        [self.view addGestureRecognizer:swipeRightGesture];
        
        /* 上スワイプ */
        UISwipeGestureRecognizer* swipeUpGesture =
        [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(view_SwipeUp:)];
        swipeUpGesture.direction = UISwipeGestureRecognizerDirectionUp;
        
        [self.view addGestureRecognizer:swipeUpGesture];
        
        /* 下スワイプ */
        UISwipeGestureRecognizer* swipeDownGesture =
        [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(view_SwipeDown:)];
        swipeDownGesture.direction = UISwipeGestureRecognizerDirectionDown;
        
        [self.view addGestureRecognizer:swipeDownGesture];
        
        [self animationStart];
        
        //self.textNumber = 0;
        //self.textView.text = [NSString stringWithFormat:@"%@", self.sourceArry[0][0]];
        
        //NSLog(@"%ld", self.sourceArry.count);
    }
}

- (void)viewWillAppear:(BOOL)animated{
    if (self.dbCardTextInfo.count != 0){
        // Initialize the dbManager object.
        self.dbOptions = [[Options alloc] initWithDatabaseFilename:@"options.sql"];
        //クエリー作成。
        NSString *queryOrder = [NSString stringWithFormat:@"select * from optionInfo"];
        //データを読み込んで配列に追加。
        self.dbOptionInfo = [[NSArray alloc] initWithArray:[self.dbOptions loadDataFromDB:queryOrder]];
        //arrColumnNamesでselectedopstrのindexを取得。
        NSInteger opIndex = [self.dbOptions.arrColumnNames indexOfObject:@"selectedop"];
        
        self.randomIndex = [[NSMutableArray alloc] init];
        
        //文字サイズ。
        if ([[[self.dbOptionInfo objectAtIndex:1] objectAtIndex:opIndex] integerValue] == 0) {
            [self.textView setFont:[UIFont systemFontOfSize:15]];
        }else if ([[[self.dbOptionInfo objectAtIndex:1] objectAtIndex:opIndex] integerValue] == 1) {
            [self.textView setFont:[UIFont systemFontOfSize:20]];
        }else if ([[[self.dbOptionInfo objectAtIndex:1] objectAtIndex:opIndex] integerValue] == 2) {
            [self.textView setFont:[UIFont systemFontOfSize:25]];
        }else if ([[[self.dbOptionInfo objectAtIndex:1] objectAtIndex:opIndex] integerValue] == 3) {
            [self.textView setFont:[UIFont systemFontOfSize:30]];
        }
        //背景色。
        if ([[[self.dbOptionInfo objectAtIndex:2] objectAtIndex:opIndex] integerValue] == 0) {
            self.backView.backgroundColor = [UIColor blueColor];
        }else if ([[[self.dbOptionInfo objectAtIndex:2] objectAtIndex:opIndex] integerValue] == 1) {
            self.backView.backgroundColor = [UIColor brownColor];
        }else if ([[[self.dbOptionInfo objectAtIndex:2] objectAtIndex:opIndex] integerValue] == 2) {
            self.backView.backgroundColor = [UIColor cyanColor];
        }else if ([[[self.dbOptionInfo objectAtIndex:2] objectAtIndex:opIndex] integerValue] == 3) {
            self.backView.backgroundColor = [UIColor grayColor];
        }else if ([[[self.dbOptionInfo objectAtIndex:2] objectAtIndex:opIndex] integerValue] == 4) {
            self.backView.backgroundColor = [UIColor greenColor];
        }else if ([[[self.dbOptionInfo objectAtIndex:2] objectAtIndex:opIndex] integerValue] == 5) {
            self.backView.backgroundColor = [UIColor orangeColor];
        }else if ([[[self.dbOptionInfo objectAtIndex:2] objectAtIndex:opIndex] integerValue] == 6) {
            self.backView.backgroundColor = [UIColor purpleColor];
        }else if ([[[self.dbOptionInfo objectAtIndex:2] objectAtIndex:opIndex] integerValue] == 7) {
            self.backView.backgroundColor = [UIColor redColor];
        }else if ([[[self.dbOptionInfo objectAtIndex:2] objectAtIndex:opIndex] integerValue] == 8) {
            self.backView.backgroundColor = [UIColor yellowColor];
        }
        //カードの順序。
        if ([[[self.dbOptionInfo objectAtIndex:0] objectAtIndex:opIndex] integerValue] == 0) {
            self.textNumber = 0;
            self.pageIndex = 0;
            self.randomSwitch = NO;
            [self resetPageAndText];
        }else if ([[[self.dbOptionInfo objectAtIndex:0] objectAtIndex:opIndex] integerValue] == 1) {
            //random
            self.textNumber = 0;
            self.pageIndex = 0;
            //NSLog(@"count %ld", self.sourceArry.count);
            
            for (int k = 0; k < self.sourceArry.count; k++) {
                [self.randomIndex addObject:[NSNumber numberWithInt:k]];
            }
            
            for (NSUInteger i = 0; i < self.sourceArry.count; ++i) {
                // Select a random element between i and end of array to swap with.
                NSInteger nElements = self.sourceArry.count - i;
                NSInteger n = (arc4random() % nElements) + i;
                [self.randomIndex exchangeObjectAtIndex:i withObjectAtIndex:n];
            }
            
            //for (int k = 0; k < self.sourceArry.count; k++) {
            //NSLog(@"%@", [NSString stringWithFormat:@"%@", self.randomIndex[k]]);
            //}
            
            self.randomSwitch = YES;
            [self resetPageAndText];
        }
    }else if(self.dbCardTextInfo.count == 0){
        // Initialize the dbManager object.
        self.dbOptions = [[Options alloc] initWithDatabaseFilename:@"options.sql"];
        //クエリー作成。
        NSString *queryOrder = [NSString stringWithFormat:@"select * from optionInfo"];
        //データを読み込んで配列に追加。
        self.dbOptionInfo = [[NSArray alloc] initWithArray:[self.dbOptions loadDataFromDB:queryOrder]];
        //arrColumnNamesでselectedopstrのindexを取得。
        NSInteger opIndex = [self.dbOptions.arrColumnNames indexOfObject:@"selectedop"];
        
        self.randomIndex = [[NSMutableArray alloc] init];
        
        //文字サイズ。
        if ([[[self.dbOptionInfo objectAtIndex:1] objectAtIndex:opIndex] integerValue] == 0) {
            [self.textView setFont:[UIFont systemFontOfSize:15]];
        }else if ([[[self.dbOptionInfo objectAtIndex:1] objectAtIndex:opIndex] integerValue] == 1) {
            [self.textView setFont:[UIFont systemFontOfSize:20]];
        }else if ([[[self.dbOptionInfo objectAtIndex:1] objectAtIndex:opIndex] integerValue] == 2) {
            [self.textView setFont:[UIFont systemFontOfSize:25]];
        }else if ([[[self.dbOptionInfo objectAtIndex:1] objectAtIndex:opIndex] integerValue] == 3) {
            [self.textView setFont:[UIFont systemFontOfSize:30]];
        }
        //背景色。
        if ([[[self.dbOptionInfo objectAtIndex:2] objectAtIndex:opIndex] integerValue] == 0) {
            self.backView.backgroundColor = [UIColor blueColor];
        }else if ([[[self.dbOptionInfo objectAtIndex:2] objectAtIndex:opIndex] integerValue] == 1) {
            self.backView.backgroundColor = [UIColor brownColor];
        }else if ([[[self.dbOptionInfo objectAtIndex:2] objectAtIndex:opIndex] integerValue] == 2) {
            self.backView.backgroundColor = [UIColor cyanColor];
        }else if ([[[self.dbOptionInfo objectAtIndex:2] objectAtIndex:opIndex] integerValue] == 3) {
            self.backView.backgroundColor = [UIColor grayColor];
        }else if ([[[self.dbOptionInfo objectAtIndex:2] objectAtIndex:opIndex] integerValue] == 4) {
            self.backView.backgroundColor = [UIColor greenColor];
        }else if ([[[self.dbOptionInfo objectAtIndex:2] objectAtIndex:opIndex] integerValue] == 5) {
            self.backView.backgroundColor = [UIColor orangeColor];
        }else if ([[[self.dbOptionInfo objectAtIndex:2] objectAtIndex:opIndex] integerValue] == 6) {
            self.backView.backgroundColor = [UIColor purpleColor];
        }else if ([[[self.dbOptionInfo objectAtIndex:2] objectAtIndex:opIndex] integerValue] == 7) {
            self.backView.backgroundColor = [UIColor redColor];
        }else if ([[[self.dbOptionInfo objectAtIndex:2] objectAtIndex:opIndex] integerValue] == 8) {
            self.backView.backgroundColor = [UIColor yellowColor];
        }
    }
}

- (void)animationStart{
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationDuration:0.5];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    // Make the animatable changes.
    self.textView.alpha = 0.0;
    self.textView.alpha = 1.0;
    
    // Commit the changes and perform the animation.
    [UIView commitAnimations];
}

- (void)view_SwipeLeft:(UISwipeGestureRecognizer *)sender{
    if (self.pageIndex + 1 < self.sourceArry.count) {
        self.pageIndex += 1;
        [self resetPageAndText];
        self.movePageSlider.value = self.pageIndex;
        self.pageLabel.text = [NSString stringWithFormat:@"%ld", self.pageIndex + 1];
    }
    [self animationStart];
}

- (void)view_SwipeRight:(UISwipeGestureRecognizer *)sender{
    if (0 < self.pageIndex) {
        self.pageIndex -= 1;
        [self resetPageAndText];
        self.movePageSlider.value = self.pageIndex;
        self.pageLabel.text = [NSString stringWithFormat:@"%ld", self.pageIndex + 1];
    }
    [self animationStart];
}

- (void)view_SwipeUp:(UISwipeGestureRecognizer *)sender{
    [self changeBackText];
}

- (void)view_SwipeDown:(UISwipeGestureRecognizer *)sender{
    [self changeNextText];
}

- (void)checkTheSecondText{
    if (self.randomSwitch == NO) {
        //クエリー作成。cardNumberはdbCardNumberInfo Arrayから値を取得しているので'%@'の''は不要。
        NSString *queryLoadCT = [NSString stringWithFormat:@"select cardText from cardTextInfo where textNumber = %d AND cardNumber = %@ AND filename = '%@' ", 1, [self.dbCardNumberInfo objectAtIndex:self.pageIndex], self.fileIDStr];
        
        //データを読み込んで配列に追加。
        self.checkTheSecondTxt = [[NSArray alloc] initWithArray:[self.cardTextManager loadDataFromDB:queryLoadCT]];
        //NSLog(@"txt %ld %@ %ld", self.checkTheSecondTxt.count, queryLoadCT, self.pageIndex);
        
        //arrColumnNamesでindexを指定。そうすることでSQLの空白と改行をなくせる。
        NSInteger indexOfText = [self.cardTextManager.arrColumnNames indexOfObject:@"cardText"];
        //cardTextのpageIndex番目を表示。
        self.secondText = [NSString stringWithFormat:@"%@", [[self.checkTheSecondTxt objectAtIndex:0] objectAtIndex:indexOfText]];
        
        //NSLog(@"txt %@", self.secondText);
    }else{
        //randomIndexのpageIndex番目を取得。
        NSInteger index = [[self.randomIndex objectAtIndex:self.pageIndex] integerValue];
        //NSLog(@"%ld", index);
        
        //クエリー作成。cardNumberはdbCardNumberInfo Arrayから値を取得しているので'%@'の''は不要。
        NSString *queryLoadCT = [NSString stringWithFormat:@"select cardText from cardTextInfo where textNumber = %d AND cardNumber = %@ AND filename = '%@' ", 1, [self.dbCardNumberInfo objectAtIndex:index], self.fileIDStr];
        
        //データを読み込んで配列に追加。
        self.checkTheSecondTxt = [[NSArray alloc] initWithArray:[self.cardTextManager loadDataFromDB:queryLoadCT]];
        //NSLog(@"txt %ld %@ %ld", self.checkTheSecondTxt.count, queryLoadCT, self.pageIndex);
        
        //arrColumnNamesでindexを指定。そうすることでSQLの空白と改行をなくせる。
        NSInteger indexOfText = [self.cardTextManager.arrColumnNames indexOfObject:@"cardText"];
        //cardTextのpageIndex番目を表示。
        self.secondText = [NSString stringWithFormat:@"%@", [[self.checkTheSecondTxt objectAtIndex:0] objectAtIndex:indexOfText]];
        
        //NSLog(@"txt %@", self.secondText);
    }
    
}

- (void)textData{
    [self checkTheSecondText];
    
    if ([self.secondText isEqualToString:@""]) {
        self.pageControl.currentPage = 0;
    }else{
        self.pageControl.currentPage = self.textNumber;
    }
}

- (void)resetPageAndText{
    [self checkTheSecondText];
    
    if (self.randomSwitch == NO) {
        if ([self.secondText isEqualToString:@""]) {
            //現在表示しているカード番号と合計数を表示する。
            self.pageCountLabel.text = [NSString stringWithFormat:@"%ld of %ld", self.pageIndex + 1, self.dbCardNumberInfo.count];
            
            self.pageControl.numberOfPages = 1;
            self.textNumber = 0;
            self.pageControl.currentPage = self.textNumber;
            self.textView.text = [NSString stringWithFormat:@"%@", self.sourceArry[self.pageIndex][0]];
        }else{
            //現在表示しているカード番号と合計数を表示する。
            self.pageCountLabel.text = [NSString stringWithFormat:@"%ld of %ld", self.pageIndex + 1, self.dbCardNumberInfo.count];
            //クエリー作成。カード番号のテキストを取得。
            NSString *queryLoadCTC = [NSString stringWithFormat:@"select cardText from cardTextInfo where cardNumber = %@ AND filename = '%@' ", [self.dbCardNumberInfo objectAtIndex:self.pageIndex], self.fileIDStr];
            
            //データを読み込んで配列に追加。カードのテキスト数を渡す。
            self.cardTextCount = [[NSArray alloc] initWithArray:[self.cardTextManager loadDataFromDB:queryLoadCTC]];
            
            self.pageControl.numberOfPages = self.cardTextCount.count;
            self.textNumber = 0;
            self.pageControl.currentPage = self.textNumber;
            self.textView.text = [NSString stringWithFormat:@"%@", self.sourceArry[self.pageIndex][0]];
        }
    }else{
        if ([self.secondText isEqualToString:@""]) {
            //現在表示しているカード番号と合計数を表示する。
            self.pageCountLabel.text = [NSString stringWithFormat:@"%ld of %ld", self.pageIndex + 1, self.dbCardNumberInfo.count];
            
            self.pageControl.numberOfPages = 1;
            self.textNumber = 0;
            self.pageControl.currentPage = self.textNumber;
            //randomIndexのpageIndex番目を取得。
            NSInteger index = [[self.randomIndex objectAtIndex:self.pageIndex] integerValue];
            self.textView.text = [NSString stringWithFormat:@"%@", self.sourceArry[index][0]];
        }else{
            //現在表示しているカード番号と合計数を表示する。
            self.pageCountLabel.text = [NSString stringWithFormat:@"%ld of %ld", self.pageIndex + 1, self.dbCardNumberInfo.count];
            //randomIndexのpageIndex番目を取得。
            NSInteger index = [[self.randomIndex objectAtIndex:self.pageIndex] integerValue];
            //クエリー作成。カード番号のテキストを取得。
            NSString *queryLoadCTC = [NSString stringWithFormat:@"select cardText from cardTextInfo where cardNumber = %@ AND filename = '%@' ", [self.dbCardNumberInfo objectAtIndex:index], self.fileIDStr];
            
            //データを読み込んで配列に追加。カードのテキスト数を渡す。
            self.cardTextCount = [[NSArray alloc] initWithArray:[self.cardTextManager loadDataFromDB:queryLoadCTC]];
            
            self.pageControl.numberOfPages = self.cardTextCount.count;
            self.textNumber = 0;
            self.pageControl.currentPage = self.textNumber;
            self.textView.text = [NSString stringWithFormat:@"%@", self.sourceArry[index][0]];
        }
    }
    
}

- (IBAction)changeTextAction:(id)sender {
    [self changeNextText];
}

- (void)changeNextText{
    if (self.randomSwitch == NO) {
        //クエリー作成。pageIndexに1を足してcardNumberに合わせる。
        NSString *queryLoadCTC = [NSString stringWithFormat:@"select cardText from cardTextInfo where cardNumber = %@ AND filename =  '%@' ", [self.dbCardNumberInfo objectAtIndex:self.pageIndex], self.fileIDStr];
        
        //データを読み込んで配列に追加。
        self.cardTextCount = [[NSArray alloc] initWithArray:[self.cardTextManager loadDataFromDB:queryLoadCTC]];
        //NSLog(@"count %ld cardNumber %@", self.cardTextCount.count, [self.dbCardNumberInfo objectAtIndex:self.pageIndex]);
        
        [self checkTheSecondText];
        
        if (self.textNumber == 0 && ![self.secondText isEqualToString:@""]) {
            self.textNumber = 1;
            [self textData];
            
            self.textView.text = [NSString stringWithFormat:@"%@", self.sourceArry[self.pageIndex][1]];
        }else if (self.textNumber == 1) {
            if (self.cardTextCount.count == 2) {
                self.textNumber = 0;
                [self textData];
                
                self.textView.text = [NSString stringWithFormat:@"%@", self.sourceArry[self.pageIndex][0]];
            }else{
                self.textNumber = 2;
                [self textData];
                
                self.textView.text = [NSString stringWithFormat:@"%@", self.sourceArry[self.pageIndex][2]];
            }
            
        }else if (self.textNumber == 2) {
            if (self.cardTextCount.count == 3) {
                self.textNumber = 0;
                [self textData];
                
                self.textView.text = [NSString stringWithFormat:@"%@", self.sourceArry[self.pageIndex][0]];
            }else{
                self.textNumber = 3;
                [self textData];
                
                self.textView.text = [NSString stringWithFormat:@"%@", self.sourceArry[self.pageIndex][3]];
            }
            
        }else if (self.textNumber == 3) {
            if (self.cardTextCount.count == 4) {
                self.textNumber = 0;
                [self textData];
                
                self.textView.text = [NSString stringWithFormat:@"%@", self.sourceArry[self.pageIndex][0]];
            }else{
                self.textNumber = 4;
                [self textData];
                
                self.textView.text = [NSString stringWithFormat:@"%@", self.sourceArry[self.pageIndex][4]];
            }
            
        }else if (self.textNumber == 4) {
            self.textNumber = 0;
            [self textData];
            
            self.textView.text = [NSString stringWithFormat:@"%@", self.sourceArry[self.pageIndex][0]];
        }
    }else{
        //randomIndexのpageIndex番目を取得。
        NSInteger index = [[self.randomIndex objectAtIndex:self.pageIndex] integerValue];
        //クエリー作成。pageIndexに1を足してcardNumberに合わせる。
        NSString *queryLoadCTC = [NSString stringWithFormat:@"select cardText from cardTextInfo where cardNumber = %@ AND filename =  '%@' ", [self.dbCardNumberInfo objectAtIndex:index], self.fileIDStr];
        
        //データを読み込んで配列に追加。
        self.cardTextCount = [[NSArray alloc] initWithArray:[self.cardTextManager loadDataFromDB:queryLoadCTC]];
        //NSLog(@"count %ld cardNumber %@", self.cardTextCount.count, [self.dbCardNumberInfo objectAtIndex:self.pageIndex]);
        
        [self checkTheSecondText];
        
        if (self.textNumber == 0 && ![self.secondText isEqualToString:@""]) {
            self.textNumber = 1;
            [self textData];
            
            self.textView.text = [NSString stringWithFormat:@"%@", self.sourceArry[index][1]];
        }else if (self.textNumber == 1) {
            if (self.cardTextCount.count == 2) {
                self.textNumber = 0;
                [self textData];
                
                self.textView.text = [NSString stringWithFormat:@"%@", self.sourceArry[index][0]];
            }else{
                self.textNumber = 2;
                [self textData];
                
                self.textView.text = [NSString stringWithFormat:@"%@", self.sourceArry[index][2]];
            }
            
        }else if (self.textNumber == 2) {
            if (self.cardTextCount.count == 3) {
                self.textNumber = 0;
                [self textData];
                
                self.textView.text = [NSString stringWithFormat:@"%@", self.sourceArry[index][0]];
            }else{
                self.textNumber = 3;
                [self textData];
                
                self.textView.text = [NSString stringWithFormat:@"%@", self.sourceArry[index][3]];
            }
            
        }else if (self.textNumber == 3) {
            if (self.cardTextCount.count == 4) {
                self.textNumber = 0;
                [self textData];
                
                self.textView.text = [NSString stringWithFormat:@"%@", self.sourceArry[index][0]];
            }else{
                self.textNumber = 4;
                [self textData];
                
                self.textView.text = [NSString stringWithFormat:@"%@", self.sourceArry[index][4]];
            }
            
        }else if (self.textNumber == 4) {
            self.textNumber = 0;
            [self textData];
            
            self.textView.text = [NSString stringWithFormat:@"%@", self.sourceArry[index][0]];
        }
    }
    [self animationStart];
}

- (void)changeBackText{
    if (self.randomSwitch == NO) {
        //クエリー作成。pageIndexに1を足してcardNumberに合わせる。
        NSString *queryLoadCTC = [NSString stringWithFormat:@"select cardText from cardTextInfo where cardNumber = %@ AND filename = '%@' ", [self.dbCardNumberInfo objectAtIndex:self.pageIndex], self.fileIDStr];
        
        //データを読み込んで配列に追加。
        self.cardTextCount = [[NSArray alloc] initWithArray:[self.cardTextManager loadDataFromDB:queryLoadCTC]];
        //NSLog(@"count %ld cardNumber %@", self.cardTextCount.count, [self.dbCardNumberInfo objectAtIndex:self.pageIndex]);
        
        [self checkTheSecondText];
        
        if (self.textNumber == 0 && ![self.secondText isEqualToString:@""]) {
            if ([self.sourceArry[self.pageIndex] count] == 0) {
                self.textNumber = 0;
                [self textData];
                self.textView.text = [NSString stringWithFormat:@"%@", self.sourceArry[self.pageIndex][0]];
            }else if ([self.sourceArry[self.pageIndex] count] == 1){
                self.textNumber = 0;
                [self textData];
                self.textView.text = [NSString stringWithFormat:@"%@", self.sourceArry[self.pageIndex][0]];
            }else if ([self.sourceArry[self.pageIndex] count] == 2){
                self.textNumber = 1;
                [self textData];
                self.textView.text = [NSString stringWithFormat:@"%@", self.sourceArry[self.pageIndex][1]];
            }else if ([self.sourceArry[self.pageIndex] count] == 3){
                self.textNumber = 2;
                [self textData];
                self.textView.text = [NSString stringWithFormat:@"%@", self.sourceArry[self.pageIndex][2]];
            }else if ([self.sourceArry[self.pageIndex] count] == 4){
                self.textNumber = 3;
                [self textData];
                self.textView.text = [NSString stringWithFormat:@"%@", self.sourceArry[self.pageIndex][3]];
            }else if ([self.sourceArry[self.pageIndex] count] == 5){
                self.textNumber = 4;
                [self textData];
                self.textView.text = [NSString stringWithFormat:@"%@", self.sourceArry[self.pageIndex][4]];
            }
        }else if (self.textNumber == 1) {
            self.textNumber = 0;
            [self textData];
            
            self.textView.text = [NSString stringWithFormat:@"%@", self.sourceArry[self.pageIndex][0]];
            
        }else if (self.textNumber == 2) {
            self.textNumber = 1;
            [self textData];
            
            self.textView.text = [NSString stringWithFormat:@"%@", self.sourceArry[self.pageIndex][1]];
        }else if (self.textNumber == 3) {
            self.textNumber = 2;
            [self textData];
            
            self.textView.text = [NSString stringWithFormat:@"%@", self.sourceArry[self.pageIndex][2]];
            
        }else if (self.textNumber == 4) {
            self.textNumber = 3;
            [self textData];
            
            self.textView.text = [NSString stringWithFormat:@"%@", self.sourceArry[self.pageIndex][3]];
        }
    }else{
        //randomIndexのpageIndex番目を取得。
        NSInteger index = [[self.randomIndex objectAtIndex:self.pageIndex] integerValue];
        //クエリー作成。pageIndexに1を足してcardNumberに合わせる。
        NSString *queryLoadCTC = [NSString stringWithFormat:@"select cardText from cardTextInfo where cardNumber = %@ AND filename = '%@' ", [self.dbCardNumberInfo objectAtIndex:index], self.fileIDStr];
        
        //データを読み込んで配列に追加。
        self.cardTextCount = [[NSArray alloc] initWithArray:[self.cardTextManager loadDataFromDB:queryLoadCTC]];
        //NSLog(@"count %ld cardNumber %@", self.cardTextCount.count, [self.dbCardNumberInfo objectAtIndex:self.pageIndex]);
        
        [self checkTheSecondText];
        
        if (self.textNumber == 0 && ![self.secondText isEqualToString:@""]) {
            if ([self.sourceArry[index] count] == 0) {
                self.textNumber = 0;
                [self textData];
                self.textView.text = [NSString stringWithFormat:@"%@", self.sourceArry[index][0]];
            }else if ([self.sourceArry[index] count] == 1){
                self.textNumber = 0;
                [self textData];
                self.textView.text = [NSString stringWithFormat:@"%@", self.sourceArry[index][0]];
            }else if ([self.sourceArry[index] count] == 2){
                self.textNumber = 1;
                [self textData];
                self.textView.text = [NSString stringWithFormat:@"%@", self.sourceArry[index][1]];
            }else if ([self.sourceArry[index] count] == 3){
                self.textNumber = 2;
                [self textData];
                self.textView.text = [NSString stringWithFormat:@"%@", self.sourceArry[index][2]];
            }else if ([self.sourceArry[index] count] == 4){
                self.textNumber = 3;
                [self textData];
                self.textView.text = [NSString stringWithFormat:@"%@", self.sourceArry[index][3]];
            }else if ([self.sourceArry[index] count] == 5){
                self.textNumber = 4;
                [self textData];
                self.textView.text = [NSString stringWithFormat:@"%@", self.sourceArry[index][4]];
            }
        }else if (self.textNumber == 1) {
            self.textNumber = 0;
            [self textData];
            
            self.textView.text = [NSString stringWithFormat:@"%@", self.sourceArry[index][0]];
            
        }else if (self.textNumber == 2) {
            self.textNumber = 1;
            [self textData];
            
            self.textView.text = [NSString stringWithFormat:@"%@", self.sourceArry[index][1]];
        }else if (self.textNumber == 3) {
            self.textNumber = 2;
            [self textData];
            
            self.textView.text = [NSString stringWithFormat:@"%@", self.sourceArry[index][2]];
            
        }else if (self.textNumber == 4) {
            self.textNumber = 3;
            [self textData];
            
            self.textView.text = [NSString stringWithFormat:@"%@", self.sourceArry[index][3]];
        }
    }
    [self animationStart];
}

- (IBAction)movePageAction:(id)sender {
    self.horizontalView.hidden = NO;
    self.movePageSlider.hidden = NO;
    self.crossButton.hidden = NO;
    self.pageLabel.hidden = NO;
    
    self.movePageSlider.value = self.pageIndex;
    self.pageLabel.text = [NSString stringWithFormat:@"%ld", self.pageIndex + 1];

}

//引数の slider には呼び出し元のUISliderオブジェクトが引き渡される。
- (void)sliderValue:(UISlider*)slider{
    self.pageIndex = (int)(self.movePageSlider.value);
    
    if (![self.pageLabel.text isEqualToString:[NSString stringWithFormat:@"%ld", self.pageIndex + 1]]) {
        
        [self resetPageAndText];
        self.pageLabel.text = [NSString stringWithFormat:@"%ld", self.pageIndex + 1];
    }
    [self animationStart];
}

- (IBAction)crossAction:(id)sender {
    self.horizontalView.hidden = YES;
    self.movePageSlider.hidden = YES;
    self.crossButton.hidden = YES;
    self.pageLabel.hidden = YES;
}

- (IBAction)backAction:(id)sender {
    // 隠していたNavBarを表示。
    [self.navigationController setNavigationBarHidden:NO];
    // コードからNavのBackボタンタップで前画面に戻る。
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
