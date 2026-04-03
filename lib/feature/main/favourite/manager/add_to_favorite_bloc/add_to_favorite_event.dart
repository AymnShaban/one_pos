part of '../../favorite_imports.dart';

abstract class FavoriteEvent {}

class AddFavorite extends FavoriteEvent {
  final AddAndDeleteFavoriteRequest request;

  AddFavorite(this.request);
}
class DeleteFavorite extends FavoriteEvent {
  final AddAndDeleteFavoriteRequest request;

  DeleteFavorite(this.request);
}

class GetFavorite extends FavoriteEvent {
  final String customerPhone;

  GetFavorite(this.customerPhone);
}
class ResetFavoriteState extends FavoriteEvent {}