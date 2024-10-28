//
//  QuestionViewController.swift
//  QuizHomeWorkFour
//
//  Created by Руслан Арыстанов on 17.10.2024.
//

import UIKit

class QuestionViewController: UIViewController {

    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var questionLabel: UILabel!
    
    @IBOutlet var singleStackView: UIStackView!
    @IBOutlet var singleButtons: [UIButton]!
    
    @IBOutlet var multipleStackView: UIStackView!
    @IBOutlet var multipleLabels: [UILabel]!
    @IBOutlet var multipleSwitches: [UISwitch]!
    
    @IBOutlet var rangedStackView: UIStackView!
    @IBOutlet var rangedLabels: [UILabel]!
    @IBOutlet var rangedSlider: UISlider! {
        //устанавливем наблюдатель свойтва didSet, этот наблюдатеь реагирует на каждое действие с элементом
        didSet {
            let answerCount = Float(currentAnswers.count - 1)
            rangedSlider.maximumValue = answerCount
            rangedSlider.value = answerCount / 2
        }
    }
    
    private let questions = Question.getQuestion()
    
    // массив в который складываем выбранные пользоватеелм ответы
    private var answersChosen: [Answer] = []
    
    // свойство для доступа к элементам массива questions
    private var questionIndex = 0
    
    //делаем вычисляемое свойство, так как если мы захотим обратиться к массиву questions на прямую, на момент обращения к массиву questions, он еще не инициализирован
    private var currentAnswers: [Answer] {
        //по индексу обращаемся в вопросу и из него извлекаем массив ответов
        questions[questionIndex].answers
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //метод для обновления элементов интерфейса в соответсвии с текущим вопросом
        updateUI()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let resultViewController = segue.destination as? ResultViewController else {
            return
        }
        
        resultViewController.answersChoosen = answersChosen
        
    }
    
    @IBAction func singleAnswerButtonPressed(_ sender: UIButton) {
        //определеяем индекс нажатой кнопки
        guard let buttonIndex = singleButtons.firstIndex(of: sender) else {
            return
        }
        //добавляем в массив ответов текущий выбранный пользователем ответ по индексу
        let currentAnswer = currentAnswers[buttonIndex]
        answersChosen.append(currentAnswer)
        
        //обновляем страницу вызвав кастомный метод
        nextQuestion()
    }
    
    @IBAction func multipleAnswerButtonPressed() {
        for (multipleSwitch, answer) in zip(multipleSwitches,currentAnswers) {
            if multipleSwitch.isOn {
                answersChosen.append(answer)
            }
        }
        
        nextQuestion()
    }
    
    @IBAction func rangedAnswerButtonPressed() {
        //получем индекс из текущего значения слайдера
        //приводим к целому числу из флоат функцией lrintf
        let index = lrintf(rangedSlider.value)
        answersChosen.append(currentAnswers[index])
        
        nextQuestion()
    }
    
}

// MARK: - Private Methods
extension QuestionViewController {
    private func updateUI() {
        // скрытие всех стеков - что бы по умолчанию на экране ничего не отображалось
        for stackView in [singleStackView, multipleStackView, rangedStackView] {
            stackView?.isHidden = true
        }
        
        // получение текущего вопроса
        let currentQuestion = questions[questionIndex]
        
        // установка текущего вопроса для лейбла
        questionLabel.text = currentQuestion.title
        
        //рассчет прогресса для UIProgressView
        let totalProgress = Float(questionIndex) / Float(questions.count)
        
        //установка текущего прогресса для UIProgressView
        progressView.setProgress(totalProgress, animated: true)
        
        //установка номера вопроса в navigation title
        //свойство класса title доступно так как мы унаследовались от navigationViewController
        title = "Вопрос № \(questionIndex + 1) из \(questions.count)"
        
        //вызов кастомного метода для показа текущего ответа
        showCurrentAnswers(for: currentQuestion.type)
    }
    
    //метод для отображения текущего вопроса
    private func showCurrentAnswers(for type: ResponseType) {
        switch type {
        case .single: showSingleStackView(with: currentAnswers)
        case .multiple: showMultipleStackView(with: currentAnswers)
        case .ranged: showRangedStackView(with: currentAnswers)
        }
    }
        
    //метод для отображения одиночных ответов
    private func showSingleStackView(with answers: [Answer]) {
        singleStackView.isHidden.toggle()
        
        for (button, answer) in zip(singleButtons, answers) {
            button.setTitle(answer.title, for: .normal)
        }
    }
    
    private func showMultipleStackView(with answers: [Answer]) {
        multipleStackView.isHidden.toggle()
        
        for (label, answer) in zip(multipleLabels, answers) {
            label.text = answer.title
        }
    }
    
    private func showRangedStackView(with answers: [Answer]) {
        rangedStackView.isHidden.toggle()
        
        rangedLabels.first?.text = answers.first?.title
        rangedLabels.last?.text = answers.last?.title
    }
    
    private func nextQuestion() {
        questionIndex += 1
        
        //если индекс меньше количества элементов массива, обновляем UI
        if questionIndex < questions.count {
            updateUI()
            return
        }
        
        performSegue(withIdentifier: "showResult", sender: nil)
    }
}
