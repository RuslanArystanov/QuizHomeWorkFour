//
//  ResultViewController.swift
//  QuizHomeWorkFour
//
//  Created by Руслан Арыстанов on 22.10.2024.
//

import UIKit

class ResultViewController: UIViewController {
    var animal = Animal.dog
    @IBOutlet var animalLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    var answersChoosen: [Answer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(answersChoosen)
        animalLabel.text = String(calculateResult().rawValue)
        descriptionLabel.text = calculateResult().definition
    }

}

extension ResultViewController {
    private func calculateResult() -> Animal {
        var animalCount: [Animal: Int] = [:]

        for answer in answersChoosen {
            animalCount[answer.animal, default: 0] += 1
        }
        
        let sordetDict = animalCount.sorted {$0.value > $1.value}
        animal = sordetDict[0].key
        
        return animal
    }
}
