//
//  PuzzleViewController.swift
//  Compound
//
//  Created by Daniel Maness on 3/28/15.
//  Copyright (c) 2015 Daniel Maness. All rights reserved.
//

import UIKit

class PuzzleViewController: BaseViewController, UITextFieldDelegate {
    private let puzzleManager = PuzzleManager()
    private let userManager = UserManager()
    private let challengeManager = ChallengeManager()
    
    /* Properties */
    var puzzle: Puzzle!
    var challenge: Challenge!
    var totalPoints: Int = 0
    var guess: String = ""
    var timer = NSTimer()
    var stars = [UIImageView]()
    var overlay: UIView?
    var MAX_HINTS = 3

    /* Outlets */
    @IBOutlet weak var statusBar: UIImageView!
    @IBOutlet weak var star0: UIImageView!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var hintButton: UIButton!
    @IBOutlet weak var hiddenText: UITextField!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var wordLabel1: UILabel!
    @IBOutlet weak var wordLabel2: UILabel!
    @IBOutlet weak var wordLabel3: UILabel!
    @IBOutlet weak var wordLabelView: UIView!
    
    /* Actions */
    @IBAction func hiddenTextChanged(sender: AnyObject) {
        updateAnswerLabel()
    }
    
    @IBAction func hintButtonPressed(sender: AnyObject) {
        if puzzle.hintsUsed < MAX_HINTS {
            useHint()
        } else {
            showGiveUpView()
        }
    }
    
    /* Setup */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let uiView = self.view as UIView
        setupView()
        
        createPuzzle()
        startPuzzle()
    }
    
    override func viewDidAppear(animated: Bool) {
        var frame = answerLabel.frame
        frame.origin.x = 100
        frame.origin.y = 100
        answerLabel.frame = frame
        
        answerLabel.center = CGPointMake(1, 0)
    }
    
    func setupView() {
        stars.append(star0)
        stars.append(star1)
        stars.append(star2)
        stars.append(star3)

        setupKeyboard()
    }
    
    func resizeObjects() {
        wordLabelView.frame = CGRectMake(0.0, 80.0, self.view.frame.size.width, 200.0)
    }
    
    func setupKeyboard() {
        hiddenText.hidden = true
        hiddenText.autocorrectionType = UITextAutocorrectionType.No
        hiddenText.returnKeyType = UIReturnKeyType.Go
        hiddenText.keyboardType = UIKeyboardType.ASCIICapable
        self.hiddenText.delegate = self
        showKeyboard()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if puzzleManager.checkAnswer(textField.text, answer: puzzle.keyword) {
            endPuzzle(Status.Complete)
        } else {
            guess = ""
            hiddenText.text = ""
            updateAnswerLabel()
        }
        
        return true
    }
    
    /* Logic */    
    func handleTimer() {
        if puzzle.time > 1 {
            puzzle.time--
            
            if (puzzle.time == 45 && puzzle.hintsUsed == 0) || (puzzle.time == 30 && puzzle.hintsUsed == 1) || (puzzle.time == 10 && puzzle.hintsUsed == 2) {
                useHint()
            }
            
            updateTimerLabel()
        } else {
            puzzle.time = 0
            updateTimerLabel()
            endPuzzle(Status.TimeUp)
        }
    }
    
    func startTimer() {
        puzzle.time = MAX_TIME
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("handleTimer"), userInfo: nil, repeats: true)
        updateTimerLabel()
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
    func createPuzzle() {
        if self.challenge != nil {
            self.puzzle = challenge.puzzle
        } else {
            self.puzzle = puzzleManager.newPuzzle()
        }
        
        self.guess = ""
        resetPuzzleView()
    }
    
    func startPuzzle() {
        puzzle.startTime = DateTime.now()
        startTimer()
    }
    
    func stopPuzzle() {
        puzzle.ended = true
        stopTimer()
        puzzle.endTime = DateTime.now()
    }
    
    func endPuzzle(status: Status) {
        puzzle.status = status
        stopPuzzle()
        userManager.updateStats(puzzle)
        
        if self.challenge == nil {
            if puzzle.status == Status.Complete {
                showPuzzleCompletedView()
            } else if puzzle.status == Status.TimeUp {
                showPuzzleFailedView("TIMES UP!")
            } else if puzzle.status == Status.GaveUp {
                showPuzzleFailedView("GAVE UP!")
            }
        } else {
            self.challenge.puzzle = self.puzzle
            challengeManager.completeChallenge(self.challenge)
            challengeManager.completeChallenge(self.challenge.parentChallenge)
            showChallengeResults()
        }
    }
    
    func useHint() {
        puzzle.hintsUsed += puzzle.hintsUsed < MAX_HINTS ? 1 : 0
        puzzle.currentHint = puzzleManager.useHint(puzzle.keyword, hintsUsed: puzzle.hintsUsed)
        
        updateHintButton()
        updateStars()
        updateWordLabels()
        
        if puzzle.hintsUsed == MAX_HINTS {
            hiddenText.text = ""
        }
        
        updateAnswerLabel()
    }
    
    /* UI */
    func showKeyboard() {
        hiddenText.becomeFirstResponder()
    }
    
    func hideKeyboard() {
        hiddenText.resignFirstResponder()
    }
    
    func updateStars() {
        for i in 0..<stars.count {
            if i < puzzle.currentStars {
                stars[i].highlighted = true
            } else {
                stars[i].highlighted = false
            }
        }
    }
    
    func updateHintButton() {
        var image = UIImage(named: "lightbulb-" + String(MAX_HINTS - puzzle.hintsUsed))
        hintButton.setImage(image, forState: UIControlState.Normal)
    }
    
    func updateTimerLabel() {
        if puzzle.time <= 10 {
            timerLabel.textColor = ColorPalette.pink
        }
        
        timerLabel.text = DateTime.getFormattedSeconds(puzzle.time)
    }
    
    func updateWordLabels() {
        wordLabel1.attributedText = formatIncompleteWord(puzzle.currentHint, combination: puzzle.combinations[0])
        wordLabel2.attributedText = formatIncompleteWord(puzzle.currentHint, combination: puzzle.combinations[1])
        wordLabel3.attributedText = formatIncompleteWord(puzzle.currentHint, combination: puzzle.combinations[2])
    }
    
    func updateAnswerLabel() {
        if puzzle.hintsUsed >= MAX_HINTS - 1 {
            if puzzle.hintsUsed == MAX_HINTS && hiddenText.text == "" {
                //hiddenText.text = puzzle.keyword.Name[0]
            }
            
            if count(hiddenText.text) >= count(puzzle.keyword) {
                hiddenText.text = hiddenText.text.subStringTo(count(puzzle.keyword))
            }
        
            self.guess = hiddenText.text.uppercaseString
            
            var attributedText: NSMutableAttributedString
            var formattedGuess = ""
            
            for i in 0..<count(self.guess) {
                formattedGuess += self.guess[i] + " "
            }
            
            while count(formattedGuess) / 2 < count(puzzle.keyword) {
                formattedGuess += "_ "
            }
            
            attributedText = NSMutableAttributedString(string: formattedGuess)
            
            for i in 0..<count(formattedGuess) {
                if formattedGuess[i] != "_" && formattedGuess[i] != " " {
                    attributedText.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: NSMakeRange(i, 1))
                }
            }
            
            answerLabel.attributedText = attributedText
        } else {
            self.guess = hiddenText.text.uppercaseString
            answerLabel.attributedText = NSMutableAttributedString(string: guess)
        }
    }
    
    func resetPuzzleView() {
        wordLabel1.text = ""
        wordLabel2.text = ""
        wordLabel3.text = ""
        answerLabel.text = ""
        hiddenText.text = ""
        
        updateStars()
        updateHintButton()
        updateWordLabels()
        updateTimerLabel()
        timerLabel.textColor = ColorPalette.black
    }
    
    func formatIncompleteWord(hint: String, combination: Combination) -> NSMutableAttributedString {
        var location = combination.keywordLocation == Location.Left ? 0 : count(combination.leftWord)
        var length = count(hint)
        var attributedString = NSMutableAttributedString(string: combination.keywordLocation == Location.Left ?
            hint.uppercaseString + combination.rightWord.uppercaseString :
            combination.leftWord.uppercaseString + hint.uppercaseString)

        if length > 0 && puzzle.hintsUsed == MAX_HINTS {
            attributedString.addAttribute(NSForegroundColorAttributeName, value: ColorPalette.black, range: NSMakeRange(location, length))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: NSMakeRange(location, 1))
        }

        return attributedString
    }
    
    /* Views */
    func showGiveUpView() {
        // This method is good for showing a view we may need to return from
        hideKeyboard()
        var viewController = UIStoryboard(name: "Puzzle", bundle: nil).instantiateViewControllerWithIdentifier("GiveUpViewController") as! GiveUpViewController
        self.addChildViewController(viewController)
        view.addSubview(viewController.view)
        viewController.didMoveToParentViewController(self)
    }
    
    func showPuzzleCompletedView() {
        // This method is good for showing a view we won't need to return from
        var viewController = UIStoryboard(name: "Puzzle", bundle: nil).instantiateViewControllerWithIdentifier("PuzzleCompletedViewController") as! PuzzleCompletedViewController
        viewController.setAnswerView(puzzle.combinations[0].combinedWord, word2: puzzle.combinations[1].combinedWord, word3: puzzle.combinations[2].combinedWord, keyword: puzzle!.keyword)
        viewController.currentStars = puzzle.currentStars
        viewController.totalStars = userManager.getStats().totalStarsEarned
        viewController.puzzle = self.puzzle
        
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    func showPuzzleFailedView(message: String) {
        // This method is good for showing a view we won't need to return from
        var viewController = UIStoryboard(name: "Puzzle", bundle: nil).instantiateViewControllerWithIdentifier("PuzzleFailedViewController") as! PuzzleFailedViewController
        viewController.message = message
        viewController.totalStars = userManager.getStats().totalStarsEarned
        
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    func showChallengeResults() {
        // This method is good for showing a view we won't need to return from
        var viewController = UIStoryboard(name: "Challenge", bundle: nil).instantiateViewControllerWithIdentifier("ChallengeResultsViewController") as! ChallengeResultsViewController
        viewController.setAnswerView(puzzle.combinations[0].combinedWord, word2: puzzle.combinations[1].combinedWord, word3: puzzle.combinations[2].combinedWord, keyword: puzzle!.keyword)
        viewController.currentStars = puzzle.currentStars
        viewController.totalStars = userManager.getStats().totalStarsEarned
        viewController.userChallenge = self.challenge
        viewController.parentChallenge = self.challenge.parentChallenge
        
        self.presentViewController(viewController, animated: true, completion: nil)
    }
}