import SwiftUI



struct StatusSelectionView: View {
    @Binding var selectedStatus: TaskStatus
    @State private var showPicker = false
    
    var body: some View {
        Button {
            showPicker = true
        } label: {
            HStack {
                Image(systemName: selectedStatus.icon)
                    .foregroundColor(selectedStatus.color)
                Text(selectedStatus.rawValue)
                Spacer()
                Image(systemName: "chevron.down")
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
        }
        .foregroundColor(.primary)
        .confirmationDialog("Select Status", isPresented: $showPicker) {
            ForEach(TaskStatus.allCases, id: \.self) { status in
                Button {
                    selectedStatus = status
                } label: {
                    Text(status.rawValue)
                }
            }
        } message: {
            Text("Choose a status")
        }
    }
}
