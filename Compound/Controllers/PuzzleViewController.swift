//
//  PuzzleViewController.swift
//  Compound
//
//  Created by Daniel Maness on 3/28/15.
//  Copyright (c) 2015 Daniel Maness. All rights reserved.
//

import UIKit

class PuzzleViewController: BaseViewController, UITextFieldDelegate {
    /* Properties */
    var puzzle: Puzzle!
    var totalPoints: Int = 0
    var guess: String = ""
    var timer = NSTimer()
    var stars = [UIImageView]()
    var overlay: UIView?

    /* Outlets */
    @IBOutlet weak var star0: UIImageView!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var hintButton: UIButton!
    @IBOutlet weak var hiddenText: UITextField!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var wordLabel0: UILabel!
    @IBOutlet weak var wordLabel1: UILabel!
    @IBOutlet weak var wordLabel2: UILabel!
    
    /* Actions */
    @IBAction func hiddenTextChanged(sender: AnyObject) {
        updateAnswerLabel()
    }
    
    @IBAction func hintButtonPressed(sender: AnyObject) {
        if puzzle.hintsUsed < puzzle.maxHints {
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
    
    func setupView() {
        stars.append(star0)
        stars.append(star1)
        stars.append(star2)
        stars.append(star3)
        setupKeyboard()
    }
    
    func setupKeyboard() {
        hiddenText.hidden = true
        hiddenText.autocorrectionType = UITextAutocorrectionType.No
        hiddenText.returnKeyType = UIReturnKeyType.Go
        self.hiddenText.delegate = self
        showKeyboard()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if trySubmit() {
            endPuzzle(Status.Complete)
        } else {
            guess = ""
            hiddenText.text = ""
            updateAnswerLabel()
        }
        
        return true
    }
    
    /* Logic */
    func getDateTimeNow() -> String {
        let date = NSDate()
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-hh-mm-ss-SSS"
        let datetime = dateFormatter.stringFromDate(date)
        return datetime
    }
    
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
        puzzle.time = puzzle.maxTime
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("handleTimer"), userInfo: nil, repeats: true)
        updateTimerLabel()
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
    func createPuzzle() {
        self.puzzle = Puzzle()
        self.puzzle.newPuzzle()
        self.guess = ""
        resetPuzzleView()
    }
    
    func startPuzzle() {
        puzzle.startTime = getDateTimeNow()
        startTimer()
    }
    
    func stopPuzzle() {
        puzzle.ended = true
        stopTimer()
        puzzle.endTime = getDateTimeNow()
        puzzle.save()
        revealPuzzle()
    }
    
    func endPuzzle(status: Status) {
        puzzle.status = status
        
        if puzzle.status == Status.Complete {
            userData.addStars(puzzle.currentStars)
            showPuzzleCompletedView()
        } else if puzzle.status == Status.TimeUp {
            showPuzzleFailedView("TIMES UP!")
        } else if puzzle.status == Status.GaveUp {
            showPuzzleFailedView("GAVE UP!")
        }
        
        stopPuzzle()
    }
    
    func trySubmit() -> Bool {
        return puzzle.checkAnswer(guess)
    }
    
    func useHint() {
        puzzle.useHint()
        
        if puzzle.hintsUsed == 1 && puzzle.hintTime1 == "" {
            puzzle.hintTime1 = getDateTimeNow()
        } else if puzzle.hintsUsed == 2 && puzzle.hintTime2 == "" {
            puzzle.hintTime2 = getDateTimeNow()
        } else if puzzle.hintsUsed == 3 && puzzle.hintTime3 == "" {
            puzzle.hintTime3 = getDateTimeNow()
        }
        
        updateHintButton()
        updateStars()
        updateWordLabels()
        
        if puzzle.hintsUsed == puzzle.maxHints {
            hiddenText.text = ""
        }
        
        updateAnswerLabel()
    }
    
    func revealPuzzle() {
        wordLabel0.attributedText = getAttributedString(puzzle.keyword.Name, combination: puzzle.combinations[0])
        wordLabel1.attributedText = getAttributedString(puzzle.keyword.Name, combination: puzzle.combinations[1])
        wordLabel2.attributedText = getAttributedString(puzzle.keyword.Name, combination: puzzle.combinations[2])
        
        answerLabel.text = puzzle.keyword.Name
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
        var image = UIImage(named: "lightbulb-" + String(puzzle.maxHints - puzzle.hintsUsed))
        hintButton.setImage(image, forState: UIControlState.Normal)
    }
    
    func updateTimerLabel() {
        if puzzle.time == puzzle.maxTime {
            timerLabel.text = "1:00"
        } else if puzzle.time <= 10 {
            timerLabel.textColor = ColorPalette.pink
            if puzzle.time == 10 {
                timerLabel.text = ":" + String(puzzle.time)
            } else {
                timerLabel.text = ":0" + String(puzzle.time)
            }
        } else {
            timerLabel.text = ":" + String(puzzle.time)
        }
    }
    
    func updateWordLabels() {
        wordLabel0.attributedText = getAttributedString(puzzle.currentHint, combination: puzzle.combinations[0])
        wordLabel1.attributedText = getAttributedString(puzzle.currentHint, combination: puzzle.combinations[1])
        wordLabel2.attributedText = getAttributedString(puzzle.currentHint, combination: puzzle.combinations[2])
    }
    
    func updateAnswerLabel() {
        if puzzle.hintsUsed >= puzzle.maxHints - 1 {
            if puzzle.hintsUsed == puzzle.maxHints && hiddenText.text == "" {
                hiddenText.text = puzzle.keyword.Name[0]
            }
            
            if count(hiddenText.text) >= count(puzzle.keyword.Name) {
                hiddenText.text = hiddenText.text.subStringTo(count(puzzle.keyword.Name))
            }
        
            self.guess = hiddenText.text.uppercaseString
            
            var attributedText: NSMutableAttributedString
            var formattedGuess = ""
            
            for i in 0..<count(self.guess) {
                formattedGuess += self.guess[i] + " "
            }
            
            while count(formattedGuess) / 2 < count(puzzle.keyword.Name) {
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
        wordLabel0.text = ""
        wordLabel1.text = ""
        wordLabel2.text = ""
        answerLabel.text = ""
        hiddenText.text = ""
        
        updateStars()
        updateHintButton()
        updateWordLabels()
        updateTimerLabel()
        timerLabel.textColor = ColorPalette.black
    }
    
    func getAttributedString(hint: String, combination: Combination) -> NSMutableAttributedString {
        var attributedString = NSMutableAttributedString(string: combination.keywordLocation == Location.Left ? hint + combination.rightWord.Name : combination.leftWord.Name + hint)
        var location = combination.keywordLocation == Location.Left ? 0 : count(combination.leftWord.Name)
        var length = count(hint)
        if puzzle.ended {
            attributedString.addAttribute(NSForegroundColorAttributeName, value: ColorPalette.black, range: NSMakeRange(location, length))
        } else if length > 0 && puzzle.hintsUsed == puzzle.maxHints {
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
        viewController.word0 = wordLabel0.attributedText as! NSMutableAttributedString
        viewController.word1 = wordLabel1.attributedText as! NSMutableAttributedString
        viewController.word2 = wordLabel2.attributedText as! NSMutableAttributedString
        viewController.currentStars = puzzle.currentStars
        viewController.totalStars = userData.getTotalStars()
        
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    func showPuzzleFailedView(message: String) {
        // This method is good for showing a view we won't need to return from
        var viewController = UIStoryboard(name: "Puzzle", bundle: nil).instantiateViewControllerWithIdentifier("PuzzleFailedViewController") as! PuzzleFailedViewController
        viewController.message = message
        viewController.totalStars = userData.getTotalStars()
        
        self.presentViewController(viewController, animated: true, completion: nil)
    }
}