//
//  ToastHelper.swift
//  NewTonNfcCardLib
//
//  Created by Alina Alinovna on 23.10.2020.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation

class ToastHelper {
    static func showToast(message : String) {
        let toastView = UILabel()
                toastView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
                toastView.textColor = UIColor.white
                toastView.textAlignment = .center
                toastView.font = UIFont.preferredFont(forTextStyle: .caption1)
                toastView.layer.cornerRadius = 25
                toastView.layer.masksToBounds = true
                toastView.text = message
                toastView.numberOfLines = 0
                toastView.alpha = 0
                toastView.translatesAutoresizingMaskIntoConstraints = false

                let window = UIApplication.shared.delegate?.window!
                window?.addSubview(toastView)

                let horizontalCenterContraint: NSLayoutConstraint = NSLayoutConstraint(item: toastView, attribute: .centerX, relatedBy: .equal, toItem: window, attribute: .centerX, multiplier: 1, constant: 0)

                let widthContraint: NSLayoutConstraint = NSLayoutConstraint(item: toastView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 275)

                let verticalContraint: [NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=200)-[loginView(==50)]-68-|", options: [.alignAllCenterX, .alignAllCenterY], metrics: nil, views: ["loginView": toastView])

                NSLayoutConstraint.activate([horizontalCenterContraint, widthContraint])
                NSLayoutConstraint.activate(verticalContraint)

                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                    toastView.alpha = 1
                }, completion: nil)

                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(2 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {
                    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                        toastView.alpha = 0
                    }, completion: { finished in
                        toastView.removeFromSuperview()
                    })
                })
}
}
