import UIKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var getWordsResults: [Word] = []

    @IBOutlet var mainTableView: UITableView!

    override func viewWillAppear(_ animated: Bool) {
        mainTableView.reloadData()
        super.viewWillAppear(animated)
//        getWordsResults.append(Word(id: 1, value: "Batman"))
        print("Opening words")
        getWords(status: "learning")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getWordsResults.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Words"
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let wordCell = tableView.dequeueReusableCell(withIdentifier: "customcell", for: indexPath) as! CustomTableViewCell
        let idx: Int = indexPath.row
        let word = getWordsResults[idx]
        wordCell.wordId?.text = String(word.id)
        wordCell.wordValue?.text = word.value

        return wordCell
    }

    func getWords(status: String) {
        let url = "https://enwords.tk/api/mobile/words?status=\(status)"
        HTTPHandler.getJson(urlString: url, completionHandler: wordsCompletion)
    }

    func wordsCompletion(data: Data?) -> Void {
        if let data = data {
            let object = JSONParser.parse(data: data)
            if let object = object {
                self.getWordsResults = WordsDataProcessor.mapJsonToWords(object: object, wordsKey: "collection")
                DispatchQueue.main.async {
                    self.mainTableView.reloadData()
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
}
