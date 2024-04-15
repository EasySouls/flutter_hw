// final RegExp emailValidationRegex = RegExp(r"^[\w-\.]+@(\w-]+\.)+[\w-]{2,4}$");
final RegExp emailValidationRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

final RegExp passwordValidationRegex =
    RegExp(r"^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$");

// Haven't tested yet, not sure if works
final RegExp nameValidationRegex = RegExp(r"/^[a-z ,.'-]+$/i");
