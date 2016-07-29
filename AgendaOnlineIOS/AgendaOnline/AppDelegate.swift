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
        
        application.registerForRemoteNotifications()
        
        AgendarNotificacoes()
        
		return true
	}
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        print("didRegisterForRemoteNotificationsWithDeviceToken  \(deviceToken)")
        
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("didFailToRegisterForRemoteNotificationsWithError")
        var erro = error
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        print("didReceiveLocalNotification - \(notification.category)")
        
        Notificacao.tratarNotificacaoRemota(notification)
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
        notificacao.category = "f9890560-bc23-4e37-9bb3-f71b6ddb492d"	
        
        
        let data = NSDate(timeIntervalSinceNow: 0)
        notificacao.fireDate = data
        
        UIApplication.sharedApplication().scheduleLocalNotification(notificacao)
    }

}

