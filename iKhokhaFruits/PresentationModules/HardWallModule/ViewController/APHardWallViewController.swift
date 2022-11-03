//
//  APHardWallViewController.swift
//  iKhokhaFruits
//
//  Created by Wykee Njenga on 10/30/22.
//  Copyright © 2022 iKhokha. All rights reserved.
//

import UIKit
import Loaf

class APHardWallViewController: BaseViewController {
    
    var viewModel: APHardWallViewModel!

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBOutlet weak var emailTextField: APAnimatablePlaceholderTextField!{
        didSet {
               self.emailTextField.bind { [weak self] in guard let checkedSelf = self else { return }
                   checkedSelf.viewModel.emailText.value = $0
               }
               self.emailTextField.bindForFailure { (error) in
                   //Do something when failure occurs.
               }
               self.emailTextField.rulesToBeValidated = [.emailLength,.emailMalformed]
           }
    }
    
    @IBOutlet weak var passwordTextField: APAnimatablePlaceholderTextField!{
        didSet {
            self.passwordTextField.bind { [weak self] in guard let checkedSelf = self else { return }
                checkedSelf.viewModel.passwordText.value = $0
            }
            self.passwordTextField.bindForFailure { (error) in
                //Do something when failure occurs.
            }
            self.passwordTextField.rulesToBeValidated = [.passwordLength]
        }
    }
    
    @IBOutlet weak var continueButton: APBindingButton!{
        didSet {
              self.continueButton.bind {
                  if self.passwordTextField.isValid() {
                      //Check if password textField is holds valid data.
                      self.showHUD()
                      self.viewModel.performLogin { [weak self] (result) in guard let checkedSelf = self else { return }
                          checkedSelf.hideHUD()
                          switch result {
                          case .success:
                              DispatchQueue.main.async {
                                  checkedSelf.navigateHome()
                              }
                              break
                          case .failure(let error):
                              print(error.error?.localizedDescription ?? "")
                              break
                          }
                      }
                  }
              }
          }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    final class func create() -> APHardWallViewController {
        let view = APHardWallViewController(nibName: "APHardWallViewController", bundle: nil)
        return view
    }
    
    
    func navigateHome(){
        let homeVC = Accessors.AppDelegate.delegate.appDiContainer.makeHomeDIContainer().makeHomeViewController()
        homeVC.modalPresentationStyle = .fullScreen
        homeVC.modalTransitionStyle = .coverVertical
        self.present(homeVC, animated: true)
    }

}
