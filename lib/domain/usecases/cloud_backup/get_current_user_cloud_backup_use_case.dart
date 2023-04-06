import 'package:deixa/core/failure/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:deixa/core/use_case/use_case.dart';
import 'package:deixa/data/model/backup/user_cloud_account.dart';
import 'package:deixa/domain/repositories/cloud_backup/cloud_backup_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCurrentUserCloudBackupUseCase
    implements NoParamUseCase<UserCloudAccount?> {
  final CloudBackupRepository _cloudBackupRepository;

  GetCurrentUserCloudBackupUseCase(this._cloudBackupRepository);

  @override
  Future<Either<Failure, UserCloudAccount?>> call() =>
      _cloudBackupRepository.currentUser();
}
