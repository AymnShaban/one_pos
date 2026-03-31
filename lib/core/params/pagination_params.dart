import 'package:equatable/equatable.dart';

class PaginationParams extends Equatable {
  final int page;
  final int limit;

  const PaginationParams({required this.page, this.limit = 15});

  @override
  List<Object?> get props => [page, limit];

  Map<String, dynamic> toJson() {
    return {'pageNumber': page, 'pageSize': limit};
  }
}
