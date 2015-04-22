//
//  GameViewController.swift
//  Compound
//
//  Created by Daniel Maness on 3/28/15.
//  Copyright (c) 2015 Daniel Maness. All rights reserved.
//

import UIKit

class GameViewController: BaseViewController, UITextFieldDelegate {
    /* Properties */
    var game: Game!
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
        if game.hintsUsed < game.maxHints {
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
        
        createGame()
        startGame()
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
            endGame(Status.Complete)
        } else {
            guess = ""
            hiddenText.text = ""
            updateAnswerLabel()
        }
        
        return true
    }
    
    /* Logic */
    func handleTimer() {
        if game.time > 1 {
            game.time--
            
            if (game.time == 45 && game.hintsUsed == 0) || (game.time == 30 && game.hintsUsed == 1) || (game.time == 10 && game.hintsUsed == 2) {
                useHint()
            }
            
            updateTimerLabel()
        } else {
            game.time = 0
            updateTimerLabel()
            endGame(Status.TimeUp)
        }
    }
    
    func startTimer() {
        game.time = game.maxTime
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("handleTimer"), userInfo: nil, repeats: true)
        updateTimerLabel()
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
    func createGame() {
        self.game = Game()
        self.game.newGame()
        self.guess = ""
        resetGameView()
    }
    
    func startGame() {
        startTimer()
    }
    
    func stopGame() {
        game.ended = true
        stopTimer()
        revealPuzzle()
    }
    
    func endGame(status: Status) {
        stopGame()
        game.status = status
        
        if game.status == Status.Complete {
            userData.addStars(game.currentStars)
            showPuzzleCompletedView()
        } else if game.status == Status.TimeUp {
            showPuzzleFailedView("TIMES UP!")
        } else if game.status == Status.GaveUp {
            showPuzzleFailedView("GAVE UP!")
        }
    }
    
    func trySubmit() -> Bool {
        return game.checkAnswer(guess)
    }
    
    func useHint() {
        game.useHint()
        updateHintButton()
        updateStars()
        updateWordLabels()
        
        if game.hintsUsed == game.maxHints {
            hiddenText.text = ""
        }
        
        updateAnswerLabel()
    }
    
    func revealPuzzle() {
        wordLabel0.attributedText = getAttributedString(game.keyword.Name, combination: game.combinations[0])
        wordLabel1.attributedText = getAttributedString(game.keyword.Name, combination: game.combinations[1])
        wordLabel2.attributedText = getAttributedString(game.keyword.Name, combination: game.combinations[2])
        
        answerLabel.text = game.keyword.Name
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
            if i < game.currentStars {
                stars[i].highlighted = true
            } else {
                stars[i].highlighted = false
            }
        }
    }
    
    func updateHintButton() {
        var image = UIImage(named: "lightbulb-" + String(game.maxHints - game.hintsUsed))
        hintButton.setImage(image, forState: UIControlState.Normal)
        
//        if game.hintsUsed >= game.maxHints {
//            hintButton.selected = true
//        } else {
//            hintButton.selected = false
//        }
    }
    
    func updateTimerLabel() {
        if game.time == game.maxTime {
            timerLabel.text = "1:00"
        } else if game.time <= 10 {
            timerLabel.textColor = ColorPalette.pink
            if game.time == 10 {
                timerLabel.text = ":" + String(game.time)
            } else {
                timerLabel.text = ":0" + String(game.time)
            }
        } else {
            timerLabel.text = ":" + String(game.time)
        }
    }
    
    func updateWordLabels() {
        wordLabel0.attributedText = getAttributedString(game.currentHint, combination: game.combinations[0])
        wordLabel1.attributedText = getAttributedString(game.currentHint, combination: game.combinations[1])
        wordLabel2.attributedText = getAttributedString(game.currentHint, combination: game.combinations[2])
    }
    
    func updateAnswerLabel() {
        if game.hintsUsed >= game.maxHints - 1 {
            if game.hintsUsed == game.maxHints && hiddenText.text == "" {
                hiddenText.text = game.keyword.Name[0]
            }
            
            if count(hiddenText.text) >= count(game.keyword.Name) {
                hiddenText.text = hiddenText.text.subStringTo(count(game.keyword.Name))
            }
        
            self.guess = hiddenText.text.uppercaseString
            
            var attributedText: NSMutableAttributedString
            var formattedGuess = ""
            
            for i in 0..<count(self.guess) {
                formattedGuess += self.guess[i] + " "
            }
            
            while count(formattedGuess) / 2 < count(game.keyword.Name) {
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
    
    func resetGameView() {
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
        if game.ended {
            attributedString.addAttribute(NSForegroundColorAttributeName, value: ColorPalette.black, range: NSMakeRange(location, length))
        } else if length > 0 && game.hintsUsed == game.maxHints {
            attributedString.addAttribute(NSForegroundColorAttributeName, value: ColorPalette.black, range: NSMakeRange(location, length))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: NSMakeRange(location, 1))
        }
        
        return attributedString
    }
    
    /* Views */
    func showGiveUpView() {
        // This method is good for showing a view we may need to return from
        hideKeyboard()
        var viewController = UIStoryboard(name: "Game", bundle: nil).instantiateViewControllerWithIdentifier("GiveUpViewController") as! GiveUpViewController
        self.addChildViewController(viewController)
        view.addSubview(viewController.view)
        viewController.didMoveToParentViewController(self)
    }
    
    func showPuzzleCompletedView() {
        // This method is good for showing a view we won't need to return from
        var viewController = UIStoryboard(name: "Game", bundle: nil).instantiateViewControllerWithIdentifier("PuzzleCompletedViewController") as! PuzzleCompletedViewController
        viewController.word0 = wordLabel0.attributedText as! NSMutableAttributedString
        viewController.word1 = wordLabel1.attributedText as! NSMutableAttributedString
        viewController.word2 = wordLabel2.attributedText as! NSMutableAttributedString
        viewController.currentStars = game.currentStars
        viewController.totalStars = userData.getTotalStars()
        
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    func showPuzzleFailedView(message: String) {
        // This method is good for showing a view we won't need to return from
        var viewController = UIStoryboard(name: "Game", bundle: nil).instantiateViewControllerWithIdentifier("PuzzleFailedViewController") as! PuzzleFailedViewController
        viewController.message = message
        viewController.totalStars = userData.getTotalStars()
        
        self.presentViewController(viewController, animated: true, completion: nil)
    }
}