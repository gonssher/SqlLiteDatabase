//
//  AppDelegate.swift
//  MySqlLiteDatabaseApp
//
//  Created by Sherwin on 2020-03-22.
//  Copyright © 2020 Sherwin. All rights reserved.
//

import UIKit
import SQLite3

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var databaseName : String? = "MyDatabase.db"
    var databasePath : String?
    var people : [Data] = []

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        let documentsDir = documentPaths[0]
        databasePath = documentsDir.appending("/" + databaseName!)
        checkAndCreateDatabase()
        readDataFromDatabase()
        return true
    }
    func readDataFromDatabase()
    {
        people.removeAll()
        var db : OpaquePointer? = nil
        
        if sqlite3_open(self.databasePath, &db)==SQLITE_OK
        {
              print("Successfully Opened database \(self.databasePath)")
            var queryStaement :OpaquePointer? = nil
            var queryStaementString : String = "select * from entries"
            if sqlite3_prepare_v2(db, queryStaementString, -1, &queryStaement, nil) == SQLITE_OK
            {
                
             while sqlite3_step(queryStaement) == SQLITE_ROW
             {
                let Id : Int = Int(sqlite3_column_int(queryStaement, 0))
                let cname = sqlite3_column_text(queryStaement, 1)
                let cemail = sqlite3_column_text(queryStaement, 2)
                let cfood = sqlite3_column_text(queryStaement, 3)
                
                let name = String(cString: cname!)
                let email = String(cString: cemail!)
                let food = String(cString: cfood!)
                
                
                let data : Data = Data.init()
                data.initWithData(theRow: Id, theName: name, theEmail: email, theFood: food)
                people.append(data)
                print("Query Result")
                print("\(Id) | \(name) |\(email) | \(food)")
               
                
                }
                 sqlite3_finalize(queryStaement)
                
            }
            else {
                
                print("Select Couldnt be prepared")
            }
            sqlite3_close(db)
        }
        else
        {
            print("Unable to open Database")
            
        }
        
    }
    
    func insertIntDatabase(person : Data) -> Bool
    {
        var db : OpaquePointer? = nil
        var retureenCode : Bool = true
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK
        {
            var insertStatement : OpaquePointer? = nil
            var insertStatementString = "insert into entries values(NULL,?,?,?)"
            if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK
            {
                let nameStr = person.name! as NSString
                let emailStr = person.email! as NSString
                let foodStr = person.food! as NSString
                sqlite3_bind_text(insertStatement, 1, nameStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 2, emailStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 3, foodStr.utf8String, -1, nil)
                
                if sqlite3_step(insertStatement) == SQLITE_DONE{
                    let rowId = sqlite3_last_insert_rowid(db)
                    print("succefull inserrted \(rowId)")
                    
                }
                else{
                    print("couldnt insert row")
                    retureenCode = false
                    
                    
                }
                sqlite3_finalize(insertStatement)
                
            }
            else {print("statemnt could nt be prepare")
                
                retureenCode = false
            }
            sqlite3_close(db)
    
        }
        else {
            print("unable to open Db")
            retureenCode = false
        }
    return retureenCode
    }
    
    func checkAndCreateDatabase()
    {
        var success = false
        let fileManager = FileManager.default
        
        success = fileManager.fileExists(atPath: databasePath!)
        
        if success {
            return
            
        }
        let databasePathFromApp = Bundle.main.resourcePath?.appending("/" + databaseName!)
        
        try?fileManager.copyItem(atPath: databasePathFromApp!, toPath: databasePath!)
        
        return
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

