class Response<T extends dynamic> {
  final T data;

  Response({required this.data});

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      data: json['data'],
    );
  }
}
