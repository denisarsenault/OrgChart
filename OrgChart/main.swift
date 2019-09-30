//
//  main.swift
//  OrgChart
//
//  Created by Denis Arsenault on 9/29/19.
//  Copyright © 2019 mybrightzone. All rights reserved.
//

import Foundation

print("Hello, World!")

//
// Extensions to string
//

extension String
{
  func isAnagramOf(_ s: String) -> Bool {
    //1
    let lowerSelf = self.lowercased().replacingOccurrences(of: " ", with: "")
    let lowerOther = s.lowercased().replacingOccurrences(of: " ", with: "")
    //2
    return lowerSelf.sorted() == lowerOther.sorted()
  }
  
  func isPalindrome() -> Bool {
    //1
    let f = self.lowercased().replacingOccurrences(of: " ", with: "")
    //2
    let s = String(f.reversed())
    //3
    return  f == s
  }
}


enum OptionType: String
{
  case palindrome = "p"
  case anagram = "a"
  case help = "h"
  case quit = "q"
  case unknown
  
  init(value: String)
  {
    switch value
    {
    case "a": self = .anagram
    case "p": self = .palindrome
    case "h": self = .help
    case "q": self = .quit
    default: self = .unknown
    }
  }
}


enum OutputType
{
    case error
    case standard
}

class ConsoleIO
{
  func writeMessage(_ message: String, to: OutputType = .standard) {
    switch to
    {
    case .standard:
      // 1
      print("\u{001B}[;m\(message)")
    case .error:
      // 2
      fputs("\u{001B}[0;31m\(message)\n", stderr)
    }
  }
  
  func printUsage()
  {
    
    let executableName = (CommandLine.arguments[0] as NSString).lastPathComponent
    
    writeMessage("usage:")
    writeMessage("\(executableName) -a string1 string2")
    writeMessage("or")
    writeMessage("\(executableName) -p string")
    writeMessage("or")
    writeMessage("\(executableName) -h to show usage information")
    writeMessage("Type \(executableName) without an option to enter interactive mode.")
  }
  
  func getInput() -> String
  {
    // 1
    let keyboard = FileHandle.standardInput
    // 2
    let inputData = keyboard.availableData
    // 3
    let strData = String(data: inputData, encoding: String.Encoding.utf8)!
    // 4
    return strData.trimmingCharacters(in: CharacterSet.newlines)
  }
}

class Panagram
{
  
  let consoleIO = ConsoleIO()
  
  func staticMode()
  {
    let argCount = CommandLine.argc
    let argument = CommandLine.arguments[1]
    let (option, value) = getOption(argument.substring(from: argument.index(argument.startIndex, offsetBy: 1)))
    
    //1
    switch option
    {
    case .anagram:
      //2
      if argCount != 4
      {
        if argCount > 4
        {
          consoleIO.writeMessage("Too many arguments for option \(option.rawValue)", to: .error)
        } else
        {
          consoleIO.writeMessage("Too few arguments for option \(option.rawValue)", to: .error)
        }
        consoleIO.printUsage()
      } else
      {
        //3
        let first = CommandLine.arguments[2]
        let second = CommandLine.arguments[3]
        
        if first.isAnagramOf(second)
        {
          consoleIO.writeMessage("\(second) is an anagram of \(first)")
        } else
        {
          consoleIO.writeMessage("\(second) is not an anagram of \(first)")
        }
      }
    case .palindrome:
      //4
      if argCount != 3
      {
        if argCount > 3
        {
          consoleIO.writeMessage("Too many arguments for option \(option.rawValue)", to: .error)
        } else
        {
          consoleIO.writeMessage("Too few arguments for option \(option.rawValue)", to: .error)
        }
        consoleIO.printUsage()
      } else
      {
        //5
        let s = CommandLine.arguments[2]
        let isPalindrome = s.isPalindrome()
        consoleIO.writeMessage("\(s) is \(isPalindrome ? "" : "not ")a palindrome")
      }
    //6
    case .help:
      consoleIO.printUsage()
      
    case .unknown, .quit:
      //7
      consoleIO.writeMessage("Unknown option \(value)")
      consoleIO.printUsage()
    }
  }
  
  func getOption(_ option: String) -> (option:OptionType, value: String)
  {
    return (OptionType(value: option), option)
  }
  
  func interactiveMode()
  {
    //1
    consoleIO.writeMessage("Welcome to Panagram. This program checks if an input string is an anagram or palindrome.")
    //2
    var shouldQuit = false
    while !shouldQuit
    {
      //3
      consoleIO.writeMessage("Type 'a' to check for anagrams or 'p' for palindromes type 'q' to quit.")
      let (option, value) = getOption(consoleIO.getInput())
      
      switch option
      {
      case .anagram:
        //4
        consoleIO.writeMessage("Type the first string:")
        let first = consoleIO.getInput()
        consoleIO.writeMessage("Type the second string:")
        let second = consoleIO.getInput()
        
        //5
        if first.isAnagramOf(second)
        {
          consoleIO.writeMessage("\(second) is an anagram of \(first)")
        } else
        {
          consoleIO.writeMessage("\(second) is not an anagram of \(first)")
        }
      case .palindrome:
        consoleIO.writeMessage("Type a word or sentence:")
        let s = consoleIO.getInput()
        let isPalindrome = s.isPalindrome()
        consoleIO.writeMessage("\(s) is \(isPalindrome ? "" : "not ")a palindrome")
        
      case .quit:
        shouldQuit = true
        
      default:
        //6
        consoleIO.writeMessage("Unknown option \(value)", to: .error)
      }
    }
  }
}

//
// Accept Command Line Argument
//

let panagram = Panagram()
if CommandLine.argc < 2
{
  panagram.interactiveMode()
} else
{
  panagram.staticMode()
}
