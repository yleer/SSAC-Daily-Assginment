//
//  SettingViewController.swift
//  ShoppingChekcListAssignment
//
//  Created by Yundong Lee on 2021/11/04.
//

import UIKit
import MobileCoreServices
import Zip

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // 저장된 폴더 위치
    func getDoumentDirectoryPath() -> String? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let path = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let directoryPath = path.first{
            return directoryPath
        }else{
            return nil
        }
    }
    
    @IBAction func backUpButtonClicked(_ sender: UIButton) {
        var urlPaths: [URL] = []
        
        // 다큐먼트 디렉토리에서 백업하고 싶은 파일 존재 여부 확인.
        // 있으면 urlPaths에 파일의 url 추가하기.
        if let path = getDoumentDirectoryPath(){
            let realm = (path as NSString).appendingPathComponent("default.realm")
            
            if FileManager.default.fileExists(atPath: realm){
                urlPaths.append(URL(string: realm)!)
            }else{
                print("백업할 파일이 없습니다. ")
            }
        }
        
        // 배열에 대한 압축 파일 만들기.
        // 성공하면 압축파일을 공유 할 수 있는 뷰 컨 present.
        do{
            let zipFileUrl = try Zip.quickZipFiles(urlPaths, fileName: "archive")
            print("zipFileUrl: \(zipFileUrl)")
            presentActivityViewController()
        }catch{
            print("Error ouccred while zipping.")
        }
    }
    
    
    @IBAction func shareButtonClicked(_ sender: UIButton) {
        presentActivityViewController()
    }
    
    
    
    @IBAction func restoreButtonClicked(_ sender: UIButton) {
        // 복구 1. 파일 앱 열기
        let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeArchive as String], in: .import)
        
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    
    // 7 공유
    func presentActivityViewController() {
        // 압축 파일 경로 가져오기
        let zipFileUrlString = (getDoumentDirectoryPath()! as NSString).appendingPathComponent("archive.zip")
        let zipFileUrl = URL(fileURLWithPath: zipFileUrlString)
         
        
        // activityItems는 공유 화면에서 공유할 아이템들 (Any 타입의 배열임. 아무거나 공유 가능하기 때문.)
        let vc = UIActivityViewController(activityItems: [zipFileUrl], applicationActivities: [])
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
}


extension SettingViewController: UIDocumentPickerDelegate{
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        // 선택한 파일의 url 가져오기
        guard let zipFileUrl = urls.first else { return }

        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let sandBoxFileUrl = directory.appendingPathComponent(zipFileUrl.lastPathComponent)

        
        if FileManager.default.fileExists(atPath: sandBoxFileUrl.path){
            do{
                let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileUrl = documentDirectory.appendingPathComponent("archive.zip")
                try Zip.unzipFile(fileUrl, destination: documentDirectory, overwrite: true, password: nil, progress: { progress in
                    print(progress)
                }, fileOutputHandler: { unzippedFile in
                    print(unzippedFile)
                })
            }catch{
                print("not good ")
            }
        }else{
            do{
                try FileManager.default.copyItem(at: zipFileUrl, to: sandBoxFileUrl)
                let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileUrl = documentDirectory.appendingPathComponent("archive.zip")
                try Zip.unzipFile(fileUrl, destination: documentDirectory, overwrite: true, password: nil, progress: { progress in
                    print(progress)
                }, fileOutputHandler: { unzippedFile in
                    print(unzippedFile)
                })
            }catch{
                print("error")
            }
        }

        
        
        let alerVc = UIAlertController(title: "완료 되었습니다.", message: "어플을 재실행 해주세요.", preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "확인.", style: .default, handler: nil)
        
        alerVc.addAction(okButton)
        
        self.present(alerVc, animated: true, completion: nil)
        
    }
    
}

