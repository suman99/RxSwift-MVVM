//
//  ReactiveExtensions.swift
//  RxSwift-MVVM
//
//  Created by Suman on 02/09/2021.
//

import UIKit
import RxSwift
import RxCocoa

extension UIViewController: loadingViewable {}


//First from below we wrote an extension to Reactive which is in RxCocoa and affect RX property of UIViewController.

extension Reactive where Base: UIViewController {
    
    //Bindable sink for 'startAnimating()', 'stopAnimatig()' methods.
    
    //We implement isAnimating variable to UIViewControllers of type Binder<Bool> so that can be bindable.
    public var isAnimating: Binder<Bool> {
        
        //Next, we create Binder and for the binder part, the closure giving us the view controller (vc) and the value of isAnimating (active). So we are able to say what happens to the viewController in each value of isAnimating, so if active is true, we are showing loading animation with vc.startAnimating() and hide the loading when active is false.
        
        return Binder(self.base, binding: { (vc,active) in
            if active {
                vc.startAnimating()
            }else {
                vc.stopAnimating()
            }
        })
    }
}
