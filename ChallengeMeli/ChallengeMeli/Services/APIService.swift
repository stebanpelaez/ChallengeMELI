//
//  ApiSearch.swift
//  Test ML
//
//  Created by Juan Esteban Pelaez on 15/11/21.
//
import Foundation

protocol APIServiceProtocol: AnyObject {
    func getService<T: Codable>(url: String, type: T.Type, completion: @escaping (Result<T, Error>) -> Void)
}

class APIService: APIServiceProtocol {

    static let shared = APIService()

    private let session: URLSession

    // By using a default argument (in this case .shared) we can add dependency
    // injection without making our app code more complicated.
    init(session: URLSession = .shared) {
        self.session = session
    }

    // Se creo en la api este unico metodo Generico para el methodo Http get.
    func getService<T: Codable>(url: String, type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {

        guard let searchUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: searchUrl) else {
            completion(.failure(APIError.invalidURL))
            return
        }

        let task = self.session.dataTask(with: url) { data, response, error in

            // Se verifica que el objeto recibido no sea nil
            guard let data = data else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }

            // Se obtiene el codigo de respuesta de la solicitud
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                completion(.failure(APIError.unexpectedResponse))
                return
            }

            // Se valida que el codigo de respuesta http este entre 200 y 299
            guard HTTPCodes.success.contains(statusCode) else {
                completion(.failure(APIError.httpCode(statusCode)))
                return
            }

            do {
                // Mapear el JSON recibido y transformarlo a nuestro modelo requerido
                let model = try JSONDecoder().decode(T.self, from: data)
                completion(.success(model))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }

}
