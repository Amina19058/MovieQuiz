import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, ViewControllerDelegate {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    private var currentQuestionIndex: Int = .zero
    private var correctAnswers: Int = .zero
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol = QuestionFactory()
    private let alertPresenter: AlertPresenter = AlertPresenter()
    private var currentQuestion: QuizQuestion?
    private let statisticService: StatisticServiceProtocol = StatisticService()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let questionFactory = QuestionFactory()
        questionFactory.setup(delegate: self)
        
        self.questionFactory = questionFactory
        startQuiz()
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else {
            return
        }

        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
            self?.view.isUserInteractionEnabled = true
        }
    }
    
    // MARK: - Private functions
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        self.view.isUserInteractionEnabled = false
        
        guard let currentQuestion else {
            return
        }

        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }

    @IBAction private func noButtonClicked(_ sender: UIButton) {
        self.view.isUserInteractionEnabled = false
        
        guard let currentQuestion else {
            return
        }
        
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    private func startQuiz() {
        self.currentQuestionIndex = .zero
        self.correctAnswers = .zero
        
        showQuizQuestion()
    }
    
    private func showQuizQuestion() {
        questionFactory.requestNextQuestion()
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
        imageView.layer.borderWidth = .zero
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        self.alertPresenter.setup(delegate: self)
        
        let alertModel = AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText,
            completion: { [weak self] in
                guard let self = self else { return }
                self.startQuiz()
            })
        
        alertPresenter.present(alertModel)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            
            let resultViewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: generateResultText(),
                buttonText: "Сыграть ещё раз")
            
            show(quiz: resultViewModel)
        } else {
            currentQuestionIndex += 1
            showQuizQuestion()
        }
    }
    
    private func generateResultText() -> String {
        let bestGame: GameResult = statisticService.bestGame
        
        return """
        Ваш результат: \(correctAnswers)/\(questionsAmount)
        Количество сыгранных квизов: \(statisticService.gamesCount)
        Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))
        Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
        """
    }
}
