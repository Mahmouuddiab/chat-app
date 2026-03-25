// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:firebase_storage/firebase_storage.dart' as _i457;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/data/data%20source/auth_remote_data_source.dart'
    as _i214;
import '../../features/auth/data/data%20source/auth_remote_ds_impl.dart'
    as _i624;
import '../../features/auth/data/repository/auth_repository_impl.dart' as _i409;
import '../../features/auth/domain/repository/auth_repository.dart' as _i961;
import '../../features/auth/domain/usecase/current_user.dart' as _i85;
import '../../features/auth/domain/usecase/login_usecase.dart' as _i911;
import '../../features/auth/domain/usecase/logout_usecase.dart' as _i757;
import '../../features/auth/domain/usecase/register_usecase.dart' as _i769;
import '../../features/auth/presentation/cubit/auth_cubit.dart' as _i117;
import '../../features/chat/data/data%20source/chat_remote_ds.dart' as _i653;
import '../../features/chat/data/data%20source/chat_remote_ds_impl.dart'
    as _i594;
import '../../features/chat/data/repository/chat_repository_impl.dart' as _i88;
import '../../features/chat/domain/repository/chat_repository.dart' as _i477;
import '../../features/chat/domain/usecase/get_message_usecase.dart' as _i297;
import '../../features/chat/domain/usecase/send_image_message.dart' as _i1019;
import '../../features/chat/domain/usecase/send_message_usecase.dart' as _i547;
import '../../features/chat/presentation/cubit/chat_cubit.dart' as _i305;
import 'auth_module.dart' as _i784;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i59.FirebaseAuth>(() => registerModule.firebaseAuth);
    gh.lazySingleton<_i974.FirebaseFirestore>(() => registerModule.firestore);
    gh.lazySingleton<_i457.FirebaseStorage>(() => registerModule.storage);
    gh.lazySingleton<_i653.ChatRemoteDs>(
      () => _i594.ChatRemoteDsImpl(
        firestore: gh<_i974.FirebaseFirestore>(),
        auth: gh<_i59.FirebaseAuth>(),
        storage: gh<_i457.FirebaseStorage>(),
      ),
    );
    gh.factory<_i477.ChatRepository>(
      () => _i88.ChatRepositoryImpl(gh<_i653.ChatRemoteDs>()),
    );
    gh.lazySingleton<_i214.AuthRemoteDataSource>(
      () => _i624.AuthRemoteDsImpl(gh<_i59.FirebaseAuth>()),
    );
    gh.factory<_i297.GetMessages>(
      () => _i297.GetMessages(gh<_i477.ChatRepository>()),
    );
    gh.factory<_i1019.SendImageMessageUseCase>(
      () => _i1019.SendImageMessageUseCase(gh<_i477.ChatRepository>()),
    );
    gh.factory<_i547.SendMessage>(
      () => _i547.SendMessage(gh<_i477.ChatRepository>()),
    );
    gh.factory<_i961.AuthRepository>(
      () => _i409.AuthRepositoryImpl(gh<_i214.AuthRemoteDataSource>()),
    );
    gh.factory<_i85.GetCurrentUserUseCase>(
      () => _i85.GetCurrentUserUseCase(gh<_i961.AuthRepository>()),
    );
    gh.factory<_i911.LoginUseCase>(
      () => _i911.LoginUseCase(gh<_i961.AuthRepository>()),
    );
    gh.factory<_i757.LogoutUseCase>(
      () => _i757.LogoutUseCase(gh<_i961.AuthRepository>()),
    );
    gh.factory<_i769.RegisterUseCase>(
      () => _i769.RegisterUseCase(gh<_i961.AuthRepository>()),
    );
    gh.factory<_i305.ChatCubit>(
      () => _i305.ChatCubit(
        gh<_i297.GetMessages>(),
        gh<_i547.SendMessage>(),
        gh<_i1019.SendImageMessageUseCase>(),
      ),
    );
    gh.factory<_i117.AuthCubit>(
      () => _i117.AuthCubit(
        loginUseCase: gh<_i911.LoginUseCase>(),
        registerUseCase: gh<_i769.RegisterUseCase>(),
        logoutUseCase: gh<_i757.LogoutUseCase>(),
        getCurrentUserUseCase: gh<_i85.GetCurrentUserUseCase>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i784.RegisterModule {}
