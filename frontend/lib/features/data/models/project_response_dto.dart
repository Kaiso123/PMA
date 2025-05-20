class ProjectResponseDto {
  final int errorCode;
  final String errorMessage;
  final dynamic data;

  ProjectResponseDto({
    required this.errorCode,
    required this.errorMessage,
    required this.data,
  });

  factory ProjectResponseDto.fromJson(Map<String, dynamic> json) {
    return ProjectResponseDto(
      errorCode: json['errorCode'] as int,
      errorMessage: json['errorMessage'] as String,
      data: json['data'],
    );
  }
}