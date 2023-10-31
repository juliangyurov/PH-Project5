//
//  ViewController.swift
//  Project5
//
//  Created by Yulian Gyuroff on 25.09.23.
//

import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
    var usedWords = [String]()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let startWords = try? String(contentsOf: startWordsURL){
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        if allWords.isEmpty{
            allWords = ["silkworm"]
        }
        startGame()
    }
    @objc func startGame(){
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return usedWords.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        //print("indexPath.row=\(indexPath.row) usedWords[\(indexPath.row)]=\(usedWords[indexPath.row])")
        return cell
    }
    
    @objc func promptForAnswer(){
        
        let ac = UIAlertController(title: "Enter Answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] action in
            guard !(ac?.textFields?[0].text?.isEmpty ?? true), let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true	)
    }
    func submit(_ answer: String){
        
        var errorTitle: String
        var errorMessage: String
        let lowerAnswer = answer.lowercased()
        
        if isPossible(word: lowerAnswer){
            if isOriginal(word: lowerAnswer){
                if isReal(word: lowerAnswer){
                    if notStartingWith(word: lowerAnswer){
                        if isLong(word: lowerAnswer){
                            usedWords.insert(lowerAnswer, at: 0)
                            let indexPath = IndexPath(row: 0, section: 0)
                            tableView.insertRows(at: [indexPath], with: .automatic)
                            return
                        }else{
                            errorTitle = "Word is shorter than 3 letters"
                            errorMessage = "Use more letters!"
                            showErrorMessage(errTitle: errorTitle, errMessage: errorMessage)
                        }
                    }else{
                        errorTitle = "Word is starting"
                        errorMessage = "Use another combination!"
                        showErrorMessage(errTitle: errorTitle, errMessage: errorMessage)
                    }
                }else{
                    errorTitle = "Word is not recognized"
                    errorMessage = "You can't just make them up, you know!"
                    showErrorMessage(errTitle: errorTitle, errMessage: errorMessage)
                }
            }else{
                errorTitle = "Word already used"
                errorMessage = "Be more original!"
                showErrorMessage(errTitle: errorTitle, errMessage: errorMessage)
            }
        }else{
            errorTitle = "Word is not possible"
            errorMessage = "You can't spell that word from \(title!.lowercased())!"
            showErrorMessage(errTitle: errorTitle, errMessage: errorMessage)
        }
        
        
        //        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        //        ac.addAction(   UIAlertAction(title: "OK", style: .default))
        //        present(ac, animated: true)
    }
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        for leter in word{
            if let position = tempWord.firstIndex(of: leter){
                tempWord.remove(at: position)
            }else{
                return false
            }
        }
        return true
    }
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    func isReal(word: String) -> Bool {
        //if word.utf16.count < 3 { return false }
        
//        guard let tempWord = title?.lowercased() else { return false }
//        let index = tempWord.index(tempWord.startIndex, offsetBy: word.utf16.count)
//        let startWord = tempWord[..<index]
//        if word == startWord  { return false }
        
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    func isLong(word: String) -> Bool {
        if word.utf16.count < 3 { return false }
        return true
    }
    func notStartingWith(word: String) -> Bool {
        guard let tempWord = title?.lowercased() else { return false }
        if tempWord.starts(with: word) { return false }
        return true
    }
    
    func showErrorMessage(errTitle: String, errMessage: String){
        let ac = UIAlertController(title: errTitle, message: errMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}

