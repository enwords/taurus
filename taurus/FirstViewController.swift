import UIKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var getWordsResults: [Word] = []

    @IBOutlet var mainTableView: UITableView!

    @IBAction func didTapExerciseButton(sender: UIButton!) {
        createExercise()
    }

    override func viewWillAppear(_ animated: Bool) {
        mainTableView.reloadData()
        super.viewWillAppear(animated)
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
        let wordCell = tableView.dequeueReusableCell(withIdentifier: "WordCell", for: indexPath) as! CustomTableViewCell
        let idx: Int = indexPath.row
        let word = getWordsResults[idx]
        wordCell.wordId?.text = String(word.id)
        wordCell.wordValue?.text = word.value

        return wordCell
    }

    func getWords(status: String) {
        let url = URL(string: "https://enwords.tk/api/mobile/words?status=\(status)")
        try! HTTPHandler.get(url: url!, completionHandler: wordsCompletion)
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

    func createExercise() {
        let url = URL(string: "https://enwords.tk/api/mobile/trainings")
        let words = self.getWordsResults
        var word_ids: [Int64] = []
        for word in words {
            word_ids.append(word.id)
        }

        try! HTTPHandler.post(
                url: url!,
                body: ["word_ids": word_ids, "training_type": "repeating"],
                completionHandler: createExerciseCompletion
        )
    }

    func createExerciseCompletion(data: Data?) -> Void {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SecondView") as! SecondViewController
        self.present(nextViewController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
}
