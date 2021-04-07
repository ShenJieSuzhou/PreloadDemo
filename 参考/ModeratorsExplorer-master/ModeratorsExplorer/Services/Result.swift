
import Foundation

enum Result<T, U: Error> {
  case success(T)
  case failure(U)
}
