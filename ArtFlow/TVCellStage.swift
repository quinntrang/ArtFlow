//
//  TVCellStage.swift
//  ArtFlow
//
//  Created by Quinn on 4/12/21.
//

import UIKit

protocol TVCellStageDelegate {
    func cell(_ cell:TVCellStage, delete entry:Entry)
}

class TVCellStage : UITableViewCell {
    @IBOutlet var stageImageView: UIImageView!
    @IBOutlet var titleLable: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    var delegate : TVCellStageDelegate?
    
    var entry : Entry! {
        didSet {
            self.setUpUI(entry: self.entry)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //self.setUpUI(entry: self.entry)
    }
    
    func setUpUI(entry:Entry) {
        self.stageImageView.image = UIImage(data: self.entry.image!)
        self.titleLable.text = self.entry.location
        self.descriptionLabel.text = self.entry.detail
        self.dateLabel.text = self.entry.createTime?.string(forFormat: KAppDateFormat)
    }
    
    @IBAction func deleteButtonTouched(_ sender: Any) {
        self.delegate?.cell(self, delete : self.entry)
    }
}
