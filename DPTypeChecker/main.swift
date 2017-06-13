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

guard let parseTree = parseFile(at: CommandLine.arguments[1]) else {
    print("could not parse file at path '\(CommandLine.arguments[1])'")
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
