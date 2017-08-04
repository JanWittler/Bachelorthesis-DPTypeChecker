//
//  main.swift
//  BNFC_cToSwift
//
//  Created by Jan Wittler on 04.06.17.
//  Copyright © 2017 Jan Wittler. All rights reserved.
//

import Foundation

guard CommandLine.argc > 1 else {
    print("missing argument")
    exit(1)
}

let fileName = CommandLine.arguments[1]
print("Parsing \(URL(string: fileName)?.lastPathComponent ?? fileName)")
guard let parseTree = parseFile(at: fileName) else {
    print("could not parse file at path '\(fileName)'")
    exit(1)
}

print("Parse successful!")
print("\n[Abstract Syntax]")
print(parseTree.show())

do {
    try typeCheck(parseTree)
    print("\nType-check successful!")
}
catch let error as TypeCheckerError {
    print("\nType-check failed with error:\n\(error)")
    exit(1)
}
