import 'package:dartz/dartz.dart';

import '../../../core/failure/failure.dart';
import '../../../data/model/backup/user_cloud_account.dart';

abstract class CloudBackupRepository {
  Future<Either<Failure, void>> exportToBackup();
  Future<Either<Failure, Stream<List<int>>>> importFromBackup(String pubKey);
  Future<Either<Failure, UserCloudAccount?>> currentUser();
  Future<Either<Failure, UserCloudAccount>> signIn();
  Future<Either<Failure, void>> signOut();
}
