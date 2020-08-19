import 'package:flutter/cupertino.dart';
import 'package:freshOk/core/error/exceptions.dart';
import 'package:freshOk/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:freshOk/core/netowrk/network_info.dart';
import 'package:freshOk/data/datasources/chat/chat_remote_datasource.dart';
import 'package:freshOk/domain/repositories/chat/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;

  ChatRepositoryImpl({
    @required this.remoteDatasource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, List>> getChatMessages(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        final List messages = await remoteDatasource.getChatMessages(userId);
        return Right(messages);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, void>> sendChatMessage(
      {String userId, String message}) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDatasource.sendChatMessage(
          message: message,
          userId: userId,
        );
        return Right(null);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, void>> sendFeedback({type, String desc}) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDatasource.sendFeedback(type: type, desc: desc);
        return Right(Null);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
