class ApiErrorMessage {
  static String translateStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad Request -- Your request sucks';
      case 401:
        return 'Unauthenticated -- Invalid credentials';
      case 403:
        return 'Forbidden -- You do not have permission to access the requested resource';
      case 404:
        return 'Not Found -- The specified resource could not be found';
      case 405:
        return 'Method Not Allowed -- You tried to access an endpoint with an invalid method';
      case 422:
        return 'Validation Error -- The given data was invalid';
      case 429:
        return 'Too Many Requests -- You\'re sending too many requests or have reached your limit for new aliases';
      case 500:
        return 'Internal Server Error -- We had a problem with our server. Try again later';
      case 503:
        return 'Service Unavailable -- We\'re temporarily offline for maintenance. Please try again later';
      default:
        return 'Server returned an error we can\'t understand ';
    }
  }
}
