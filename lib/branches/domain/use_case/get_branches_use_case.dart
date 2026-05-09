import 'package:keopi/branches/data/repository/branch_repository.dart';
import 'package:keopi/branches/domain/entity/branch.dart';

class GetBranchesUseCase {
  final _branchRepository = BranchRepository();

  Future<List<Branch>> call() async {
    return await _branchRepository.getBranches();
  }
}
