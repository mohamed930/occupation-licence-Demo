//
//  AppDelegate.swift
//  occupations licence
//
//  Created by Mohamed Ali on 16/10/2021.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var loginviewmodel = loginViewModel()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        checkUserDefaults()
        return true
    }
    
    private func checkUserDefaults () {

           // let savedPerson = UserDefaults.standard.object(forKey: currentUser) as? Data
           // let decoder = JSONDecoder()
           // if let loadedPerson = try? decoder.decode(UserModel.self, from: savedPerson) {
           //      print("F: \(loadedPerson.UserName)")
           // }
           
           
           // First Check user in Firebase State && USERDefaults is exsist or not.
        if UserDefaults.standard.object(forKey: currentUser) as? Data != nil {
            
            // Send to chats we have login and we have to go chatsVC
            self.MakeViewControolerisInit(StroyName: "home", Id: "tabBar")
            
            DispatchQueue.main.async {
                print("User exsist")
                
                guard let user = UserDefaultsMethods.loadDataFromUserDefaults(Key: currentUser, className: SavedUserModel.self) else {
                    print("Can't load data from UserDefaults")
                    return
                }
                
                tocken = user.userEmail
                userId = Int(user.userId)!
                email = user.userEmail
                
                self.loginviewmodel.EmailBehaviour.accept(email)
                self.loginviewmodel.PasswordBehaviour.accept(user.password)
                
                self.loginviewmodel.loginWithEmailOperation()
            }
        }
        else {
            print("user not found")
            
            // Sned to login failed and we have to go loginVC
            self.MakeViewControolerisInit(StroyName: "Login", Id: "LoginViewController")
        }
   }
       
       // MARK:- TODO:- This Method for Set root VC.
       private func MakeViewControolerisInit(StroyName: String ,Id: String) {
           
           self.window = UIWindow(frame: UIScreen.main.bounds)

           let storyboard = UIStoryboard(name: StroyName , bundle: nil)

           let initialViewController = storyboard.instantiateViewController(withIdentifier: Id)

           self.window?.rootViewController = initialViewController
           self.window?.makeKeyAndVisible()

       }
       // ------------------------------------------------

}

