//
//  ConfigurableViewProtocol.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/22.
//

import UIKit

protocol ConfigurableViewProtocol { }
extension ConfigurableViewProtocol {
    @discardableResult
    func setup(_ block: (_ view: Self) -> Void) -> Self {
        block(self)
        return self
    }
}
extension UIView: ConfigurableViewProtocol { }
extension UICollectionViewLayout: ConfigurableViewProtocol { }
