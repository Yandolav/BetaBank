import Foundation

protocol HomePresenterInput: AnyObject {
    func presentData(response: Home.LoadData.Response)
}

typealias HomePresenterOutput = HomeViewControllerInput

final class HomePresenter {

    // MARK: Public properties

    weak var viewController: HomePresenterOutput?

    // MARK: Private methods

    private func directionTitle(_ direction: Transaction.Direction) -> String {
        switch direction {
        case .credit: return "Входящий перевод"
        case .debit: return "Исходящий перевод"
        }
    }

    private func formatBalance(_ minor: Int) -> String {
        let major = Double(minor) / 100.0
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = "."
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        let formatted = formatter.string(from: NSNumber(value: major)) ?? "\(major)"
        return "\(formatted) ₽"
    }

    private func formatCardNumber(_ number: String) -> String {
        let digits = number.filter { $0.isNumber }
        guard digits.count >= 8 else { return number }
        let first4 = String(digits.prefix(4))
        let last4 = String(digits.suffix(4))
        return "\(first4)  ••••  ••••  \(last4)"
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yy"
        return formatter.string(from: date)
    }

    private func formatSectionDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: date)
    }

    private func formatTransactionDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM, HH:mm"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: date)
    }

    private func formatAmount(_ minor: Int, direction: Transaction.Direction) -> String {
        let major = Double(minor) / 100.0
        let sign = direction == .credit ? "+" : "-"
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = "."
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        let formatted = formatter.string(from: NSNumber(value: major)) ?? "\(major)"
        return "\(sign)\(formatted) ₽"
    }
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
            holderName: card.userFullName,
            bankName: card.bankName.uppercased(),
            cardNumber: formatCardNumber(card.number),
            balance: formatBalance(card.balance),
            validatePeriod: formatDate(card.validatePeriod)
        )
    }

    func makeTransactionViewModel(_ transaction: Transaction) -> TransactionCellViewModel {
        TransactionCellViewModel(
            id: transaction.id,
            date: formatTransactionDate(transaction.date),
            sectionDate: formatSectionDate(transaction.date),
            amount: formatAmount(transaction.amountMinor, direction: transaction.direction),
            direction: transaction.direction,
            status: transaction.status,
            comment: transaction.comment ?? directionTitle(transaction.direction)
        )
    }
}
