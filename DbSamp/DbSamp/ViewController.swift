
import UIKit
import CoreData

class ViewController: UIViewController {
    
    
    @IBOutlet weak var listTableView: UITableView!
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var ageField: UITextField!
    
    @IBAction func input(_ sender: Any) {
        
        guard let name = nameField.text, name.count > 0 else {
            return
        }
        
        guard let ageText = ageField.text, ageText.count > 0, let age = Int(ageText) else {
            return
        }
        
        // Core data에 접근하려면 반드시 Context의 도움을 받아야함
        // -> Appdelegate의 persistentContainer의 도움을 받아서 가져옴
        // UIApplication.shared의 delegate를 타입 캐스팅해준다
        // 그리고 persistentContainer에 내장된 context를 이용
        // 늘 저장되도록 요청
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let ctx = appDelegate.persistentContainer.viewContext
        
        // PersonEntity는 자동으로 model에서 생성된 class
        // NSEntityDescription을 쓰기위해 CoreData를 import해준다(UIKit에 없음)
        // 그냥 생성해도 되지만 생성자가 까다로워서 NSEntityDescription을 쓴다
        // 하지만 그렇게 되면 NSManagedObject이므로 PersonEntity가 되기 위해서 타입 캐스팅해준다
        let newPerson = NSEntityDescription.insertNewObject(forEntityName: "Person", into: ctx) as! PersonEntity
        // 이렇게 하면 ctx(Context)에는 저장된다. 하지만 영구히 저장된건 아님. 메모리에는 저장되어있음.
        newPerson.name = name
        newPerson.age = Int16(age)
        
        // Context가 영구히 파일로 저장되도록 요청한다
        do {
            // throws가 붙어있으면 try로 감싸준다
            try ctx.save()
        } catch {
            print(error)
        }
        
        nameField.text = ""
        ageField.text = ""
        reloadData()
        
    }
    
    
    // 읽어들인 자료를 임시로 저장할 배열
    var list = [PersonEntity]()
    
    
    // reloadData 함수 만들어줌
    func reloadData() {
        // Core Data에 저장된 데이터를 읽어올때는 NSFetchRequest를 만든다 -> 가져오기 요청
        // Generic?으로 클래스이름도 지정해준다
        // 그런데 읽어들일 때 정렬된 데이타가 아님.
        let request = NSFetchRequest<PersonEntity>(entityName: "Person")
        
        // 받은 배열을 정렬할 것임
        // ascending : 오름차순
        // 나이가 만약 똑같으면? -> 미정
        let sortByAge = NSSortDescriptor(key: "age", ascending: true)
        let sortByName = NSSortDescriptor(key: "name", ascending: true)
        // 나이로 먼저 정렬 -> 이름으로 정렬
        request.sortDescriptors = [sortByAge, sortByName]
        
        // 다시 context의 도움을 받기위해...
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let ctx = appDelegate.persistentContainer.viewContext
        // try 뒤에 물음표를 붙이면 do~catch문 안써도 됨
        // try? -> 정상적으로 실행되면 오케이, 안되면 nil이 리턴됨
        if let list = try? ctx.fetch(request) {
            // DB에서 가져올 리스트를 붙여준다
            self.list = list
        }
        
        listTableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadData()
    }
    

}



extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        let target = list[indexPath.row]
        cell.textLabel?.text = target.name
        cell.detailTextLabel?.text = "\(target.age)"
        
        return cell
    }
    
    
}
































