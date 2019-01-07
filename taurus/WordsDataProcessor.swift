import Foundation

class WordsDataProcessor {
    static func mapJsonToWords(object: [String: AnyObject], wordsKey: String) -> [Word] {
        var mappedWords: [Word] = []
        guard let words = object[wordsKey] as? [[String: AnyObject]] else {
            return mappedWords
        }

        for word in words {
            guard let id = word["id"] as? Int64,
                  let value = word["value"] as? String
                    else {
                continue
            }

            let wordClass = Word(id: id, value: value)
            mappedWords.append(wordClass)
        }
        return mappedWords
    }
}
