//
//  SettingsViewModel.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 05/10/22.
//

import Foundation

struct SettingsViewModel {
    
    func numberOfItems() -> Int{
        return SettingsItem().itemsTitle.count
    }
    
    func titleItem(_ row: Int) -> String{
        return SettingsItem().itemsTitle[row]
    }
    
    func descriptionItem(_ row: Int) -> String{
        return SettingsItem().itemsDescription[row]
    }
}
