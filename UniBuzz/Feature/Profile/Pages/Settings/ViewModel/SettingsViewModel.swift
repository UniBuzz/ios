//
//  SettingsViewModel.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 05/10/22.
//

import Foundation
import Firebase

class SettingsViewModel {
    
    var logOutView: (() -> Void)?
    
    func numberOfItems() -> Int{
        return SettingsItem().itemsTitle.count
    }
    
    func titleItem(_ row: Int) -> String{
        return SettingsItem().itemsTitle[row]
    }
    
    func descriptionItem(_ row: Int) -> String{
        return SettingsItem().itemsDescription[row]
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
            logOutView?()
        } catch {
            print("DEBUG: Error signin out..")
        }
    }
    
}
