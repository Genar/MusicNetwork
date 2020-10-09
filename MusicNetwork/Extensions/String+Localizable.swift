//
//  String+Localizable.swift
//  MusicNetwork
//
//  Created by Genar Codina Reverter on 07/10/2020.
//  Copyright © 2020 Genar Codina Reverter. All rights reserved.
//

import Foundation

extension String {

    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {

        let result = NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")

        return result
    }
}
