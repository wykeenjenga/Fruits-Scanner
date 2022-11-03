//
//  APHardWallViewController.swift
//  iKhokhaFruits
//
//  Created by Wykee Njenga on 10/30/22.
//  Copyright © 2022 iKhokha. All rights reserved.
//

import UIKit

class APHardWallViewController: BaseViewController {
    
    var viewModel: APHardWallViewModel!

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBOutlet weak var emailTextField: APAnimatablePlaceholderTextField!{
        didSet{
            
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
        didSet{
            self.continueButton.bind {
                self.showHUD()
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
