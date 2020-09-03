//
//  ListCell.swift
//  Task_Project
//
//  Created  on 01/09/20.
//  Copyright © 2020 Test. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell, UITextFieldDelegate {


    @IBOutlet weak var btnYes: UIButton!
       @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var questionLbl: UILabel!

    @IBOutlet weak var btnCheckBox: UIButton!
    @IBOutlet weak var btnUnCheckBox: UIButton!
    @IBOutlet weak var titleLbl: UILabel!

    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var btnClick: UIButton!

    @IBOutlet weak var txtField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
