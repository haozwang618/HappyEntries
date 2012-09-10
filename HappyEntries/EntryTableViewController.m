//
//  EntryTableViewController.m
//  HappyEntries
//
//  Created by Haozhu Wang on 9/3/12.
//
//

#import "EntryTableViewController.h"
#import "EntryCell.h"
#import "AppDelegate.h"
#import "SingleEntry.h"

@interface EntryTableViewController ()

@end

@implementation EntryTableViewController

@synthesize entryArray;
@synthesize categorizedEntryArrays;
@synthesize managedObjectContext;
@synthesize headerView;
@synthesize keyArray;
@synthesize dateModePicker;

DateMode currentMode;
NSDateFormatter *dateFormat;
NSArray* dateModeTitles;
NSString * selectedOrganize;
bool showPicker =false;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy hh:mm:ssa"];
    currentMode = ALL;
    
    dateModeTitles=[[NSArray alloc] initWithObjects:@"ALL", @"DAY", @"WEEK", @"MONTH", @"YEAR", nil];
    
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    managedObjectContext = [delegate managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"SingleEntry" inManagedObjectContext:managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSError *error;
    entryArray = [[NSMutableArray alloc] initWithArray:[managedObjectContext executeFetchRequest:request error:&error] copyItems:NO];
    
    [entryArray sortUsingComparator:^NSComparisonResult(SingleEntry * first, SingleEntry * second){
        return [second.entryDate compare: first.entryDate];
                  }];
}

-(void) viewDidAppear:(BOOL)animated
{
   
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(float)averageRating: (NSArray *)entryList
{
    float sum=0;
    
    for (SingleEntry* currentEntry in entryList) {
        sum += [currentEntry.entryRating floatValue];
    }
    
    if ([entryList count]==0) {
        return 0;
    }
    else
    {
        return sum/[entryList count];
    }
}

-(UIColor*)colorByScore:(float) score
{
    if ( score< 25) {
        return [UIColor redColor];
    }
    else if (score < 45) {
        return[UIColor purpleColor];
    }
    else if((score > 55) && (score  < 75))
    {
        return [UIColor blueColor];
    }
    else if (score >75)
    {
        return [UIColor cyanColor];
    }
    else
    {
        return [UIColor greenColor];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    if (currentMode == ALL) {
        return 1;
    }
    else
    {
        return [keyArray count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (currentMode == ALL)
    {
        return [entryArray count];
    }
    else
    {
        return [[categorizedEntryArrays objectForKey:[keyArray objectAtIndex:section]] count];
    }
}

-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * myHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    if (currentMode == ALL) {
        [myHeaderView setBackgroundColor:[self colorByScore:[self averageRating:entryArray]]];
    }
    else
    {
        [myHeaderView setBackgroundColor:[self colorByScore:[self averageRating:[categorizedEntryArrays objectForKey:[keyArray objectAtIndex:section]]]]];
    }
    
    return myHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

-(EntryCell *) makeEntryCell:(SingleEntry*) thisEntry
{
    static NSString *CellIdentifier = @"EntryCell";
    EntryCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell.titleLabel setText:thisEntry.entryTitle];
    
    [cell.scoreLabel setTextColor:[self colorByScore:[thisEntry.entryRating floatValue]]];
    [cell.titleLabel setTextColor:[self colorByScore:[thisEntry.entryRating floatValue]]];
    
    NSString* dateString= [dateFormat stringFromDate:thisEntry.entryDate];
    [cell.dateLabel setText:dateString];
    [cell.reasonTextView setText:thisEntry.entryBody];
    [cell.scoreLabel setText:[NSString stringWithFormat:@"%d",[thisEntry.entryRating intValue]]];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"EntryCell";
    EntryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (entryArray == nil) {
        return cell;
    }
    
    SingleEntry * thisEntry;
    if(currentMode == ALL)
    {
        thisEntry =[entryArray objectAtIndex:[indexPath row]];
    
        
    }
    else
    {
        id key = [keyArray objectAtIndex:[indexPath section]];
        thisEntry = [[categorizedEntryArrays objectForKey:key] objectAtIndex:[indexPath row]];
    }
                     
    cell = [self makeEntryCell:thisEntry];
                     // Configure the cell...
                     
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

//-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if (<#condition#>) {
//        <#statements#>
//    }
//}

#pragma mark - Date Organization Mode Setup
-(void)organizeBy:(DateMode) thisMode
{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    
    if(keyArray == nil)
    {
        keyArray = [[NSMutableArray alloc] init];
    }
    else
    {
        [keyArray removeAllObjects];
    }
    
    if (categorizedEntryArrays == nil) {
        categorizedEntryArrays = [[NSMutableDictionary alloc] init];
    }
    else
    {
        [categorizedEntryArrays removeAllObjects];
    }
    
    NSMutableArray * tempEntries = [[NSMutableArray alloc] initWithArray:entryArray copyItems:NO];
    NSUInteger flag;
    NSString * key;
    switch (thisMode) {
        case DAY:
            flag = NSDayCalendarUnit | NSWeekCalendarUnit |NSMonthCalendarUnit|NSYearCalendarUnit;
            key = [NSString stringWithFormat:@"DAY"];
            break;
        case WEEK:
            flag = NSWeekCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
            key = [NSString stringWithFormat:@"WEEK"];
            break;
        case MONTH:
            flag = NSMonthCalendarUnit|NSYearCalendarUnit;
            key = [NSString stringWithFormat:@"MONTH"];
            break;
        case YEAR:
            flag = NSYearCalendarUnit;
            key = [NSString stringWithFormat:@"YEAR"];
            break;
        default:
            break;
    }
    /////////////////////////////////////////////////////
    SingleEntry * pivotEntry;
    NSMutableArray * segmentedArray;
    
    NSString * serialKey;
    bool pivotSet = false;
    int secNum=0;
    for(int i =0; i< [tempEntries count]; ++i)
    {
        if ((i == 0)&&(!pivotSet))
        {
            pivotEntry = [tempEntries objectAtIndex:i];
            [tempEntries removeObject:pivotEntry];
            i =-1;
            
            segmentedArray = [[NSMutableArray alloc]init];
            [segmentedArray addObject:pivotEntry];
            
            serialKey = [NSString stringWithFormat:@"%@%d",key,secNum];
            [keyArray addObject:serialKey];
            pivotSet = true;
            continue;
        }
        
        SingleEntry* thisEntry = [tempEntries objectAtIndex:i];
        NSDateComponents * pivotComponent = [calendar components:flag fromDate:pivotEntry.entryDate];
        NSDateComponents * entryComponent = [calendar components:flag fromDate:thisEntry.entryDate];
        
        bool compare;
        switch (thisMode) {
            case DAY:
                compare = (([pivotComponent day] == [entryComponent day]) && ([pivotComponent week] == [entryComponent week]) && ([pivotComponent month] == [entryComponent month]) && ([pivotComponent year] == [entryComponent year]));
                break;
            case WEEK:
                compare = (([pivotComponent week] == [entryComponent week]) && ([pivotComponent month] == [entryComponent month]) && ([pivotComponent year] == [entryComponent year]));
                break;
            case MONTH:
                compare = (([pivotComponent month] == [entryComponent month])&&([pivotComponent year] == [entryComponent year]));
                break;
            case YEAR:
                compare = [pivotComponent year] == [entryComponent year];
                break;
        }
        
        if(compare)
        {
            [segmentedArray addObject:thisEntry];
            [tempEntries removeObject:thisEntry];
            if([tempEntries count] == 0)
            {
                [categorizedEntryArrays setObject:segmentedArray forKey:serialKey];
            }
            i=-1;
            continue;
        }
        else
        {
            [categorizedEntryArrays setObject:segmentedArray forKey:serialKey];
            segmentedArray =nil;
            ++secNum;
            i=-1;
            pivotSet = false;
            
        }
    }
    
}

-(void) organizeTable
{
    if (currentMode == ALL)
    {
        return;
    }
    else
    {
        [self organizeBy:currentMode];
    }
    [self.tableView reloadData];
}

-(IBAction)organizeButtonPress:(id)sender
{
    UIButton* thisButton= (UIButton*)sender;
    if (dateModePicker == nil) {
            dateModePicker = [[UIPickerView alloc] init];
            [dateModePicker setDataSource:self];
            [dateModePicker setDelegate:self];
            dateModePicker.showsSelectionIndicator = YES;
            
            [self.view addSubview:dateModePicker];
            CGPoint orig= dateModePicker.frame.origin;
            CGSize size = dateModePicker.frame.size;
            dateModePicker.frame = CGRectMake(0, orig.y+2000, size.width, size.height);
        }
    
    if (showPicker) {
        [UIView animateWithDuration:1.0f
                              delay:0
                            options: UIViewAnimationCurveEaseOut
                         animations:^{
                             CGPoint orig= dateModePicker.frame.origin;
                             CGSize size = dateModePicker.frame.size;
                              dateModePicker.frame = CGRectMake(0, orig.y+2000, size.width, size.height);
                             //dateModePicker.frame = CGRectMake(0, 0, sizeOrig.width, sizeOrig.height);
                         }
                         completion:^(BOOL finished){
                             showPicker = false;
                             [thisButton setTitle:@"Organize By:" forState:UIControlStateNormal];
                             if([selectedOrganize isEqualToString:[dateModeTitles objectAtIndex:0]])
                             {
                                 currentMode = ALL;
                             }
                             else if([selectedOrganize isEqualToString:[dateModeTitles objectAtIndex:1]])
                             {
                                 currentMode = DAY;
                             }
                             else if([selectedOrganize isEqualToString:[dateModeTitles objectAtIndex:2]])
                             {
                                 currentMode = WEEK;
                             }
                             else if([selectedOrganize isEqualToString:[dateModeTitles objectAtIndex:3]])
                             {
                                 currentMode = MONTH;
                             }
                             else if([selectedOrganize isEqualToString:[dateModeTitles objectAtIndex:4]])
                             {
                                 currentMode = YEAR;
                             }
                            [self organizeTable];
                             [dateModePicker setHidden:YES];
                         }];
    }
    else
    {
        [UIView animateWithDuration:1.0f
                          delay:0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         //CGSize sizeOrig = dateModePicker.frame.size;
                         //dateModePicker.frame = CGRectMake(0, 0, 0, 0);
                         CGSize size = dateModePicker.frame.size;
                         dateModePicker.frame = CGRectMake(0, 0, size.width, size.height);
                        [dateModePicker setHidden:NO];
                     }
                     completion:^(BOOL finished){
                         showPicker = true;
                         [thisButton setTitle:@"Done" forState:UIControlStateNormal];
                        
                         [self.view bringSubviewToFront:dateModePicker];
                     }];
    }
    //showPicker = ~showPicker;
    
}


-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [dateModeTitles count];
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [dateModeTitles objectAtIndex:row];
}

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedOrganize = [dateModeTitles objectAtIndex:row];
}
@end
