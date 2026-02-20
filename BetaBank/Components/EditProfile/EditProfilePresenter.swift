protocol EditProfilePresenterInput: AnyObject {
    func presentUser(response: EditProfile.LoadData.Response)
    func presentStartEdit(response: EditProfile.StartEditProfile.Response)
    func presentNewUser(response: EditProfile.SaveNewData.Response)
}

typealias EditProfilePresenterOutput = EditProfileViewControllerInput

final class EditProfilePresenter {

    // MARK: Public properties

    weak var viewController: EditProfilePresenterOutput?
}

// MARK: - EditProfileInteractorInput

extension EditProfilePresenter: EditProfilePresenterInput {
    func presentUser(response: EditProfile.LoadData.Response) {
        // code
    }
    
    func presentStartEdit(response: EditProfile.StartEditProfile.Response) {
        // code
    }
    
    func presentNewUser(response: EditProfile.SaveNewData.Response) {
        // code
    }
}
