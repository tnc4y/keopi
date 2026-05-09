import 'package:keopi/recommendation/domain/entity/recommendation.dart';

abstract class IRecommendationRepository {
  Future<List<Recommendation>> getRecommendations();
}
