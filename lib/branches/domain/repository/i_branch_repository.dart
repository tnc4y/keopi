import 'package:keopi/branches/domain/entity/branch.dart';

abstract class IBranchRepository {
  Future<List<Branch>> getBranches();
}
