#import <Foundation/Foundation.h>


@interface NQueensPuzzle:NSObject
/* method declaration */
- (int)fill_queen:(int)queens is_ouput:(BOOL)output;
@end

@implementation NQueensPuzzle
- (int)fill_queen:(int)queens is_ouput:(BOOL)output{

    //新建 "output" 目錄, 並增加檔案 "NQueensPuzzle_Sol.txt"
    NSFileHandle *fileHandle = nil;
    if (output){
        NSFileManager *fm  = [NSFileManager defaultManager];
        NSString *currentPath = [fm currentDirectoryPath];
        NSString *output_path = [NSString stringWithFormat:@"%@\\%@", currentPath, @"output"];

        BOOL isDir = YES;
        BOOL isFolder = [[NSFileManager defaultManager] fileExistsAtPath:output_path isDirectory:&isDir];
        if (!isFolder){
            NSError *error = nil;
            [fm createDirectoryAtPath:output_path withIntermediateDirectories:NO attributes:nil error:&error];
            if (!error){
                NSLog(@"Failed to create directory \"%@\". Error: %@", output_path, error);
                return -1;
            }
        }

        NSString *fileName = [NSString stringWithFormat:@"%@\\%@", output_path, @"NQueensPuzzle_Sol.txt"];
        isDir = NO;
        BOOL isFile = [[NSFileManager defaultManager] fileExistsAtPath:fileName isDirectory:&isDir];
        if (!isFile){
            [fm createFileAtPath:fileName contents:nil attributes:nil];
        }
        fileHandle = [NSFileHandle fileHandleForWritingAtPath:fileName];
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:[[NSString  stringWithFormat:@"the %d-queens puzzle\r\n", queens] dataUsingEncoding:NSUTF8StringEncoding]];
    }

    int i, k, flag, not_finish=1, sol_count=0;
	int a[queens+1];
    i=1;
    a[1]=1;
    while(not_finish){ //not_finish=l:处理尚未结束
        while(not_finish && i <= queens){ //处理尚未结束且还没处理到第Queens个元素
            for(flag=1, k=1; flag && k < i; k++) //判断是否有多个皇后在同一行
                if(a[k]==a[i])
                    flag=0;
            for (k=1; flag&&k<i; k++) //判断是否有多个皇后在同一对角线
                if((a[i]==a[k]-(k-i)) || (a[i]==a[k]+(k-i)))
                    flag=0;
            if(!flag){//若存在矛盾不满足要求，需要重新设置第i个元素
                if(a[i]==a[i-1]){ //若a[i]的值已经经过一圈追上a[i-1]的值
                    i--;

                    if(i>1 && a[i]==queens)
                        a[i]=1;//当a[i]为Queens时将a[i]的值置1
                    else
                        if(i==1 && a[i]==queens)
                            not_finish=0;//当第一位的值达到Queens时结束
                        else
                            a[i]++;//将a[il的值取下一个值
                }else if(a[i] == queens)
                    a[i]=1;
                else
                    a[i]++; //将a[i]的值取下一个值
            }else if(++i<=queens)
                if(a[i-1] == queens)
                    a[i]=1;//若前一个元素的值为Queens则a[i]=l
                else
                    a[i] = a[i-1]+1;//否则元素的值为前一个元素的下一个值
        }

        if(not_finish){
            ++sol_count;
            //輸出結果到 "output\NQueensPuzzle_Sol.txt" 下
			if(output){
                [fileHandle writeData:[[NSString  stringWithFormat:@"%@%d\r\n", @"// Solution ", sol_count] dataUsingEncoding:NSUTF8StringEncoding]];
				for(k=1; k<=queens; k++)
                {
                    if (a[k] == 1)
                    {
                        [fileHandle writeData:[[NSString stringWithFormat:@"%@", @"Q"] dataUsingEncoding:NSUTF8StringEncoding]];
                        [fileHandle writeData:[[@"" stringByPaddingToLength:queens-a[k] withString:@"." startingAtIndex:0] dataUsingEncoding:NSUTF8StringEncoding]];
                    }
                    else
                        if (a[k] == queens)
                        {
                            [fileHandle writeData:[[@"" stringByPaddingToLength:queens-1 withString:@"." startingAtIndex:0] dataUsingEncoding:NSUTF8StringEncoding]];
                            [fileHandle writeData:[[NSString stringWithFormat:@"%@", @"Q"] dataUsingEncoding:NSUTF8StringEncoding]];
                        }
                        else
                        {
                            [fileHandle writeData:[[@"" stringByPaddingToLength:a[k]-1 withString:@"." startingAtIndex:0] dataUsingEncoding:NSUTF8StringEncoding]];
                            [fileHandle writeData:[[NSString stringWithFormat:@"%@", @"Q"] dataUsingEncoding:NSUTF8StringEncoding]];
                            [fileHandle writeData:[[@"" stringByPaddingToLength:queens-a[k] withString:@"." startingAtIndex:0] dataUsingEncoding:NSUTF8StringEncoding]];
                        }
                    [fileHandle writeData:[[NSString stringWithFormat:@"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                }
			}

            if(a[queens-1]<queens )
                a[queens-1]++;
            else
                a[queens-1]=1;

            i=queens -1;
        }
    }

    if(output)
        [fileHandle closeFile];

	return sol_count;
}

@end

int main (int argc, const char *argv[])

{
    /*
        Problem:
            Write a function that returns all distinct solutions to the 8-queens puzzle.
            Each solution contains a distinct board configuration of the 8-queens' placement,
            where 'Q' and '.' both indicate a queen and an empty space respectively.
    */

    NSAutoreleasePool *pool =[[NSAutoreleasePool alloc] init];

    NQueensPuzzle *n_queen = [[NQueensPuzzle alloc] init];
    int queens = 8;
    int total_sol = [n_queen fill_queen:queens is_ouput:TRUE];
    NSLog(@"total of distinct solution for the %d-queens puzzle is %d", queens, total_sol);

    [pool drain];

    return 0;

}
