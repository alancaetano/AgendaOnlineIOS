//
//  AppDelegate.swift
//  AgendaOnline
//
//  Created by João Fabio Lourenço dos Santos on 07/02/16.
//  Copyright © 2016 Agenda Online. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		// Override point for customization after application launch.
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [UIUserNotificationType.Badge, UIUserNotificationType.Sound, UIUserNotificationType.Alert], categories: nil))
        
        //application.registerForRemoteNotifications()
        
        //AgendarNotificacoes()
        
		return true
	}
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        var data = deviceToken
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        var erro = error
    }

	func applicationWillResignActive(application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        if(notification.category == Notificacao.CATEGORIA_MENSAGEM){
            NSNotificationCenter.defaultCenter().postNotificationName("mensagem", object: nil)
        }
    }
    
    //TESTE -------------------------------//------------------------------------//------------------------------------------//------
    func AgendarNotificacoes(){
        let timer = NSTimer.scheduledTimerWithTimeInterval(20.0, target: self, selector: #selector(AppDelegate.Notificar), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    func Notificar(){
        print("notificando...")
        
        let notificacao = UILocalNotification()
        notificacao.alertBody = "mensagem do professor enviada por push"
        notificacao.category = Notificacao.CATEGORIA_MENSAGEM
        
        let data = NSDate(timeIntervalSinceNow: 0)
        notificacao.fireDate = data
        
        UIApplication.sharedApplication().scheduleLocalNotification(notificacao)
    }
    
   static func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        if(notification.category == Notificacao.CATEGORIA_ALUNO){
            Aluno.CarregarAlunos()
        }
    }
}

