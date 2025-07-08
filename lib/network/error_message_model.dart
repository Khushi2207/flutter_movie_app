import 'package:equatable/equatable.dart';

class ErrorMessageModel extends Equatable {
  final String statusCode;
  final String statusMessage;

  const ErrorMessageModel({
    required this.statusCode,
    required this.statusMessage,
  });

  factory ErrorMessageModel.fromJson(Map<String, dynamic> json) {
    return ErrorMessageModel(
      statusCode: json["status"],
      statusMessage: json["message"],
    );
  }

  @override
  List<Object?> get props => [
        statusCode,
        statusMessage,
      ];
}
