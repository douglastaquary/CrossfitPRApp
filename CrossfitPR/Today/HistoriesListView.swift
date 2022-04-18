//
//  PRHistoriesListView.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 29/03/22.
//

import SwiftUI
import Combine
import CoreData


typealias AppStore = Store<AppState, AppAction, AppDependencies>

struct HistoriesListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: PR.entity(), sortDescriptors: [], predicate: NSPredicate(format: "prName != %@", PRType.empty.rawValue))
    
    var prs: FetchedResults<PR>
    
    @StateObject private var viewModel = HistoryViewModel()
    @EnvironmentObject var viewlaunch: ViewLaunch
    @EnvironmentObject var store: TodosStore
   
    @State var showNewPRView = false
    @State private var draft: String = ""

    var body: some View {
        NavigationView {
            ScrollViewReader { scrollView in
                ScrollView {
                    ForEach(prs, id: \.id) { pr in
                        NavigationLink(destination: NewPRRecordView()) {
                            PRView(record: pr)
                        }
                    }
                    .onDelete(perform: delete)
                    .onMove(perform: move)
                    .redacted(reason: viewModel.isLoading ? .placeholder : [])
                    Button(action: {
                        self.showNewPRView.toggle()
                    }){
                    Text("Novo PR")
                        .foregroundColor(.white)
                        .font(.headline)
                        .frame(width: 350, height: 48)
                        .background(Color.green)
                        .cornerRadius(8)
                        .padding(.top, 12)
                    }
                    .sheet(isPresented: $showNewPRView) {
                        NewPRRecordView()
                    }
                }
                //.padding(.top, 36)
            }
            .onAppear {
                self.viewModel.fetch()
            }
        }
    }
    
    private func delete(_ indexes: IndexSet) {
        store.todos.remove(atOffsets: indexes)
    }

    private func move(_ indexes: IndexSet, to offset: Int) {
        store.todos.move(fromOffsets: indexes, toOffset: offset)
    }
    
    private func addTodo() {
        let newTodo = Todo(title: draft, date: Date(), isDone: false, priority: 0)
        store.todos.insert(newTodo, at: 0)
        draft = ""
    }
}

struct PRHistoriesListView_Previews: PreviewProvider {
    static var previews: some View {
        HistoriesListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}


struct Todo: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var date: Date
    var isDone: Bool
    var priority: Int
}

final class TodosStore: ObservableObject {
    @Published var todos: [Todo] = []

    func orderByDate() {
        todos.sort { $0.date < $1.date }
    }

    func orderByPriority() {
        todos.sort { $0.priority > $1.priority }
    }

    func removeCompleted() {
        todos.removeAll { $0.isDone }
    }
}


struct TodoItemView: View {
    let todo: Binding<Todo>

    var body: some View {
        HStack {
            Toggle(isOn: todo.isDone) {
                Text(todo.title.wrappedValue)
                    .strikethrough(todo.isDone.wrappedValue)
            }
        }
    }
}

struct TodoItemView_Previews: PreviewProvider {
    static var previews: some View {
        TodoItemView(todo: .constant(Todo(title: "task", date: .now, isDone: false, priority: 0)))
    }
}

struct PRView: View {
    var record: PR
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(record.prName)
                .font(.headline)
                .foregroundColor(.primary)
            Spacer()
            Text(String(format: "%.1f lb", "\(record.recordValue)"))
                .font(.subheadline)
                .foregroundColor(.secondary)
            Divider()
        }
        .padding(.leading, 16)
    }
}
