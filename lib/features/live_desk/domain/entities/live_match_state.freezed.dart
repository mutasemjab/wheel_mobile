// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'live_match_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LiveClock {

 int get accMs; int? get runAtMs;
/// Create a copy of LiveClock
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LiveClockCopyWith<LiveClock> get copyWith => _$LiveClockCopyWithImpl<LiveClock>(this as LiveClock, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LiveClock&&(identical(other.accMs, accMs) || other.accMs == accMs)&&(identical(other.runAtMs, runAtMs) || other.runAtMs == runAtMs));
}


@override
int get hashCode => Object.hash(runtimeType,accMs,runAtMs);

@override
String toString() {
  return 'LiveClock(accMs: $accMs, runAtMs: $runAtMs)';
}


}

/// @nodoc
abstract mixin class $LiveClockCopyWith<$Res>  {
  factory $LiveClockCopyWith(LiveClock value, $Res Function(LiveClock) _then) = _$LiveClockCopyWithImpl;
@useResult
$Res call({
 int accMs, int? runAtMs
});




}
/// @nodoc
class _$LiveClockCopyWithImpl<$Res>
    implements $LiveClockCopyWith<$Res> {
  _$LiveClockCopyWithImpl(this._self, this._then);

  final LiveClock _self;
  final $Res Function(LiveClock) _then;

/// Create a copy of LiveClock
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accMs = null,Object? runAtMs = freezed,}) {
  return _then(_self.copyWith(
accMs: null == accMs ? _self.accMs : accMs // ignore: cast_nullable_to_non_nullable
as int,runAtMs: freezed == runAtMs ? _self.runAtMs : runAtMs // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [LiveClock].
extension LiveClockPatterns on LiveClock {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LiveClock value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LiveClock() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LiveClock value)  $default,){
final _that = this;
switch (_that) {
case _LiveClock():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LiveClock value)?  $default,){
final _that = this;
switch (_that) {
case _LiveClock() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int accMs,  int? runAtMs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LiveClock() when $default != null:
return $default(_that.accMs,_that.runAtMs);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int accMs,  int? runAtMs)  $default,) {final _that = this;
switch (_that) {
case _LiveClock():
return $default(_that.accMs,_that.runAtMs);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int accMs,  int? runAtMs)?  $default,) {final _that = this;
switch (_that) {
case _LiveClock() when $default != null:
return $default(_that.accMs,_that.runAtMs);case _:
  return null;

}
}

}

/// @nodoc


class _LiveClock extends LiveClock {
  const _LiveClock({this.accMs = 0, this.runAtMs}): super._();
  

@override@JsonKey() final  int accMs;
@override final  int? runAtMs;

/// Create a copy of LiveClock
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LiveClockCopyWith<_LiveClock> get copyWith => __$LiveClockCopyWithImpl<_LiveClock>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LiveClock&&(identical(other.accMs, accMs) || other.accMs == accMs)&&(identical(other.runAtMs, runAtMs) || other.runAtMs == runAtMs));
}


@override
int get hashCode => Object.hash(runtimeType,accMs,runAtMs);

@override
String toString() {
  return 'LiveClock(accMs: $accMs, runAtMs: $runAtMs)';
}


}

/// @nodoc
abstract mixin class _$LiveClockCopyWith<$Res> implements $LiveClockCopyWith<$Res> {
  factory _$LiveClockCopyWith(_LiveClock value, $Res Function(_LiveClock) _then) = __$LiveClockCopyWithImpl;
@override @useResult
$Res call({
 int accMs, int? runAtMs
});




}
/// @nodoc
class __$LiveClockCopyWithImpl<$Res>
    implements _$LiveClockCopyWith<$Res> {
  __$LiveClockCopyWithImpl(this._self, this._then);

  final _LiveClock _self;
  final $Res Function(_LiveClock) _then;

/// Create a copy of LiveClock
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accMs = null,Object? runAtMs = freezed,}) {
  return _then(_LiveClock(
accMs: null == accMs ? _self.accMs : accMs // ignore: cast_nullable_to_non_nullable
as int,runAtMs: freezed == runAtMs ? _self.runAtMs : runAtMs // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc
mixin _$LiveEvent {

 String get uuid; LiveEventType get type; String? get player; String? get assist; int? get minute;
/// Create a copy of LiveEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LiveEventCopyWith<LiveEvent> get copyWith => _$LiveEventCopyWithImpl<LiveEvent>(this as LiveEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LiveEvent&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.type, type) || other.type == type)&&(identical(other.player, player) || other.player == player)&&(identical(other.assist, assist) || other.assist == assist)&&(identical(other.minute, minute) || other.minute == minute));
}


@override
int get hashCode => Object.hash(runtimeType,uuid,type,player,assist,minute);

@override
String toString() {
  return 'LiveEvent(uuid: $uuid, type: $type, player: $player, assist: $assist, minute: $minute)';
}


}

/// @nodoc
abstract mixin class $LiveEventCopyWith<$Res>  {
  factory $LiveEventCopyWith(LiveEvent value, $Res Function(LiveEvent) _then) = _$LiveEventCopyWithImpl;
@useResult
$Res call({
 String uuid, LiveEventType type, String? player, String? assist, int? minute
});




}
/// @nodoc
class _$LiveEventCopyWithImpl<$Res>
    implements $LiveEventCopyWith<$Res> {
  _$LiveEventCopyWithImpl(this._self, this._then);

  final LiveEvent _self;
  final $Res Function(LiveEvent) _then;

/// Create a copy of LiveEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uuid = null,Object? type = null,Object? player = freezed,Object? assist = freezed,Object? minute = freezed,}) {
  return _then(_self.copyWith(
uuid: null == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as LiveEventType,player: freezed == player ? _self.player : player // ignore: cast_nullable_to_non_nullable
as String?,assist: freezed == assist ? _self.assist : assist // ignore: cast_nullable_to_non_nullable
as String?,minute: freezed == minute ? _self.minute : minute // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [LiveEvent].
extension LiveEventPatterns on LiveEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LiveEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LiveEvent() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LiveEvent value)  $default,){
final _that = this;
switch (_that) {
case _LiveEvent():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LiveEvent value)?  $default,){
final _that = this;
switch (_that) {
case _LiveEvent() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uuid,  LiveEventType type,  String? player,  String? assist,  int? minute)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LiveEvent() when $default != null:
return $default(_that.uuid,_that.type,_that.player,_that.assist,_that.minute);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uuid,  LiveEventType type,  String? player,  String? assist,  int? minute)  $default,) {final _that = this;
switch (_that) {
case _LiveEvent():
return $default(_that.uuid,_that.type,_that.player,_that.assist,_that.minute);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uuid,  LiveEventType type,  String? player,  String? assist,  int? minute)?  $default,) {final _that = this;
switch (_that) {
case _LiveEvent() when $default != null:
return $default(_that.uuid,_that.type,_that.player,_that.assist,_that.minute);case _:
  return null;

}
}

}

/// @nodoc


class _LiveEvent implements LiveEvent {
  const _LiveEvent({required this.uuid, required this.type, this.player, this.assist, this.minute});
  

@override final  String uuid;
@override final  LiveEventType type;
@override final  String? player;
@override final  String? assist;
@override final  int? minute;

/// Create a copy of LiveEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LiveEventCopyWith<_LiveEvent> get copyWith => __$LiveEventCopyWithImpl<_LiveEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LiveEvent&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.type, type) || other.type == type)&&(identical(other.player, player) || other.player == player)&&(identical(other.assist, assist) || other.assist == assist)&&(identical(other.minute, minute) || other.minute == minute));
}


@override
int get hashCode => Object.hash(runtimeType,uuid,type,player,assist,minute);

@override
String toString() {
  return 'LiveEvent(uuid: $uuid, type: $type, player: $player, assist: $assist, minute: $minute)';
}


}

/// @nodoc
abstract mixin class _$LiveEventCopyWith<$Res> implements $LiveEventCopyWith<$Res> {
  factory _$LiveEventCopyWith(_LiveEvent value, $Res Function(_LiveEvent) _then) = __$LiveEventCopyWithImpl;
@override @useResult
$Res call({
 String uuid, LiveEventType type, String? player, String? assist, int? minute
});




}
/// @nodoc
class __$LiveEventCopyWithImpl<$Res>
    implements _$LiveEventCopyWith<$Res> {
  __$LiveEventCopyWithImpl(this._self, this._then);

  final _LiveEvent _self;
  final $Res Function(_LiveEvent) _then;

/// Create a copy of LiveEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uuid = null,Object? type = null,Object? player = freezed,Object? assist = freezed,Object? minute = freezed,}) {
  return _then(_LiveEvent(
uuid: null == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as LiveEventType,player: freezed == player ? _self.player : player // ignore: cast_nullable_to_non_nullable
as String?,assist: freezed == assist ? _self.assist : assist // ignore: cast_nullable_to_non_nullable
as String?,minute: freezed == minute ? _self.minute : minute // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc
mixin _$LiveMatchState {

 String get code; String get opponent; DateTime get date; List<String> get played; List<String> get excused; Set<String> get unfair; Set<String> get late; Map<String, int> get values; String? get motm; LiveClock get clock;/// Oldest → newest.
 List<LiveEvent> get events; SyncStatus get syncStatus; DateTime? get lastSyncedAt;/// `POST /admin/live` succeeded for [code].
 bool get serverCreated;/// `POST /admin/live/finish` succeeded; [summary] holds the WhatsApp text.
 bool get finished; String? get summary;
/// Create a copy of LiveMatchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LiveMatchStateCopyWith<LiveMatchState> get copyWith => _$LiveMatchStateCopyWithImpl<LiveMatchState>(this as LiveMatchState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LiveMatchState&&(identical(other.code, code) || other.code == code)&&(identical(other.opponent, opponent) || other.opponent == opponent)&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other.played, played)&&const DeepCollectionEquality().equals(other.excused, excused)&&const DeepCollectionEquality().equals(other.unfair, unfair)&&const DeepCollectionEquality().equals(other.late, late)&&const DeepCollectionEquality().equals(other.values, values)&&(identical(other.motm, motm) || other.motm == motm)&&(identical(other.clock, clock) || other.clock == clock)&&const DeepCollectionEquality().equals(other.events, events)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus)&&(identical(other.lastSyncedAt, lastSyncedAt) || other.lastSyncedAt == lastSyncedAt)&&(identical(other.serverCreated, serverCreated) || other.serverCreated == serverCreated)&&(identical(other.finished, finished) || other.finished == finished)&&(identical(other.summary, summary) || other.summary == summary));
}


@override
int get hashCode => Object.hash(runtimeType,code,opponent,date,const DeepCollectionEquality().hash(played),const DeepCollectionEquality().hash(excused),const DeepCollectionEquality().hash(unfair),const DeepCollectionEquality().hash(late),const DeepCollectionEquality().hash(values),motm,clock,const DeepCollectionEquality().hash(events),syncStatus,lastSyncedAt,serverCreated,finished,summary);

@override
String toString() {
  return 'LiveMatchState(code: $code, opponent: $opponent, date: $date, played: $played, excused: $excused, unfair: $unfair, late: $late, values: $values, motm: $motm, clock: $clock, events: $events, syncStatus: $syncStatus, lastSyncedAt: $lastSyncedAt, serverCreated: $serverCreated, finished: $finished, summary: $summary)';
}


}

/// @nodoc
abstract mixin class $LiveMatchStateCopyWith<$Res>  {
  factory $LiveMatchStateCopyWith(LiveMatchState value, $Res Function(LiveMatchState) _then) = _$LiveMatchStateCopyWithImpl;
@useResult
$Res call({
 String code, String opponent, DateTime date, List<String> played, List<String> excused, Set<String> unfair, Set<String> late, Map<String, int> values, String? motm, LiveClock clock, List<LiveEvent> events, SyncStatus syncStatus, DateTime? lastSyncedAt, bool serverCreated, bool finished, String? summary
});


$LiveClockCopyWith<$Res> get clock;

}
/// @nodoc
class _$LiveMatchStateCopyWithImpl<$Res>
    implements $LiveMatchStateCopyWith<$Res> {
  _$LiveMatchStateCopyWithImpl(this._self, this._then);

  final LiveMatchState _self;
  final $Res Function(LiveMatchState) _then;

/// Create a copy of LiveMatchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? opponent = null,Object? date = null,Object? played = null,Object? excused = null,Object? unfair = null,Object? late = null,Object? values = null,Object? motm = freezed,Object? clock = null,Object? events = null,Object? syncStatus = null,Object? lastSyncedAt = freezed,Object? serverCreated = null,Object? finished = null,Object? summary = freezed,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,opponent: null == opponent ? _self.opponent : opponent // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,played: null == played ? _self.played : played // ignore: cast_nullable_to_non_nullable
as List<String>,excused: null == excused ? _self.excused : excused // ignore: cast_nullable_to_non_nullable
as List<String>,unfair: null == unfair ? _self.unfair : unfair // ignore: cast_nullable_to_non_nullable
as Set<String>,late: null == late ? _self.late : late // ignore: cast_nullable_to_non_nullable
as Set<String>,values: null == values ? _self.values : values // ignore: cast_nullable_to_non_nullable
as Map<String, int>,motm: freezed == motm ? _self.motm : motm // ignore: cast_nullable_to_non_nullable
as String?,clock: null == clock ? _self.clock : clock // ignore: cast_nullable_to_non_nullable
as LiveClock,events: null == events ? _self.events : events // ignore: cast_nullable_to_non_nullable
as List<LiveEvent>,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as SyncStatus,lastSyncedAt: freezed == lastSyncedAt ? _self.lastSyncedAt : lastSyncedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverCreated: null == serverCreated ? _self.serverCreated : serverCreated // ignore: cast_nullable_to_non_nullable
as bool,finished: null == finished ? _self.finished : finished // ignore: cast_nullable_to_non_nullable
as bool,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of LiveMatchState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LiveClockCopyWith<$Res> get clock {
  
  return $LiveClockCopyWith<$Res>(_self.clock, (value) {
    return _then(_self.copyWith(clock: value));
  });
}
}


/// Adds pattern-matching-related methods to [LiveMatchState].
extension LiveMatchStatePatterns on LiveMatchState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LiveMatchState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LiveMatchState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LiveMatchState value)  $default,){
final _that = this;
switch (_that) {
case _LiveMatchState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LiveMatchState value)?  $default,){
final _that = this;
switch (_that) {
case _LiveMatchState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String opponent,  DateTime date,  List<String> played,  List<String> excused,  Set<String> unfair,  Set<String> late,  Map<String, int> values,  String? motm,  LiveClock clock,  List<LiveEvent> events,  SyncStatus syncStatus,  DateTime? lastSyncedAt,  bool serverCreated,  bool finished,  String? summary)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LiveMatchState() when $default != null:
return $default(_that.code,_that.opponent,_that.date,_that.played,_that.excused,_that.unfair,_that.late,_that.values,_that.motm,_that.clock,_that.events,_that.syncStatus,_that.lastSyncedAt,_that.serverCreated,_that.finished,_that.summary);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String opponent,  DateTime date,  List<String> played,  List<String> excused,  Set<String> unfair,  Set<String> late,  Map<String, int> values,  String? motm,  LiveClock clock,  List<LiveEvent> events,  SyncStatus syncStatus,  DateTime? lastSyncedAt,  bool serverCreated,  bool finished,  String? summary)  $default,) {final _that = this;
switch (_that) {
case _LiveMatchState():
return $default(_that.code,_that.opponent,_that.date,_that.played,_that.excused,_that.unfair,_that.late,_that.values,_that.motm,_that.clock,_that.events,_that.syncStatus,_that.lastSyncedAt,_that.serverCreated,_that.finished,_that.summary);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String opponent,  DateTime date,  List<String> played,  List<String> excused,  Set<String> unfair,  Set<String> late,  Map<String, int> values,  String? motm,  LiveClock clock,  List<LiveEvent> events,  SyncStatus syncStatus,  DateTime? lastSyncedAt,  bool serverCreated,  bool finished,  String? summary)?  $default,) {final _that = this;
switch (_that) {
case _LiveMatchState() when $default != null:
return $default(_that.code,_that.opponent,_that.date,_that.played,_that.excused,_that.unfair,_that.late,_that.values,_that.motm,_that.clock,_that.events,_that.syncStatus,_that.lastSyncedAt,_that.serverCreated,_that.finished,_that.summary);case _:
  return null;

}
}

}

/// @nodoc


class _LiveMatchState extends LiveMatchState {
  const _LiveMatchState({required this.code, required this.opponent, required this.date, final  List<String> played = const <String>[], final  List<String> excused = const <String>[], final  Set<String> unfair = const <String>{}, final  Set<String> late = const <String>{}, final  Map<String, int> values = const <String, int>{}, this.motm, this.clock = const LiveClock(), final  List<LiveEvent> events = const <LiveEvent>[], this.syncStatus = SyncStatus.pending, this.lastSyncedAt, this.serverCreated = false, this.finished = false, this.summary}): _played = played,_excused = excused,_unfair = unfair,_late = late,_values = values,_events = events,super._();
  

@override final  String code;
@override final  String opponent;
@override final  DateTime date;
 final  List<String> _played;
@override@JsonKey() List<String> get played {
  if (_played is EqualUnmodifiableListView) return _played;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_played);
}

 final  List<String> _excused;
@override@JsonKey() List<String> get excused {
  if (_excused is EqualUnmodifiableListView) return _excused;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_excused);
}

 final  Set<String> _unfair;
@override@JsonKey() Set<String> get unfair {
  if (_unfair is EqualUnmodifiableSetView) return _unfair;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_unfair);
}

 final  Set<String> _late;
@override@JsonKey() Set<String> get late {
  if (_late is EqualUnmodifiableSetView) return _late;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_late);
}

 final  Map<String, int> _values;
@override@JsonKey() Map<String, int> get values {
  if (_values is EqualUnmodifiableMapView) return _values;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_values);
}

@override final  String? motm;
@override@JsonKey() final  LiveClock clock;
/// Oldest → newest.
 final  List<LiveEvent> _events;
/// Oldest → newest.
@override@JsonKey() List<LiveEvent> get events {
  if (_events is EqualUnmodifiableListView) return _events;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_events);
}

@override@JsonKey() final  SyncStatus syncStatus;
@override final  DateTime? lastSyncedAt;
/// `POST /admin/live` succeeded for [code].
@override@JsonKey() final  bool serverCreated;
/// `POST /admin/live/finish` succeeded; [summary] holds the WhatsApp text.
@override@JsonKey() final  bool finished;
@override final  String? summary;

/// Create a copy of LiveMatchState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LiveMatchStateCopyWith<_LiveMatchState> get copyWith => __$LiveMatchStateCopyWithImpl<_LiveMatchState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LiveMatchState&&(identical(other.code, code) || other.code == code)&&(identical(other.opponent, opponent) || other.opponent == opponent)&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other._played, _played)&&const DeepCollectionEquality().equals(other._excused, _excused)&&const DeepCollectionEquality().equals(other._unfair, _unfair)&&const DeepCollectionEquality().equals(other._late, _late)&&const DeepCollectionEquality().equals(other._values, _values)&&(identical(other.motm, motm) || other.motm == motm)&&(identical(other.clock, clock) || other.clock == clock)&&const DeepCollectionEquality().equals(other._events, _events)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus)&&(identical(other.lastSyncedAt, lastSyncedAt) || other.lastSyncedAt == lastSyncedAt)&&(identical(other.serverCreated, serverCreated) || other.serverCreated == serverCreated)&&(identical(other.finished, finished) || other.finished == finished)&&(identical(other.summary, summary) || other.summary == summary));
}


@override
int get hashCode => Object.hash(runtimeType,code,opponent,date,const DeepCollectionEquality().hash(_played),const DeepCollectionEquality().hash(_excused),const DeepCollectionEquality().hash(_unfair),const DeepCollectionEquality().hash(_late),const DeepCollectionEquality().hash(_values),motm,clock,const DeepCollectionEquality().hash(_events),syncStatus,lastSyncedAt,serverCreated,finished,summary);

@override
String toString() {
  return 'LiveMatchState(code: $code, opponent: $opponent, date: $date, played: $played, excused: $excused, unfair: $unfair, late: $late, values: $values, motm: $motm, clock: $clock, events: $events, syncStatus: $syncStatus, lastSyncedAt: $lastSyncedAt, serverCreated: $serverCreated, finished: $finished, summary: $summary)';
}


}

/// @nodoc
abstract mixin class _$LiveMatchStateCopyWith<$Res> implements $LiveMatchStateCopyWith<$Res> {
  factory _$LiveMatchStateCopyWith(_LiveMatchState value, $Res Function(_LiveMatchState) _then) = __$LiveMatchStateCopyWithImpl;
@override @useResult
$Res call({
 String code, String opponent, DateTime date, List<String> played, List<String> excused, Set<String> unfair, Set<String> late, Map<String, int> values, String? motm, LiveClock clock, List<LiveEvent> events, SyncStatus syncStatus, DateTime? lastSyncedAt, bool serverCreated, bool finished, String? summary
});


@override $LiveClockCopyWith<$Res> get clock;

}
/// @nodoc
class __$LiveMatchStateCopyWithImpl<$Res>
    implements _$LiveMatchStateCopyWith<$Res> {
  __$LiveMatchStateCopyWithImpl(this._self, this._then);

  final _LiveMatchState _self;
  final $Res Function(_LiveMatchState) _then;

/// Create a copy of LiveMatchState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? opponent = null,Object? date = null,Object? played = null,Object? excused = null,Object? unfair = null,Object? late = null,Object? values = null,Object? motm = freezed,Object? clock = null,Object? events = null,Object? syncStatus = null,Object? lastSyncedAt = freezed,Object? serverCreated = null,Object? finished = null,Object? summary = freezed,}) {
  return _then(_LiveMatchState(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,opponent: null == opponent ? _self.opponent : opponent // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,played: null == played ? _self._played : played // ignore: cast_nullable_to_non_nullable
as List<String>,excused: null == excused ? _self._excused : excused // ignore: cast_nullable_to_non_nullable
as List<String>,unfair: null == unfair ? _self._unfair : unfair // ignore: cast_nullable_to_non_nullable
as Set<String>,late: null == late ? _self._late : late // ignore: cast_nullable_to_non_nullable
as Set<String>,values: null == values ? _self._values : values // ignore: cast_nullable_to_non_nullable
as Map<String, int>,motm: freezed == motm ? _self.motm : motm // ignore: cast_nullable_to_non_nullable
as String?,clock: null == clock ? _self.clock : clock // ignore: cast_nullable_to_non_nullable
as LiveClock,events: null == events ? _self._events : events // ignore: cast_nullable_to_non_nullable
as List<LiveEvent>,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as SyncStatus,lastSyncedAt: freezed == lastSyncedAt ? _self.lastSyncedAt : lastSyncedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverCreated: null == serverCreated ? _self.serverCreated : serverCreated // ignore: cast_nullable_to_non_nullable
as bool,finished: null == finished ? _self.finished : finished // ignore: cast_nullable_to_non_nullable
as bool,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of LiveMatchState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LiveClockCopyWith<$Res> get clock {
  
  return $LiveClockCopyWith<$Res>(_self.clock, (value) {
    return _then(_self.copyWith(clock: value));
  });
}
}

// dart format on
