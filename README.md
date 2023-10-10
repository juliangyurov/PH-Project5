## [Project 5: Word Scramble](https://www.hackingwithswift.com/read/5/overview)

**Description:** Create an anagram game while learning about closures and booleans.

- Setting up

- Reading from disk: `contentsOf`

- Pick a word, any word: `UIAlertController`

- Prepare for submission: `lowercased()` and `IndexPath`

- Checking for valid answers

- Or else what?

- Wrap up

## [Download assets for this project from GitHub](https://github.com/twostraws/HackingWithSwift)

## [Review what you learned](https://www.hackingwithswift.com/review/hws/project-5-word-scramble)

**Challenge**

1. Disallow answers that are shorter than three letters or are just our start word. For the three-letter check, the easiest thing to do is put a check into `isReal()` that returns false if the word length is under three letters. For the second part, just compare the start word against their input word and return false if they are the same.

2. Refactor all the else statements we just added so that they call a new method called `showErrorMessage()`. This should accept an error message and a title, and do all the `UIAlertController` work from there.

3. Add a left bar button item that calls `startGame()`, so users can restart with a new word whenever they want to.
