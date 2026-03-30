import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_session.freezed.dart';
part 'user_session.g.dart';

@Freezed(toJson: true)
abstract class UserSession with _$UserSession {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory UserSession({
    required String id,
    required String userId,
    required String presetId,
    required int durationSeconds,
    required DateTime startedAt,
    DateTime? endedAt,
    @Default({}) Map<String, dynamic> metadata,
  }) = _UserSession;

  factory UserSession.fromJson(Map<String, dynamic> json) =>
      _$UserSessionFromJson(json);
}
