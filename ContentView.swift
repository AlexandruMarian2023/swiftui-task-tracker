
import SwiftUI

struct TaskItem: Identifiable {
    let id: Int
    var title: String
    var isCompleted: Bool = false
}

struct ContentView: View {

    @State private var newTaskTitle = ""
    @State private var nextTaskID = 4

    @State private var tasks = [
        TaskItem(id: 1, title: "Learn Swift"),
        TaskItem(id: 2, title: "Learn SwiftUI"),
        TaskItem(id: 3, title: "Build my first app")
    ]

    // Count completed tasks
    private var completedCount: Int {
        tasks.filter { $0.isCompleted }.count
    }

    // Add a new task
    private func addTask() {
        let title = newTaskTitle.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !title.isEmpty else {
            return
        }

        tasks.append(
            TaskItem(id: nextTaskID, title: title)
        )

        nextTaskID += 1
        newTaskTitle = ""
    }

    // Delete one task
    private func deleteTask(id: Int) {
        if let index = tasks.firstIndex(where: {
            $0.id == id
        }) {
            tasks.remove(at: index)
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 15) {

                HStack {
                    TextField(
                        "Enter a new task",
                        text: $newTaskTitle
                    )
                    .textFieldStyle(.roundedBorder)

                    Button("Add") {
                        addTask()
                    }
                    .disabled(
                        newTaskTitle.trimmingCharacters(
                            in: .whitespacesAndNewlines
                        ).isEmpty
                    )
                }
                .padding(.horizontal)

                Text(
                    "\(completedCount) of \(tasks.count) tasks completed"
                )
                .font(.subheadline)
                .foregroundColor(.secondary)

                if tasks.isEmpty {
                    Text("No tasks yet. Add your first task!")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    List {
                        ForEach($tasks) { $task in
                            HStack {
                                Toggle(
                                    isOn: $task.isCompleted
                                ) {
                                    Text(task.title)
                                        .strikethrough(task.isCompleted)
                                }

                                Button("Delete") {
                                    deleteTask(id: task.id)
                                }
                                .foregroundColor(.red)
                            }
                        }
                    }
                    .listStyle(.plain)
                }

                Spacer(minLength: 0)
            }
            .navigationTitle("My Tasks")
        }
    }
}
