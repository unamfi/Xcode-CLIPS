//
//  MABSBViewController.m
//  MABSB
//
//  Created by Gary Riley on 8/23/13.
//  Copyright (c) 2013 Gary Riley. All rights reserved.
//

#import "MABSBViewController.h"
#import "clips.h"

@interface MABSBViewController ()

@end

@implementation MABSBViewController

/************************/
/* QueryInterfaceRouter */
/************************/
intBool QueryInterfaceRouter(
  void *theEnv,
  char *logicalName)
  {
   if ( (strcmp(logicalName,"stdout") == 0) ||
        (strcmp(logicalName,WPROMPT) == 0) ||
        (strcmp(logicalName,WTRACE) == 0) ||
        (strcmp(logicalName,WERROR) == 0) ||
        (strcmp(logicalName,WWARNING) == 0) ||
        (strcmp(logicalName,WDISPLAY) == 0) ||
        (strcmp(logicalName,WDIALOG) == 0) )
     { return(TRUE); }

    return(FALSE);
  }

/************************/
/* PrintInterfaceRouter */
/************************/
int PrintInterfaceRouter(
  void *theEnv,
  char *logicalName,
  char *str)
  {
   NSString *theStr = [NSString stringWithCString: str encoding: NSUTF8StringEncoding];
   
   if (str == nil)
     { return(FALSE); }
          
   MABSBViewController *theVC = (__bridge MABSBViewController *) GetEnvironmentRouterContext(theEnv);
   
   theVC.outputView.text = [theVC.outputView.text stringByAppendingString: theStr];

   return(TRUE);
  }

- (void)viewDidLoad
  {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  }

- (void)didReceiveMemoryWarning
  {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
  }

- (void) viewDidAppear: (BOOL) animated
  {
   void *theEnv;
    
   theEnv = CreateEnvironment();
   if (theEnv == NULL) return;
 
   EnvAddRouterWithContext(theEnv,"CLIPSSimpleOutput",10,QueryInterfaceRouter,PrintInterfaceRouter,
                           NULL,NULL,NULL,(__bridge void *)(self));
  
   NSString* filePath = [[NSBundle mainBundle] pathForResource: @"mab" ofType:@"clp"];
   char *cFilePath = (char *) [filePath UTF8String];
   EnvLoad(theEnv,cFilePath);

   EnvReset(theEnv);
   EnvRun(theEnv,-1);
      
  }

@end
