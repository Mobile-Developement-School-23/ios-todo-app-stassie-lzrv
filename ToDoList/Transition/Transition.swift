//
//  Transition.swift
//  ToDoList
//
//  Created by Настя Лазарева on 30.06.2023.
//

import Foundation


import UIKit

extension MainViewController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let firstViewController = presenting as? MainViewController,
            let secondViewController = presented as? TaskViewController,
            let selectedCellImageViewSnapshot = selectedCellImageViewSnapshot
            else { return nil }

        animator = Animator(type: .present, firstViewController: firstViewController, secondViewController: secondViewController, selectedCellImageViewSnapshot: selectedCellImageViewSnapshot)
        return animator
    }

    
}
