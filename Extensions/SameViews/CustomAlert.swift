//
//  CustomAlert.swift
//  MyFirstApp
//
//  Created by Эдгар Исаев on 20.03.2023.
//

import UIKit

class CustomAlert {
     
    private let blackBackgroundView: UIView = {
       let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()
    
    private let alertView: UIView = {
       let view = UIView()
        view.backgroundColor = .specialBackground
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let scrollView = UIScrollView()
    
    private var mainView: UIView?
    
    private let setsTextField = SameTextField()
    private let repsTextField = SameTextField()
    
    private var buttonAction: ((String, String) -> Void)?
    
    func presentCustomAlert(viewController: UIViewController,
                            repsOrTimer: String,
                            completion: @escaping (String, String) -> Void) {
        
        registerForKeyboardNotification()
         
        guard let parentView = viewController.view else { return }
        mainView = parentView
        
        scrollView.frame = parentView.frame
        parentView.addSubview(scrollView)
        
        blackBackgroundView.frame = parentView.frame
        scrollView.addSubview(blackBackgroundView)
        
        alertView.frame = CGRect(x: 40,
                                 y: -420,
                                 width: parentView.frame.width - 80,
                                 height: 420)
        scrollView.addSubview(alertView)
        
        let sportsmenImageView = UIImageView(frame: CGRect(
            x: (alertView.frame.width - alertView.frame.height * 0.4) / 2,
            y: 30,
            width: alertView.frame.height * 0.4,
            height: alertView.frame.height * 0.4))
        sportsmenImageView.image = UIImage(named: "sportsmanAlert")
        sportsmenImageView.contentMode = .scaleAspectFit
        alertView.addSubview(sportsmenImageView)
        
        let editingLabel = UILabel(text: "Editing", font: .robotoMedium22(), textColor: .specialBlack)
        editingLabel.frame = CGRect(x: 10,
                                    y: sportsmenImageView.frame.height + 50,
                                    width: alertView.frame.width - 20,
                                    height: 25)
        editingLabel.textAlignment = .center
        editingLabel.translatesAutoresizingMaskIntoConstraints = true
        alertView.addSubview(editingLabel)
        
        let setsLabel = UILabel(text: "Sets")
        setsLabel.translatesAutoresizingMaskIntoConstraints = true
        setsLabel.frame = CGRect(x: 30,
                                 y: editingLabel.frame.maxY + 10,
                                 width: alertView.frame.width - 60,
                                 height: 20)
        alertView.addSubview(setsLabel)
        
        setsTextField.frame = CGRect(x: 20,
                                     y: setsLabel.frame.maxY,
                                     width: alertView.frame.width - 40,
                                     height: 30)
        setsTextField.translatesAutoresizingMaskIntoConstraints = true
        setsTextField.keyboardType = .numberPad
        alertView.addSubview(setsTextField)
        
        let repsOrTimerLabel = UILabel(text: repsOrTimer)
        repsOrTimerLabel.translatesAutoresizingMaskIntoConstraints = true
        repsOrTimerLabel.frame = CGRect(x: 30,
                                 y: setsTextField.frame.maxY + 3,
                                 width: alertView.frame.width - 60,
                                 height: 20)
        alertView.addSubview(repsOrTimerLabel)
        
        repsTextField.frame = CGRect(x: 20,
                                     y: repsOrTimerLabel .frame.maxY,
                                     width: alertView.frame.width - 40,
                                     height: 30)
        repsTextField.translatesAutoresizingMaskIntoConstraints = true
        repsTextField.keyboardType = .numberPad
        alertView.addSubview(repsTextField)
        
        let okButton = GreenButton(text: "OK")
        okButton.frame = CGRect(x: 50,
                                y: repsTextField.frame.maxY + 15,
                                width: alertView.frame.width - 100,
                                height: 35)
        okButton.translatesAutoresizingMaskIntoConstraints = true
        okButton.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        alertView.addSubview(okButton)
        
        buttonAction = completion
        
        UIView.animate(withDuration: 0.3) {
            self.blackBackgroundView.alpha = 0.8
        } completion: { done in
            if done {
                UIView.animate(withDuration: 0.3) {
                    self.alertView.center = parentView.center
                }
            }
        }
    }
    
    @objc private func okButtonTapped() {
        guard let setsNumber = setsTextField.text,
              let repsNumber = repsTextField.text else { return }
        
        buttonAction?(setsNumber,repsNumber)
        
        guard let targetView = mainView else { return }
        
        UIView.animate(withDuration: 0.3) {
            self.alertView.frame = CGRect(x: 40,
                                          y: targetView.frame.height,
                                          width: targetView.frame.width - 80,
                                          height: 420)
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.blackBackgroundView.alpha = 0
            } completion: { done in
                if done {
                    self.alertView.removeFromSuperview()
                    self.blackBackgroundView.removeFromSuperview()
                    self.scrollView.removeFromSuperview()
//                    self.setsTextField.text = ""
//                    self.repsTextField.text = ""
                    self.removeForKeyboardNotification()
                }
            }

        }

    }
    
    private func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(kbWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(kbWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func removeForKeyboardNotification() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    @objc private func kbWillShow() {
        scrollView.contentOffset = CGPoint(x: 0, y: 100)
    }
    
    @objc private func kbWillHide() {
        scrollView.contentOffset = CGPoint.zero
    }
    
}
