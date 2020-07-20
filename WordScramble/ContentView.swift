//
//  ContentView.swift
//  WordScramble
//
//  Created by Gavin Butler on 15-07-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var usedWords = [String]()
    @State private var rootWord = "Blah"
    @State private var newWord = ""
    @State private var score = 0
    
    //Variables for error messages:
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false

    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter your word", text: $newWord, onCommit: addNewWord)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding()
                List(usedWords, id: \.self) {
                    Text($0)
                    Spacer()
                    Image(systemName: "\($0.count).circle")
                }
                Text("Score: \(score)")
                    .font(.title)
            }
            .navigationBarTitle(rootWord)
            .navigationBarItems(leading: Button(action: startGame) {
                Text("Re-Start")
                .padding(8  )
                .foregroundColor(.white)
                .background(Color.black)
                .clipShape(Capsule())
            })
            .onAppear(perform: startGame)
            .alert(isPresented: $showingError) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else {
            return
        }
        
        guard answer.count > 3 else  {
            wordError(title: "Not long enough", message: "Please use > 3 letter words")
            return
        }
        
        guard answer != rootWord else {
            wordError(title: "Not allowed", message: "Using the original word is not allowed")
            return
        }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }
        
        guard usesRootWordLetters(word: answer) else {
            wordError(title: "Letters not permitted", message: "Only use letters from the above word")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Not a word", message: "Please use only real words")
            return
        }
        
        usedWords.insert(answer, at: 0)
        score += answer.count
        newWord = ""
    }
    
    func startGame() {
        usedWords = []
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                //We now have the file loaded into a string
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement()?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "Silkworm"
                return
            }
        }
        fatalError("Could not load start.txt file from bundle")
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func usesRootWordLetters(word: String) -> Bool {
        var tempWord = rootWord.lowercased()
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


//Checking spelling:
/*let word = "swift"
let checker = UITextChecker()
let range = NSRange(location: 0, length: word.utf16.count)
let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
if misspelledRange.location == NSNotFound {
    //No spelling mistakes - good to go
}*/



//Accessing a file and processing the contents
/*var body: some View {
    if let fileURL = Bundle.main.url(forResource: "some-file", withExtension: "txt") {
        //We found the file in our bundle
        
        if let fileContents = try? String(contentsOf: fileURL) {
            //We now have the file loaded into a string
        }
    }
    
    let input = """
        a
        b
        c
    """
    let letters = input.components(separatedBy: "\n")
    let letter = letters.randomElement()
    let trimmed = letter?.trimmingCharacters(in: .whitespacesAndNewlines)
    return Text("Hello Verld!!")
}*/

//List from an array
/*struct ContentView: View {
    let people = ["Finn", "Leia", "Luke", "Rey"]
    var body: some View {
        List {
            Text("Static Row 1")
            ForEach(people, id: \.self) {
                Text($0)
            }
            Text("Static Row 2")
        }
    .listStyle(GroupedListStyle())
    }
}*/

//List(3)
/*List(0..<5) {   //Forms can't do this!
        Text("Dynamic row \($0)")
    }
.listStyle(GroupedListStyle())*/

//List(2)
/*struct ContentView: View {
    var body: some View {
        List {
            Section(header: Text("Section 1")) {
                Text("Static Row 1")
                Text("Static Row 2")
            }
            Section(header: Text("Section 2")) {
                ForEach(1..<6) {
                    Text("Dynamic row \($0)")
                }
            }
            Section(header: Text("Section 3")) {
                Text("Static Row 3")
                Text("Static Row 4")
            }
        }
    .listStyle(GroupedListStyle())
    }
}*/

//List(1)
/*
List {
     Text("Hello, World!")
     Text("Hello, World!")
     Text("Hello, World!")
}
*/
