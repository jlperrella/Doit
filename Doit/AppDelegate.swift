//
//  AppDelegate.swift
//  Doit
//
//  Created by jp on 2019-06-03.
//  Copyright © 2019 Jordan Perrella. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    do {
      _ = try Realm()
    } catch{
      print("Error initializing new realm \(error)")
    }
    //print (Realm.Configuration.defaultConfiguration.fileURL)
    
    return true
  }
  
}


