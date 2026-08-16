import AppIntents
import Foundation

/// Errors thrown from `LogTransactionIntent.perform()` that are surfaced to
/// Shortcuts/Wallet automation banners and (via `TransactionLogNotifier`) to
/// local notifications when the silent flow fails.
enum LogTransactionError: Error, LocalizedError, CustomLocalizedStringResourceConvertible {
    case noBudgetLoaded
    case noAccountSelected
    case accountUnavailable
    case invalidAmount(received: String)
    case noAmountReceived
    case writeFailed(underlying: String)

    var errorDescription: String? {
        switch self {
        case .noBudgetLoaded:
            return String(localized: "Open Actuali and select a budget first.")
        case .noAccountSelected:
            return String(localized: "Select an account in your shortcut or set a default account in Actuali settings.")
        case .accountUnavailable:
            return String(localized: "Account is no longer available. Edit your shortcut to pick a different account.")
        case .invalidAmount(let received):
            // Show what the automation actually delivered: issue #41 failures
            // hinge on whether iOS passed the real text or a coerced "0".
            let shown = received.trimmingCharacters(in: .whitespacesAndNewlines).prefix(40)
            return String(
                format: String(localized: "Amount must be greater than 0 (received \"%@\")."),
                String(shown)
            )
        case .noAmountReceived:
            return String(localized: "No amount was received from the automation. iOS sometimes runs Wallet automations before the transaction details are available.")
        case .writeFailed(let underlying):
            return String(
                format: String(localized: "Couldn't save transaction. Tap to retry. (%@)"),
                String(describing: underlying)
            )
        }
    }

    var localizedStringResource: LocalizedStringResource {
        LocalizedStringResource(stringLiteral: errorDescription ?? "Unknown error")
    }
}

enum GetBalanceError: Error, LocalizedError, CustomLocalizedStringResourceConvertible {
    case accountNotFound
    case categoryNotFound
    case noBudgetLoaded
    case noAccountSelected

    var errorDescription: String? {
        switch self {
        case .accountNotFound:
            return String(localized: "Account was not found. Select a valid account in your shortcut.")
        case .categoryNotFound:
            return String(localized: "Category was not found in the current budget month.")
        case .noBudgetLoaded:
            return String(localized: "Open Actuali and select a budget first.")
        case .noAccountSelected:
            return String(localized: "Select an account in your shortcut or set a default account in Actuali settings.")
        }
    }

    var localizedStringResource: LocalizedStringResource {
        LocalizedStringResource(stringLiteral: errorDescription ?? "Unknown error")
    }
}
