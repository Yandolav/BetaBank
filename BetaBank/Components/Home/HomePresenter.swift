protocol HomePresenterInput: AnyObject {
    func presentData(response: Home.LoadData.Response)
}

typealias HomePresenterOutput = HomeViewControllerInput

final class HomePresenter {

    // MARK: Public properties

    weak var viewController: HomePresenterOutput?
}

// MARK: - HomePresenterInput

extension HomePresenter: HomePresenterInput {
    func presentData(response: Home.LoadData.Response) {
        switch response.result {
        case .success(let data):
            let cardViewModels = data.cards.map { makeCardViewModel($0) }
            let transactionViewModels = data.transactions.map { makeTransactionViewModel($0) }

            if cardViewModels.isEmpty && transactionViewModels.isEmpty {
                viewController?.displayData(viewModel: .init(state: .empty))
                return
            }

            viewController?.displayData(
                viewModel: .init(
                    state: .content(
                        user: data.user,
                        cards: cardViewModels,
                        transactions: transactionViewModels
                    )
                )
            )

        case .failure(let error):
            viewController?.displayData(
                viewModel: .init(state: .error(message: error.localizedDescription))
            )
        }
    }
}

// MARK: - Private mapping

private extension HomePresenter {
    func makeCardViewModel(_ card: Card) -> CardCellViewModel {
        CardCellViewModel(
            id: card.id,
            balance: card.balance,
            number: card.number,
            userFullName: card.userFullName,
            validatePeriod: card.validatePeriod,
            bankName: card.bankName,
            code: card.code
        )
    }

    func makeTransactionViewModel(_ transaction: Transaction) -> TransactionCellViewModel {
        TransactionCellViewModel(
            id: transaction.id,
            date: transaction.date,
            amountMinor: transaction.amountMinor,
            direction: transaction.direction,
            status: transaction.status,
            comment: transaction.comment
        )
    }
}
