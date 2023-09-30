//
//  Copy+Extension.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/01.
//

import Foundation

func copy<T>(_ src: T, block: (inout T) -> ()) -> T {
    var dest = src
    block(&dest)
    return dest
}
