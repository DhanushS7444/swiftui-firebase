//
//  String + Extensions.swift
//  whatsUp
//
//  Created by Dhanush S on 07/04/23.
//

import Foundation

extension String {
    var isEmptyOrWhiteSpace: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
