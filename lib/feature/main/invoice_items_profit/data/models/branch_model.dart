class BranchModel {
  final int id;
  final String name;
  final bool isSelected;

  const BranchModel({
    required this.id,
    required this.name,
    this.isSelected = false,
  });

  BranchModel copyWith({bool? isSelected}) {
    return BranchModel(
      id: id,
      name: name,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
