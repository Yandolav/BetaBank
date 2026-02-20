protocol EditProfileInteractorInput: AnyObject {
    func loadData(request: EditProfile.LoadData.Request)
    func startEdit(request: EditProfile.StartEditProfile.Request)
    func saveNewUser(request: EditProfile.SaveNewData.Request)
}

typealias EditProfileInteractorOutput = EditProfilePresenterInput

final class EditProfileInteractor {

    // MARK: Private properties

    private let provider: EditProfileProviderProtocol

    // MARK: Public properties

    var presenter: EditProfileInteractorOutput?

    // MARK: Init

    init(provider: EditProfileProviderProtocol) {
        self.provider = provider
    }
}

// MARK: - EditProfileInteractorInput

extension EditProfileInteractor: EditProfileInteractorInput {
    func loadData(request: EditProfile.LoadData.Request) {
        // code
    }
    
    func startEdit(request: EditProfile.StartEditProfile.Request) {
        // code
    }
    
    func saveNewUser(request: EditProfile.SaveNewData.Request) {
        // code
    }
}

