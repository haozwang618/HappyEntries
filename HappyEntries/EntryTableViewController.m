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
NSDateFormatter *dateFormat;
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
    
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    managedObjectContext = [delegate managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"SingleEntry" inManagedObjectContext:managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSError *error;
    entryArray = [[NSMutableArray alloc] initWithArray:[managedObjectContext executeFetchRequest:request error:&error] copyItems:NO];
}

-(void) viewDidAppear:(BOOL)animated
{
   
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [entryArray count];
}

-(EntryCell *) makeEntryCell:(SingleEntry*) thisEntry
{
    static NSString *CellIdentifier = @"EntryCell";
    EntryCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell.titleLabel setText:thisEntry.entryTitle];
    
    if ( [thisEntry.entryRating intValue]< 25) {
        [cell.titleLabel setTextColor:[UIColor redColor]];
        [cell.scoreLabel setTextColor:[UIColor redColor]];
    }
    else if ([thisEntry.entryRating intValue] < 45) {
        [cell.titleLabel setTextColor:[UIColor purpleColor]];
        [cell.scoreLabel setTextColor:[UIColor purpleColor]];
    }
    else if(([thisEntry.entryRating intValue] > 55) && ([thisEntry.entryRating intValue]  < 75))
    {
        [cell.titleLabel setTextColor:[UIColor blueColor]];
        [cell.scoreLabel setTextColor:[UIColor blueColor]];
    }
    else if ([thisEntry.entryRating intValue] >75)
    {
        [cell.titleLabel setTextColor:[UIColor cyanColor]];
        [cell.scoreLabel setTextColor:[UIColor cyanColor]];
    }
    else
    {
        [cell.titleLabel setTextColor:[UIColor greenColor]];
        [cell.scoreLabel setTextColor:[UIColor greenColor]];
    }
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
    SingleEntry * thisEntry =[entryArray objectAtIndex:[indexPath row]];
    
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

@end
