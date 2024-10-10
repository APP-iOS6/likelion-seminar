//
//  ConnectFirebase.swift
//  SeminarConsumer
//
//  Created by 이소영 on 10/8/24.
//
import Foundation
import FirebaseCore
import FirebaseFirestore
import Observation

@Observable
class ConnectFirebase {
    private let db = Firestore.firestore()
    var seminars: [Seminar] = []
    
    init() {
        Task {
            self.seminars = try await getSeminars()
        }
    }
    
    // User 컬렉션에 비회원 유저정보가 있는지 여부, 있다면 id 스트링 값을 반환
    func isExistUser(_ user: User) async throws -> (Bool, String) {
        var id = ""
        
        do {
            let datas = try await db.collection("User").getDocuments().documents
            
            for data in datas {
                let testData = data.data()
                
                if testData["name"] as? String == user.name && testData["email"] as! String == user.email {
                    id = data.documentID
                    return (true, id)
                }
            }
        } catch {
            print("isExistUser fail \(error.localizedDescription)")
        }
        return (false, id)
    }
    
    // Seminar 컬렉션에 있는 세미나 목록을 반환
    func getSeminars() async throws -> [Seminar] {
        do {
            let documents = try await db.collection("Seminar").getDocuments().documents
            let data = try documents.compactMap { snapshot in
                try snapshot.data(as: Seminar.self)
            }
            return data
        } catch {
            print("failed to get seminar \(error.localizedDescription)")
        }
        return []
    }
    
    // 비회원이 신청한 세미나 목록을 반환
    func getUserSeminars(_ user: User) async throws -> [Seminar] {
        var userSeminars: [Seminar] = []
        do {
            let (isExist, documentID) = try await isExistUser(user)
            
            if isExist {
                let data = try await db.collection("User").document(documentID).getDocument().data()
                
                if let seminarReferences = data?["seminars"] as? [DocumentReference] {
                    userSeminars = try await referencesToSeminars(seminarReferences)
                }
                return userSeminars
            }
        } catch {
            print("failed to get user seminar \(error.localizedDescription)")
        }
        return userSeminars
    }
    
    // 회원이 신청한 세미나 목록을 반환
    func getAuthSeminars(_ documentID: String) async throws -> [Seminar] {
        var userSeminars: [Seminar] = []
        do {
            let data = try await db.collection("User").document(documentID).getDocument().data()
            
            if let seminarReferences = data?["seminars"] as? [DocumentReference] {
                userSeminars = try await referencesToSeminars(seminarReferences)
            }
            return userSeminars
        } catch {
            print("failed to get auth seminars \(error.localizedDescription)")
        }
        return userSeminars
    }
    
    // Seminar 컬렉션에 있는 레퍼런스를 이용해 세미나 목록을 반환 -> 유저가 신청한 세미나 목록을 확인하기 위한 작업
    func referencesToSeminars(_ references: [DocumentReference]) async throws -> [Seminar] {
        var userSeminars: [Seminar] = []
        do {
            for reference in references {
//                let seminar = try await reference.getDocument().data(as: Seminar.self)
//                    userSeminars.append(seminar)
                let seminar = try await reference.getDocument().data()
                let id = try await reference.getDocument().documentID
                
                if let name = seminar?["name"] as? String{
                    let startDateForSeminar = seminar?["startDateForSeminar"] as? Date ?? .now
                    let endDateForSeminar = seminar?["endDateForSeminar"] as? Date ?? .now
                    let startDateForApply = seminar?["startDateForApply"] as? Date ?? .now
                    let endDateForApply = seminar?["endDateForApply"] as? Date ?? .now
                    let content = seminar?["content"] as? String ?? ""
                    let location = seminar?["location"] as? String ?? ""
                    let capacity = seminar?["capacity"] as? Int ?? 0
                    let participants = seminar?["participants"] as? Int ?? 0
                    let image = seminar?["image"] as? String ?? ""
                    let category = seminar?["category"] as? String ?? ""
                    
                    userSeminars.append(Seminar(id: id, name: name, startDateForSeminar: startDateForSeminar, endDateForSeminar: endDateForSeminar, startDateForApply: startDateForApply, endDateForApply: endDateForApply, content: content, location: location, capacity: capacity, participants: participants, image: image, category: category))
                }else{
                    continue
                }
            }
            print(userSeminars)
            return userSeminars
        } catch {
            print("에러!!!!!!!!!!!")
            print("referencesToSeminars fail \(error.localizedDescription)")
        }
        return userSeminars
    }
    
    // 세미나 신청하기
    func applyForNewSeminar(_ seminar: Seminar, user: User) async throws -> Bool{
        do {
            let (isExist, documentID) = try await isExistUser(user)
            let seminarRef = db.collection("Seminar").document(seminar.id)
            
            if !isExist {
                try await uploadUser(user)
                try await updateUserSeminar(user.id, seminarRef: seminarRef)
            } else {
                try await updateUserSeminar(documentID, seminarRef: seminarRef)
            }
            try await uploadUserToSeminar(seminar, user: user)
            return true
        } catch {
            print("upload user fail : \(error.localizedDescription)")
            return false
        }
    }

    // 신규 유저 업로드
    func uploadUser(_ user: User) async throws {
        do {
            try await db.collection("User").document(user.id).setData([
                "name": "\(user.name)",
                "email": "\(user.email)",
                "phone": "\(user.phone)",
                "ticketCount": "\(user.ticketCount)",
                "seminars": []
            ])
            print("upload user success")
        } catch {
            print("upload user fail : \(error.localizedDescription)")
        }
    }
    
    // 세미나에 유저 신청 정보 업로드
    func uploadUserToSeminar(_ seminar: Seminar, user: User) async throws {
        do {
            try db.collection("Seminar").document(seminar.id).collection("Participant").document(user.id).setData(from: user) { _ in
                print("upload user to seminar collection success")
            }
        } catch {
            print("upload user to seminar collection fail : \(error.localizedDescription)")
        }
    }
    
    // 유저가 새로 신청한 세미나를 목록에 추가
    func updateUserSeminar(_ documentID: String, seminarRef: DocumentReference) async throws {
        do {
            try await db.collection("User").document(documentID).updateData(["seminars": FieldValue.arrayUnion([seminarRef])])
            print("update user seminar success")
        } catch {
            print("update user seminar fail : \(error.localizedDescription)")
        }
    }
    
    
}
