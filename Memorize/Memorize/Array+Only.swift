//
//  Array+Only.swift
//  Memorize
//
//  Created by Daniel Luo on 3/18/21.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
