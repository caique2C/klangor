// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ProfilesTable extends Profiles with TableInfo<$ProfilesTable, Profile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _displayNameMeta =
      const VerificationMeta('displayName');
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
      'display_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('ma_auth'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [username, displayName, source, createdAt, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profiles';
  @override
  VerificationContext validateIntegrity(Insertable<Profile> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
          _displayNameMeta,
          displayName.isAcceptableOrUnknown(
              data['display_name']!, _displayNameMeta));
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {username};
  @override
  Profile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Profile(
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      displayName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}display_name']),
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(attachedDatabase, alias);
  }
}

class Profile extends DataClass implements Insertable<Profile> {
  /// MA username or manually entered name (primary key)
  final String username;

  /// Display name from MA or same as username
  final String? displayName;

  /// How the profile was created: 'ma_auth' or 'manual'
  final String source;

  /// When the profile was created
  final DateTime createdAt;

  /// Whether this is the currently active profile
  final bool isActive;
  const Profile(
      {required this.username,
      this.displayName,
      required this.source,
      required this.createdAt,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['username'] = Variable<String>(username);
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    map['source'] = Variable<String>(source);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      username: Value(username),
      displayName: displayName == null && nullToAbsent
          ? const Value.absent()
          : Value(displayName),
      source: Value(source),
      createdAt: Value(createdAt),
      isActive: Value(isActive),
    );
  }

  factory Profile.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Profile(
      username: serializer.fromJson<String>(json['username']),
      displayName: serializer.fromJson<String?>(json['displayName']),
      source: serializer.fromJson<String>(json['source']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'username': serializer.toJson<String>(username),
      'displayName': serializer.toJson<String?>(displayName),
      'source': serializer.toJson<String>(source),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  Profile copyWith(
          {String? username,
          Value<String?> displayName = const Value.absent(),
          String? source,
          DateTime? createdAt,
          bool? isActive}) =>
      Profile(
        username: username ?? this.username,
        displayName: displayName.present ? displayName.value : this.displayName,
        source: source ?? this.source,
        createdAt: createdAt ?? this.createdAt,
        isActive: isActive ?? this.isActive,
      );
  Profile copyWithCompanion(ProfilesCompanion data) {
    return Profile(
      username: data.username.present ? data.username.value : this.username,
      displayName:
          data.displayName.present ? data.displayName.value : this.displayName,
      source: data.source.present ? data.source.value : this.source,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Profile(')
          ..write('username: $username, ')
          ..write('displayName: $displayName, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(username, displayName, source, createdAt, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Profile &&
          other.username == this.username &&
          other.displayName == this.displayName &&
          other.source == this.source &&
          other.createdAt == this.createdAt &&
          other.isActive == this.isActive);
}

class ProfilesCompanion extends UpdateCompanion<Profile> {
  final Value<String> username;
  final Value<String?> displayName;
  final Value<String> source;
  final Value<DateTime> createdAt;
  final Value<bool> isActive;
  final Value<int> rowid;
  const ProfilesCompanion({
    this.username = const Value.absent(),
    this.displayName = const Value.absent(),
    this.source = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProfilesCompanion.insert({
    required String username,
    this.displayName = const Value.absent(),
    this.source = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : username = Value(username);
  static Insertable<Profile> custom({
    Expression<String>? username,
    Expression<String>? displayName,
    Expression<String>? source,
    Expression<DateTime>? createdAt,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (username != null) 'username': username,
      if (displayName != null) 'display_name': displayName,
      if (source != null) 'source': source,
      if (createdAt != null) 'created_at': createdAt,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProfilesCompanion copyWith(
      {Value<String>? username,
      Value<String?>? displayName,
      Value<String>? source,
      Value<DateTime>? createdAt,
      Value<bool>? isActive,
      Value<int>? rowid}) {
    return ProfilesCompanion(
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesCompanion(')
          ..write('username: $username, ')
          ..write('displayName: $displayName, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecentlyPlayedTable extends RecentlyPlayed
    with TableInfo<$RecentlyPlayedTable, RecentlyPlayedData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecentlyPlayedTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _profileUsernameMeta =
      const VerificationMeta('profileUsername');
  @override
  late final GeneratedColumn<String> profileUsername = GeneratedColumn<String>(
      'profile_username', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES profiles (username)'));
  static const VerificationMeta _mediaIdMeta =
      const VerificationMeta('mediaId');
  @override
  late final GeneratedColumn<String> mediaId = GeneratedColumn<String>(
      'media_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _mediaTypeMeta =
      const VerificationMeta('mediaType');
  @override
  late final GeneratedColumn<String> mediaType = GeneratedColumn<String>(
      'media_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _artistNameMeta =
      const VerificationMeta('artistName');
  @override
  late final GeneratedColumn<String> artistName = GeneratedColumn<String>(
      'artist_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _imageUrlMeta =
      const VerificationMeta('imageUrl');
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
      'image_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _metadataMeta =
      const VerificationMeta('metadata');
  @override
  late final GeneratedColumn<String> metadata = GeneratedColumn<String>(
      'metadata', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _playedAtMeta =
      const VerificationMeta('playedAt');
  @override
  late final GeneratedColumn<DateTime> playedAt = GeneratedColumn<DateTime>(
      'played_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        profileUsername,
        mediaId,
        mediaType,
        name,
        artistName,
        imageUrl,
        metadata,
        playedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recently_played';
  @override
  VerificationContext validateIntegrity(Insertable<RecentlyPlayedData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('profile_username')) {
      context.handle(
          _profileUsernameMeta,
          profileUsername.isAcceptableOrUnknown(
              data['profile_username']!, _profileUsernameMeta));
    } else if (isInserting) {
      context.missing(_profileUsernameMeta);
    }
    if (data.containsKey('media_id')) {
      context.handle(_mediaIdMeta,
          mediaId.isAcceptableOrUnknown(data['media_id']!, _mediaIdMeta));
    } else if (isInserting) {
      context.missing(_mediaIdMeta);
    }
    if (data.containsKey('media_type')) {
      context.handle(_mediaTypeMeta,
          mediaType.isAcceptableOrUnknown(data['media_type']!, _mediaTypeMeta));
    } else if (isInserting) {
      context.missing(_mediaTypeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('artist_name')) {
      context.handle(
          _artistNameMeta,
          artistName.isAcceptableOrUnknown(
              data['artist_name']!, _artistNameMeta));
    }
    if (data.containsKey('image_url')) {
      context.handle(_imageUrlMeta,
          imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta));
    }
    if (data.containsKey('metadata')) {
      context.handle(_metadataMeta,
          metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta));
    }
    if (data.containsKey('played_at')) {
      context.handle(_playedAtMeta,
          playedAt.isAcceptableOrUnknown(data['played_at']!, _playedAtMeta));
    } else if (isInserting) {
      context.missing(_playedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecentlyPlayedData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecentlyPlayedData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      profileUsername: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}profile_username'])!,
      mediaId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}media_id'])!,
      mediaType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}media_type'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      artistName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}artist_name']),
      imageUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_url']),
      metadata: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metadata']),
      playedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}played_at'])!,
    );
  }

  @override
  $RecentlyPlayedTable createAlias(String alias) {
    return $RecentlyPlayedTable(attachedDatabase, alias);
  }
}

class RecentlyPlayedData extends DataClass
    implements Insertable<RecentlyPlayedData> {
  /// Auto-incrementing ID
  final int id;

  /// Profile this belongs to
  final String profileUsername;

  /// Media item ID from Music Assistant
  final String mediaId;

  /// Type: 'track', 'album', 'artist', 'playlist', 'audiobook'
  final String mediaType;

  /// Display name of the item
  final String name;

  /// Artist/author name (for display)
  final String? artistName;

  /// Image URL for the item
  final String? imageUrl;

  /// Additional metadata as JSON (e.g., album name for tracks)
  final String? metadata;

  /// When this was played
  final DateTime playedAt;
  const RecentlyPlayedData(
      {required this.id,
      required this.profileUsername,
      required this.mediaId,
      required this.mediaType,
      required this.name,
      this.artistName,
      this.imageUrl,
      this.metadata,
      required this.playedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['profile_username'] = Variable<String>(profileUsername);
    map['media_id'] = Variable<String>(mediaId);
    map['media_type'] = Variable<String>(mediaType);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || artistName != null) {
      map['artist_name'] = Variable<String>(artistName);
    }
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    if (!nullToAbsent || metadata != null) {
      map['metadata'] = Variable<String>(metadata);
    }
    map['played_at'] = Variable<DateTime>(playedAt);
    return map;
  }

  RecentlyPlayedCompanion toCompanion(bool nullToAbsent) {
    return RecentlyPlayedCompanion(
      id: Value(id),
      profileUsername: Value(profileUsername),
      mediaId: Value(mediaId),
      mediaType: Value(mediaType),
      name: Value(name),
      artistName: artistName == null && nullToAbsent
          ? const Value.absent()
          : Value(artistName),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      metadata: metadata == null && nullToAbsent
          ? const Value.absent()
          : Value(metadata),
      playedAt: Value(playedAt),
    );
  }

  factory RecentlyPlayedData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecentlyPlayedData(
      id: serializer.fromJson<int>(json['id']),
      profileUsername: serializer.fromJson<String>(json['profileUsername']),
      mediaId: serializer.fromJson<String>(json['mediaId']),
      mediaType: serializer.fromJson<String>(json['mediaType']),
      name: serializer.fromJson<String>(json['name']),
      artistName: serializer.fromJson<String?>(json['artistName']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      metadata: serializer.fromJson<String?>(json['metadata']),
      playedAt: serializer.fromJson<DateTime>(json['playedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'profileUsername': serializer.toJson<String>(profileUsername),
      'mediaId': serializer.toJson<String>(mediaId),
      'mediaType': serializer.toJson<String>(mediaType),
      'name': serializer.toJson<String>(name),
      'artistName': serializer.toJson<String?>(artistName),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'metadata': serializer.toJson<String?>(metadata),
      'playedAt': serializer.toJson<DateTime>(playedAt),
    };
  }

  RecentlyPlayedData copyWith(
          {int? id,
          String? profileUsername,
          String? mediaId,
          String? mediaType,
          String? name,
          Value<String?> artistName = const Value.absent(),
          Value<String?> imageUrl = const Value.absent(),
          Value<String?> metadata = const Value.absent(),
          DateTime? playedAt}) =>
      RecentlyPlayedData(
        id: id ?? this.id,
        profileUsername: profileUsername ?? this.profileUsername,
        mediaId: mediaId ?? this.mediaId,
        mediaType: mediaType ?? this.mediaType,
        name: name ?? this.name,
        artistName: artistName.present ? artistName.value : this.artistName,
        imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
        metadata: metadata.present ? metadata.value : this.metadata,
        playedAt: playedAt ?? this.playedAt,
      );
  RecentlyPlayedData copyWithCompanion(RecentlyPlayedCompanion data) {
    return RecentlyPlayedData(
      id: data.id.present ? data.id.value : this.id,
      profileUsername: data.profileUsername.present
          ? data.profileUsername.value
          : this.profileUsername,
      mediaId: data.mediaId.present ? data.mediaId.value : this.mediaId,
      mediaType: data.mediaType.present ? data.mediaType.value : this.mediaType,
      name: data.name.present ? data.name.value : this.name,
      artistName:
          data.artistName.present ? data.artistName.value : this.artistName,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
      playedAt: data.playedAt.present ? data.playedAt.value : this.playedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecentlyPlayedData(')
          ..write('id: $id, ')
          ..write('profileUsername: $profileUsername, ')
          ..write('mediaId: $mediaId, ')
          ..write('mediaType: $mediaType, ')
          ..write('name: $name, ')
          ..write('artistName: $artistName, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('metadata: $metadata, ')
          ..write('playedAt: $playedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, profileUsername, mediaId, mediaType, name,
      artistName, imageUrl, metadata, playedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecentlyPlayedData &&
          other.id == this.id &&
          other.profileUsername == this.profileUsername &&
          other.mediaId == this.mediaId &&
          other.mediaType == this.mediaType &&
          other.name == this.name &&
          other.artistName == this.artistName &&
          other.imageUrl == this.imageUrl &&
          other.metadata == this.metadata &&
          other.playedAt == this.playedAt);
}

class RecentlyPlayedCompanion extends UpdateCompanion<RecentlyPlayedData> {
  final Value<int> id;
  final Value<String> profileUsername;
  final Value<String> mediaId;
  final Value<String> mediaType;
  final Value<String> name;
  final Value<String?> artistName;
  final Value<String?> imageUrl;
  final Value<String?> metadata;
  final Value<DateTime> playedAt;
  const RecentlyPlayedCompanion({
    this.id = const Value.absent(),
    this.profileUsername = const Value.absent(),
    this.mediaId = const Value.absent(),
    this.mediaType = const Value.absent(),
    this.name = const Value.absent(),
    this.artistName = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.metadata = const Value.absent(),
    this.playedAt = const Value.absent(),
  });
  RecentlyPlayedCompanion.insert({
    this.id = const Value.absent(),
    required String profileUsername,
    required String mediaId,
    required String mediaType,
    required String name,
    this.artistName = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.metadata = const Value.absent(),
    required DateTime playedAt,
  })  : profileUsername = Value(profileUsername),
        mediaId = Value(mediaId),
        mediaType = Value(mediaType),
        name = Value(name),
        playedAt = Value(playedAt);
  static Insertable<RecentlyPlayedData> custom({
    Expression<int>? id,
    Expression<String>? profileUsername,
    Expression<String>? mediaId,
    Expression<String>? mediaType,
    Expression<String>? name,
    Expression<String>? artistName,
    Expression<String>? imageUrl,
    Expression<String>? metadata,
    Expression<DateTime>? playedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileUsername != null) 'profile_username': profileUsername,
      if (mediaId != null) 'media_id': mediaId,
      if (mediaType != null) 'media_type': mediaType,
      if (name != null) 'name': name,
      if (artistName != null) 'artist_name': artistName,
      if (imageUrl != null) 'image_url': imageUrl,
      if (metadata != null) 'metadata': metadata,
      if (playedAt != null) 'played_at': playedAt,
    });
  }

  RecentlyPlayedCompanion copyWith(
      {Value<int>? id,
      Value<String>? profileUsername,
      Value<String>? mediaId,
      Value<String>? mediaType,
      Value<String>? name,
      Value<String?>? artistName,
      Value<String?>? imageUrl,
      Value<String?>? metadata,
      Value<DateTime>? playedAt}) {
    return RecentlyPlayedCompanion(
      id: id ?? this.id,
      profileUsername: profileUsername ?? this.profileUsername,
      mediaId: mediaId ?? this.mediaId,
      mediaType: mediaType ?? this.mediaType,
      name: name ?? this.name,
      artistName: artistName ?? this.artistName,
      imageUrl: imageUrl ?? this.imageUrl,
      metadata: metadata ?? this.metadata,
      playedAt: playedAt ?? this.playedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (profileUsername.present) {
      map['profile_username'] = Variable<String>(profileUsername.value);
    }
    if (mediaId.present) {
      map['media_id'] = Variable<String>(mediaId.value);
    }
    if (mediaType.present) {
      map['media_type'] = Variable<String>(mediaType.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (artistName.present) {
      map['artist_name'] = Variable<String>(artistName.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(metadata.value);
    }
    if (playedAt.present) {
      map['played_at'] = Variable<DateTime>(playedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecentlyPlayedCompanion(')
          ..write('id: $id, ')
          ..write('profileUsername: $profileUsername, ')
          ..write('mediaId: $mediaId, ')
          ..write('mediaType: $mediaType, ')
          ..write('name: $name, ')
          ..write('artistName: $artistName, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('metadata: $metadata, ')
          ..write('playedAt: $playedAt')
          ..write(')'))
        .toString();
  }
}

class $LibraryCacheTable extends LibraryCache
    with TableInfo<$LibraryCacheTable, LibraryCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LibraryCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _cacheKeyMeta =
      const VerificationMeta('cacheKey');
  @override
  late final GeneratedColumn<String> cacheKey = GeneratedColumn<String>(
      'cache_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _itemTypeMeta =
      const VerificationMeta('itemType');
  @override
  late final GeneratedColumn<String> itemType = GeneratedColumn<String>(
      'item_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
      'item_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
      'data', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastSyncedMeta =
      const VerificationMeta('lastSynced');
  @override
  late final GeneratedColumn<DateTime> lastSynced = GeneratedColumn<DateTime>(
      'last_synced', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _sourceProvidersMeta =
      const VerificationMeta('sourceProviders');
  @override
  late final GeneratedColumn<String> sourceProviders = GeneratedColumn<String>(
      'source_providers', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  @override
  List<GeneratedColumn> get $columns => [
        cacheKey,
        itemType,
        itemId,
        data,
        lastSynced,
        isDeleted,
        sourceProviders
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'library_cache';
  @override
  VerificationContext validateIntegrity(Insertable<LibraryCacheData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('cache_key')) {
      context.handle(_cacheKeyMeta,
          cacheKey.isAcceptableOrUnknown(data['cache_key']!, _cacheKeyMeta));
    } else if (isInserting) {
      context.missing(_cacheKeyMeta);
    }
    if (data.containsKey('item_type')) {
      context.handle(_itemTypeMeta,
          itemType.isAcceptableOrUnknown(data['item_type']!, _itemTypeMeta));
    } else if (isInserting) {
      context.missing(_itemTypeMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
          _dataMeta, this.data.isAcceptableOrUnknown(data['data']!, _dataMeta));
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    if (data.containsKey('last_synced')) {
      context.handle(
          _lastSyncedMeta,
          lastSynced.isAcceptableOrUnknown(
              data['last_synced']!, _lastSyncedMeta));
    } else if (isInserting) {
      context.missing(_lastSyncedMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('source_providers')) {
      context.handle(
          _sourceProvidersMeta,
          sourceProviders.isAcceptableOrUnknown(
              data['source_providers']!, _sourceProvidersMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {cacheKey};
  @override
  LibraryCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LibraryCacheData(
      cacheKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cache_key'])!,
      itemType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_type'])!,
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_id'])!,
      data: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data'])!,
      lastSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_synced'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      sourceProviders: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}source_providers'])!,
    );
  }

  @override
  $LibraryCacheTable createAlias(String alias) {
    return $LibraryCacheTable(attachedDatabase, alias);
  }
}

class LibraryCacheData extends DataClass
    implements Insertable<LibraryCacheData> {
  /// Composite key: provider + item_id
  final String cacheKey;

  /// Type: 'album', 'artist', 'track', 'playlist', 'audiobook', 'audiobook_author'
  final String itemType;

  /// The item ID from Music Assistant
  final String itemId;

  /// Serialized item data as JSON
  final String data;

  /// When this was last synced from MA
  final DateTime lastSynced;

  /// Whether this item was deleted on the server
  final bool isDeleted;

  /// Provider instance IDs that provided this item (JSON array)
  /// Used for client-side filtering by source provider
  final String sourceProviders;
  const LibraryCacheData(
      {required this.cacheKey,
      required this.itemType,
      required this.itemId,
      required this.data,
      required this.lastSynced,
      required this.isDeleted,
      required this.sourceProviders});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['cache_key'] = Variable<String>(cacheKey);
    map['item_type'] = Variable<String>(itemType);
    map['item_id'] = Variable<String>(itemId);
    map['data'] = Variable<String>(data);
    map['last_synced'] = Variable<DateTime>(lastSynced);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['source_providers'] = Variable<String>(sourceProviders);
    return map;
  }

  LibraryCacheCompanion toCompanion(bool nullToAbsent) {
    return LibraryCacheCompanion(
      cacheKey: Value(cacheKey),
      itemType: Value(itemType),
      itemId: Value(itemId),
      data: Value(data),
      lastSynced: Value(lastSynced),
      isDeleted: Value(isDeleted),
      sourceProviders: Value(sourceProviders),
    );
  }

  factory LibraryCacheData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LibraryCacheData(
      cacheKey: serializer.fromJson<String>(json['cacheKey']),
      itemType: serializer.fromJson<String>(json['itemType']),
      itemId: serializer.fromJson<String>(json['itemId']),
      data: serializer.fromJson<String>(json['data']),
      lastSynced: serializer.fromJson<DateTime>(json['lastSynced']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      sourceProviders: serializer.fromJson<String>(json['sourceProviders']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cacheKey': serializer.toJson<String>(cacheKey),
      'itemType': serializer.toJson<String>(itemType),
      'itemId': serializer.toJson<String>(itemId),
      'data': serializer.toJson<String>(data),
      'lastSynced': serializer.toJson<DateTime>(lastSynced),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'sourceProviders': serializer.toJson<String>(sourceProviders),
    };
  }

  LibraryCacheData copyWith(
          {String? cacheKey,
          String? itemType,
          String? itemId,
          String? data,
          DateTime? lastSynced,
          bool? isDeleted,
          String? sourceProviders}) =>
      LibraryCacheData(
        cacheKey: cacheKey ?? this.cacheKey,
        itemType: itemType ?? this.itemType,
        itemId: itemId ?? this.itemId,
        data: data ?? this.data,
        lastSynced: lastSynced ?? this.lastSynced,
        isDeleted: isDeleted ?? this.isDeleted,
        sourceProviders: sourceProviders ?? this.sourceProviders,
      );
  LibraryCacheData copyWithCompanion(LibraryCacheCompanion data) {
    return LibraryCacheData(
      cacheKey: data.cacheKey.present ? data.cacheKey.value : this.cacheKey,
      itemType: data.itemType.present ? data.itemType.value : this.itemType,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      data: data.data.present ? data.data.value : this.data,
      lastSynced:
          data.lastSynced.present ? data.lastSynced.value : this.lastSynced,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      sourceProviders: data.sourceProviders.present
          ? data.sourceProviders.value
          : this.sourceProviders,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LibraryCacheData(')
          ..write('cacheKey: $cacheKey, ')
          ..write('itemType: $itemType, ')
          ..write('itemId: $itemId, ')
          ..write('data: $data, ')
          ..write('lastSynced: $lastSynced, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('sourceProviders: $sourceProviders')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      cacheKey, itemType, itemId, data, lastSynced, isDeleted, sourceProviders);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LibraryCacheData &&
          other.cacheKey == this.cacheKey &&
          other.itemType == this.itemType &&
          other.itemId == this.itemId &&
          other.data == this.data &&
          other.lastSynced == this.lastSynced &&
          other.isDeleted == this.isDeleted &&
          other.sourceProviders == this.sourceProviders);
}

class LibraryCacheCompanion extends UpdateCompanion<LibraryCacheData> {
  final Value<String> cacheKey;
  final Value<String> itemType;
  final Value<String> itemId;
  final Value<String> data;
  final Value<DateTime> lastSynced;
  final Value<bool> isDeleted;
  final Value<String> sourceProviders;
  final Value<int> rowid;
  const LibraryCacheCompanion({
    this.cacheKey = const Value.absent(),
    this.itemType = const Value.absent(),
    this.itemId = const Value.absent(),
    this.data = const Value.absent(),
    this.lastSynced = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.sourceProviders = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LibraryCacheCompanion.insert({
    required String cacheKey,
    required String itemType,
    required String itemId,
    required String data,
    required DateTime lastSynced,
    this.isDeleted = const Value.absent(),
    this.sourceProviders = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : cacheKey = Value(cacheKey),
        itemType = Value(itemType),
        itemId = Value(itemId),
        data = Value(data),
        lastSynced = Value(lastSynced);
  static Insertable<LibraryCacheData> custom({
    Expression<String>? cacheKey,
    Expression<String>? itemType,
    Expression<String>? itemId,
    Expression<String>? data,
    Expression<DateTime>? lastSynced,
    Expression<bool>? isDeleted,
    Expression<String>? sourceProviders,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (cacheKey != null) 'cache_key': cacheKey,
      if (itemType != null) 'item_type': itemType,
      if (itemId != null) 'item_id': itemId,
      if (data != null) 'data': data,
      if (lastSynced != null) 'last_synced': lastSynced,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (sourceProviders != null) 'source_providers': sourceProviders,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LibraryCacheCompanion copyWith(
      {Value<String>? cacheKey,
      Value<String>? itemType,
      Value<String>? itemId,
      Value<String>? data,
      Value<DateTime>? lastSynced,
      Value<bool>? isDeleted,
      Value<String>? sourceProviders,
      Value<int>? rowid}) {
    return LibraryCacheCompanion(
      cacheKey: cacheKey ?? this.cacheKey,
      itemType: itemType ?? this.itemType,
      itemId: itemId ?? this.itemId,
      data: data ?? this.data,
      lastSynced: lastSynced ?? this.lastSynced,
      isDeleted: isDeleted ?? this.isDeleted,
      sourceProviders: sourceProviders ?? this.sourceProviders,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cacheKey.present) {
      map['cache_key'] = Variable<String>(cacheKey.value);
    }
    if (itemType.present) {
      map['item_type'] = Variable<String>(itemType.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (lastSynced.present) {
      map['last_synced'] = Variable<DateTime>(lastSynced.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (sourceProviders.present) {
      map['source_providers'] = Variable<String>(sourceProviders.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LibraryCacheCompanion(')
          ..write('cacheKey: $cacheKey, ')
          ..write('itemType: $itemType, ')
          ..write('itemId: $itemId, ')
          ..write('data: $data, ')
          ..write('lastSynced: $lastSynced, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('sourceProviders: $sourceProviders, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncMetadataTable extends SyncMetadata
    with TableInfo<$SyncMetadataTable, SyncMetadataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncMetadataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _syncTypeMeta =
      const VerificationMeta('syncType');
  @override
  late final GeneratedColumn<String> syncType = GeneratedColumn<String>(
      'sync_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastSyncedAtMeta =
      const VerificationMeta('lastSyncedAt');
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
      'last_synced_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _itemCountMeta =
      const VerificationMeta('itemCount');
  @override
  late final GeneratedColumn<int> itemCount = GeneratedColumn<int>(
      'item_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [syncType, lastSyncedAt, itemCount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_metadata';
  @override
  VerificationContext validateIntegrity(Insertable<SyncMetadataData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('sync_type')) {
      context.handle(_syncTypeMeta,
          syncType.isAcceptableOrUnknown(data['sync_type']!, _syncTypeMeta));
    } else if (isInserting) {
      context.missing(_syncTypeMeta);
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
          _lastSyncedAtMeta,
          lastSyncedAt.isAcceptableOrUnknown(
              data['last_synced_at']!, _lastSyncedAtMeta));
    } else if (isInserting) {
      context.missing(_lastSyncedAtMeta);
    }
    if (data.containsKey('item_count')) {
      context.handle(_itemCountMeta,
          itemCount.isAcceptableOrUnknown(data['item_count']!, _itemCountMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {syncType};
  @override
  SyncMetadataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncMetadataData(
      syncType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_type'])!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_synced_at'])!,
      itemCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}item_count'])!,
    );
  }

  @override
  $SyncMetadataTable createAlias(String alias) {
    return $SyncMetadataTable(attachedDatabase, alias);
  }
}

class SyncMetadataData extends DataClass
    implements Insertable<SyncMetadataData> {
  /// What was synced: 'albums', 'artists', 'audiobooks', etc.
  final String syncType;

  /// When the last successful sync completed
  final DateTime lastSyncedAt;

  /// Number of items synced
  final int itemCount;
  const SyncMetadataData(
      {required this.syncType,
      required this.lastSyncedAt,
      required this.itemCount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['sync_type'] = Variable<String>(syncType);
    map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    map['item_count'] = Variable<int>(itemCount);
    return map;
  }

  SyncMetadataCompanion toCompanion(bool nullToAbsent) {
    return SyncMetadataCompanion(
      syncType: Value(syncType),
      lastSyncedAt: Value(lastSyncedAt),
      itemCount: Value(itemCount),
    );
  }

  factory SyncMetadataData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncMetadataData(
      syncType: serializer.fromJson<String>(json['syncType']),
      lastSyncedAt: serializer.fromJson<DateTime>(json['lastSyncedAt']),
      itemCount: serializer.fromJson<int>(json['itemCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'syncType': serializer.toJson<String>(syncType),
      'lastSyncedAt': serializer.toJson<DateTime>(lastSyncedAt),
      'itemCount': serializer.toJson<int>(itemCount),
    };
  }

  SyncMetadataData copyWith(
          {String? syncType, DateTime? lastSyncedAt, int? itemCount}) =>
      SyncMetadataData(
        syncType: syncType ?? this.syncType,
        lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
        itemCount: itemCount ?? this.itemCount,
      );
  SyncMetadataData copyWithCompanion(SyncMetadataCompanion data) {
    return SyncMetadataData(
      syncType: data.syncType.present ? data.syncType.value : this.syncType,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      itemCount: data.itemCount.present ? data.itemCount.value : this.itemCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetadataData(')
          ..write('syncType: $syncType, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('itemCount: $itemCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(syncType, lastSyncedAt, itemCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncMetadataData &&
          other.syncType == this.syncType &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.itemCount == this.itemCount);
}

class SyncMetadataCompanion extends UpdateCompanion<SyncMetadataData> {
  final Value<String> syncType;
  final Value<DateTime> lastSyncedAt;
  final Value<int> itemCount;
  final Value<int> rowid;
  const SyncMetadataCompanion({
    this.syncType = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.itemCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncMetadataCompanion.insert({
    required String syncType,
    required DateTime lastSyncedAt,
    this.itemCount = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : syncType = Value(syncType),
        lastSyncedAt = Value(lastSyncedAt);
  static Insertable<SyncMetadataData> custom({
    Expression<String>? syncType,
    Expression<DateTime>? lastSyncedAt,
    Expression<int>? itemCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (syncType != null) 'sync_type': syncType,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (itemCount != null) 'item_count': itemCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncMetadataCompanion copyWith(
      {Value<String>? syncType,
      Value<DateTime>? lastSyncedAt,
      Value<int>? itemCount,
      Value<int>? rowid}) {
    return SyncMetadataCompanion(
      syncType: syncType ?? this.syncType,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      itemCount: itemCount ?? this.itemCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (syncType.present) {
      map['sync_type'] = Variable<String>(syncType.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (itemCount.present) {
      map['item_count'] = Variable<int>(itemCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetadataCompanion(')
          ..write('syncType: $syncType, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('itemCount: $itemCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlaybackStateTable extends PlaybackState
    with TableInfo<$PlaybackStateTable, PlaybackStateData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaybackStateTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('current'));
  static const VerificationMeta _playerIdMeta =
      const VerificationMeta('playerId');
  @override
  late final GeneratedColumn<String> playerId = GeneratedColumn<String>(
      'player_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _playerNameMeta =
      const VerificationMeta('playerName');
  @override
  late final GeneratedColumn<String> playerName = GeneratedColumn<String>(
      'player_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _currentTrackJsonMeta =
      const VerificationMeta('currentTrackJson');
  @override
  late final GeneratedColumn<String> currentTrackJson = GeneratedColumn<String>(
      'current_track_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _positionSecondsMeta =
      const VerificationMeta('positionSeconds');
  @override
  late final GeneratedColumn<double> positionSeconds = GeneratedColumn<double>(
      'position_seconds', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _isPlayingMeta =
      const VerificationMeta('isPlaying');
  @override
  late final GeneratedColumn<bool> isPlaying = GeneratedColumn<bool>(
      'is_playing', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_playing" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _savedAtMeta =
      const VerificationMeta('savedAt');
  @override
  late final GeneratedColumn<DateTime> savedAt = GeneratedColumn<DateTime>(
      'saved_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        playerId,
        playerName,
        currentTrackJson,
        positionSeconds,
        isPlaying,
        savedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'playback_state';
  @override
  VerificationContext validateIntegrity(Insertable<PlaybackStateData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('player_id')) {
      context.handle(_playerIdMeta,
          playerId.isAcceptableOrUnknown(data['player_id']!, _playerIdMeta));
    }
    if (data.containsKey('player_name')) {
      context.handle(
          _playerNameMeta,
          playerName.isAcceptableOrUnknown(
              data['player_name']!, _playerNameMeta));
    }
    if (data.containsKey('current_track_json')) {
      context.handle(
          _currentTrackJsonMeta,
          currentTrackJson.isAcceptableOrUnknown(
              data['current_track_json']!, _currentTrackJsonMeta));
    }
    if (data.containsKey('position_seconds')) {
      context.handle(
          _positionSecondsMeta,
          positionSeconds.isAcceptableOrUnknown(
              data['position_seconds']!, _positionSecondsMeta));
    }
    if (data.containsKey('is_playing')) {
      context.handle(_isPlayingMeta,
          isPlaying.isAcceptableOrUnknown(data['is_playing']!, _isPlayingMeta));
    }
    if (data.containsKey('saved_at')) {
      context.handle(_savedAtMeta,
          savedAt.isAcceptableOrUnknown(data['saved_at']!, _savedAtMeta));
    } else if (isInserting) {
      context.missing(_savedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlaybackStateData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlaybackStateData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      playerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}player_id']),
      playerName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}player_name']),
      currentTrackJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}current_track_json']),
      positionSeconds: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}position_seconds'])!,
      isPlaying: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_playing'])!,
      savedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}saved_at'])!,
    );
  }

  @override
  $PlaybackStateTable createAlias(String alias) {
    return $PlaybackStateTable(attachedDatabase, alias);
  }
}

class PlaybackStateData extends DataClass
    implements Insertable<PlaybackStateData> {
  /// Always 'current' - single row table
  final String id;

  /// Selected player ID
  final String? playerId;

  /// Selected player name (for display if player unavailable)
  final String? playerName;

  /// Current track as JSON
  final String? currentTrackJson;

  /// Current position in seconds
  final double positionSeconds;

  /// Whether playback was active
  final bool isPlaying;

  /// When this state was saved
  final DateTime savedAt;
  const PlaybackStateData(
      {required this.id,
      this.playerId,
      this.playerName,
      this.currentTrackJson,
      required this.positionSeconds,
      required this.isPlaying,
      required this.savedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || playerId != null) {
      map['player_id'] = Variable<String>(playerId);
    }
    if (!nullToAbsent || playerName != null) {
      map['player_name'] = Variable<String>(playerName);
    }
    if (!nullToAbsent || currentTrackJson != null) {
      map['current_track_json'] = Variable<String>(currentTrackJson);
    }
    map['position_seconds'] = Variable<double>(positionSeconds);
    map['is_playing'] = Variable<bool>(isPlaying);
    map['saved_at'] = Variable<DateTime>(savedAt);
    return map;
  }

  PlaybackStateCompanion toCompanion(bool nullToAbsent) {
    return PlaybackStateCompanion(
      id: Value(id),
      playerId: playerId == null && nullToAbsent
          ? const Value.absent()
          : Value(playerId),
      playerName: playerName == null && nullToAbsent
          ? const Value.absent()
          : Value(playerName),
      currentTrackJson: currentTrackJson == null && nullToAbsent
          ? const Value.absent()
          : Value(currentTrackJson),
      positionSeconds: Value(positionSeconds),
      isPlaying: Value(isPlaying),
      savedAt: Value(savedAt),
    );
  }

  factory PlaybackStateData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlaybackStateData(
      id: serializer.fromJson<String>(json['id']),
      playerId: serializer.fromJson<String?>(json['playerId']),
      playerName: serializer.fromJson<String?>(json['playerName']),
      currentTrackJson: serializer.fromJson<String?>(json['currentTrackJson']),
      positionSeconds: serializer.fromJson<double>(json['positionSeconds']),
      isPlaying: serializer.fromJson<bool>(json['isPlaying']),
      savedAt: serializer.fromJson<DateTime>(json['savedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'playerId': serializer.toJson<String?>(playerId),
      'playerName': serializer.toJson<String?>(playerName),
      'currentTrackJson': serializer.toJson<String?>(currentTrackJson),
      'positionSeconds': serializer.toJson<double>(positionSeconds),
      'isPlaying': serializer.toJson<bool>(isPlaying),
      'savedAt': serializer.toJson<DateTime>(savedAt),
    };
  }

  PlaybackStateData copyWith(
          {String? id,
          Value<String?> playerId = const Value.absent(),
          Value<String?> playerName = const Value.absent(),
          Value<String?> currentTrackJson = const Value.absent(),
          double? positionSeconds,
          bool? isPlaying,
          DateTime? savedAt}) =>
      PlaybackStateData(
        id: id ?? this.id,
        playerId: playerId.present ? playerId.value : this.playerId,
        playerName: playerName.present ? playerName.value : this.playerName,
        currentTrackJson: currentTrackJson.present
            ? currentTrackJson.value
            : this.currentTrackJson,
        positionSeconds: positionSeconds ?? this.positionSeconds,
        isPlaying: isPlaying ?? this.isPlaying,
        savedAt: savedAt ?? this.savedAt,
      );
  PlaybackStateData copyWithCompanion(PlaybackStateCompanion data) {
    return PlaybackStateData(
      id: data.id.present ? data.id.value : this.id,
      playerId: data.playerId.present ? data.playerId.value : this.playerId,
      playerName:
          data.playerName.present ? data.playerName.value : this.playerName,
      currentTrackJson: data.currentTrackJson.present
          ? data.currentTrackJson.value
          : this.currentTrackJson,
      positionSeconds: data.positionSeconds.present
          ? data.positionSeconds.value
          : this.positionSeconds,
      isPlaying: data.isPlaying.present ? data.isPlaying.value : this.isPlaying,
      savedAt: data.savedAt.present ? data.savedAt.value : this.savedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlaybackStateData(')
          ..write('id: $id, ')
          ..write('playerId: $playerId, ')
          ..write('playerName: $playerName, ')
          ..write('currentTrackJson: $currentTrackJson, ')
          ..write('positionSeconds: $positionSeconds, ')
          ..write('isPlaying: $isPlaying, ')
          ..write('savedAt: $savedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, playerId, playerName, currentTrackJson,
      positionSeconds, isPlaying, savedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlaybackStateData &&
          other.id == this.id &&
          other.playerId == this.playerId &&
          other.playerName == this.playerName &&
          other.currentTrackJson == this.currentTrackJson &&
          other.positionSeconds == this.positionSeconds &&
          other.isPlaying == this.isPlaying &&
          other.savedAt == this.savedAt);
}

class PlaybackStateCompanion extends UpdateCompanion<PlaybackStateData> {
  final Value<String> id;
  final Value<String?> playerId;
  final Value<String?> playerName;
  final Value<String?> currentTrackJson;
  final Value<double> positionSeconds;
  final Value<bool> isPlaying;
  final Value<DateTime> savedAt;
  final Value<int> rowid;
  const PlaybackStateCompanion({
    this.id = const Value.absent(),
    this.playerId = const Value.absent(),
    this.playerName = const Value.absent(),
    this.currentTrackJson = const Value.absent(),
    this.positionSeconds = const Value.absent(),
    this.isPlaying = const Value.absent(),
    this.savedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlaybackStateCompanion.insert({
    this.id = const Value.absent(),
    this.playerId = const Value.absent(),
    this.playerName = const Value.absent(),
    this.currentTrackJson = const Value.absent(),
    this.positionSeconds = const Value.absent(),
    this.isPlaying = const Value.absent(),
    required DateTime savedAt,
    this.rowid = const Value.absent(),
  }) : savedAt = Value(savedAt);
  static Insertable<PlaybackStateData> custom({
    Expression<String>? id,
    Expression<String>? playerId,
    Expression<String>? playerName,
    Expression<String>? currentTrackJson,
    Expression<double>? positionSeconds,
    Expression<bool>? isPlaying,
    Expression<DateTime>? savedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (playerId != null) 'player_id': playerId,
      if (playerName != null) 'player_name': playerName,
      if (currentTrackJson != null) 'current_track_json': currentTrackJson,
      if (positionSeconds != null) 'position_seconds': positionSeconds,
      if (isPlaying != null) 'is_playing': isPlaying,
      if (savedAt != null) 'saved_at': savedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlaybackStateCompanion copyWith(
      {Value<String>? id,
      Value<String?>? playerId,
      Value<String?>? playerName,
      Value<String?>? currentTrackJson,
      Value<double>? positionSeconds,
      Value<bool>? isPlaying,
      Value<DateTime>? savedAt,
      Value<int>? rowid}) {
    return PlaybackStateCompanion(
      id: id ?? this.id,
      playerId: playerId ?? this.playerId,
      playerName: playerName ?? this.playerName,
      currentTrackJson: currentTrackJson ?? this.currentTrackJson,
      positionSeconds: positionSeconds ?? this.positionSeconds,
      isPlaying: isPlaying ?? this.isPlaying,
      savedAt: savedAt ?? this.savedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (playerId.present) {
      map['player_id'] = Variable<String>(playerId.value);
    }
    if (playerName.present) {
      map['player_name'] = Variable<String>(playerName.value);
    }
    if (currentTrackJson.present) {
      map['current_track_json'] = Variable<String>(currentTrackJson.value);
    }
    if (positionSeconds.present) {
      map['position_seconds'] = Variable<double>(positionSeconds.value);
    }
    if (isPlaying.present) {
      map['is_playing'] = Variable<bool>(isPlaying.value);
    }
    if (savedAt.present) {
      map['saved_at'] = Variable<DateTime>(savedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaybackStateCompanion(')
          ..write('id: $id, ')
          ..write('playerId: $playerId, ')
          ..write('playerName: $playerName, ')
          ..write('currentTrackJson: $currentTrackJson, ')
          ..write('positionSeconds: $positionSeconds, ')
          ..write('isPlaying: $isPlaying, ')
          ..write('savedAt: $savedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedPlayersTable extends CachedPlayers
    with TableInfo<$CachedPlayersTable, CachedPlayer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedPlayersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _playerIdMeta =
      const VerificationMeta('playerId');
  @override
  late final GeneratedColumn<String> playerId = GeneratedColumn<String>(
      'player_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _playerJsonMeta =
      const VerificationMeta('playerJson');
  @override
  late final GeneratedColumn<String> playerJson = GeneratedColumn<String>(
      'player_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _currentTrackJsonMeta =
      const VerificationMeta('currentTrackJson');
  @override
  late final GeneratedColumn<String> currentTrackJson = GeneratedColumn<String>(
      'current_track_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastUpdatedMeta =
      const VerificationMeta('lastUpdated');
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
      'last_updated', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [playerId, playerJson, currentTrackJson, lastUpdated];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_players';
  @override
  VerificationContext validateIntegrity(Insertable<CachedPlayer> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('player_id')) {
      context.handle(_playerIdMeta,
          playerId.isAcceptableOrUnknown(data['player_id']!, _playerIdMeta));
    } else if (isInserting) {
      context.missing(_playerIdMeta);
    }
    if (data.containsKey('player_json')) {
      context.handle(
          _playerJsonMeta,
          playerJson.isAcceptableOrUnknown(
              data['player_json']!, _playerJsonMeta));
    } else if (isInserting) {
      context.missing(_playerJsonMeta);
    }
    if (data.containsKey('current_track_json')) {
      context.handle(
          _currentTrackJsonMeta,
          currentTrackJson.isAcceptableOrUnknown(
              data['current_track_json']!, _currentTrackJsonMeta));
    }
    if (data.containsKey('last_updated')) {
      context.handle(
          _lastUpdatedMeta,
          lastUpdated.isAcceptableOrUnknown(
              data['last_updated']!, _lastUpdatedMeta));
    } else if (isInserting) {
      context.missing(_lastUpdatedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {playerId};
  @override
  CachedPlayer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedPlayer(
      playerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}player_id'])!,
      playerJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}player_json'])!,
      currentTrackJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}current_track_json']),
      lastUpdated: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_updated'])!,
    );
  }

  @override
  $CachedPlayersTable createAlias(String alias) {
    return $CachedPlayersTable(attachedDatabase, alias);
  }
}

class CachedPlayer extends DataClass implements Insertable<CachedPlayer> {
  /// Player ID from Music Assistant
  final String playerId;

  /// Player data as JSON
  final String playerJson;

  /// Current track for this player as JSON (for mini player display)
  final String? currentTrackJson;

  /// When this was last updated
  final DateTime lastUpdated;
  const CachedPlayer(
      {required this.playerId,
      required this.playerJson,
      this.currentTrackJson,
      required this.lastUpdated});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['player_id'] = Variable<String>(playerId);
    map['player_json'] = Variable<String>(playerJson);
    if (!nullToAbsent || currentTrackJson != null) {
      map['current_track_json'] = Variable<String>(currentTrackJson);
    }
    map['last_updated'] = Variable<DateTime>(lastUpdated);
    return map;
  }

  CachedPlayersCompanion toCompanion(bool nullToAbsent) {
    return CachedPlayersCompanion(
      playerId: Value(playerId),
      playerJson: Value(playerJson),
      currentTrackJson: currentTrackJson == null && nullToAbsent
          ? const Value.absent()
          : Value(currentTrackJson),
      lastUpdated: Value(lastUpdated),
    );
  }

  factory CachedPlayer.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedPlayer(
      playerId: serializer.fromJson<String>(json['playerId']),
      playerJson: serializer.fromJson<String>(json['playerJson']),
      currentTrackJson: serializer.fromJson<String?>(json['currentTrackJson']),
      lastUpdated: serializer.fromJson<DateTime>(json['lastUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'playerId': serializer.toJson<String>(playerId),
      'playerJson': serializer.toJson<String>(playerJson),
      'currentTrackJson': serializer.toJson<String?>(currentTrackJson),
      'lastUpdated': serializer.toJson<DateTime>(lastUpdated),
    };
  }

  CachedPlayer copyWith(
          {String? playerId,
          String? playerJson,
          Value<String?> currentTrackJson = const Value.absent(),
          DateTime? lastUpdated}) =>
      CachedPlayer(
        playerId: playerId ?? this.playerId,
        playerJson: playerJson ?? this.playerJson,
        currentTrackJson: currentTrackJson.present
            ? currentTrackJson.value
            : this.currentTrackJson,
        lastUpdated: lastUpdated ?? this.lastUpdated,
      );
  CachedPlayer copyWithCompanion(CachedPlayersCompanion data) {
    return CachedPlayer(
      playerId: data.playerId.present ? data.playerId.value : this.playerId,
      playerJson:
          data.playerJson.present ? data.playerJson.value : this.playerJson,
      currentTrackJson: data.currentTrackJson.present
          ? data.currentTrackJson.value
          : this.currentTrackJson,
      lastUpdated:
          data.lastUpdated.present ? data.lastUpdated.value : this.lastUpdated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedPlayer(')
          ..write('playerId: $playerId, ')
          ..write('playerJson: $playerJson, ')
          ..write('currentTrackJson: $currentTrackJson, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(playerId, playerJson, currentTrackJson, lastUpdated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedPlayer &&
          other.playerId == this.playerId &&
          other.playerJson == this.playerJson &&
          other.currentTrackJson == this.currentTrackJson &&
          other.lastUpdated == this.lastUpdated);
}

class CachedPlayersCompanion extends UpdateCompanion<CachedPlayer> {
  final Value<String> playerId;
  final Value<String> playerJson;
  final Value<String?> currentTrackJson;
  final Value<DateTime> lastUpdated;
  final Value<int> rowid;
  const CachedPlayersCompanion({
    this.playerId = const Value.absent(),
    this.playerJson = const Value.absent(),
    this.currentTrackJson = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedPlayersCompanion.insert({
    required String playerId,
    required String playerJson,
    this.currentTrackJson = const Value.absent(),
    required DateTime lastUpdated,
    this.rowid = const Value.absent(),
  })  : playerId = Value(playerId),
        playerJson = Value(playerJson),
        lastUpdated = Value(lastUpdated);
  static Insertable<CachedPlayer> custom({
    Expression<String>? playerId,
    Expression<String>? playerJson,
    Expression<String>? currentTrackJson,
    Expression<DateTime>? lastUpdated,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (playerId != null) 'player_id': playerId,
      if (playerJson != null) 'player_json': playerJson,
      if (currentTrackJson != null) 'current_track_json': currentTrackJson,
      if (lastUpdated != null) 'last_updated': lastUpdated,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedPlayersCompanion copyWith(
      {Value<String>? playerId,
      Value<String>? playerJson,
      Value<String?>? currentTrackJson,
      Value<DateTime>? lastUpdated,
      Value<int>? rowid}) {
    return CachedPlayersCompanion(
      playerId: playerId ?? this.playerId,
      playerJson: playerJson ?? this.playerJson,
      currentTrackJson: currentTrackJson ?? this.currentTrackJson,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (playerId.present) {
      map['player_id'] = Variable<String>(playerId.value);
    }
    if (playerJson.present) {
      map['player_json'] = Variable<String>(playerJson.value);
    }
    if (currentTrackJson.present) {
      map['current_track_json'] = Variable<String>(currentTrackJson.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedPlayersCompanion(')
          ..write('playerId: $playerId, ')
          ..write('playerJson: $playerJson, ')
          ..write('currentTrackJson: $currentTrackJson, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedQueueTable extends CachedQueue
    with TableInfo<$CachedQueueTable, CachedQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _playerIdMeta =
      const VerificationMeta('playerId');
  @override
  late final GeneratedColumn<String> playerId = GeneratedColumn<String>(
      'player_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _itemJsonMeta =
      const VerificationMeta('itemJson');
  @override
  late final GeneratedColumn<String> itemJson = GeneratedColumn<String>(
      'item_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _positionMeta =
      const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, playerId, itemJson, position];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_queue';
  @override
  VerificationContext validateIntegrity(Insertable<CachedQueueData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('player_id')) {
      context.handle(_playerIdMeta,
          playerId.isAcceptableOrUnknown(data['player_id']!, _playerIdMeta));
    } else if (isInserting) {
      context.missing(_playerIdMeta);
    }
    if (data.containsKey('item_json')) {
      context.handle(_itemJsonMeta,
          itemJson.isAcceptableOrUnknown(data['item_json']!, _itemJsonMeta));
    } else if (isInserting) {
      context.missing(_itemJsonMeta);
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta,
          position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedQueueData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      playerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}player_id'])!,
      itemJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_json'])!,
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
    );
  }

  @override
  $CachedQueueTable createAlias(String alias) {
    return $CachedQueueTable(attachedDatabase, alias);
  }
}

class CachedQueueData extends DataClass implements Insertable<CachedQueueData> {
  /// Auto-incrementing ID for ordering
  final int id;

  /// Player ID this queue belongs to
  final String playerId;

  /// Queue item as JSON
  final String itemJson;

  /// Position in queue
  final int position;
  const CachedQueueData(
      {required this.id,
      required this.playerId,
      required this.itemJson,
      required this.position});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['player_id'] = Variable<String>(playerId);
    map['item_json'] = Variable<String>(itemJson);
    map['position'] = Variable<int>(position);
    return map;
  }

  CachedQueueCompanion toCompanion(bool nullToAbsent) {
    return CachedQueueCompanion(
      id: Value(id),
      playerId: Value(playerId),
      itemJson: Value(itemJson),
      position: Value(position),
    );
  }

  factory CachedQueueData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedQueueData(
      id: serializer.fromJson<int>(json['id']),
      playerId: serializer.fromJson<String>(json['playerId']),
      itemJson: serializer.fromJson<String>(json['itemJson']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'playerId': serializer.toJson<String>(playerId),
      'itemJson': serializer.toJson<String>(itemJson),
      'position': serializer.toJson<int>(position),
    };
  }

  CachedQueueData copyWith(
          {int? id, String? playerId, String? itemJson, int? position}) =>
      CachedQueueData(
        id: id ?? this.id,
        playerId: playerId ?? this.playerId,
        itemJson: itemJson ?? this.itemJson,
        position: position ?? this.position,
      );
  CachedQueueData copyWithCompanion(CachedQueueCompanion data) {
    return CachedQueueData(
      id: data.id.present ? data.id.value : this.id,
      playerId: data.playerId.present ? data.playerId.value : this.playerId,
      itemJson: data.itemJson.present ? data.itemJson.value : this.itemJson,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedQueueData(')
          ..write('id: $id, ')
          ..write('playerId: $playerId, ')
          ..write('itemJson: $itemJson, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, playerId, itemJson, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedQueueData &&
          other.id == this.id &&
          other.playerId == this.playerId &&
          other.itemJson == this.itemJson &&
          other.position == this.position);
}

class CachedQueueCompanion extends UpdateCompanion<CachedQueueData> {
  final Value<int> id;
  final Value<String> playerId;
  final Value<String> itemJson;
  final Value<int> position;
  const CachedQueueCompanion({
    this.id = const Value.absent(),
    this.playerId = const Value.absent(),
    this.itemJson = const Value.absent(),
    this.position = const Value.absent(),
  });
  CachedQueueCompanion.insert({
    this.id = const Value.absent(),
    required String playerId,
    required String itemJson,
    required int position,
  })  : playerId = Value(playerId),
        itemJson = Value(itemJson),
        position = Value(position);
  static Insertable<CachedQueueData> custom({
    Expression<int>? id,
    Expression<String>? playerId,
    Expression<String>? itemJson,
    Expression<int>? position,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (playerId != null) 'player_id': playerId,
      if (itemJson != null) 'item_json': itemJson,
      if (position != null) 'position': position,
    });
  }

  CachedQueueCompanion copyWith(
      {Value<int>? id,
      Value<String>? playerId,
      Value<String>? itemJson,
      Value<int>? position}) {
    return CachedQueueCompanion(
      id: id ?? this.id,
      playerId: playerId ?? this.playerId,
      itemJson: itemJson ?? this.itemJson,
      position: position ?? this.position,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (playerId.present) {
      map['player_id'] = Variable<String>(playerId.value);
    }
    if (itemJson.present) {
      map['item_json'] = Variable<String>(itemJson.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedQueueCompanion(')
          ..write('id: $id, ')
          ..write('playerId: $playerId, ')
          ..write('itemJson: $itemJson, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }
}

class $HomeRowCacheTable extends HomeRowCache
    with TableInfo<$HomeRowCacheTable, HomeRowCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HomeRowCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _rowTypeMeta =
      const VerificationMeta('rowType');
  @override
  late final GeneratedColumn<String> rowType = GeneratedColumn<String>(
      'row_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _itemsJsonMeta =
      const VerificationMeta('itemsJson');
  @override
  late final GeneratedColumn<String> itemsJson = GeneratedColumn<String>(
      'items_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastUpdatedMeta =
      const VerificationMeta('lastUpdated');
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
      'last_updated', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [rowType, itemsJson, lastUpdated];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'home_row_cache';
  @override
  VerificationContext validateIntegrity(Insertable<HomeRowCacheData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('row_type')) {
      context.handle(_rowTypeMeta,
          rowType.isAcceptableOrUnknown(data['row_type']!, _rowTypeMeta));
    } else if (isInserting) {
      context.missing(_rowTypeMeta);
    }
    if (data.containsKey('items_json')) {
      context.handle(_itemsJsonMeta,
          itemsJson.isAcceptableOrUnknown(data['items_json']!, _itemsJsonMeta));
    } else if (isInserting) {
      context.missing(_itemsJsonMeta);
    }
    if (data.containsKey('last_updated')) {
      context.handle(
          _lastUpdatedMeta,
          lastUpdated.isAcceptableOrUnknown(
              data['last_updated']!, _lastUpdatedMeta));
    } else if (isInserting) {
      context.missing(_lastUpdatedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {rowType};
  @override
  HomeRowCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HomeRowCacheData(
      rowType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}row_type'])!,
      itemsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}items_json'])!,
      lastUpdated: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_updated'])!,
    );
  }

  @override
  $HomeRowCacheTable createAlias(String alias) {
    return $HomeRowCacheTable(attachedDatabase, alias);
  }
}

class HomeRowCacheData extends DataClass
    implements Insertable<HomeRowCacheData> {
  /// Row type: 'recent_albums', 'discover_artists', 'discover_albums'
  final String rowType;

  /// Serialized list of items as JSON array
  final String itemsJson;

  /// When this was last updated
  final DateTime lastUpdated;
  const HomeRowCacheData(
      {required this.rowType,
      required this.itemsJson,
      required this.lastUpdated});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['row_type'] = Variable<String>(rowType);
    map['items_json'] = Variable<String>(itemsJson);
    map['last_updated'] = Variable<DateTime>(lastUpdated);
    return map;
  }

  HomeRowCacheCompanion toCompanion(bool nullToAbsent) {
    return HomeRowCacheCompanion(
      rowType: Value(rowType),
      itemsJson: Value(itemsJson),
      lastUpdated: Value(lastUpdated),
    );
  }

  factory HomeRowCacheData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HomeRowCacheData(
      rowType: serializer.fromJson<String>(json['rowType']),
      itemsJson: serializer.fromJson<String>(json['itemsJson']),
      lastUpdated: serializer.fromJson<DateTime>(json['lastUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rowType': serializer.toJson<String>(rowType),
      'itemsJson': serializer.toJson<String>(itemsJson),
      'lastUpdated': serializer.toJson<DateTime>(lastUpdated),
    };
  }

  HomeRowCacheData copyWith(
          {String? rowType, String? itemsJson, DateTime? lastUpdated}) =>
      HomeRowCacheData(
        rowType: rowType ?? this.rowType,
        itemsJson: itemsJson ?? this.itemsJson,
        lastUpdated: lastUpdated ?? this.lastUpdated,
      );
  HomeRowCacheData copyWithCompanion(HomeRowCacheCompanion data) {
    return HomeRowCacheData(
      rowType: data.rowType.present ? data.rowType.value : this.rowType,
      itemsJson: data.itemsJson.present ? data.itemsJson.value : this.itemsJson,
      lastUpdated:
          data.lastUpdated.present ? data.lastUpdated.value : this.lastUpdated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HomeRowCacheData(')
          ..write('rowType: $rowType, ')
          ..write('itemsJson: $itemsJson, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(rowType, itemsJson, lastUpdated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HomeRowCacheData &&
          other.rowType == this.rowType &&
          other.itemsJson == this.itemsJson &&
          other.lastUpdated == this.lastUpdated);
}

class HomeRowCacheCompanion extends UpdateCompanion<HomeRowCacheData> {
  final Value<String> rowType;
  final Value<String> itemsJson;
  final Value<DateTime> lastUpdated;
  final Value<int> rowid;
  const HomeRowCacheCompanion({
    this.rowType = const Value.absent(),
    this.itemsJson = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HomeRowCacheCompanion.insert({
    required String rowType,
    required String itemsJson,
    required DateTime lastUpdated,
    this.rowid = const Value.absent(),
  })  : rowType = Value(rowType),
        itemsJson = Value(itemsJson),
        lastUpdated = Value(lastUpdated);
  static Insertable<HomeRowCacheData> custom({
    Expression<String>? rowType,
    Expression<String>? itemsJson,
    Expression<DateTime>? lastUpdated,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (rowType != null) 'row_type': rowType,
      if (itemsJson != null) 'items_json': itemsJson,
      if (lastUpdated != null) 'last_updated': lastUpdated,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HomeRowCacheCompanion copyWith(
      {Value<String>? rowType,
      Value<String>? itemsJson,
      Value<DateTime>? lastUpdated,
      Value<int>? rowid}) {
    return HomeRowCacheCompanion(
      rowType: rowType ?? this.rowType,
      itemsJson: itemsJson ?? this.itemsJson,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rowType.present) {
      map['row_type'] = Variable<String>(rowType.value);
    }
    if (itemsJson.present) {
      map['items_json'] = Variable<String>(itemsJson.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HomeRowCacheCompanion(')
          ..write('rowType: $rowType, ')
          ..write('itemsJson: $itemsJson, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SearchHistoryTable extends SearchHistory
    with TableInfo<$SearchHistoryTable, SearchHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SearchHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _queryMeta = const VerificationMeta('query');
  @override
  late final GeneratedColumn<String> query = GeneratedColumn<String>(
      'query', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _searchedAtMeta =
      const VerificationMeta('searchedAt');
  @override
  late final GeneratedColumn<DateTime> searchedAt = GeneratedColumn<DateTime>(
      'searched_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, query, searchedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'search_history';
  @override
  VerificationContext validateIntegrity(Insertable<SearchHistoryData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('query')) {
      context.handle(
          _queryMeta, query.isAcceptableOrUnknown(data['query']!, _queryMeta));
    } else if (isInserting) {
      context.missing(_queryMeta);
    }
    if (data.containsKey('searched_at')) {
      context.handle(
          _searchedAtMeta,
          searchedAt.isAcceptableOrUnknown(
              data['searched_at']!, _searchedAtMeta));
    } else if (isInserting) {
      context.missing(_searchedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SearchHistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SearchHistoryData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      query: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}query'])!,
      searchedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}searched_at'])!,
    );
  }

  @override
  $SearchHistoryTable createAlias(String alias) {
    return $SearchHistoryTable(attachedDatabase, alias);
  }
}

class SearchHistoryData extends DataClass
    implements Insertable<SearchHistoryData> {
  /// Auto-incrementing ID
  final int id;

  /// The search query
  final String query;

  /// When the search was performed
  final DateTime searchedAt;
  const SearchHistoryData(
      {required this.id, required this.query, required this.searchedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['query'] = Variable<String>(query);
    map['searched_at'] = Variable<DateTime>(searchedAt);
    return map;
  }

  SearchHistoryCompanion toCompanion(bool nullToAbsent) {
    return SearchHistoryCompanion(
      id: Value(id),
      query: Value(query),
      searchedAt: Value(searchedAt),
    );
  }

  factory SearchHistoryData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SearchHistoryData(
      id: serializer.fromJson<int>(json['id']),
      query: serializer.fromJson<String>(json['query']),
      searchedAt: serializer.fromJson<DateTime>(json['searchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'query': serializer.toJson<String>(query),
      'searchedAt': serializer.toJson<DateTime>(searchedAt),
    };
  }

  SearchHistoryData copyWith({int? id, String? query, DateTime? searchedAt}) =>
      SearchHistoryData(
        id: id ?? this.id,
        query: query ?? this.query,
        searchedAt: searchedAt ?? this.searchedAt,
      );
  SearchHistoryData copyWithCompanion(SearchHistoryCompanion data) {
    return SearchHistoryData(
      id: data.id.present ? data.id.value : this.id,
      query: data.query.present ? data.query.value : this.query,
      searchedAt:
          data.searchedAt.present ? data.searchedAt.value : this.searchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SearchHistoryData(')
          ..write('id: $id, ')
          ..write('query: $query, ')
          ..write('searchedAt: $searchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, query, searchedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SearchHistoryData &&
          other.id == this.id &&
          other.query == this.query &&
          other.searchedAt == this.searchedAt);
}

class SearchHistoryCompanion extends UpdateCompanion<SearchHistoryData> {
  final Value<int> id;
  final Value<String> query;
  final Value<DateTime> searchedAt;
  const SearchHistoryCompanion({
    this.id = const Value.absent(),
    this.query = const Value.absent(),
    this.searchedAt = const Value.absent(),
  });
  SearchHistoryCompanion.insert({
    this.id = const Value.absent(),
    required String query,
    required DateTime searchedAt,
  })  : query = Value(query),
        searchedAt = Value(searchedAt);
  static Insertable<SearchHistoryData> custom({
    Expression<int>? id,
    Expression<String>? query,
    Expression<DateTime>? searchedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (query != null) 'query': query,
      if (searchedAt != null) 'searched_at': searchedAt,
    });
  }

  SearchHistoryCompanion copyWith(
      {Value<int>? id, Value<String>? query, Value<DateTime>? searchedAt}) {
    return SearchHistoryCompanion(
      id: id ?? this.id,
      query: query ?? this.query,
      searchedAt: searchedAt ?? this.searchedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (query.present) {
      map['query'] = Variable<String>(query.value);
    }
    if (searchedAt.present) {
      map['searched_at'] = Variable<DateTime>(searchedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SearchHistoryCompanion(')
          ..write('id: $id, ')
          ..write('query: $query, ')
          ..write('searchedAt: $searchedAt')
          ..write(')'))
        .toString();
  }
}

class $DetailTrackCacheTable extends DetailTrackCache
    with TableInfo<$DetailTrackCacheTable, DetailTrackCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DetailTrackCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _cacheKeyMeta =
      const VerificationMeta('cacheKey');
  @override
  late final GeneratedColumn<String> cacheKey = GeneratedColumn<String>(
      'cache_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _parentTypeMeta =
      const VerificationMeta('parentType');
  @override
  late final GeneratedColumn<String> parentType = GeneratedColumn<String>(
      'parent_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _parentKeyMeta =
      const VerificationMeta('parentKey');
  @override
  late final GeneratedColumn<String> parentKey = GeneratedColumn<String>(
      'parent_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tracksJsonMeta =
      const VerificationMeta('tracksJson');
  @override
  late final GeneratedColumn<String> tracksJson = GeneratedColumn<String>(
      'tracks_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastFetchedMeta =
      const VerificationMeta('lastFetched');
  @override
  late final GeneratedColumn<DateTime> lastFetched = GeneratedColumn<DateTime>(
      'last_fetched', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _lastAccessedMeta =
      const VerificationMeta('lastAccessed');
  @override
  late final GeneratedColumn<DateTime> lastAccessed = GeneratedColumn<DateTime>(
      'last_accessed', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [cacheKey, parentType, parentKey, tracksJson, lastFetched, lastAccessed];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'detail_track_cache';
  @override
  VerificationContext validateIntegrity(
      Insertable<DetailTrackCacheData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('cache_key')) {
      context.handle(_cacheKeyMeta,
          cacheKey.isAcceptableOrUnknown(data['cache_key']!, _cacheKeyMeta));
    } else if (isInserting) {
      context.missing(_cacheKeyMeta);
    }
    if (data.containsKey('parent_type')) {
      context.handle(
          _parentTypeMeta,
          parentType.isAcceptableOrUnknown(
              data['parent_type']!, _parentTypeMeta));
    } else if (isInserting) {
      context.missing(_parentTypeMeta);
    }
    if (data.containsKey('parent_key')) {
      context.handle(_parentKeyMeta,
          parentKey.isAcceptableOrUnknown(data['parent_key']!, _parentKeyMeta));
    } else if (isInserting) {
      context.missing(_parentKeyMeta);
    }
    if (data.containsKey('tracks_json')) {
      context.handle(
          _tracksJsonMeta,
          tracksJson.isAcceptableOrUnknown(
              data['tracks_json']!, _tracksJsonMeta));
    } else if (isInserting) {
      context.missing(_tracksJsonMeta);
    }
    if (data.containsKey('last_fetched')) {
      context.handle(
          _lastFetchedMeta,
          lastFetched.isAcceptableOrUnknown(
              data['last_fetched']!, _lastFetchedMeta));
    } else if (isInserting) {
      context.missing(_lastFetchedMeta);
    }
    if (data.containsKey('last_accessed')) {
      context.handle(
          _lastAccessedMeta,
          lastAccessed.isAcceptableOrUnknown(
              data['last_accessed']!, _lastAccessedMeta));
    } else if (isInserting) {
      context.missing(_lastAccessedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {cacheKey};
  @override
  DetailTrackCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DetailTrackCacheData(
      cacheKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cache_key'])!,
      parentType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}parent_type'])!,
      parentKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}parent_key'])!,
      tracksJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tracks_json'])!,
      lastFetched: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_fetched'])!,
      lastAccessed: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_accessed'])!,
    );
  }

  @override
  $DetailTrackCacheTable createAlias(String alias) {
    return $DetailTrackCacheTable(attachedDatabase, alias);
  }
}

class DetailTrackCacheData extends DataClass
    implements Insertable<DetailTrackCacheData> {
  /// Composite key: "{parentType}_{parentKey}"
  final String cacheKey;

  /// Type: 'album' or 'playlist'
  final String parentType;

  /// The parent item's cache key (e.g., "provider_itemId")
  final String parentKey;

  /// Serialized list of tracks as JSON array
  final String tracksJson;

  /// When this was fetched from API
  final DateTime lastFetched;

  /// When this was last accessed (for LRU eviction)
  final DateTime lastAccessed;
  const DetailTrackCacheData(
      {required this.cacheKey,
      required this.parentType,
      required this.parentKey,
      required this.tracksJson,
      required this.lastFetched,
      required this.lastAccessed});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['cache_key'] = Variable<String>(cacheKey);
    map['parent_type'] = Variable<String>(parentType);
    map['parent_key'] = Variable<String>(parentKey);
    map['tracks_json'] = Variable<String>(tracksJson);
    map['last_fetched'] = Variable<DateTime>(lastFetched);
    map['last_accessed'] = Variable<DateTime>(lastAccessed);
    return map;
  }

  DetailTrackCacheCompanion toCompanion(bool nullToAbsent) {
    return DetailTrackCacheCompanion(
      cacheKey: Value(cacheKey),
      parentType: Value(parentType),
      parentKey: Value(parentKey),
      tracksJson: Value(tracksJson),
      lastFetched: Value(lastFetched),
      lastAccessed: Value(lastAccessed),
    );
  }

  factory DetailTrackCacheData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DetailTrackCacheData(
      cacheKey: serializer.fromJson<String>(json['cacheKey']),
      parentType: serializer.fromJson<String>(json['parentType']),
      parentKey: serializer.fromJson<String>(json['parentKey']),
      tracksJson: serializer.fromJson<String>(json['tracksJson']),
      lastFetched: serializer.fromJson<DateTime>(json['lastFetched']),
      lastAccessed: serializer.fromJson<DateTime>(json['lastAccessed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cacheKey': serializer.toJson<String>(cacheKey),
      'parentType': serializer.toJson<String>(parentType),
      'parentKey': serializer.toJson<String>(parentKey),
      'tracksJson': serializer.toJson<String>(tracksJson),
      'lastFetched': serializer.toJson<DateTime>(lastFetched),
      'lastAccessed': serializer.toJson<DateTime>(lastAccessed),
    };
  }

  DetailTrackCacheData copyWith(
          {String? cacheKey,
          String? parentType,
          String? parentKey,
          String? tracksJson,
          DateTime? lastFetched,
          DateTime? lastAccessed}) =>
      DetailTrackCacheData(
        cacheKey: cacheKey ?? this.cacheKey,
        parentType: parentType ?? this.parentType,
        parentKey: parentKey ?? this.parentKey,
        tracksJson: tracksJson ?? this.tracksJson,
        lastFetched: lastFetched ?? this.lastFetched,
        lastAccessed: lastAccessed ?? this.lastAccessed,
      );
  DetailTrackCacheData copyWithCompanion(DetailTrackCacheCompanion data) {
    return DetailTrackCacheData(
      cacheKey: data.cacheKey.present ? data.cacheKey.value : this.cacheKey,
      parentType:
          data.parentType.present ? data.parentType.value : this.parentType,
      parentKey: data.parentKey.present ? data.parentKey.value : this.parentKey,
      tracksJson:
          data.tracksJson.present ? data.tracksJson.value : this.tracksJson,
      lastFetched:
          data.lastFetched.present ? data.lastFetched.value : this.lastFetched,
      lastAccessed: data.lastAccessed.present
          ? data.lastAccessed.value
          : this.lastAccessed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DetailTrackCacheData(')
          ..write('cacheKey: $cacheKey, ')
          ..write('parentType: $parentType, ')
          ..write('parentKey: $parentKey, ')
          ..write('tracksJson: $tracksJson, ')
          ..write('lastFetched: $lastFetched, ')
          ..write('lastAccessed: $lastAccessed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      cacheKey, parentType, parentKey, tracksJson, lastFetched, lastAccessed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DetailTrackCacheData &&
          other.cacheKey == this.cacheKey &&
          other.parentType == this.parentType &&
          other.parentKey == this.parentKey &&
          other.tracksJson == this.tracksJson &&
          other.lastFetched == this.lastFetched &&
          other.lastAccessed == this.lastAccessed);
}

class DetailTrackCacheCompanion extends UpdateCompanion<DetailTrackCacheData> {
  final Value<String> cacheKey;
  final Value<String> parentType;
  final Value<String> parentKey;
  final Value<String> tracksJson;
  final Value<DateTime> lastFetched;
  final Value<DateTime> lastAccessed;
  final Value<int> rowid;
  const DetailTrackCacheCompanion({
    this.cacheKey = const Value.absent(),
    this.parentType = const Value.absent(),
    this.parentKey = const Value.absent(),
    this.tracksJson = const Value.absent(),
    this.lastFetched = const Value.absent(),
    this.lastAccessed = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DetailTrackCacheCompanion.insert({
    required String cacheKey,
    required String parentType,
    required String parentKey,
    required String tracksJson,
    required DateTime lastFetched,
    required DateTime lastAccessed,
    this.rowid = const Value.absent(),
  })  : cacheKey = Value(cacheKey),
        parentType = Value(parentType),
        parentKey = Value(parentKey),
        tracksJson = Value(tracksJson),
        lastFetched = Value(lastFetched),
        lastAccessed = Value(lastAccessed);
  static Insertable<DetailTrackCacheData> custom({
    Expression<String>? cacheKey,
    Expression<String>? parentType,
    Expression<String>? parentKey,
    Expression<String>? tracksJson,
    Expression<DateTime>? lastFetched,
    Expression<DateTime>? lastAccessed,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (cacheKey != null) 'cache_key': cacheKey,
      if (parentType != null) 'parent_type': parentType,
      if (parentKey != null) 'parent_key': parentKey,
      if (tracksJson != null) 'tracks_json': tracksJson,
      if (lastFetched != null) 'last_fetched': lastFetched,
      if (lastAccessed != null) 'last_accessed': lastAccessed,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DetailTrackCacheCompanion copyWith(
      {Value<String>? cacheKey,
      Value<String>? parentType,
      Value<String>? parentKey,
      Value<String>? tracksJson,
      Value<DateTime>? lastFetched,
      Value<DateTime>? lastAccessed,
      Value<int>? rowid}) {
    return DetailTrackCacheCompanion(
      cacheKey: cacheKey ?? this.cacheKey,
      parentType: parentType ?? this.parentType,
      parentKey: parentKey ?? this.parentKey,
      tracksJson: tracksJson ?? this.tracksJson,
      lastFetched: lastFetched ?? this.lastFetched,
      lastAccessed: lastAccessed ?? this.lastAccessed,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cacheKey.present) {
      map['cache_key'] = Variable<String>(cacheKey.value);
    }
    if (parentType.present) {
      map['parent_type'] = Variable<String>(parentType.value);
    }
    if (parentKey.present) {
      map['parent_key'] = Variable<String>(parentKey.value);
    }
    if (tracksJson.present) {
      map['tracks_json'] = Variable<String>(tracksJson.value);
    }
    if (lastFetched.present) {
      map['last_fetched'] = Variable<DateTime>(lastFetched.value);
    }
    if (lastAccessed.present) {
      map['last_accessed'] = Variable<DateTime>(lastAccessed.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DetailTrackCacheCompanion(')
          ..write('cacheKey: $cacheKey, ')
          ..write('parentType: $parentType, ')
          ..write('parentKey: $parentKey, ')
          ..write('tracksJson: $tracksJson, ')
          ..write('lastFetched: $lastFetched, ')
          ..write('lastAccessed: $lastAccessed, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ArtistsTable extends Artists
    with TableInfo<$ArtistsTable, ArtistEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ArtistsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _providerMeta =
      const VerificationMeta('provider');
  @override
  late final GeneratedColumn<String> provider = GeneratedColumn<String>(
      'provider', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
      'item_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sortNameMeta =
      const VerificationMeta('sortName');
  @override
  late final GeneratedColumn<String> sortName = GeneratedColumn<String>(
      'sort_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _uriMeta = const VerificationMeta('uri');
  @override
  late final GeneratedColumn<String> uri = GeneratedColumn<String>(
      'uri', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _favoriteMeta =
      const VerificationMeta('favorite');
  @override
  late final GeneratedColumn<bool> favorite = GeneratedColumn<bool>(
      'favorite', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("favorite" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _inLibraryMeta =
      const VerificationMeta('inLibrary');
  @override
  late final GeneratedColumn<bool> inLibrary = GeneratedColumn<bool>(
      'in_library', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("in_library" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _metadataJsonMeta =
      const VerificationMeta('metadataJson');
  @override
  late final GeneratedColumn<String> metadataJson = GeneratedColumn<String>(
      'metadata_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastSyncedMeta =
      const VerificationMeta('lastSynced');
  @override
  late final GeneratedColumn<DateTime> lastSynced = GeneratedColumn<DateTime>(
      'last_synced', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        provider,
        itemId,
        name,
        sortName,
        uri,
        favorite,
        inLibrary,
        metadataJson,
        lastSynced
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'artists';
  @override
  VerificationContext validateIntegrity(Insertable<ArtistEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('provider')) {
      context.handle(_providerMeta,
          provider.isAcceptableOrUnknown(data['provider']!, _providerMeta));
    } else if (isInserting) {
      context.missing(_providerMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sort_name')) {
      context.handle(_sortNameMeta,
          sortName.isAcceptableOrUnknown(data['sort_name']!, _sortNameMeta));
    }
    if (data.containsKey('uri')) {
      context.handle(
          _uriMeta, uri.isAcceptableOrUnknown(data['uri']!, _uriMeta));
    }
    if (data.containsKey('favorite')) {
      context.handle(_favoriteMeta,
          favorite.isAcceptableOrUnknown(data['favorite']!, _favoriteMeta));
    }
    if (data.containsKey('in_library')) {
      context.handle(_inLibraryMeta,
          inLibrary.isAcceptableOrUnknown(data['in_library']!, _inLibraryMeta));
    }
    if (data.containsKey('metadata_json')) {
      context.handle(
          _metadataJsonMeta,
          metadataJson.isAcceptableOrUnknown(
              data['metadata_json']!, _metadataJsonMeta));
    }
    if (data.containsKey('last_synced')) {
      context.handle(
          _lastSyncedMeta,
          lastSynced.isAcceptableOrUnknown(
              data['last_synced']!, _lastSyncedMeta));
    } else if (isInserting) {
      context.missing(_lastSyncedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {provider, itemId};
  @override
  ArtistEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ArtistEntity(
      provider: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}provider'])!,
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      sortName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sort_name']),
      uri: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uri']),
      favorite: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}favorite'])!,
      inLibrary: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}in_library'])!,
      metadataJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metadata_json']),
      lastSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_synced'])!,
    );
  }

  @override
  $ArtistsTable createAlias(String alias) {
    return $ArtistsTable(attachedDatabase, alias);
  }
}

class ArtistEntity extends DataClass implements Insertable<ArtistEntity> {
  final String provider;
  final String itemId;
  final String name;
  final String? sortName;
  final String? uri;
  final bool favorite;
  final bool inLibrary;

  /// Anything not modeled as its own column (images, description, etc.)
  final String? metadataJson;
  final DateTime lastSynced;
  const ArtistEntity(
      {required this.provider,
      required this.itemId,
      required this.name,
      this.sortName,
      this.uri,
      required this.favorite,
      required this.inLibrary,
      this.metadataJson,
      required this.lastSynced});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['provider'] = Variable<String>(provider);
    map['item_id'] = Variable<String>(itemId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || sortName != null) {
      map['sort_name'] = Variable<String>(sortName);
    }
    if (!nullToAbsent || uri != null) {
      map['uri'] = Variable<String>(uri);
    }
    map['favorite'] = Variable<bool>(favorite);
    map['in_library'] = Variable<bool>(inLibrary);
    if (!nullToAbsent || metadataJson != null) {
      map['metadata_json'] = Variable<String>(metadataJson);
    }
    map['last_synced'] = Variable<DateTime>(lastSynced);
    return map;
  }

  ArtistsCompanion toCompanion(bool nullToAbsent) {
    return ArtistsCompanion(
      provider: Value(provider),
      itemId: Value(itemId),
      name: Value(name),
      sortName: sortName == null && nullToAbsent
          ? const Value.absent()
          : Value(sortName),
      uri: uri == null && nullToAbsent ? const Value.absent() : Value(uri),
      favorite: Value(favorite),
      inLibrary: Value(inLibrary),
      metadataJson: metadataJson == null && nullToAbsent
          ? const Value.absent()
          : Value(metadataJson),
      lastSynced: Value(lastSynced),
    );
  }

  factory ArtistEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ArtistEntity(
      provider: serializer.fromJson<String>(json['provider']),
      itemId: serializer.fromJson<String>(json['itemId']),
      name: serializer.fromJson<String>(json['name']),
      sortName: serializer.fromJson<String?>(json['sortName']),
      uri: serializer.fromJson<String?>(json['uri']),
      favorite: serializer.fromJson<bool>(json['favorite']),
      inLibrary: serializer.fromJson<bool>(json['inLibrary']),
      metadataJson: serializer.fromJson<String?>(json['metadataJson']),
      lastSynced: serializer.fromJson<DateTime>(json['lastSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'provider': serializer.toJson<String>(provider),
      'itemId': serializer.toJson<String>(itemId),
      'name': serializer.toJson<String>(name),
      'sortName': serializer.toJson<String?>(sortName),
      'uri': serializer.toJson<String?>(uri),
      'favorite': serializer.toJson<bool>(favorite),
      'inLibrary': serializer.toJson<bool>(inLibrary),
      'metadataJson': serializer.toJson<String?>(metadataJson),
      'lastSynced': serializer.toJson<DateTime>(lastSynced),
    };
  }

  ArtistEntity copyWith(
          {String? provider,
          String? itemId,
          String? name,
          Value<String?> sortName = const Value.absent(),
          Value<String?> uri = const Value.absent(),
          bool? favorite,
          bool? inLibrary,
          Value<String?> metadataJson = const Value.absent(),
          DateTime? lastSynced}) =>
      ArtistEntity(
        provider: provider ?? this.provider,
        itemId: itemId ?? this.itemId,
        name: name ?? this.name,
        sortName: sortName.present ? sortName.value : this.sortName,
        uri: uri.present ? uri.value : this.uri,
        favorite: favorite ?? this.favorite,
        inLibrary: inLibrary ?? this.inLibrary,
        metadataJson:
            metadataJson.present ? metadataJson.value : this.metadataJson,
        lastSynced: lastSynced ?? this.lastSynced,
      );
  ArtistEntity copyWithCompanion(ArtistsCompanion data) {
    return ArtistEntity(
      provider: data.provider.present ? data.provider.value : this.provider,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      name: data.name.present ? data.name.value : this.name,
      sortName: data.sortName.present ? data.sortName.value : this.sortName,
      uri: data.uri.present ? data.uri.value : this.uri,
      favorite: data.favorite.present ? data.favorite.value : this.favorite,
      inLibrary: data.inLibrary.present ? data.inLibrary.value : this.inLibrary,
      metadataJson: data.metadataJson.present
          ? data.metadataJson.value
          : this.metadataJson,
      lastSynced:
          data.lastSynced.present ? data.lastSynced.value : this.lastSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ArtistEntity(')
          ..write('provider: $provider, ')
          ..write('itemId: $itemId, ')
          ..write('name: $name, ')
          ..write('sortName: $sortName, ')
          ..write('uri: $uri, ')
          ..write('favorite: $favorite, ')
          ..write('inLibrary: $inLibrary, ')
          ..write('metadataJson: $metadataJson, ')
          ..write('lastSynced: $lastSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(provider, itemId, name, sortName, uri,
      favorite, inLibrary, metadataJson, lastSynced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ArtistEntity &&
          other.provider == this.provider &&
          other.itemId == this.itemId &&
          other.name == this.name &&
          other.sortName == this.sortName &&
          other.uri == this.uri &&
          other.favorite == this.favorite &&
          other.inLibrary == this.inLibrary &&
          other.metadataJson == this.metadataJson &&
          other.lastSynced == this.lastSynced);
}

class ArtistsCompanion extends UpdateCompanion<ArtistEntity> {
  final Value<String> provider;
  final Value<String> itemId;
  final Value<String> name;
  final Value<String?> sortName;
  final Value<String?> uri;
  final Value<bool> favorite;
  final Value<bool> inLibrary;
  final Value<String?> metadataJson;
  final Value<DateTime> lastSynced;
  final Value<int> rowid;
  const ArtistsCompanion({
    this.provider = const Value.absent(),
    this.itemId = const Value.absent(),
    this.name = const Value.absent(),
    this.sortName = const Value.absent(),
    this.uri = const Value.absent(),
    this.favorite = const Value.absent(),
    this.inLibrary = const Value.absent(),
    this.metadataJson = const Value.absent(),
    this.lastSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ArtistsCompanion.insert({
    required String provider,
    required String itemId,
    required String name,
    this.sortName = const Value.absent(),
    this.uri = const Value.absent(),
    this.favorite = const Value.absent(),
    this.inLibrary = const Value.absent(),
    this.metadataJson = const Value.absent(),
    required DateTime lastSynced,
    this.rowid = const Value.absent(),
  })  : provider = Value(provider),
        itemId = Value(itemId),
        name = Value(name),
        lastSynced = Value(lastSynced);
  static Insertable<ArtistEntity> custom({
    Expression<String>? provider,
    Expression<String>? itemId,
    Expression<String>? name,
    Expression<String>? sortName,
    Expression<String>? uri,
    Expression<bool>? favorite,
    Expression<bool>? inLibrary,
    Expression<String>? metadataJson,
    Expression<DateTime>? lastSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (provider != null) 'provider': provider,
      if (itemId != null) 'item_id': itemId,
      if (name != null) 'name': name,
      if (sortName != null) 'sort_name': sortName,
      if (uri != null) 'uri': uri,
      if (favorite != null) 'favorite': favorite,
      if (inLibrary != null) 'in_library': inLibrary,
      if (metadataJson != null) 'metadata_json': metadataJson,
      if (lastSynced != null) 'last_synced': lastSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ArtistsCompanion copyWith(
      {Value<String>? provider,
      Value<String>? itemId,
      Value<String>? name,
      Value<String?>? sortName,
      Value<String?>? uri,
      Value<bool>? favorite,
      Value<bool>? inLibrary,
      Value<String?>? metadataJson,
      Value<DateTime>? lastSynced,
      Value<int>? rowid}) {
    return ArtistsCompanion(
      provider: provider ?? this.provider,
      itemId: itemId ?? this.itemId,
      name: name ?? this.name,
      sortName: sortName ?? this.sortName,
      uri: uri ?? this.uri,
      favorite: favorite ?? this.favorite,
      inLibrary: inLibrary ?? this.inLibrary,
      metadataJson: metadataJson ?? this.metadataJson,
      lastSynced: lastSynced ?? this.lastSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (provider.present) {
      map['provider'] = Variable<String>(provider.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortName.present) {
      map['sort_name'] = Variable<String>(sortName.value);
    }
    if (uri.present) {
      map['uri'] = Variable<String>(uri.value);
    }
    if (favorite.present) {
      map['favorite'] = Variable<bool>(favorite.value);
    }
    if (inLibrary.present) {
      map['in_library'] = Variable<bool>(inLibrary.value);
    }
    if (metadataJson.present) {
      map['metadata_json'] = Variable<String>(metadataJson.value);
    }
    if (lastSynced.present) {
      map['last_synced'] = Variable<DateTime>(lastSynced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ArtistsCompanion(')
          ..write('provider: $provider, ')
          ..write('itemId: $itemId, ')
          ..write('name: $name, ')
          ..write('sortName: $sortName, ')
          ..write('uri: $uri, ')
          ..write('favorite: $favorite, ')
          ..write('inLibrary: $inLibrary, ')
          ..write('metadataJson: $metadataJson, ')
          ..write('lastSynced: $lastSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AlbumsTable extends Albums with TableInfo<$AlbumsTable, AlbumEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlbumsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _providerMeta =
      const VerificationMeta('provider');
  @override
  late final GeneratedColumn<String> provider = GeneratedColumn<String>(
      'provider', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
      'item_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sortNameMeta =
      const VerificationMeta('sortName');
  @override
  late final GeneratedColumn<String> sortName = GeneratedColumn<String>(
      'sort_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _uriMeta = const VerificationMeta('uri');
  @override
  late final GeneratedColumn<String> uri = GeneratedColumn<String>(
      'uri', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _albumTypeMeta =
      const VerificationMeta('albumType');
  @override
  late final GeneratedColumn<String> albumType = GeneratedColumn<String>(
      'album_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
      'year', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _artistsJsonMeta =
      const VerificationMeta('artistsJson');
  @override
  late final GeneratedColumn<String> artistsJson = GeneratedColumn<String>(
      'artists_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _favoriteMeta =
      const VerificationMeta('favorite');
  @override
  late final GeneratedColumn<bool> favorite = GeneratedColumn<bool>(
      'favorite', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("favorite" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _inLibraryMeta =
      const VerificationMeta('inLibrary');
  @override
  late final GeneratedColumn<bool> inLibrary = GeneratedColumn<bool>(
      'in_library', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("in_library" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _metadataJsonMeta =
      const VerificationMeta('metadataJson');
  @override
  late final GeneratedColumn<String> metadataJson = GeneratedColumn<String>(
      'metadata_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastSyncedMeta =
      const VerificationMeta('lastSynced');
  @override
  late final GeneratedColumn<DateTime> lastSynced = GeneratedColumn<DateTime>(
      'last_synced', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        provider,
        itemId,
        name,
        sortName,
        uri,
        albumType,
        year,
        artistsJson,
        favorite,
        inLibrary,
        metadataJson,
        lastSynced
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'albums';
  @override
  VerificationContext validateIntegrity(Insertable<AlbumEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('provider')) {
      context.handle(_providerMeta,
          provider.isAcceptableOrUnknown(data['provider']!, _providerMeta));
    } else if (isInserting) {
      context.missing(_providerMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sort_name')) {
      context.handle(_sortNameMeta,
          sortName.isAcceptableOrUnknown(data['sort_name']!, _sortNameMeta));
    }
    if (data.containsKey('uri')) {
      context.handle(
          _uriMeta, uri.isAcceptableOrUnknown(data['uri']!, _uriMeta));
    }
    if (data.containsKey('album_type')) {
      context.handle(_albumTypeMeta,
          albumType.isAcceptableOrUnknown(data['album_type']!, _albumTypeMeta));
    }
    if (data.containsKey('year')) {
      context.handle(
          _yearMeta, year.isAcceptableOrUnknown(data['year']!, _yearMeta));
    }
    if (data.containsKey('artists_json')) {
      context.handle(
          _artistsJsonMeta,
          artistsJson.isAcceptableOrUnknown(
              data['artists_json']!, _artistsJsonMeta));
    }
    if (data.containsKey('favorite')) {
      context.handle(_favoriteMeta,
          favorite.isAcceptableOrUnknown(data['favorite']!, _favoriteMeta));
    }
    if (data.containsKey('in_library')) {
      context.handle(_inLibraryMeta,
          inLibrary.isAcceptableOrUnknown(data['in_library']!, _inLibraryMeta));
    }
    if (data.containsKey('metadata_json')) {
      context.handle(
          _metadataJsonMeta,
          metadataJson.isAcceptableOrUnknown(
              data['metadata_json']!, _metadataJsonMeta));
    }
    if (data.containsKey('last_synced')) {
      context.handle(
          _lastSyncedMeta,
          lastSynced.isAcceptableOrUnknown(
              data['last_synced']!, _lastSyncedMeta));
    } else if (isInserting) {
      context.missing(_lastSyncedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {provider, itemId};
  @override
  AlbumEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AlbumEntity(
      provider: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}provider'])!,
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      sortName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sort_name']),
      uri: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uri']),
      albumType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}album_type']),
      year: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}year']),
      artistsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}artists_json']),
      favorite: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}favorite'])!,
      inLibrary: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}in_library'])!,
      metadataJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metadata_json']),
      lastSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_synced'])!,
    );
  }

  @override
  $AlbumsTable createAlias(String alias) {
    return $AlbumsTable(attachedDatabase, alias);
  }
}

class AlbumEntity extends DataClass implements Insertable<AlbumEntity> {
  final String provider;
  final String itemId;
  final String name;
  final String? sortName;
  final String? uri;
  final String? albumType;
  final int? year;

  /// Denormalized JSON list of {item_id, provider, name} - nothing today
  /// queries "albums by artist X" via a join (the existing code matches by
  /// artist name), so a many-to-many join table here would be
  /// overengineering rather than architecture.
  final String? artistsJson;
  final bool favorite;
  final bool inLibrary;
  final String? metadataJson;
  final DateTime lastSynced;
  const AlbumEntity(
      {required this.provider,
      required this.itemId,
      required this.name,
      this.sortName,
      this.uri,
      this.albumType,
      this.year,
      this.artistsJson,
      required this.favorite,
      required this.inLibrary,
      this.metadataJson,
      required this.lastSynced});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['provider'] = Variable<String>(provider);
    map['item_id'] = Variable<String>(itemId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || sortName != null) {
      map['sort_name'] = Variable<String>(sortName);
    }
    if (!nullToAbsent || uri != null) {
      map['uri'] = Variable<String>(uri);
    }
    if (!nullToAbsent || albumType != null) {
      map['album_type'] = Variable<String>(albumType);
    }
    if (!nullToAbsent || year != null) {
      map['year'] = Variable<int>(year);
    }
    if (!nullToAbsent || artistsJson != null) {
      map['artists_json'] = Variable<String>(artistsJson);
    }
    map['favorite'] = Variable<bool>(favorite);
    map['in_library'] = Variable<bool>(inLibrary);
    if (!nullToAbsent || metadataJson != null) {
      map['metadata_json'] = Variable<String>(metadataJson);
    }
    map['last_synced'] = Variable<DateTime>(lastSynced);
    return map;
  }

  AlbumsCompanion toCompanion(bool nullToAbsent) {
    return AlbumsCompanion(
      provider: Value(provider),
      itemId: Value(itemId),
      name: Value(name),
      sortName: sortName == null && nullToAbsent
          ? const Value.absent()
          : Value(sortName),
      uri: uri == null && nullToAbsent ? const Value.absent() : Value(uri),
      albumType: albumType == null && nullToAbsent
          ? const Value.absent()
          : Value(albumType),
      year: year == null && nullToAbsent ? const Value.absent() : Value(year),
      artistsJson: artistsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(artistsJson),
      favorite: Value(favorite),
      inLibrary: Value(inLibrary),
      metadataJson: metadataJson == null && nullToAbsent
          ? const Value.absent()
          : Value(metadataJson),
      lastSynced: Value(lastSynced),
    );
  }

  factory AlbumEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AlbumEntity(
      provider: serializer.fromJson<String>(json['provider']),
      itemId: serializer.fromJson<String>(json['itemId']),
      name: serializer.fromJson<String>(json['name']),
      sortName: serializer.fromJson<String?>(json['sortName']),
      uri: serializer.fromJson<String?>(json['uri']),
      albumType: serializer.fromJson<String?>(json['albumType']),
      year: serializer.fromJson<int?>(json['year']),
      artistsJson: serializer.fromJson<String?>(json['artistsJson']),
      favorite: serializer.fromJson<bool>(json['favorite']),
      inLibrary: serializer.fromJson<bool>(json['inLibrary']),
      metadataJson: serializer.fromJson<String?>(json['metadataJson']),
      lastSynced: serializer.fromJson<DateTime>(json['lastSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'provider': serializer.toJson<String>(provider),
      'itemId': serializer.toJson<String>(itemId),
      'name': serializer.toJson<String>(name),
      'sortName': serializer.toJson<String?>(sortName),
      'uri': serializer.toJson<String?>(uri),
      'albumType': serializer.toJson<String?>(albumType),
      'year': serializer.toJson<int?>(year),
      'artistsJson': serializer.toJson<String?>(artistsJson),
      'favorite': serializer.toJson<bool>(favorite),
      'inLibrary': serializer.toJson<bool>(inLibrary),
      'metadataJson': serializer.toJson<String?>(metadataJson),
      'lastSynced': serializer.toJson<DateTime>(lastSynced),
    };
  }

  AlbumEntity copyWith(
          {String? provider,
          String? itemId,
          String? name,
          Value<String?> sortName = const Value.absent(),
          Value<String?> uri = const Value.absent(),
          Value<String?> albumType = const Value.absent(),
          Value<int?> year = const Value.absent(),
          Value<String?> artistsJson = const Value.absent(),
          bool? favorite,
          bool? inLibrary,
          Value<String?> metadataJson = const Value.absent(),
          DateTime? lastSynced}) =>
      AlbumEntity(
        provider: provider ?? this.provider,
        itemId: itemId ?? this.itemId,
        name: name ?? this.name,
        sortName: sortName.present ? sortName.value : this.sortName,
        uri: uri.present ? uri.value : this.uri,
        albumType: albumType.present ? albumType.value : this.albumType,
        year: year.present ? year.value : this.year,
        artistsJson: artistsJson.present ? artistsJson.value : this.artistsJson,
        favorite: favorite ?? this.favorite,
        inLibrary: inLibrary ?? this.inLibrary,
        metadataJson:
            metadataJson.present ? metadataJson.value : this.metadataJson,
        lastSynced: lastSynced ?? this.lastSynced,
      );
  AlbumEntity copyWithCompanion(AlbumsCompanion data) {
    return AlbumEntity(
      provider: data.provider.present ? data.provider.value : this.provider,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      name: data.name.present ? data.name.value : this.name,
      sortName: data.sortName.present ? data.sortName.value : this.sortName,
      uri: data.uri.present ? data.uri.value : this.uri,
      albumType: data.albumType.present ? data.albumType.value : this.albumType,
      year: data.year.present ? data.year.value : this.year,
      artistsJson:
          data.artistsJson.present ? data.artistsJson.value : this.artistsJson,
      favorite: data.favorite.present ? data.favorite.value : this.favorite,
      inLibrary: data.inLibrary.present ? data.inLibrary.value : this.inLibrary,
      metadataJson: data.metadataJson.present
          ? data.metadataJson.value
          : this.metadataJson,
      lastSynced:
          data.lastSynced.present ? data.lastSynced.value : this.lastSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AlbumEntity(')
          ..write('provider: $provider, ')
          ..write('itemId: $itemId, ')
          ..write('name: $name, ')
          ..write('sortName: $sortName, ')
          ..write('uri: $uri, ')
          ..write('albumType: $albumType, ')
          ..write('year: $year, ')
          ..write('artistsJson: $artistsJson, ')
          ..write('favorite: $favorite, ')
          ..write('inLibrary: $inLibrary, ')
          ..write('metadataJson: $metadataJson, ')
          ..write('lastSynced: $lastSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      provider,
      itemId,
      name,
      sortName,
      uri,
      albumType,
      year,
      artistsJson,
      favorite,
      inLibrary,
      metadataJson,
      lastSynced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AlbumEntity &&
          other.provider == this.provider &&
          other.itemId == this.itemId &&
          other.name == this.name &&
          other.sortName == this.sortName &&
          other.uri == this.uri &&
          other.albumType == this.albumType &&
          other.year == this.year &&
          other.artistsJson == this.artistsJson &&
          other.favorite == this.favorite &&
          other.inLibrary == this.inLibrary &&
          other.metadataJson == this.metadataJson &&
          other.lastSynced == this.lastSynced);
}

class AlbumsCompanion extends UpdateCompanion<AlbumEntity> {
  final Value<String> provider;
  final Value<String> itemId;
  final Value<String> name;
  final Value<String?> sortName;
  final Value<String?> uri;
  final Value<String?> albumType;
  final Value<int?> year;
  final Value<String?> artistsJson;
  final Value<bool> favorite;
  final Value<bool> inLibrary;
  final Value<String?> metadataJson;
  final Value<DateTime> lastSynced;
  final Value<int> rowid;
  const AlbumsCompanion({
    this.provider = const Value.absent(),
    this.itemId = const Value.absent(),
    this.name = const Value.absent(),
    this.sortName = const Value.absent(),
    this.uri = const Value.absent(),
    this.albumType = const Value.absent(),
    this.year = const Value.absent(),
    this.artistsJson = const Value.absent(),
    this.favorite = const Value.absent(),
    this.inLibrary = const Value.absent(),
    this.metadataJson = const Value.absent(),
    this.lastSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AlbumsCompanion.insert({
    required String provider,
    required String itemId,
    required String name,
    this.sortName = const Value.absent(),
    this.uri = const Value.absent(),
    this.albumType = const Value.absent(),
    this.year = const Value.absent(),
    this.artistsJson = const Value.absent(),
    this.favorite = const Value.absent(),
    this.inLibrary = const Value.absent(),
    this.metadataJson = const Value.absent(),
    required DateTime lastSynced,
    this.rowid = const Value.absent(),
  })  : provider = Value(provider),
        itemId = Value(itemId),
        name = Value(name),
        lastSynced = Value(lastSynced);
  static Insertable<AlbumEntity> custom({
    Expression<String>? provider,
    Expression<String>? itemId,
    Expression<String>? name,
    Expression<String>? sortName,
    Expression<String>? uri,
    Expression<String>? albumType,
    Expression<int>? year,
    Expression<String>? artistsJson,
    Expression<bool>? favorite,
    Expression<bool>? inLibrary,
    Expression<String>? metadataJson,
    Expression<DateTime>? lastSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (provider != null) 'provider': provider,
      if (itemId != null) 'item_id': itemId,
      if (name != null) 'name': name,
      if (sortName != null) 'sort_name': sortName,
      if (uri != null) 'uri': uri,
      if (albumType != null) 'album_type': albumType,
      if (year != null) 'year': year,
      if (artistsJson != null) 'artists_json': artistsJson,
      if (favorite != null) 'favorite': favorite,
      if (inLibrary != null) 'in_library': inLibrary,
      if (metadataJson != null) 'metadata_json': metadataJson,
      if (lastSynced != null) 'last_synced': lastSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AlbumsCompanion copyWith(
      {Value<String>? provider,
      Value<String>? itemId,
      Value<String>? name,
      Value<String?>? sortName,
      Value<String?>? uri,
      Value<String?>? albumType,
      Value<int?>? year,
      Value<String?>? artistsJson,
      Value<bool>? favorite,
      Value<bool>? inLibrary,
      Value<String?>? metadataJson,
      Value<DateTime>? lastSynced,
      Value<int>? rowid}) {
    return AlbumsCompanion(
      provider: provider ?? this.provider,
      itemId: itemId ?? this.itemId,
      name: name ?? this.name,
      sortName: sortName ?? this.sortName,
      uri: uri ?? this.uri,
      albumType: albumType ?? this.albumType,
      year: year ?? this.year,
      artistsJson: artistsJson ?? this.artistsJson,
      favorite: favorite ?? this.favorite,
      inLibrary: inLibrary ?? this.inLibrary,
      metadataJson: metadataJson ?? this.metadataJson,
      lastSynced: lastSynced ?? this.lastSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (provider.present) {
      map['provider'] = Variable<String>(provider.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortName.present) {
      map['sort_name'] = Variable<String>(sortName.value);
    }
    if (uri.present) {
      map['uri'] = Variable<String>(uri.value);
    }
    if (albumType.present) {
      map['album_type'] = Variable<String>(albumType.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (artistsJson.present) {
      map['artists_json'] = Variable<String>(artistsJson.value);
    }
    if (favorite.present) {
      map['favorite'] = Variable<bool>(favorite.value);
    }
    if (inLibrary.present) {
      map['in_library'] = Variable<bool>(inLibrary.value);
    }
    if (metadataJson.present) {
      map['metadata_json'] = Variable<String>(metadataJson.value);
    }
    if (lastSynced.present) {
      map['last_synced'] = Variable<DateTime>(lastSynced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlbumsCompanion(')
          ..write('provider: $provider, ')
          ..write('itemId: $itemId, ')
          ..write('name: $name, ')
          ..write('sortName: $sortName, ')
          ..write('uri: $uri, ')
          ..write('albumType: $albumType, ')
          ..write('year: $year, ')
          ..write('artistsJson: $artistsJson, ')
          ..write('favorite: $favorite, ')
          ..write('inLibrary: $inLibrary, ')
          ..write('metadataJson: $metadataJson, ')
          ..write('lastSynced: $lastSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TracksTable extends Tracks with TableInfo<$TracksTable, TrackEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TracksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _providerMeta =
      const VerificationMeta('provider');
  @override
  late final GeneratedColumn<String> provider = GeneratedColumn<String>(
      'provider', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
      'item_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sortNameMeta =
      const VerificationMeta('sortName');
  @override
  late final GeneratedColumn<String> sortName = GeneratedColumn<String>(
      'sort_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _uriMeta = const VerificationMeta('uri');
  @override
  late final GeneratedColumn<String> uri = GeneratedColumn<String>(
      'uri', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _durationSecondsMeta =
      const VerificationMeta('durationSeconds');
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
      'duration_seconds', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _artistsJsonMeta =
      const VerificationMeta('artistsJson');
  @override
  late final GeneratedColumn<String> artistsJson = GeneratedColumn<String>(
      'artists_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _albumProviderMeta =
      const VerificationMeta('albumProvider');
  @override
  late final GeneratedColumn<String> albumProvider = GeneratedColumn<String>(
      'album_provider', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _albumItemIdMeta =
      const VerificationMeta('albumItemId');
  @override
  late final GeneratedColumn<String> albumItemId = GeneratedColumn<String>(
      'album_item_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _positionMeta =
      const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _favoriteMeta =
      const VerificationMeta('favorite');
  @override
  late final GeneratedColumn<bool> favorite = GeneratedColumn<bool>(
      'favorite', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("favorite" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _inLibraryMeta =
      const VerificationMeta('inLibrary');
  @override
  late final GeneratedColumn<bool> inLibrary = GeneratedColumn<bool>(
      'in_library', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("in_library" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _metadataJsonMeta =
      const VerificationMeta('metadataJson');
  @override
  late final GeneratedColumn<String> metadataJson = GeneratedColumn<String>(
      'metadata_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastSyncedMeta =
      const VerificationMeta('lastSynced');
  @override
  late final GeneratedColumn<DateTime> lastSynced = GeneratedColumn<DateTime>(
      'last_synced', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        provider,
        itemId,
        name,
        sortName,
        uri,
        durationSeconds,
        artistsJson,
        albumProvider,
        albumItemId,
        position,
        favorite,
        inLibrary,
        metadataJson,
        lastSynced
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tracks';
  @override
  VerificationContext validateIntegrity(Insertable<TrackEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('provider')) {
      context.handle(_providerMeta,
          provider.isAcceptableOrUnknown(data['provider']!, _providerMeta));
    } else if (isInserting) {
      context.missing(_providerMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sort_name')) {
      context.handle(_sortNameMeta,
          sortName.isAcceptableOrUnknown(data['sort_name']!, _sortNameMeta));
    }
    if (data.containsKey('uri')) {
      context.handle(
          _uriMeta, uri.isAcceptableOrUnknown(data['uri']!, _uriMeta));
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
          _durationSecondsMeta,
          durationSeconds.isAcceptableOrUnknown(
              data['duration_seconds']!, _durationSecondsMeta));
    }
    if (data.containsKey('artists_json')) {
      context.handle(
          _artistsJsonMeta,
          artistsJson.isAcceptableOrUnknown(
              data['artists_json']!, _artistsJsonMeta));
    }
    if (data.containsKey('album_provider')) {
      context.handle(
          _albumProviderMeta,
          albumProvider.isAcceptableOrUnknown(
              data['album_provider']!, _albumProviderMeta));
    }
    if (data.containsKey('album_item_id')) {
      context.handle(
          _albumItemIdMeta,
          albumItemId.isAcceptableOrUnknown(
              data['album_item_id']!, _albumItemIdMeta));
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta,
          position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    }
    if (data.containsKey('favorite')) {
      context.handle(_favoriteMeta,
          favorite.isAcceptableOrUnknown(data['favorite']!, _favoriteMeta));
    }
    if (data.containsKey('in_library')) {
      context.handle(_inLibraryMeta,
          inLibrary.isAcceptableOrUnknown(data['in_library']!, _inLibraryMeta));
    }
    if (data.containsKey('metadata_json')) {
      context.handle(
          _metadataJsonMeta,
          metadataJson.isAcceptableOrUnknown(
              data['metadata_json']!, _metadataJsonMeta));
    }
    if (data.containsKey('last_synced')) {
      context.handle(
          _lastSyncedMeta,
          lastSynced.isAcceptableOrUnknown(
              data['last_synced']!, _lastSyncedMeta));
    } else if (isInserting) {
      context.missing(_lastSyncedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {provider, itemId};
  @override
  TrackEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrackEntity(
      provider: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}provider'])!,
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      sortName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sort_name']),
      uri: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uri']),
      durationSeconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_seconds']),
      artistsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}artists_json']),
      albumProvider: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}album_provider']),
      albumItemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}album_item_id']),
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position']),
      favorite: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}favorite'])!,
      inLibrary: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}in_library'])!,
      metadataJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metadata_json']),
      lastSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_synced'])!,
    );
  }

  @override
  $TracksTable createAlias(String alias) {
    return $TracksTable(attachedDatabase, alias);
  }
}

class TrackEntity extends DataClass implements Insertable<TrackEntity> {
  final String provider;
  final String itemId;
  final String name;
  final String? sortName;
  final String? uri;
  final int? durationSeconds;
  final String? artistsJson;
  final String? albumProvider;
  final String? albumItemId;

  /// Position within the owning album (for ordered track listings).
  final int? position;
  final bool favorite;
  final bool inLibrary;
  final String? metadataJson;
  final DateTime lastSynced;
  const TrackEntity(
      {required this.provider,
      required this.itemId,
      required this.name,
      this.sortName,
      this.uri,
      this.durationSeconds,
      this.artistsJson,
      this.albumProvider,
      this.albumItemId,
      this.position,
      required this.favorite,
      required this.inLibrary,
      this.metadataJson,
      required this.lastSynced});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['provider'] = Variable<String>(provider);
    map['item_id'] = Variable<String>(itemId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || sortName != null) {
      map['sort_name'] = Variable<String>(sortName);
    }
    if (!nullToAbsent || uri != null) {
      map['uri'] = Variable<String>(uri);
    }
    if (!nullToAbsent || durationSeconds != null) {
      map['duration_seconds'] = Variable<int>(durationSeconds);
    }
    if (!nullToAbsent || artistsJson != null) {
      map['artists_json'] = Variable<String>(artistsJson);
    }
    if (!nullToAbsent || albumProvider != null) {
      map['album_provider'] = Variable<String>(albumProvider);
    }
    if (!nullToAbsent || albumItemId != null) {
      map['album_item_id'] = Variable<String>(albumItemId);
    }
    if (!nullToAbsent || position != null) {
      map['position'] = Variable<int>(position);
    }
    map['favorite'] = Variable<bool>(favorite);
    map['in_library'] = Variable<bool>(inLibrary);
    if (!nullToAbsent || metadataJson != null) {
      map['metadata_json'] = Variable<String>(metadataJson);
    }
    map['last_synced'] = Variable<DateTime>(lastSynced);
    return map;
  }

  TracksCompanion toCompanion(bool nullToAbsent) {
    return TracksCompanion(
      provider: Value(provider),
      itemId: Value(itemId),
      name: Value(name),
      sortName: sortName == null && nullToAbsent
          ? const Value.absent()
          : Value(sortName),
      uri: uri == null && nullToAbsent ? const Value.absent() : Value(uri),
      durationSeconds: durationSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(durationSeconds),
      artistsJson: artistsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(artistsJson),
      albumProvider: albumProvider == null && nullToAbsent
          ? const Value.absent()
          : Value(albumProvider),
      albumItemId: albumItemId == null && nullToAbsent
          ? const Value.absent()
          : Value(albumItemId),
      position: position == null && nullToAbsent
          ? const Value.absent()
          : Value(position),
      favorite: Value(favorite),
      inLibrary: Value(inLibrary),
      metadataJson: metadataJson == null && nullToAbsent
          ? const Value.absent()
          : Value(metadataJson),
      lastSynced: Value(lastSynced),
    );
  }

  factory TrackEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrackEntity(
      provider: serializer.fromJson<String>(json['provider']),
      itemId: serializer.fromJson<String>(json['itemId']),
      name: serializer.fromJson<String>(json['name']),
      sortName: serializer.fromJson<String?>(json['sortName']),
      uri: serializer.fromJson<String?>(json['uri']),
      durationSeconds: serializer.fromJson<int?>(json['durationSeconds']),
      artistsJson: serializer.fromJson<String?>(json['artistsJson']),
      albumProvider: serializer.fromJson<String?>(json['albumProvider']),
      albumItemId: serializer.fromJson<String?>(json['albumItemId']),
      position: serializer.fromJson<int?>(json['position']),
      favorite: serializer.fromJson<bool>(json['favorite']),
      inLibrary: serializer.fromJson<bool>(json['inLibrary']),
      metadataJson: serializer.fromJson<String?>(json['metadataJson']),
      lastSynced: serializer.fromJson<DateTime>(json['lastSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'provider': serializer.toJson<String>(provider),
      'itemId': serializer.toJson<String>(itemId),
      'name': serializer.toJson<String>(name),
      'sortName': serializer.toJson<String?>(sortName),
      'uri': serializer.toJson<String?>(uri),
      'durationSeconds': serializer.toJson<int?>(durationSeconds),
      'artistsJson': serializer.toJson<String?>(artistsJson),
      'albumProvider': serializer.toJson<String?>(albumProvider),
      'albumItemId': serializer.toJson<String?>(albumItemId),
      'position': serializer.toJson<int?>(position),
      'favorite': serializer.toJson<bool>(favorite),
      'inLibrary': serializer.toJson<bool>(inLibrary),
      'metadataJson': serializer.toJson<String?>(metadataJson),
      'lastSynced': serializer.toJson<DateTime>(lastSynced),
    };
  }

  TrackEntity copyWith(
          {String? provider,
          String? itemId,
          String? name,
          Value<String?> sortName = const Value.absent(),
          Value<String?> uri = const Value.absent(),
          Value<int?> durationSeconds = const Value.absent(),
          Value<String?> artistsJson = const Value.absent(),
          Value<String?> albumProvider = const Value.absent(),
          Value<String?> albumItemId = const Value.absent(),
          Value<int?> position = const Value.absent(),
          bool? favorite,
          bool? inLibrary,
          Value<String?> metadataJson = const Value.absent(),
          DateTime? lastSynced}) =>
      TrackEntity(
        provider: provider ?? this.provider,
        itemId: itemId ?? this.itemId,
        name: name ?? this.name,
        sortName: sortName.present ? sortName.value : this.sortName,
        uri: uri.present ? uri.value : this.uri,
        durationSeconds: durationSeconds.present
            ? durationSeconds.value
            : this.durationSeconds,
        artistsJson: artistsJson.present ? artistsJson.value : this.artistsJson,
        albumProvider:
            albumProvider.present ? albumProvider.value : this.albumProvider,
        albumItemId: albumItemId.present ? albumItemId.value : this.albumItemId,
        position: position.present ? position.value : this.position,
        favorite: favorite ?? this.favorite,
        inLibrary: inLibrary ?? this.inLibrary,
        metadataJson:
            metadataJson.present ? metadataJson.value : this.metadataJson,
        lastSynced: lastSynced ?? this.lastSynced,
      );
  TrackEntity copyWithCompanion(TracksCompanion data) {
    return TrackEntity(
      provider: data.provider.present ? data.provider.value : this.provider,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      name: data.name.present ? data.name.value : this.name,
      sortName: data.sortName.present ? data.sortName.value : this.sortName,
      uri: data.uri.present ? data.uri.value : this.uri,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      artistsJson:
          data.artistsJson.present ? data.artistsJson.value : this.artistsJson,
      albumProvider: data.albumProvider.present
          ? data.albumProvider.value
          : this.albumProvider,
      albumItemId:
          data.albumItemId.present ? data.albumItemId.value : this.albumItemId,
      position: data.position.present ? data.position.value : this.position,
      favorite: data.favorite.present ? data.favorite.value : this.favorite,
      inLibrary: data.inLibrary.present ? data.inLibrary.value : this.inLibrary,
      metadataJson: data.metadataJson.present
          ? data.metadataJson.value
          : this.metadataJson,
      lastSynced:
          data.lastSynced.present ? data.lastSynced.value : this.lastSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrackEntity(')
          ..write('provider: $provider, ')
          ..write('itemId: $itemId, ')
          ..write('name: $name, ')
          ..write('sortName: $sortName, ')
          ..write('uri: $uri, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('artistsJson: $artistsJson, ')
          ..write('albumProvider: $albumProvider, ')
          ..write('albumItemId: $albumItemId, ')
          ..write('position: $position, ')
          ..write('favorite: $favorite, ')
          ..write('inLibrary: $inLibrary, ')
          ..write('metadataJson: $metadataJson, ')
          ..write('lastSynced: $lastSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      provider,
      itemId,
      name,
      sortName,
      uri,
      durationSeconds,
      artistsJson,
      albumProvider,
      albumItemId,
      position,
      favorite,
      inLibrary,
      metadataJson,
      lastSynced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrackEntity &&
          other.provider == this.provider &&
          other.itemId == this.itemId &&
          other.name == this.name &&
          other.sortName == this.sortName &&
          other.uri == this.uri &&
          other.durationSeconds == this.durationSeconds &&
          other.artistsJson == this.artistsJson &&
          other.albumProvider == this.albumProvider &&
          other.albumItemId == this.albumItemId &&
          other.position == this.position &&
          other.favorite == this.favorite &&
          other.inLibrary == this.inLibrary &&
          other.metadataJson == this.metadataJson &&
          other.lastSynced == this.lastSynced);
}

class TracksCompanion extends UpdateCompanion<TrackEntity> {
  final Value<String> provider;
  final Value<String> itemId;
  final Value<String> name;
  final Value<String?> sortName;
  final Value<String?> uri;
  final Value<int?> durationSeconds;
  final Value<String?> artistsJson;
  final Value<String?> albumProvider;
  final Value<String?> albumItemId;
  final Value<int?> position;
  final Value<bool> favorite;
  final Value<bool> inLibrary;
  final Value<String?> metadataJson;
  final Value<DateTime> lastSynced;
  final Value<int> rowid;
  const TracksCompanion({
    this.provider = const Value.absent(),
    this.itemId = const Value.absent(),
    this.name = const Value.absent(),
    this.sortName = const Value.absent(),
    this.uri = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.artistsJson = const Value.absent(),
    this.albumProvider = const Value.absent(),
    this.albumItemId = const Value.absent(),
    this.position = const Value.absent(),
    this.favorite = const Value.absent(),
    this.inLibrary = const Value.absent(),
    this.metadataJson = const Value.absent(),
    this.lastSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TracksCompanion.insert({
    required String provider,
    required String itemId,
    required String name,
    this.sortName = const Value.absent(),
    this.uri = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.artistsJson = const Value.absent(),
    this.albumProvider = const Value.absent(),
    this.albumItemId = const Value.absent(),
    this.position = const Value.absent(),
    this.favorite = const Value.absent(),
    this.inLibrary = const Value.absent(),
    this.metadataJson = const Value.absent(),
    required DateTime lastSynced,
    this.rowid = const Value.absent(),
  })  : provider = Value(provider),
        itemId = Value(itemId),
        name = Value(name),
        lastSynced = Value(lastSynced);
  static Insertable<TrackEntity> custom({
    Expression<String>? provider,
    Expression<String>? itemId,
    Expression<String>? name,
    Expression<String>? sortName,
    Expression<String>? uri,
    Expression<int>? durationSeconds,
    Expression<String>? artistsJson,
    Expression<String>? albumProvider,
    Expression<String>? albumItemId,
    Expression<int>? position,
    Expression<bool>? favorite,
    Expression<bool>? inLibrary,
    Expression<String>? metadataJson,
    Expression<DateTime>? lastSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (provider != null) 'provider': provider,
      if (itemId != null) 'item_id': itemId,
      if (name != null) 'name': name,
      if (sortName != null) 'sort_name': sortName,
      if (uri != null) 'uri': uri,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (artistsJson != null) 'artists_json': artistsJson,
      if (albumProvider != null) 'album_provider': albumProvider,
      if (albumItemId != null) 'album_item_id': albumItemId,
      if (position != null) 'position': position,
      if (favorite != null) 'favorite': favorite,
      if (inLibrary != null) 'in_library': inLibrary,
      if (metadataJson != null) 'metadata_json': metadataJson,
      if (lastSynced != null) 'last_synced': lastSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TracksCompanion copyWith(
      {Value<String>? provider,
      Value<String>? itemId,
      Value<String>? name,
      Value<String?>? sortName,
      Value<String?>? uri,
      Value<int?>? durationSeconds,
      Value<String?>? artistsJson,
      Value<String?>? albumProvider,
      Value<String?>? albumItemId,
      Value<int?>? position,
      Value<bool>? favorite,
      Value<bool>? inLibrary,
      Value<String?>? metadataJson,
      Value<DateTime>? lastSynced,
      Value<int>? rowid}) {
    return TracksCompanion(
      provider: provider ?? this.provider,
      itemId: itemId ?? this.itemId,
      name: name ?? this.name,
      sortName: sortName ?? this.sortName,
      uri: uri ?? this.uri,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      artistsJson: artistsJson ?? this.artistsJson,
      albumProvider: albumProvider ?? this.albumProvider,
      albumItemId: albumItemId ?? this.albumItemId,
      position: position ?? this.position,
      favorite: favorite ?? this.favorite,
      inLibrary: inLibrary ?? this.inLibrary,
      metadataJson: metadataJson ?? this.metadataJson,
      lastSynced: lastSynced ?? this.lastSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (provider.present) {
      map['provider'] = Variable<String>(provider.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortName.present) {
      map['sort_name'] = Variable<String>(sortName.value);
    }
    if (uri.present) {
      map['uri'] = Variable<String>(uri.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (artistsJson.present) {
      map['artists_json'] = Variable<String>(artistsJson.value);
    }
    if (albumProvider.present) {
      map['album_provider'] = Variable<String>(albumProvider.value);
    }
    if (albumItemId.present) {
      map['album_item_id'] = Variable<String>(albumItemId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (favorite.present) {
      map['favorite'] = Variable<bool>(favorite.value);
    }
    if (inLibrary.present) {
      map['in_library'] = Variable<bool>(inLibrary.value);
    }
    if (metadataJson.present) {
      map['metadata_json'] = Variable<String>(metadataJson.value);
    }
    if (lastSynced.present) {
      map['last_synced'] = Variable<DateTime>(lastSynced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TracksCompanion(')
          ..write('provider: $provider, ')
          ..write('itemId: $itemId, ')
          ..write('name: $name, ')
          ..write('sortName: $sortName, ')
          ..write('uri: $uri, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('artistsJson: $artistsJson, ')
          ..write('albumProvider: $albumProvider, ')
          ..write('albumItemId: $albumItemId, ')
          ..write('position: $position, ')
          ..write('favorite: $favorite, ')
          ..write('inLibrary: $inLibrary, ')
          ..write('metadataJson: $metadataJson, ')
          ..write('lastSynced: $lastSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlaylistsTable extends Playlists
    with TableInfo<$PlaylistsTable, PlaylistEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaylistsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _providerMeta =
      const VerificationMeta('provider');
  @override
  late final GeneratedColumn<String> provider = GeneratedColumn<String>(
      'provider', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
      'item_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sortNameMeta =
      const VerificationMeta('sortName');
  @override
  late final GeneratedColumn<String> sortName = GeneratedColumn<String>(
      'sort_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _uriMeta = const VerificationMeta('uri');
  @override
  late final GeneratedColumn<String> uri = GeneratedColumn<String>(
      'uri', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _ownerMeta = const VerificationMeta('owner');
  @override
  late final GeneratedColumn<String> owner = GeneratedColumn<String>(
      'owner', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isEditableMeta =
      const VerificationMeta('isEditable');
  @override
  late final GeneratedColumn<bool> isEditable = GeneratedColumn<bool>(
      'is_editable', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_editable" IN (0, 1))'));
  static const VerificationMeta _trackCountMeta =
      const VerificationMeta('trackCount');
  @override
  late final GeneratedColumn<int> trackCount = GeneratedColumn<int>(
      'track_count', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _favoriteMeta =
      const VerificationMeta('favorite');
  @override
  late final GeneratedColumn<bool> favorite = GeneratedColumn<bool>(
      'favorite', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("favorite" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _inLibraryMeta =
      const VerificationMeta('inLibrary');
  @override
  late final GeneratedColumn<bool> inLibrary = GeneratedColumn<bool>(
      'in_library', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("in_library" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _metadataJsonMeta =
      const VerificationMeta('metadataJson');
  @override
  late final GeneratedColumn<String> metadataJson = GeneratedColumn<String>(
      'metadata_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastSyncedMeta =
      const VerificationMeta('lastSynced');
  @override
  late final GeneratedColumn<DateTime> lastSynced = GeneratedColumn<DateTime>(
      'last_synced', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        provider,
        itemId,
        name,
        sortName,
        uri,
        owner,
        isEditable,
        trackCount,
        favorite,
        inLibrary,
        metadataJson,
        lastSynced
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'playlists';
  @override
  VerificationContext validateIntegrity(Insertable<PlaylistEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('provider')) {
      context.handle(_providerMeta,
          provider.isAcceptableOrUnknown(data['provider']!, _providerMeta));
    } else if (isInserting) {
      context.missing(_providerMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sort_name')) {
      context.handle(_sortNameMeta,
          sortName.isAcceptableOrUnknown(data['sort_name']!, _sortNameMeta));
    }
    if (data.containsKey('uri')) {
      context.handle(
          _uriMeta, uri.isAcceptableOrUnknown(data['uri']!, _uriMeta));
    }
    if (data.containsKey('owner')) {
      context.handle(
          _ownerMeta, owner.isAcceptableOrUnknown(data['owner']!, _ownerMeta));
    }
    if (data.containsKey('is_editable')) {
      context.handle(
          _isEditableMeta,
          isEditable.isAcceptableOrUnknown(
              data['is_editable']!, _isEditableMeta));
    }
    if (data.containsKey('track_count')) {
      context.handle(
          _trackCountMeta,
          trackCount.isAcceptableOrUnknown(
              data['track_count']!, _trackCountMeta));
    }
    if (data.containsKey('favorite')) {
      context.handle(_favoriteMeta,
          favorite.isAcceptableOrUnknown(data['favorite']!, _favoriteMeta));
    }
    if (data.containsKey('in_library')) {
      context.handle(_inLibraryMeta,
          inLibrary.isAcceptableOrUnknown(data['in_library']!, _inLibraryMeta));
    }
    if (data.containsKey('metadata_json')) {
      context.handle(
          _metadataJsonMeta,
          metadataJson.isAcceptableOrUnknown(
              data['metadata_json']!, _metadataJsonMeta));
    }
    if (data.containsKey('last_synced')) {
      context.handle(
          _lastSyncedMeta,
          lastSynced.isAcceptableOrUnknown(
              data['last_synced']!, _lastSyncedMeta));
    } else if (isInserting) {
      context.missing(_lastSyncedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {provider, itemId};
  @override
  PlaylistEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlaylistEntity(
      provider: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}provider'])!,
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      sortName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sort_name']),
      uri: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uri']),
      owner: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}owner']),
      isEditable: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_editable']),
      trackCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}track_count']),
      favorite: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}favorite'])!,
      inLibrary: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}in_library'])!,
      metadataJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metadata_json']),
      lastSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_synced'])!,
    );
  }

  @override
  $PlaylistsTable createAlias(String alias) {
    return $PlaylistsTable(attachedDatabase, alias);
  }
}

class PlaylistEntity extends DataClass implements Insertable<PlaylistEntity> {
  final String provider;
  final String itemId;
  final String name;
  final String? sortName;
  final String? uri;
  final String? owner;
  final bool? isEditable;
  final int? trackCount;
  final bool favorite;
  final bool inLibrary;
  final String? metadataJson;
  final DateTime lastSynced;
  const PlaylistEntity(
      {required this.provider,
      required this.itemId,
      required this.name,
      this.sortName,
      this.uri,
      this.owner,
      this.isEditable,
      this.trackCount,
      required this.favorite,
      required this.inLibrary,
      this.metadataJson,
      required this.lastSynced});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['provider'] = Variable<String>(provider);
    map['item_id'] = Variable<String>(itemId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || sortName != null) {
      map['sort_name'] = Variable<String>(sortName);
    }
    if (!nullToAbsent || uri != null) {
      map['uri'] = Variable<String>(uri);
    }
    if (!nullToAbsent || owner != null) {
      map['owner'] = Variable<String>(owner);
    }
    if (!nullToAbsent || isEditable != null) {
      map['is_editable'] = Variable<bool>(isEditable);
    }
    if (!nullToAbsent || trackCount != null) {
      map['track_count'] = Variable<int>(trackCount);
    }
    map['favorite'] = Variable<bool>(favorite);
    map['in_library'] = Variable<bool>(inLibrary);
    if (!nullToAbsent || metadataJson != null) {
      map['metadata_json'] = Variable<String>(metadataJson);
    }
    map['last_synced'] = Variable<DateTime>(lastSynced);
    return map;
  }

  PlaylistsCompanion toCompanion(bool nullToAbsent) {
    return PlaylistsCompanion(
      provider: Value(provider),
      itemId: Value(itemId),
      name: Value(name),
      sortName: sortName == null && nullToAbsent
          ? const Value.absent()
          : Value(sortName),
      uri: uri == null && nullToAbsent ? const Value.absent() : Value(uri),
      owner:
          owner == null && nullToAbsent ? const Value.absent() : Value(owner),
      isEditable: isEditable == null && nullToAbsent
          ? const Value.absent()
          : Value(isEditable),
      trackCount: trackCount == null && nullToAbsent
          ? const Value.absent()
          : Value(trackCount),
      favorite: Value(favorite),
      inLibrary: Value(inLibrary),
      metadataJson: metadataJson == null && nullToAbsent
          ? const Value.absent()
          : Value(metadataJson),
      lastSynced: Value(lastSynced),
    );
  }

  factory PlaylistEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlaylistEntity(
      provider: serializer.fromJson<String>(json['provider']),
      itemId: serializer.fromJson<String>(json['itemId']),
      name: serializer.fromJson<String>(json['name']),
      sortName: serializer.fromJson<String?>(json['sortName']),
      uri: serializer.fromJson<String?>(json['uri']),
      owner: serializer.fromJson<String?>(json['owner']),
      isEditable: serializer.fromJson<bool?>(json['isEditable']),
      trackCount: serializer.fromJson<int?>(json['trackCount']),
      favorite: serializer.fromJson<bool>(json['favorite']),
      inLibrary: serializer.fromJson<bool>(json['inLibrary']),
      metadataJson: serializer.fromJson<String?>(json['metadataJson']),
      lastSynced: serializer.fromJson<DateTime>(json['lastSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'provider': serializer.toJson<String>(provider),
      'itemId': serializer.toJson<String>(itemId),
      'name': serializer.toJson<String>(name),
      'sortName': serializer.toJson<String?>(sortName),
      'uri': serializer.toJson<String?>(uri),
      'owner': serializer.toJson<String?>(owner),
      'isEditable': serializer.toJson<bool?>(isEditable),
      'trackCount': serializer.toJson<int?>(trackCount),
      'favorite': serializer.toJson<bool>(favorite),
      'inLibrary': serializer.toJson<bool>(inLibrary),
      'metadataJson': serializer.toJson<String?>(metadataJson),
      'lastSynced': serializer.toJson<DateTime>(lastSynced),
    };
  }

  PlaylistEntity copyWith(
          {String? provider,
          String? itemId,
          String? name,
          Value<String?> sortName = const Value.absent(),
          Value<String?> uri = const Value.absent(),
          Value<String?> owner = const Value.absent(),
          Value<bool?> isEditable = const Value.absent(),
          Value<int?> trackCount = const Value.absent(),
          bool? favorite,
          bool? inLibrary,
          Value<String?> metadataJson = const Value.absent(),
          DateTime? lastSynced}) =>
      PlaylistEntity(
        provider: provider ?? this.provider,
        itemId: itemId ?? this.itemId,
        name: name ?? this.name,
        sortName: sortName.present ? sortName.value : this.sortName,
        uri: uri.present ? uri.value : this.uri,
        owner: owner.present ? owner.value : this.owner,
        isEditable: isEditable.present ? isEditable.value : this.isEditable,
        trackCount: trackCount.present ? trackCount.value : this.trackCount,
        favorite: favorite ?? this.favorite,
        inLibrary: inLibrary ?? this.inLibrary,
        metadataJson:
            metadataJson.present ? metadataJson.value : this.metadataJson,
        lastSynced: lastSynced ?? this.lastSynced,
      );
  PlaylistEntity copyWithCompanion(PlaylistsCompanion data) {
    return PlaylistEntity(
      provider: data.provider.present ? data.provider.value : this.provider,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      name: data.name.present ? data.name.value : this.name,
      sortName: data.sortName.present ? data.sortName.value : this.sortName,
      uri: data.uri.present ? data.uri.value : this.uri,
      owner: data.owner.present ? data.owner.value : this.owner,
      isEditable:
          data.isEditable.present ? data.isEditable.value : this.isEditable,
      trackCount:
          data.trackCount.present ? data.trackCount.value : this.trackCount,
      favorite: data.favorite.present ? data.favorite.value : this.favorite,
      inLibrary: data.inLibrary.present ? data.inLibrary.value : this.inLibrary,
      metadataJson: data.metadataJson.present
          ? data.metadataJson.value
          : this.metadataJson,
      lastSynced:
          data.lastSynced.present ? data.lastSynced.value : this.lastSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistEntity(')
          ..write('provider: $provider, ')
          ..write('itemId: $itemId, ')
          ..write('name: $name, ')
          ..write('sortName: $sortName, ')
          ..write('uri: $uri, ')
          ..write('owner: $owner, ')
          ..write('isEditable: $isEditable, ')
          ..write('trackCount: $trackCount, ')
          ..write('favorite: $favorite, ')
          ..write('inLibrary: $inLibrary, ')
          ..write('metadataJson: $metadataJson, ')
          ..write('lastSynced: $lastSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(provider, itemId, name, sortName, uri, owner,
      isEditable, trackCount, favorite, inLibrary, metadataJson, lastSynced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlaylistEntity &&
          other.provider == this.provider &&
          other.itemId == this.itemId &&
          other.name == this.name &&
          other.sortName == this.sortName &&
          other.uri == this.uri &&
          other.owner == this.owner &&
          other.isEditable == this.isEditable &&
          other.trackCount == this.trackCount &&
          other.favorite == this.favorite &&
          other.inLibrary == this.inLibrary &&
          other.metadataJson == this.metadataJson &&
          other.lastSynced == this.lastSynced);
}

class PlaylistsCompanion extends UpdateCompanion<PlaylistEntity> {
  final Value<String> provider;
  final Value<String> itemId;
  final Value<String> name;
  final Value<String?> sortName;
  final Value<String?> uri;
  final Value<String?> owner;
  final Value<bool?> isEditable;
  final Value<int?> trackCount;
  final Value<bool> favorite;
  final Value<bool> inLibrary;
  final Value<String?> metadataJson;
  final Value<DateTime> lastSynced;
  final Value<int> rowid;
  const PlaylistsCompanion({
    this.provider = const Value.absent(),
    this.itemId = const Value.absent(),
    this.name = const Value.absent(),
    this.sortName = const Value.absent(),
    this.uri = const Value.absent(),
    this.owner = const Value.absent(),
    this.isEditable = const Value.absent(),
    this.trackCount = const Value.absent(),
    this.favorite = const Value.absent(),
    this.inLibrary = const Value.absent(),
    this.metadataJson = const Value.absent(),
    this.lastSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlaylistsCompanion.insert({
    required String provider,
    required String itemId,
    required String name,
    this.sortName = const Value.absent(),
    this.uri = const Value.absent(),
    this.owner = const Value.absent(),
    this.isEditable = const Value.absent(),
    this.trackCount = const Value.absent(),
    this.favorite = const Value.absent(),
    this.inLibrary = const Value.absent(),
    this.metadataJson = const Value.absent(),
    required DateTime lastSynced,
    this.rowid = const Value.absent(),
  })  : provider = Value(provider),
        itemId = Value(itemId),
        name = Value(name),
        lastSynced = Value(lastSynced);
  static Insertable<PlaylistEntity> custom({
    Expression<String>? provider,
    Expression<String>? itemId,
    Expression<String>? name,
    Expression<String>? sortName,
    Expression<String>? uri,
    Expression<String>? owner,
    Expression<bool>? isEditable,
    Expression<int>? trackCount,
    Expression<bool>? favorite,
    Expression<bool>? inLibrary,
    Expression<String>? metadataJson,
    Expression<DateTime>? lastSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (provider != null) 'provider': provider,
      if (itemId != null) 'item_id': itemId,
      if (name != null) 'name': name,
      if (sortName != null) 'sort_name': sortName,
      if (uri != null) 'uri': uri,
      if (owner != null) 'owner': owner,
      if (isEditable != null) 'is_editable': isEditable,
      if (trackCount != null) 'track_count': trackCount,
      if (favorite != null) 'favorite': favorite,
      if (inLibrary != null) 'in_library': inLibrary,
      if (metadataJson != null) 'metadata_json': metadataJson,
      if (lastSynced != null) 'last_synced': lastSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlaylistsCompanion copyWith(
      {Value<String>? provider,
      Value<String>? itemId,
      Value<String>? name,
      Value<String?>? sortName,
      Value<String?>? uri,
      Value<String?>? owner,
      Value<bool?>? isEditable,
      Value<int?>? trackCount,
      Value<bool>? favorite,
      Value<bool>? inLibrary,
      Value<String?>? metadataJson,
      Value<DateTime>? lastSynced,
      Value<int>? rowid}) {
    return PlaylistsCompanion(
      provider: provider ?? this.provider,
      itemId: itemId ?? this.itemId,
      name: name ?? this.name,
      sortName: sortName ?? this.sortName,
      uri: uri ?? this.uri,
      owner: owner ?? this.owner,
      isEditable: isEditable ?? this.isEditable,
      trackCount: trackCount ?? this.trackCount,
      favorite: favorite ?? this.favorite,
      inLibrary: inLibrary ?? this.inLibrary,
      metadataJson: metadataJson ?? this.metadataJson,
      lastSynced: lastSynced ?? this.lastSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (provider.present) {
      map['provider'] = Variable<String>(provider.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortName.present) {
      map['sort_name'] = Variable<String>(sortName.value);
    }
    if (uri.present) {
      map['uri'] = Variable<String>(uri.value);
    }
    if (owner.present) {
      map['owner'] = Variable<String>(owner.value);
    }
    if (isEditable.present) {
      map['is_editable'] = Variable<bool>(isEditable.value);
    }
    if (trackCount.present) {
      map['track_count'] = Variable<int>(trackCount.value);
    }
    if (favorite.present) {
      map['favorite'] = Variable<bool>(favorite.value);
    }
    if (inLibrary.present) {
      map['in_library'] = Variable<bool>(inLibrary.value);
    }
    if (metadataJson.present) {
      map['metadata_json'] = Variable<String>(metadataJson.value);
    }
    if (lastSynced.present) {
      map['last_synced'] = Variable<DateTime>(lastSynced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistsCompanion(')
          ..write('provider: $provider, ')
          ..write('itemId: $itemId, ')
          ..write('name: $name, ')
          ..write('sortName: $sortName, ')
          ..write('uri: $uri, ')
          ..write('owner: $owner, ')
          ..write('isEditable: $isEditable, ')
          ..write('trackCount: $trackCount, ')
          ..write('favorite: $favorite, ')
          ..write('inLibrary: $inLibrary, ')
          ..write('metadataJson: $metadataJson, ')
          ..write('lastSynced: $lastSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlaylistTracksTable extends PlaylistTracks
    with TableInfo<$PlaylistTracksTable, PlaylistTrackEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaylistTracksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _playlistProviderMeta =
      const VerificationMeta('playlistProvider');
  @override
  late final GeneratedColumn<String> playlistProvider = GeneratedColumn<String>(
      'playlist_provider', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _playlistItemIdMeta =
      const VerificationMeta('playlistItemId');
  @override
  late final GeneratedColumn<String> playlistItemId = GeneratedColumn<String>(
      'playlist_item_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _trackProviderMeta =
      const VerificationMeta('trackProvider');
  @override
  late final GeneratedColumn<String> trackProvider = GeneratedColumn<String>(
      'track_provider', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _trackItemIdMeta =
      const VerificationMeta('trackItemId');
  @override
  late final GeneratedColumn<String> trackItemId = GeneratedColumn<String>(
      'track_item_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _positionMeta =
      const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        playlistProvider,
        playlistItemId,
        trackProvider,
        trackItemId,
        position
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'playlist_tracks';
  @override
  VerificationContext validateIntegrity(
      Insertable<PlaylistTrackEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('playlist_provider')) {
      context.handle(
          _playlistProviderMeta,
          playlistProvider.isAcceptableOrUnknown(
              data['playlist_provider']!, _playlistProviderMeta));
    } else if (isInserting) {
      context.missing(_playlistProviderMeta);
    }
    if (data.containsKey('playlist_item_id')) {
      context.handle(
          _playlistItemIdMeta,
          playlistItemId.isAcceptableOrUnknown(
              data['playlist_item_id']!, _playlistItemIdMeta));
    } else if (isInserting) {
      context.missing(_playlistItemIdMeta);
    }
    if (data.containsKey('track_provider')) {
      context.handle(
          _trackProviderMeta,
          trackProvider.isAcceptableOrUnknown(
              data['track_provider']!, _trackProviderMeta));
    } else if (isInserting) {
      context.missing(_trackProviderMeta);
    }
    if (data.containsKey('track_item_id')) {
      context.handle(
          _trackItemIdMeta,
          trackItemId.isAcceptableOrUnknown(
              data['track_item_id']!, _trackItemIdMeta));
    } else if (isInserting) {
      context.missing(_trackItemIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta,
          position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlaylistTrackEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlaylistTrackEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      playlistProvider: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}playlist_provider'])!,
      playlistItemId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}playlist_item_id'])!,
      trackProvider: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}track_provider'])!,
      trackItemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}track_item_id'])!,
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
    );
  }

  @override
  $PlaylistTracksTable createAlias(String alias) {
    return $PlaylistTracksTable(attachedDatabase, alias);
  }
}

class PlaylistTrackEntity extends DataClass
    implements Insertable<PlaylistTrackEntity> {
  final int id;
  final String playlistProvider;
  final String playlistItemId;
  final String trackProvider;
  final String trackItemId;
  final int position;
  const PlaylistTrackEntity(
      {required this.id,
      required this.playlistProvider,
      required this.playlistItemId,
      required this.trackProvider,
      required this.trackItemId,
      required this.position});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['playlist_provider'] = Variable<String>(playlistProvider);
    map['playlist_item_id'] = Variable<String>(playlistItemId);
    map['track_provider'] = Variable<String>(trackProvider);
    map['track_item_id'] = Variable<String>(trackItemId);
    map['position'] = Variable<int>(position);
    return map;
  }

  PlaylistTracksCompanion toCompanion(bool nullToAbsent) {
    return PlaylistTracksCompanion(
      id: Value(id),
      playlistProvider: Value(playlistProvider),
      playlistItemId: Value(playlistItemId),
      trackProvider: Value(trackProvider),
      trackItemId: Value(trackItemId),
      position: Value(position),
    );
  }

  factory PlaylistTrackEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlaylistTrackEntity(
      id: serializer.fromJson<int>(json['id']),
      playlistProvider: serializer.fromJson<String>(json['playlistProvider']),
      playlistItemId: serializer.fromJson<String>(json['playlistItemId']),
      trackProvider: serializer.fromJson<String>(json['trackProvider']),
      trackItemId: serializer.fromJson<String>(json['trackItemId']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'playlistProvider': serializer.toJson<String>(playlistProvider),
      'playlistItemId': serializer.toJson<String>(playlistItemId),
      'trackProvider': serializer.toJson<String>(trackProvider),
      'trackItemId': serializer.toJson<String>(trackItemId),
      'position': serializer.toJson<int>(position),
    };
  }

  PlaylistTrackEntity copyWith(
          {int? id,
          String? playlistProvider,
          String? playlistItemId,
          String? trackProvider,
          String? trackItemId,
          int? position}) =>
      PlaylistTrackEntity(
        id: id ?? this.id,
        playlistProvider: playlistProvider ?? this.playlistProvider,
        playlistItemId: playlistItemId ?? this.playlistItemId,
        trackProvider: trackProvider ?? this.trackProvider,
        trackItemId: trackItemId ?? this.trackItemId,
        position: position ?? this.position,
      );
  PlaylistTrackEntity copyWithCompanion(PlaylistTracksCompanion data) {
    return PlaylistTrackEntity(
      id: data.id.present ? data.id.value : this.id,
      playlistProvider: data.playlistProvider.present
          ? data.playlistProvider.value
          : this.playlistProvider,
      playlistItemId: data.playlistItemId.present
          ? data.playlistItemId.value
          : this.playlistItemId,
      trackProvider: data.trackProvider.present
          ? data.trackProvider.value
          : this.trackProvider,
      trackItemId:
          data.trackItemId.present ? data.trackItemId.value : this.trackItemId,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistTrackEntity(')
          ..write('id: $id, ')
          ..write('playlistProvider: $playlistProvider, ')
          ..write('playlistItemId: $playlistItemId, ')
          ..write('trackProvider: $trackProvider, ')
          ..write('trackItemId: $trackItemId, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, playlistProvider, playlistItemId,
      trackProvider, trackItemId, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlaylistTrackEntity &&
          other.id == this.id &&
          other.playlistProvider == this.playlistProvider &&
          other.playlistItemId == this.playlistItemId &&
          other.trackProvider == this.trackProvider &&
          other.trackItemId == this.trackItemId &&
          other.position == this.position);
}

class PlaylistTracksCompanion extends UpdateCompanion<PlaylistTrackEntity> {
  final Value<int> id;
  final Value<String> playlistProvider;
  final Value<String> playlistItemId;
  final Value<String> trackProvider;
  final Value<String> trackItemId;
  final Value<int> position;
  const PlaylistTracksCompanion({
    this.id = const Value.absent(),
    this.playlistProvider = const Value.absent(),
    this.playlistItemId = const Value.absent(),
    this.trackProvider = const Value.absent(),
    this.trackItemId = const Value.absent(),
    this.position = const Value.absent(),
  });
  PlaylistTracksCompanion.insert({
    this.id = const Value.absent(),
    required String playlistProvider,
    required String playlistItemId,
    required String trackProvider,
    required String trackItemId,
    required int position,
  })  : playlistProvider = Value(playlistProvider),
        playlistItemId = Value(playlistItemId),
        trackProvider = Value(trackProvider),
        trackItemId = Value(trackItemId),
        position = Value(position);
  static Insertable<PlaylistTrackEntity> custom({
    Expression<int>? id,
    Expression<String>? playlistProvider,
    Expression<String>? playlistItemId,
    Expression<String>? trackProvider,
    Expression<String>? trackItemId,
    Expression<int>? position,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (playlistProvider != null) 'playlist_provider': playlistProvider,
      if (playlistItemId != null) 'playlist_item_id': playlistItemId,
      if (trackProvider != null) 'track_provider': trackProvider,
      if (trackItemId != null) 'track_item_id': trackItemId,
      if (position != null) 'position': position,
    });
  }

  PlaylistTracksCompanion copyWith(
      {Value<int>? id,
      Value<String>? playlistProvider,
      Value<String>? playlistItemId,
      Value<String>? trackProvider,
      Value<String>? trackItemId,
      Value<int>? position}) {
    return PlaylistTracksCompanion(
      id: id ?? this.id,
      playlistProvider: playlistProvider ?? this.playlistProvider,
      playlistItemId: playlistItemId ?? this.playlistItemId,
      trackProvider: trackProvider ?? this.trackProvider,
      trackItemId: trackItemId ?? this.trackItemId,
      position: position ?? this.position,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (playlistProvider.present) {
      map['playlist_provider'] = Variable<String>(playlistProvider.value);
    }
    if (playlistItemId.present) {
      map['playlist_item_id'] = Variable<String>(playlistItemId.value);
    }
    if (trackProvider.present) {
      map['track_provider'] = Variable<String>(trackProvider.value);
    }
    if (trackItemId.present) {
      map['track_item_id'] = Variable<String>(trackItemId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistTracksCompanion(')
          ..write('id: $id, ')
          ..write('playlistProvider: $playlistProvider, ')
          ..write('playlistItemId: $playlistItemId, ')
          ..write('trackProvider: $trackProvider, ')
          ..write('trackItemId: $trackItemId, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }
}

class $AudiobooksTable extends Audiobooks
    with TableInfo<$AudiobooksTable, AudiobookEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AudiobooksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _providerMeta =
      const VerificationMeta('provider');
  @override
  late final GeneratedColumn<String> provider = GeneratedColumn<String>(
      'provider', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
      'item_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sortNameMeta =
      const VerificationMeta('sortName');
  @override
  late final GeneratedColumn<String> sortName = GeneratedColumn<String>(
      'sort_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _uriMeta = const VerificationMeta('uri');
  @override
  late final GeneratedColumn<String> uri = GeneratedColumn<String>(
      'uri', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _authorsJsonMeta =
      const VerificationMeta('authorsJson');
  @override
  late final GeneratedColumn<String> authorsJson = GeneratedColumn<String>(
      'authors_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _narratorsJsonMeta =
      const VerificationMeta('narratorsJson');
  @override
  late final GeneratedColumn<String> narratorsJson = GeneratedColumn<String>(
      'narrators_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _publisherMeta =
      const VerificationMeta('publisher');
  @override
  late final GeneratedColumn<String> publisher = GeneratedColumn<String>(
      'publisher', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
      'year', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _durationSecondsMeta =
      const VerificationMeta('durationSeconds');
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
      'duration_seconds', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _resumePositionMsMeta =
      const VerificationMeta('resumePositionMs');
  @override
  late final GeneratedColumn<int> resumePositionMs = GeneratedColumn<int>(
      'resume_position_ms', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _fullyPlayedMeta =
      const VerificationMeta('fullyPlayed');
  @override
  late final GeneratedColumn<bool> fullyPlayed = GeneratedColumn<bool>(
      'fully_played', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("fully_played" IN (0, 1))'));
  static const VerificationMeta _browseOrderMeta =
      const VerificationMeta('browseOrder');
  @override
  late final GeneratedColumn<int> browseOrder = GeneratedColumn<int>(
      'browse_order', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _favoriteMeta =
      const VerificationMeta('favorite');
  @override
  late final GeneratedColumn<bool> favorite = GeneratedColumn<bool>(
      'favorite', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("favorite" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _inLibraryMeta =
      const VerificationMeta('inLibrary');
  @override
  late final GeneratedColumn<bool> inLibrary = GeneratedColumn<bool>(
      'in_library', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("in_library" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _metadataJsonMeta =
      const VerificationMeta('metadataJson');
  @override
  late final GeneratedColumn<String> metadataJson = GeneratedColumn<String>(
      'metadata_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastSyncedMeta =
      const VerificationMeta('lastSynced');
  @override
  late final GeneratedColumn<DateTime> lastSynced = GeneratedColumn<DateTime>(
      'last_synced', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        provider,
        itemId,
        name,
        sortName,
        uri,
        authorsJson,
        narratorsJson,
        publisher,
        description,
        year,
        durationSeconds,
        resumePositionMs,
        fullyPlayed,
        browseOrder,
        favorite,
        inLibrary,
        metadataJson,
        lastSynced
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audiobooks';
  @override
  VerificationContext validateIntegrity(Insertable<AudiobookEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('provider')) {
      context.handle(_providerMeta,
          provider.isAcceptableOrUnknown(data['provider']!, _providerMeta));
    } else if (isInserting) {
      context.missing(_providerMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sort_name')) {
      context.handle(_sortNameMeta,
          sortName.isAcceptableOrUnknown(data['sort_name']!, _sortNameMeta));
    }
    if (data.containsKey('uri')) {
      context.handle(
          _uriMeta, uri.isAcceptableOrUnknown(data['uri']!, _uriMeta));
    }
    if (data.containsKey('authors_json')) {
      context.handle(
          _authorsJsonMeta,
          authorsJson.isAcceptableOrUnknown(
              data['authors_json']!, _authorsJsonMeta));
    }
    if (data.containsKey('narrators_json')) {
      context.handle(
          _narratorsJsonMeta,
          narratorsJson.isAcceptableOrUnknown(
              data['narrators_json']!, _narratorsJsonMeta));
    }
    if (data.containsKey('publisher')) {
      context.handle(_publisherMeta,
          publisher.isAcceptableOrUnknown(data['publisher']!, _publisherMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('year')) {
      context.handle(
          _yearMeta, year.isAcceptableOrUnknown(data['year']!, _yearMeta));
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
          _durationSecondsMeta,
          durationSeconds.isAcceptableOrUnknown(
              data['duration_seconds']!, _durationSecondsMeta));
    }
    if (data.containsKey('resume_position_ms')) {
      context.handle(
          _resumePositionMsMeta,
          resumePositionMs.isAcceptableOrUnknown(
              data['resume_position_ms']!, _resumePositionMsMeta));
    }
    if (data.containsKey('fully_played')) {
      context.handle(
          _fullyPlayedMeta,
          fullyPlayed.isAcceptableOrUnknown(
              data['fully_played']!, _fullyPlayedMeta));
    }
    if (data.containsKey('browse_order')) {
      context.handle(
          _browseOrderMeta,
          browseOrder.isAcceptableOrUnknown(
              data['browse_order']!, _browseOrderMeta));
    }
    if (data.containsKey('favorite')) {
      context.handle(_favoriteMeta,
          favorite.isAcceptableOrUnknown(data['favorite']!, _favoriteMeta));
    }
    if (data.containsKey('in_library')) {
      context.handle(_inLibraryMeta,
          inLibrary.isAcceptableOrUnknown(data['in_library']!, _inLibraryMeta));
    }
    if (data.containsKey('metadata_json')) {
      context.handle(
          _metadataJsonMeta,
          metadataJson.isAcceptableOrUnknown(
              data['metadata_json']!, _metadataJsonMeta));
    }
    if (data.containsKey('last_synced')) {
      context.handle(
          _lastSyncedMeta,
          lastSynced.isAcceptableOrUnknown(
              data['last_synced']!, _lastSyncedMeta));
    } else if (isInserting) {
      context.missing(_lastSyncedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {provider, itemId};
  @override
  AudiobookEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AudiobookEntity(
      provider: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}provider'])!,
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      sortName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sort_name']),
      uri: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uri']),
      authorsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}authors_json']),
      narratorsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}narrators_json']),
      publisher: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}publisher']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      year: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}year']),
      durationSeconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_seconds']),
      resumePositionMs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}resume_position_ms']),
      fullyPlayed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}fully_played']),
      browseOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}browse_order']),
      favorite: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}favorite'])!,
      inLibrary: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}in_library'])!,
      metadataJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metadata_json']),
      lastSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_synced'])!,
    );
  }

  @override
  $AudiobooksTable createAlias(String alias) {
    return $AudiobooksTable(attachedDatabase, alias);
  }
}

class AudiobookEntity extends DataClass implements Insertable<AudiobookEntity> {
  final String provider;
  final String itemId;
  final String name;
  final String? sortName;
  final String? uri;
  final String? authorsJson;
  final String? narratorsJson;
  final String? publisher;
  final String? description;
  final int? year;
  final int? durationSeconds;
  final int? resumePositionMs;
  final bool? fullyPlayed;
  final int? browseOrder;
  final bool favorite;
  final bool inLibrary;
  final String? metadataJson;
  final DateTime lastSynced;
  const AudiobookEntity(
      {required this.provider,
      required this.itemId,
      required this.name,
      this.sortName,
      this.uri,
      this.authorsJson,
      this.narratorsJson,
      this.publisher,
      this.description,
      this.year,
      this.durationSeconds,
      this.resumePositionMs,
      this.fullyPlayed,
      this.browseOrder,
      required this.favorite,
      required this.inLibrary,
      this.metadataJson,
      required this.lastSynced});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['provider'] = Variable<String>(provider);
    map['item_id'] = Variable<String>(itemId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || sortName != null) {
      map['sort_name'] = Variable<String>(sortName);
    }
    if (!nullToAbsent || uri != null) {
      map['uri'] = Variable<String>(uri);
    }
    if (!nullToAbsent || authorsJson != null) {
      map['authors_json'] = Variable<String>(authorsJson);
    }
    if (!nullToAbsent || narratorsJson != null) {
      map['narrators_json'] = Variable<String>(narratorsJson);
    }
    if (!nullToAbsent || publisher != null) {
      map['publisher'] = Variable<String>(publisher);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || year != null) {
      map['year'] = Variable<int>(year);
    }
    if (!nullToAbsent || durationSeconds != null) {
      map['duration_seconds'] = Variable<int>(durationSeconds);
    }
    if (!nullToAbsent || resumePositionMs != null) {
      map['resume_position_ms'] = Variable<int>(resumePositionMs);
    }
    if (!nullToAbsent || fullyPlayed != null) {
      map['fully_played'] = Variable<bool>(fullyPlayed);
    }
    if (!nullToAbsent || browseOrder != null) {
      map['browse_order'] = Variable<int>(browseOrder);
    }
    map['favorite'] = Variable<bool>(favorite);
    map['in_library'] = Variable<bool>(inLibrary);
    if (!nullToAbsent || metadataJson != null) {
      map['metadata_json'] = Variable<String>(metadataJson);
    }
    map['last_synced'] = Variable<DateTime>(lastSynced);
    return map;
  }

  AudiobooksCompanion toCompanion(bool nullToAbsent) {
    return AudiobooksCompanion(
      provider: Value(provider),
      itemId: Value(itemId),
      name: Value(name),
      sortName: sortName == null && nullToAbsent
          ? const Value.absent()
          : Value(sortName),
      uri: uri == null && nullToAbsent ? const Value.absent() : Value(uri),
      authorsJson: authorsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(authorsJson),
      narratorsJson: narratorsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(narratorsJson),
      publisher: publisher == null && nullToAbsent
          ? const Value.absent()
          : Value(publisher),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      year: year == null && nullToAbsent ? const Value.absent() : Value(year),
      durationSeconds: durationSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(durationSeconds),
      resumePositionMs: resumePositionMs == null && nullToAbsent
          ? const Value.absent()
          : Value(resumePositionMs),
      fullyPlayed: fullyPlayed == null && nullToAbsent
          ? const Value.absent()
          : Value(fullyPlayed),
      browseOrder: browseOrder == null && nullToAbsent
          ? const Value.absent()
          : Value(browseOrder),
      favorite: Value(favorite),
      inLibrary: Value(inLibrary),
      metadataJson: metadataJson == null && nullToAbsent
          ? const Value.absent()
          : Value(metadataJson),
      lastSynced: Value(lastSynced),
    );
  }

  factory AudiobookEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AudiobookEntity(
      provider: serializer.fromJson<String>(json['provider']),
      itemId: serializer.fromJson<String>(json['itemId']),
      name: serializer.fromJson<String>(json['name']),
      sortName: serializer.fromJson<String?>(json['sortName']),
      uri: serializer.fromJson<String?>(json['uri']),
      authorsJson: serializer.fromJson<String?>(json['authorsJson']),
      narratorsJson: serializer.fromJson<String?>(json['narratorsJson']),
      publisher: serializer.fromJson<String?>(json['publisher']),
      description: serializer.fromJson<String?>(json['description']),
      year: serializer.fromJson<int?>(json['year']),
      durationSeconds: serializer.fromJson<int?>(json['durationSeconds']),
      resumePositionMs: serializer.fromJson<int?>(json['resumePositionMs']),
      fullyPlayed: serializer.fromJson<bool?>(json['fullyPlayed']),
      browseOrder: serializer.fromJson<int?>(json['browseOrder']),
      favorite: serializer.fromJson<bool>(json['favorite']),
      inLibrary: serializer.fromJson<bool>(json['inLibrary']),
      metadataJson: serializer.fromJson<String?>(json['metadataJson']),
      lastSynced: serializer.fromJson<DateTime>(json['lastSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'provider': serializer.toJson<String>(provider),
      'itemId': serializer.toJson<String>(itemId),
      'name': serializer.toJson<String>(name),
      'sortName': serializer.toJson<String?>(sortName),
      'uri': serializer.toJson<String?>(uri),
      'authorsJson': serializer.toJson<String?>(authorsJson),
      'narratorsJson': serializer.toJson<String?>(narratorsJson),
      'publisher': serializer.toJson<String?>(publisher),
      'description': serializer.toJson<String?>(description),
      'year': serializer.toJson<int?>(year),
      'durationSeconds': serializer.toJson<int?>(durationSeconds),
      'resumePositionMs': serializer.toJson<int?>(resumePositionMs),
      'fullyPlayed': serializer.toJson<bool?>(fullyPlayed),
      'browseOrder': serializer.toJson<int?>(browseOrder),
      'favorite': serializer.toJson<bool>(favorite),
      'inLibrary': serializer.toJson<bool>(inLibrary),
      'metadataJson': serializer.toJson<String?>(metadataJson),
      'lastSynced': serializer.toJson<DateTime>(lastSynced),
    };
  }

  AudiobookEntity copyWith(
          {String? provider,
          String? itemId,
          String? name,
          Value<String?> sortName = const Value.absent(),
          Value<String?> uri = const Value.absent(),
          Value<String?> authorsJson = const Value.absent(),
          Value<String?> narratorsJson = const Value.absent(),
          Value<String?> publisher = const Value.absent(),
          Value<String?> description = const Value.absent(),
          Value<int?> year = const Value.absent(),
          Value<int?> durationSeconds = const Value.absent(),
          Value<int?> resumePositionMs = const Value.absent(),
          Value<bool?> fullyPlayed = const Value.absent(),
          Value<int?> browseOrder = const Value.absent(),
          bool? favorite,
          bool? inLibrary,
          Value<String?> metadataJson = const Value.absent(),
          DateTime? lastSynced}) =>
      AudiobookEntity(
        provider: provider ?? this.provider,
        itemId: itemId ?? this.itemId,
        name: name ?? this.name,
        sortName: sortName.present ? sortName.value : this.sortName,
        uri: uri.present ? uri.value : this.uri,
        authorsJson: authorsJson.present ? authorsJson.value : this.authorsJson,
        narratorsJson:
            narratorsJson.present ? narratorsJson.value : this.narratorsJson,
        publisher: publisher.present ? publisher.value : this.publisher,
        description: description.present ? description.value : this.description,
        year: year.present ? year.value : this.year,
        durationSeconds: durationSeconds.present
            ? durationSeconds.value
            : this.durationSeconds,
        resumePositionMs: resumePositionMs.present
            ? resumePositionMs.value
            : this.resumePositionMs,
        fullyPlayed: fullyPlayed.present ? fullyPlayed.value : this.fullyPlayed,
        browseOrder: browseOrder.present ? browseOrder.value : this.browseOrder,
        favorite: favorite ?? this.favorite,
        inLibrary: inLibrary ?? this.inLibrary,
        metadataJson:
            metadataJson.present ? metadataJson.value : this.metadataJson,
        lastSynced: lastSynced ?? this.lastSynced,
      );
  AudiobookEntity copyWithCompanion(AudiobooksCompanion data) {
    return AudiobookEntity(
      provider: data.provider.present ? data.provider.value : this.provider,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      name: data.name.present ? data.name.value : this.name,
      sortName: data.sortName.present ? data.sortName.value : this.sortName,
      uri: data.uri.present ? data.uri.value : this.uri,
      authorsJson:
          data.authorsJson.present ? data.authorsJson.value : this.authorsJson,
      narratorsJson: data.narratorsJson.present
          ? data.narratorsJson.value
          : this.narratorsJson,
      publisher: data.publisher.present ? data.publisher.value : this.publisher,
      description:
          data.description.present ? data.description.value : this.description,
      year: data.year.present ? data.year.value : this.year,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      resumePositionMs: data.resumePositionMs.present
          ? data.resumePositionMs.value
          : this.resumePositionMs,
      fullyPlayed:
          data.fullyPlayed.present ? data.fullyPlayed.value : this.fullyPlayed,
      browseOrder:
          data.browseOrder.present ? data.browseOrder.value : this.browseOrder,
      favorite: data.favorite.present ? data.favorite.value : this.favorite,
      inLibrary: data.inLibrary.present ? data.inLibrary.value : this.inLibrary,
      metadataJson: data.metadataJson.present
          ? data.metadataJson.value
          : this.metadataJson,
      lastSynced:
          data.lastSynced.present ? data.lastSynced.value : this.lastSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AudiobookEntity(')
          ..write('provider: $provider, ')
          ..write('itemId: $itemId, ')
          ..write('name: $name, ')
          ..write('sortName: $sortName, ')
          ..write('uri: $uri, ')
          ..write('authorsJson: $authorsJson, ')
          ..write('narratorsJson: $narratorsJson, ')
          ..write('publisher: $publisher, ')
          ..write('description: $description, ')
          ..write('year: $year, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('resumePositionMs: $resumePositionMs, ')
          ..write('fullyPlayed: $fullyPlayed, ')
          ..write('browseOrder: $browseOrder, ')
          ..write('favorite: $favorite, ')
          ..write('inLibrary: $inLibrary, ')
          ..write('metadataJson: $metadataJson, ')
          ..write('lastSynced: $lastSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      provider,
      itemId,
      name,
      sortName,
      uri,
      authorsJson,
      narratorsJson,
      publisher,
      description,
      year,
      durationSeconds,
      resumePositionMs,
      fullyPlayed,
      browseOrder,
      favorite,
      inLibrary,
      metadataJson,
      lastSynced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AudiobookEntity &&
          other.provider == this.provider &&
          other.itemId == this.itemId &&
          other.name == this.name &&
          other.sortName == this.sortName &&
          other.uri == this.uri &&
          other.authorsJson == this.authorsJson &&
          other.narratorsJson == this.narratorsJson &&
          other.publisher == this.publisher &&
          other.description == this.description &&
          other.year == this.year &&
          other.durationSeconds == this.durationSeconds &&
          other.resumePositionMs == this.resumePositionMs &&
          other.fullyPlayed == this.fullyPlayed &&
          other.browseOrder == this.browseOrder &&
          other.favorite == this.favorite &&
          other.inLibrary == this.inLibrary &&
          other.metadataJson == this.metadataJson &&
          other.lastSynced == this.lastSynced);
}

class AudiobooksCompanion extends UpdateCompanion<AudiobookEntity> {
  final Value<String> provider;
  final Value<String> itemId;
  final Value<String> name;
  final Value<String?> sortName;
  final Value<String?> uri;
  final Value<String?> authorsJson;
  final Value<String?> narratorsJson;
  final Value<String?> publisher;
  final Value<String?> description;
  final Value<int?> year;
  final Value<int?> durationSeconds;
  final Value<int?> resumePositionMs;
  final Value<bool?> fullyPlayed;
  final Value<int?> browseOrder;
  final Value<bool> favorite;
  final Value<bool> inLibrary;
  final Value<String?> metadataJson;
  final Value<DateTime> lastSynced;
  final Value<int> rowid;
  const AudiobooksCompanion({
    this.provider = const Value.absent(),
    this.itemId = const Value.absent(),
    this.name = const Value.absent(),
    this.sortName = const Value.absent(),
    this.uri = const Value.absent(),
    this.authorsJson = const Value.absent(),
    this.narratorsJson = const Value.absent(),
    this.publisher = const Value.absent(),
    this.description = const Value.absent(),
    this.year = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.resumePositionMs = const Value.absent(),
    this.fullyPlayed = const Value.absent(),
    this.browseOrder = const Value.absent(),
    this.favorite = const Value.absent(),
    this.inLibrary = const Value.absent(),
    this.metadataJson = const Value.absent(),
    this.lastSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AudiobooksCompanion.insert({
    required String provider,
    required String itemId,
    required String name,
    this.sortName = const Value.absent(),
    this.uri = const Value.absent(),
    this.authorsJson = const Value.absent(),
    this.narratorsJson = const Value.absent(),
    this.publisher = const Value.absent(),
    this.description = const Value.absent(),
    this.year = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.resumePositionMs = const Value.absent(),
    this.fullyPlayed = const Value.absent(),
    this.browseOrder = const Value.absent(),
    this.favorite = const Value.absent(),
    this.inLibrary = const Value.absent(),
    this.metadataJson = const Value.absent(),
    required DateTime lastSynced,
    this.rowid = const Value.absent(),
  })  : provider = Value(provider),
        itemId = Value(itemId),
        name = Value(name),
        lastSynced = Value(lastSynced);
  static Insertable<AudiobookEntity> custom({
    Expression<String>? provider,
    Expression<String>? itemId,
    Expression<String>? name,
    Expression<String>? sortName,
    Expression<String>? uri,
    Expression<String>? authorsJson,
    Expression<String>? narratorsJson,
    Expression<String>? publisher,
    Expression<String>? description,
    Expression<int>? year,
    Expression<int>? durationSeconds,
    Expression<int>? resumePositionMs,
    Expression<bool>? fullyPlayed,
    Expression<int>? browseOrder,
    Expression<bool>? favorite,
    Expression<bool>? inLibrary,
    Expression<String>? metadataJson,
    Expression<DateTime>? lastSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (provider != null) 'provider': provider,
      if (itemId != null) 'item_id': itemId,
      if (name != null) 'name': name,
      if (sortName != null) 'sort_name': sortName,
      if (uri != null) 'uri': uri,
      if (authorsJson != null) 'authors_json': authorsJson,
      if (narratorsJson != null) 'narrators_json': narratorsJson,
      if (publisher != null) 'publisher': publisher,
      if (description != null) 'description': description,
      if (year != null) 'year': year,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (resumePositionMs != null) 'resume_position_ms': resumePositionMs,
      if (fullyPlayed != null) 'fully_played': fullyPlayed,
      if (browseOrder != null) 'browse_order': browseOrder,
      if (favorite != null) 'favorite': favorite,
      if (inLibrary != null) 'in_library': inLibrary,
      if (metadataJson != null) 'metadata_json': metadataJson,
      if (lastSynced != null) 'last_synced': lastSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AudiobooksCompanion copyWith(
      {Value<String>? provider,
      Value<String>? itemId,
      Value<String>? name,
      Value<String?>? sortName,
      Value<String?>? uri,
      Value<String?>? authorsJson,
      Value<String?>? narratorsJson,
      Value<String?>? publisher,
      Value<String?>? description,
      Value<int?>? year,
      Value<int?>? durationSeconds,
      Value<int?>? resumePositionMs,
      Value<bool?>? fullyPlayed,
      Value<int?>? browseOrder,
      Value<bool>? favorite,
      Value<bool>? inLibrary,
      Value<String?>? metadataJson,
      Value<DateTime>? lastSynced,
      Value<int>? rowid}) {
    return AudiobooksCompanion(
      provider: provider ?? this.provider,
      itemId: itemId ?? this.itemId,
      name: name ?? this.name,
      sortName: sortName ?? this.sortName,
      uri: uri ?? this.uri,
      authorsJson: authorsJson ?? this.authorsJson,
      narratorsJson: narratorsJson ?? this.narratorsJson,
      publisher: publisher ?? this.publisher,
      description: description ?? this.description,
      year: year ?? this.year,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      resumePositionMs: resumePositionMs ?? this.resumePositionMs,
      fullyPlayed: fullyPlayed ?? this.fullyPlayed,
      browseOrder: browseOrder ?? this.browseOrder,
      favorite: favorite ?? this.favorite,
      inLibrary: inLibrary ?? this.inLibrary,
      metadataJson: metadataJson ?? this.metadataJson,
      lastSynced: lastSynced ?? this.lastSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (provider.present) {
      map['provider'] = Variable<String>(provider.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortName.present) {
      map['sort_name'] = Variable<String>(sortName.value);
    }
    if (uri.present) {
      map['uri'] = Variable<String>(uri.value);
    }
    if (authorsJson.present) {
      map['authors_json'] = Variable<String>(authorsJson.value);
    }
    if (narratorsJson.present) {
      map['narrators_json'] = Variable<String>(narratorsJson.value);
    }
    if (publisher.present) {
      map['publisher'] = Variable<String>(publisher.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (resumePositionMs.present) {
      map['resume_position_ms'] = Variable<int>(resumePositionMs.value);
    }
    if (fullyPlayed.present) {
      map['fully_played'] = Variable<bool>(fullyPlayed.value);
    }
    if (browseOrder.present) {
      map['browse_order'] = Variable<int>(browseOrder.value);
    }
    if (favorite.present) {
      map['favorite'] = Variable<bool>(favorite.value);
    }
    if (inLibrary.present) {
      map['in_library'] = Variable<bool>(inLibrary.value);
    }
    if (metadataJson.present) {
      map['metadata_json'] = Variable<String>(metadataJson.value);
    }
    if (lastSynced.present) {
      map['last_synced'] = Variable<DateTime>(lastSynced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AudiobooksCompanion(')
          ..write('provider: $provider, ')
          ..write('itemId: $itemId, ')
          ..write('name: $name, ')
          ..write('sortName: $sortName, ')
          ..write('uri: $uri, ')
          ..write('authorsJson: $authorsJson, ')
          ..write('narratorsJson: $narratorsJson, ')
          ..write('publisher: $publisher, ')
          ..write('description: $description, ')
          ..write('year: $year, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('resumePositionMs: $resumePositionMs, ')
          ..write('fullyPlayed: $fullyPlayed, ')
          ..write('browseOrder: $browseOrder, ')
          ..write('favorite: $favorite, ')
          ..write('inLibrary: $inLibrary, ')
          ..write('metadataJson: $metadataJson, ')
          ..write('lastSynced: $lastSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChaptersTable extends Chapters
    with TableInfo<$ChaptersTable, ChapterEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChaptersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _audiobookProviderMeta =
      const VerificationMeta('audiobookProvider');
  @override
  late final GeneratedColumn<String> audiobookProvider =
      GeneratedColumn<String>('audiobook_provider', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _audiobookItemIdMeta =
      const VerificationMeta('audiobookItemId');
  @override
  late final GeneratedColumn<String> audiobookItemId = GeneratedColumn<String>(
      'audiobook_item_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _chapterNumberMeta =
      const VerificationMeta('chapterNumber');
  @override
  late final GeneratedColumn<int> chapterNumber = GeneratedColumn<int>(
      'chapter_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _positionMsMeta =
      const VerificationMeta('positionMs');
  @override
  late final GeneratedColumn<int> positionMs = GeneratedColumn<int>(
      'position_ms', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _durationMsMeta =
      const VerificationMeta('durationMs');
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
      'duration_ms', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        audiobookProvider,
        audiobookItemId,
        chapterNumber,
        positionMs,
        title,
        durationMs
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chapters';
  @override
  VerificationContext validateIntegrity(Insertable<ChapterEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('audiobook_provider')) {
      context.handle(
          _audiobookProviderMeta,
          audiobookProvider.isAcceptableOrUnknown(
              data['audiobook_provider']!, _audiobookProviderMeta));
    } else if (isInserting) {
      context.missing(_audiobookProviderMeta);
    }
    if (data.containsKey('audiobook_item_id')) {
      context.handle(
          _audiobookItemIdMeta,
          audiobookItemId.isAcceptableOrUnknown(
              data['audiobook_item_id']!, _audiobookItemIdMeta));
    } else if (isInserting) {
      context.missing(_audiobookItemIdMeta);
    }
    if (data.containsKey('chapter_number')) {
      context.handle(
          _chapterNumberMeta,
          chapterNumber.isAcceptableOrUnknown(
              data['chapter_number']!, _chapterNumberMeta));
    } else if (isInserting) {
      context.missing(_chapterNumberMeta);
    }
    if (data.containsKey('position_ms')) {
      context.handle(
          _positionMsMeta,
          positionMs.isAcceptableOrUnknown(
              data['position_ms']!, _positionMsMeta));
    } else if (isInserting) {
      context.missing(_positionMsMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
          _durationMsMeta,
          durationMs.isAcceptableOrUnknown(
              data['duration_ms']!, _durationMsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChapterEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChapterEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      audiobookProvider: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}audiobook_provider'])!,
      audiobookItemId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}audiobook_item_id'])!,
      chapterNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}chapter_number'])!,
      positionMs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position_ms'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      durationMs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_ms']),
    );
  }

  @override
  $ChaptersTable createAlias(String alias) {
    return $ChaptersTable(attachedDatabase, alias);
  }
}

class ChapterEntity extends DataClass implements Insertable<ChapterEntity> {
  final int id;
  final String audiobookProvider;
  final String audiobookItemId;
  final int chapterNumber;
  final int positionMs;
  final String title;
  final int? durationMs;
  const ChapterEntity(
      {required this.id,
      required this.audiobookProvider,
      required this.audiobookItemId,
      required this.chapterNumber,
      required this.positionMs,
      required this.title,
      this.durationMs});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['audiobook_provider'] = Variable<String>(audiobookProvider);
    map['audiobook_item_id'] = Variable<String>(audiobookItemId);
    map['chapter_number'] = Variable<int>(chapterNumber);
    map['position_ms'] = Variable<int>(positionMs);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || durationMs != null) {
      map['duration_ms'] = Variable<int>(durationMs);
    }
    return map;
  }

  ChaptersCompanion toCompanion(bool nullToAbsent) {
    return ChaptersCompanion(
      id: Value(id),
      audiobookProvider: Value(audiobookProvider),
      audiobookItemId: Value(audiobookItemId),
      chapterNumber: Value(chapterNumber),
      positionMs: Value(positionMs),
      title: Value(title),
      durationMs: durationMs == null && nullToAbsent
          ? const Value.absent()
          : Value(durationMs),
    );
  }

  factory ChapterEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChapterEntity(
      id: serializer.fromJson<int>(json['id']),
      audiobookProvider: serializer.fromJson<String>(json['audiobookProvider']),
      audiobookItemId: serializer.fromJson<String>(json['audiobookItemId']),
      chapterNumber: serializer.fromJson<int>(json['chapterNumber']),
      positionMs: serializer.fromJson<int>(json['positionMs']),
      title: serializer.fromJson<String>(json['title']),
      durationMs: serializer.fromJson<int?>(json['durationMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'audiobookProvider': serializer.toJson<String>(audiobookProvider),
      'audiobookItemId': serializer.toJson<String>(audiobookItemId),
      'chapterNumber': serializer.toJson<int>(chapterNumber),
      'positionMs': serializer.toJson<int>(positionMs),
      'title': serializer.toJson<String>(title),
      'durationMs': serializer.toJson<int?>(durationMs),
    };
  }

  ChapterEntity copyWith(
          {int? id,
          String? audiobookProvider,
          String? audiobookItemId,
          int? chapterNumber,
          int? positionMs,
          String? title,
          Value<int?> durationMs = const Value.absent()}) =>
      ChapterEntity(
        id: id ?? this.id,
        audiobookProvider: audiobookProvider ?? this.audiobookProvider,
        audiobookItemId: audiobookItemId ?? this.audiobookItemId,
        chapterNumber: chapterNumber ?? this.chapterNumber,
        positionMs: positionMs ?? this.positionMs,
        title: title ?? this.title,
        durationMs: durationMs.present ? durationMs.value : this.durationMs,
      );
  ChapterEntity copyWithCompanion(ChaptersCompanion data) {
    return ChapterEntity(
      id: data.id.present ? data.id.value : this.id,
      audiobookProvider: data.audiobookProvider.present
          ? data.audiobookProvider.value
          : this.audiobookProvider,
      audiobookItemId: data.audiobookItemId.present
          ? data.audiobookItemId.value
          : this.audiobookItemId,
      chapterNumber: data.chapterNumber.present
          ? data.chapterNumber.value
          : this.chapterNumber,
      positionMs:
          data.positionMs.present ? data.positionMs.value : this.positionMs,
      title: data.title.present ? data.title.value : this.title,
      durationMs:
          data.durationMs.present ? data.durationMs.value : this.durationMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChapterEntity(')
          ..write('id: $id, ')
          ..write('audiobookProvider: $audiobookProvider, ')
          ..write('audiobookItemId: $audiobookItemId, ')
          ..write('chapterNumber: $chapterNumber, ')
          ..write('positionMs: $positionMs, ')
          ..write('title: $title, ')
          ..write('durationMs: $durationMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, audiobookProvider, audiobookItemId,
      chapterNumber, positionMs, title, durationMs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChapterEntity &&
          other.id == this.id &&
          other.audiobookProvider == this.audiobookProvider &&
          other.audiobookItemId == this.audiobookItemId &&
          other.chapterNumber == this.chapterNumber &&
          other.positionMs == this.positionMs &&
          other.title == this.title &&
          other.durationMs == this.durationMs);
}

class ChaptersCompanion extends UpdateCompanion<ChapterEntity> {
  final Value<int> id;
  final Value<String> audiobookProvider;
  final Value<String> audiobookItemId;
  final Value<int> chapterNumber;
  final Value<int> positionMs;
  final Value<String> title;
  final Value<int?> durationMs;
  const ChaptersCompanion({
    this.id = const Value.absent(),
    this.audiobookProvider = const Value.absent(),
    this.audiobookItemId = const Value.absent(),
    this.chapterNumber = const Value.absent(),
    this.positionMs = const Value.absent(),
    this.title = const Value.absent(),
    this.durationMs = const Value.absent(),
  });
  ChaptersCompanion.insert({
    this.id = const Value.absent(),
    required String audiobookProvider,
    required String audiobookItemId,
    required int chapterNumber,
    required int positionMs,
    required String title,
    this.durationMs = const Value.absent(),
  })  : audiobookProvider = Value(audiobookProvider),
        audiobookItemId = Value(audiobookItemId),
        chapterNumber = Value(chapterNumber),
        positionMs = Value(positionMs),
        title = Value(title);
  static Insertable<ChapterEntity> custom({
    Expression<int>? id,
    Expression<String>? audiobookProvider,
    Expression<String>? audiobookItemId,
    Expression<int>? chapterNumber,
    Expression<int>? positionMs,
    Expression<String>? title,
    Expression<int>? durationMs,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (audiobookProvider != null) 'audiobook_provider': audiobookProvider,
      if (audiobookItemId != null) 'audiobook_item_id': audiobookItemId,
      if (chapterNumber != null) 'chapter_number': chapterNumber,
      if (positionMs != null) 'position_ms': positionMs,
      if (title != null) 'title': title,
      if (durationMs != null) 'duration_ms': durationMs,
    });
  }

  ChaptersCompanion copyWith(
      {Value<int>? id,
      Value<String>? audiobookProvider,
      Value<String>? audiobookItemId,
      Value<int>? chapterNumber,
      Value<int>? positionMs,
      Value<String>? title,
      Value<int?>? durationMs}) {
    return ChaptersCompanion(
      id: id ?? this.id,
      audiobookProvider: audiobookProvider ?? this.audiobookProvider,
      audiobookItemId: audiobookItemId ?? this.audiobookItemId,
      chapterNumber: chapterNumber ?? this.chapterNumber,
      positionMs: positionMs ?? this.positionMs,
      title: title ?? this.title,
      durationMs: durationMs ?? this.durationMs,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (audiobookProvider.present) {
      map['audiobook_provider'] = Variable<String>(audiobookProvider.value);
    }
    if (audiobookItemId.present) {
      map['audiobook_item_id'] = Variable<String>(audiobookItemId.value);
    }
    if (chapterNumber.present) {
      map['chapter_number'] = Variable<int>(chapterNumber.value);
    }
    if (positionMs.present) {
      map['position_ms'] = Variable<int>(positionMs.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChaptersCompanion(')
          ..write('id: $id, ')
          ..write('audiobookProvider: $audiobookProvider, ')
          ..write('audiobookItemId: $audiobookItemId, ')
          ..write('chapterNumber: $chapterNumber, ')
          ..write('positionMs: $positionMs, ')
          ..write('title: $title, ')
          ..write('durationMs: $durationMs')
          ..write(')'))
        .toString();
  }
}

class $ProviderMappingsTable extends ProviderMappings
    with TableInfo<$ProviderMappingsTable, ProviderMappingEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProviderMappingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _ownerTypeMeta =
      const VerificationMeta('ownerType');
  @override
  late final GeneratedColumn<String> ownerType = GeneratedColumn<String>(
      'owner_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ownerProviderMeta =
      const VerificationMeta('ownerProvider');
  @override
  late final GeneratedColumn<String> ownerProvider = GeneratedColumn<String>(
      'owner_provider', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ownerItemIdMeta =
      const VerificationMeta('ownerItemId');
  @override
  late final GeneratedColumn<String> ownerItemId = GeneratedColumn<String>(
      'owner_item_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _mappingItemIdMeta =
      const VerificationMeta('mappingItemId');
  @override
  late final GeneratedColumn<String> mappingItemId = GeneratedColumn<String>(
      'mapping_item_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _providerDomainMeta =
      const VerificationMeta('providerDomain');
  @override
  late final GeneratedColumn<String> providerDomain = GeneratedColumn<String>(
      'provider_domain', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _providerInstanceMeta =
      const VerificationMeta('providerInstance');
  @override
  late final GeneratedColumn<String> providerInstance = GeneratedColumn<String>(
      'provider_instance', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _availableMeta =
      const VerificationMeta('available');
  @override
  late final GeneratedColumn<bool> available = GeneratedColumn<bool>(
      'available', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("available" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _inLibraryMeta =
      const VerificationMeta('inLibrary');
  @override
  late final GeneratedColumn<bool> inLibrary = GeneratedColumn<bool>(
      'in_library', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("in_library" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _audioFormatJsonMeta =
      const VerificationMeta('audioFormatJson');
  @override
  late final GeneratedColumn<String> audioFormatJson = GeneratedColumn<String>(
      'audio_format_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        ownerType,
        ownerProvider,
        ownerItemId,
        mappingItemId,
        providerDomain,
        providerInstance,
        available,
        inLibrary,
        audioFormatJson
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'provider_mappings';
  @override
  VerificationContext validateIntegrity(
      Insertable<ProviderMappingEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('owner_type')) {
      context.handle(_ownerTypeMeta,
          ownerType.isAcceptableOrUnknown(data['owner_type']!, _ownerTypeMeta));
    } else if (isInserting) {
      context.missing(_ownerTypeMeta);
    }
    if (data.containsKey('owner_provider')) {
      context.handle(
          _ownerProviderMeta,
          ownerProvider.isAcceptableOrUnknown(
              data['owner_provider']!, _ownerProviderMeta));
    } else if (isInserting) {
      context.missing(_ownerProviderMeta);
    }
    if (data.containsKey('owner_item_id')) {
      context.handle(
          _ownerItemIdMeta,
          ownerItemId.isAcceptableOrUnknown(
              data['owner_item_id']!, _ownerItemIdMeta));
    } else if (isInserting) {
      context.missing(_ownerItemIdMeta);
    }
    if (data.containsKey('mapping_item_id')) {
      context.handle(
          _mappingItemIdMeta,
          mappingItemId.isAcceptableOrUnknown(
              data['mapping_item_id']!, _mappingItemIdMeta));
    } else if (isInserting) {
      context.missing(_mappingItemIdMeta);
    }
    if (data.containsKey('provider_domain')) {
      context.handle(
          _providerDomainMeta,
          providerDomain.isAcceptableOrUnknown(
              data['provider_domain']!, _providerDomainMeta));
    } else if (isInserting) {
      context.missing(_providerDomainMeta);
    }
    if (data.containsKey('provider_instance')) {
      context.handle(
          _providerInstanceMeta,
          providerInstance.isAcceptableOrUnknown(
              data['provider_instance']!, _providerInstanceMeta));
    } else if (isInserting) {
      context.missing(_providerInstanceMeta);
    }
    if (data.containsKey('available')) {
      context.handle(_availableMeta,
          available.isAcceptableOrUnknown(data['available']!, _availableMeta));
    }
    if (data.containsKey('in_library')) {
      context.handle(_inLibraryMeta,
          inLibrary.isAcceptableOrUnknown(data['in_library']!, _inLibraryMeta));
    }
    if (data.containsKey('audio_format_json')) {
      context.handle(
          _audioFormatJsonMeta,
          audioFormatJson.isAcceptableOrUnknown(
              data['audio_format_json']!, _audioFormatJsonMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProviderMappingEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProviderMappingEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      ownerType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}owner_type'])!,
      ownerProvider: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}owner_provider'])!,
      ownerItemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}owner_item_id'])!,
      mappingItemId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}mapping_item_id'])!,
      providerDomain: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}provider_domain'])!,
      providerInstance: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}provider_instance'])!,
      available: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}available'])!,
      inLibrary: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}in_library'])!,
      audioFormatJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}audio_format_json']),
    );
  }

  @override
  $ProviderMappingsTable createAlias(String alias) {
    return $ProviderMappingsTable(attachedDatabase, alias);
  }
}

class ProviderMappingEntity extends DataClass
    implements Insertable<ProviderMappingEntity> {
  final int id;

  /// 'artist' | 'album' | 'track' | 'playlist' | 'audiobook'
  final String ownerType;
  final String ownerProvider;
  final String ownerItemId;
  final String mappingItemId;
  final String providerDomain;
  final String providerInstance;
  final bool available;
  final bool inLibrary;
  final String? audioFormatJson;
  const ProviderMappingEntity(
      {required this.id,
      required this.ownerType,
      required this.ownerProvider,
      required this.ownerItemId,
      required this.mappingItemId,
      required this.providerDomain,
      required this.providerInstance,
      required this.available,
      required this.inLibrary,
      this.audioFormatJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['owner_type'] = Variable<String>(ownerType);
    map['owner_provider'] = Variable<String>(ownerProvider);
    map['owner_item_id'] = Variable<String>(ownerItemId);
    map['mapping_item_id'] = Variable<String>(mappingItemId);
    map['provider_domain'] = Variable<String>(providerDomain);
    map['provider_instance'] = Variable<String>(providerInstance);
    map['available'] = Variable<bool>(available);
    map['in_library'] = Variable<bool>(inLibrary);
    if (!nullToAbsent || audioFormatJson != null) {
      map['audio_format_json'] = Variable<String>(audioFormatJson);
    }
    return map;
  }

  ProviderMappingsCompanion toCompanion(bool nullToAbsent) {
    return ProviderMappingsCompanion(
      id: Value(id),
      ownerType: Value(ownerType),
      ownerProvider: Value(ownerProvider),
      ownerItemId: Value(ownerItemId),
      mappingItemId: Value(mappingItemId),
      providerDomain: Value(providerDomain),
      providerInstance: Value(providerInstance),
      available: Value(available),
      inLibrary: Value(inLibrary),
      audioFormatJson: audioFormatJson == null && nullToAbsent
          ? const Value.absent()
          : Value(audioFormatJson),
    );
  }

  factory ProviderMappingEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProviderMappingEntity(
      id: serializer.fromJson<int>(json['id']),
      ownerType: serializer.fromJson<String>(json['ownerType']),
      ownerProvider: serializer.fromJson<String>(json['ownerProvider']),
      ownerItemId: serializer.fromJson<String>(json['ownerItemId']),
      mappingItemId: serializer.fromJson<String>(json['mappingItemId']),
      providerDomain: serializer.fromJson<String>(json['providerDomain']),
      providerInstance: serializer.fromJson<String>(json['providerInstance']),
      available: serializer.fromJson<bool>(json['available']),
      inLibrary: serializer.fromJson<bool>(json['inLibrary']),
      audioFormatJson: serializer.fromJson<String?>(json['audioFormatJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ownerType': serializer.toJson<String>(ownerType),
      'ownerProvider': serializer.toJson<String>(ownerProvider),
      'ownerItemId': serializer.toJson<String>(ownerItemId),
      'mappingItemId': serializer.toJson<String>(mappingItemId),
      'providerDomain': serializer.toJson<String>(providerDomain),
      'providerInstance': serializer.toJson<String>(providerInstance),
      'available': serializer.toJson<bool>(available),
      'inLibrary': serializer.toJson<bool>(inLibrary),
      'audioFormatJson': serializer.toJson<String?>(audioFormatJson),
    };
  }

  ProviderMappingEntity copyWith(
          {int? id,
          String? ownerType,
          String? ownerProvider,
          String? ownerItemId,
          String? mappingItemId,
          String? providerDomain,
          String? providerInstance,
          bool? available,
          bool? inLibrary,
          Value<String?> audioFormatJson = const Value.absent()}) =>
      ProviderMappingEntity(
        id: id ?? this.id,
        ownerType: ownerType ?? this.ownerType,
        ownerProvider: ownerProvider ?? this.ownerProvider,
        ownerItemId: ownerItemId ?? this.ownerItemId,
        mappingItemId: mappingItemId ?? this.mappingItemId,
        providerDomain: providerDomain ?? this.providerDomain,
        providerInstance: providerInstance ?? this.providerInstance,
        available: available ?? this.available,
        inLibrary: inLibrary ?? this.inLibrary,
        audioFormatJson: audioFormatJson.present
            ? audioFormatJson.value
            : this.audioFormatJson,
      );
  ProviderMappingEntity copyWithCompanion(ProviderMappingsCompanion data) {
    return ProviderMappingEntity(
      id: data.id.present ? data.id.value : this.id,
      ownerType: data.ownerType.present ? data.ownerType.value : this.ownerType,
      ownerProvider: data.ownerProvider.present
          ? data.ownerProvider.value
          : this.ownerProvider,
      ownerItemId:
          data.ownerItemId.present ? data.ownerItemId.value : this.ownerItemId,
      mappingItemId: data.mappingItemId.present
          ? data.mappingItemId.value
          : this.mappingItemId,
      providerDomain: data.providerDomain.present
          ? data.providerDomain.value
          : this.providerDomain,
      providerInstance: data.providerInstance.present
          ? data.providerInstance.value
          : this.providerInstance,
      available: data.available.present ? data.available.value : this.available,
      inLibrary: data.inLibrary.present ? data.inLibrary.value : this.inLibrary,
      audioFormatJson: data.audioFormatJson.present
          ? data.audioFormatJson.value
          : this.audioFormatJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProviderMappingEntity(')
          ..write('id: $id, ')
          ..write('ownerType: $ownerType, ')
          ..write('ownerProvider: $ownerProvider, ')
          ..write('ownerItemId: $ownerItemId, ')
          ..write('mappingItemId: $mappingItemId, ')
          ..write('providerDomain: $providerDomain, ')
          ..write('providerInstance: $providerInstance, ')
          ..write('available: $available, ')
          ..write('inLibrary: $inLibrary, ')
          ..write('audioFormatJson: $audioFormatJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      ownerType,
      ownerProvider,
      ownerItemId,
      mappingItemId,
      providerDomain,
      providerInstance,
      available,
      inLibrary,
      audioFormatJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProviderMappingEntity &&
          other.id == this.id &&
          other.ownerType == this.ownerType &&
          other.ownerProvider == this.ownerProvider &&
          other.ownerItemId == this.ownerItemId &&
          other.mappingItemId == this.mappingItemId &&
          other.providerDomain == this.providerDomain &&
          other.providerInstance == this.providerInstance &&
          other.available == this.available &&
          other.inLibrary == this.inLibrary &&
          other.audioFormatJson == this.audioFormatJson);
}

class ProviderMappingsCompanion extends UpdateCompanion<ProviderMappingEntity> {
  final Value<int> id;
  final Value<String> ownerType;
  final Value<String> ownerProvider;
  final Value<String> ownerItemId;
  final Value<String> mappingItemId;
  final Value<String> providerDomain;
  final Value<String> providerInstance;
  final Value<bool> available;
  final Value<bool> inLibrary;
  final Value<String?> audioFormatJson;
  const ProviderMappingsCompanion({
    this.id = const Value.absent(),
    this.ownerType = const Value.absent(),
    this.ownerProvider = const Value.absent(),
    this.ownerItemId = const Value.absent(),
    this.mappingItemId = const Value.absent(),
    this.providerDomain = const Value.absent(),
    this.providerInstance = const Value.absent(),
    this.available = const Value.absent(),
    this.inLibrary = const Value.absent(),
    this.audioFormatJson = const Value.absent(),
  });
  ProviderMappingsCompanion.insert({
    this.id = const Value.absent(),
    required String ownerType,
    required String ownerProvider,
    required String ownerItemId,
    required String mappingItemId,
    required String providerDomain,
    required String providerInstance,
    this.available = const Value.absent(),
    this.inLibrary = const Value.absent(),
    this.audioFormatJson = const Value.absent(),
  })  : ownerType = Value(ownerType),
        ownerProvider = Value(ownerProvider),
        ownerItemId = Value(ownerItemId),
        mappingItemId = Value(mappingItemId),
        providerDomain = Value(providerDomain),
        providerInstance = Value(providerInstance);
  static Insertable<ProviderMappingEntity> custom({
    Expression<int>? id,
    Expression<String>? ownerType,
    Expression<String>? ownerProvider,
    Expression<String>? ownerItemId,
    Expression<String>? mappingItemId,
    Expression<String>? providerDomain,
    Expression<String>? providerInstance,
    Expression<bool>? available,
    Expression<bool>? inLibrary,
    Expression<String>? audioFormatJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerType != null) 'owner_type': ownerType,
      if (ownerProvider != null) 'owner_provider': ownerProvider,
      if (ownerItemId != null) 'owner_item_id': ownerItemId,
      if (mappingItemId != null) 'mapping_item_id': mappingItemId,
      if (providerDomain != null) 'provider_domain': providerDomain,
      if (providerInstance != null) 'provider_instance': providerInstance,
      if (available != null) 'available': available,
      if (inLibrary != null) 'in_library': inLibrary,
      if (audioFormatJson != null) 'audio_format_json': audioFormatJson,
    });
  }

  ProviderMappingsCompanion copyWith(
      {Value<int>? id,
      Value<String>? ownerType,
      Value<String>? ownerProvider,
      Value<String>? ownerItemId,
      Value<String>? mappingItemId,
      Value<String>? providerDomain,
      Value<String>? providerInstance,
      Value<bool>? available,
      Value<bool>? inLibrary,
      Value<String?>? audioFormatJson}) {
    return ProviderMappingsCompanion(
      id: id ?? this.id,
      ownerType: ownerType ?? this.ownerType,
      ownerProvider: ownerProvider ?? this.ownerProvider,
      ownerItemId: ownerItemId ?? this.ownerItemId,
      mappingItemId: mappingItemId ?? this.mappingItemId,
      providerDomain: providerDomain ?? this.providerDomain,
      providerInstance: providerInstance ?? this.providerInstance,
      available: available ?? this.available,
      inLibrary: inLibrary ?? this.inLibrary,
      audioFormatJson: audioFormatJson ?? this.audioFormatJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ownerType.present) {
      map['owner_type'] = Variable<String>(ownerType.value);
    }
    if (ownerProvider.present) {
      map['owner_provider'] = Variable<String>(ownerProvider.value);
    }
    if (ownerItemId.present) {
      map['owner_item_id'] = Variable<String>(ownerItemId.value);
    }
    if (mappingItemId.present) {
      map['mapping_item_id'] = Variable<String>(mappingItemId.value);
    }
    if (providerDomain.present) {
      map['provider_domain'] = Variable<String>(providerDomain.value);
    }
    if (providerInstance.present) {
      map['provider_instance'] = Variable<String>(providerInstance.value);
    }
    if (available.present) {
      map['available'] = Variable<bool>(available.value);
    }
    if (inLibrary.present) {
      map['in_library'] = Variable<bool>(inLibrary.value);
    }
    if (audioFormatJson.present) {
      map['audio_format_json'] = Variable<String>(audioFormatJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProviderMappingsCompanion(')
          ..write('id: $id, ')
          ..write('ownerType: $ownerType, ')
          ..write('ownerProvider: $ownerProvider, ')
          ..write('ownerItemId: $ownerItemId, ')
          ..write('mappingItemId: $mappingItemId, ')
          ..write('providerDomain: $providerDomain, ')
          ..write('providerInstance: $providerInstance, ')
          ..write('available: $available, ')
          ..write('inLibrary: $inLibrary, ')
          ..write('audioFormatJson: $audioFormatJson')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProfilesTable profiles = $ProfilesTable(this);
  late final $RecentlyPlayedTable recentlyPlayed = $RecentlyPlayedTable(this);
  late final $LibraryCacheTable libraryCache = $LibraryCacheTable(this);
  late final $SyncMetadataTable syncMetadata = $SyncMetadataTable(this);
  late final $PlaybackStateTable playbackState = $PlaybackStateTable(this);
  late final $CachedPlayersTable cachedPlayers = $CachedPlayersTable(this);
  late final $CachedQueueTable cachedQueue = $CachedQueueTable(this);
  late final $HomeRowCacheTable homeRowCache = $HomeRowCacheTable(this);
  late final $SearchHistoryTable searchHistory = $SearchHistoryTable(this);
  late final $DetailTrackCacheTable detailTrackCache =
      $DetailTrackCacheTable(this);
  late final $ArtistsTable artists = $ArtistsTable(this);
  late final $AlbumsTable albums = $AlbumsTable(this);
  late final $TracksTable tracks = $TracksTable(this);
  late final $PlaylistsTable playlists = $PlaylistsTable(this);
  late final $PlaylistTracksTable playlistTracks = $PlaylistTracksTable(this);
  late final $AudiobooksTable audiobooks = $AudiobooksTable(this);
  late final $ChaptersTable chapters = $ChaptersTable(this);
  late final $ProviderMappingsTable providerMappings =
      $ProviderMappingsTable(this);
  late final Index idxRecentlyPlayedProfile = Index(
      'idx_recently_played_profile',
      'CREATE INDEX idx_recently_played_profile ON recently_played (profile_username)');
  late final Index idxRecentlyPlayedProfilePlayed = Index(
      'idx_recently_played_profile_played',
      'CREATE INDEX idx_recently_played_profile_played ON recently_played (profile_username, played_at)');
  late final Index idxLibraryCacheType = Index('idx_library_cache_type',
      'CREATE INDEX idx_library_cache_type ON library_cache (item_type)');
  late final Index idxLibraryCacheTypeDeleted = Index(
      'idx_library_cache_type_deleted',
      'CREATE INDEX idx_library_cache_type_deleted ON library_cache (item_type, is_deleted)');
  late final Index idxCachedQueuePlayer = Index('idx_cached_queue_player',
      'CREATE INDEX idx_cached_queue_player ON cached_queue (player_id)');
  late final Index idxCachedQueuePlayerPosition = Index(
      'idx_cached_queue_player_position',
      'CREATE INDEX idx_cached_queue_player_position ON cached_queue (player_id, position)');
  late final Index idxArtistsFavorite = Index('idx_artists_favorite',
      'CREATE INDEX idx_artists_favorite ON artists (favorite)');
  late final Index idxAlbumsFavorite = Index('idx_albums_favorite',
      'CREATE INDEX idx_albums_favorite ON albums (favorite)');
  late final Index idxTracksAlbum = Index('idx_tracks_album',
      'CREATE INDEX idx_tracks_album ON tracks (album_provider, album_item_id)');
  late final Index idxTracksFavorite = Index('idx_tracks_favorite',
      'CREATE INDEX idx_tracks_favorite ON tracks (favorite)');
  late final Index idxPlaylistsFavorite = Index('idx_playlists_favorite',
      'CREATE INDEX idx_playlists_favorite ON playlists (favorite)');
  late final Index idxPlaylistTracksPlaylist = Index(
      'idx_playlist_tracks_playlist',
      'CREATE INDEX idx_playlist_tracks_playlist ON playlist_tracks (playlist_provider, playlist_item_id, position)');
  late final Index idxAudiobooksFavorite = Index('idx_audiobooks_favorite',
      'CREATE INDEX idx_audiobooks_favorite ON audiobooks (favorite)');
  late final Index idxChaptersAudiobook = Index('idx_chapters_audiobook',
      'CREATE INDEX idx_chapters_audiobook ON chapters (audiobook_provider, audiobook_item_id)');
  late final Index idxProviderMappingsOwner = Index(
      'idx_provider_mappings_owner',
      'CREATE INDEX idx_provider_mappings_owner ON provider_mappings (owner_type, owner_provider, owner_item_id)');
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        profiles,
        recentlyPlayed,
        libraryCache,
        syncMetadata,
        playbackState,
        cachedPlayers,
        cachedQueue,
        homeRowCache,
        searchHistory,
        detailTrackCache,
        artists,
        albums,
        tracks,
        playlists,
        playlistTracks,
        audiobooks,
        chapters,
        providerMappings,
        idxRecentlyPlayedProfile,
        idxRecentlyPlayedProfilePlayed,
        idxLibraryCacheType,
        idxLibraryCacheTypeDeleted,
        idxCachedQueuePlayer,
        idxCachedQueuePlayerPosition,
        idxArtistsFavorite,
        idxAlbumsFavorite,
        idxTracksAlbum,
        idxTracksFavorite,
        idxPlaylistsFavorite,
        idxPlaylistTracksPlaylist,
        idxAudiobooksFavorite,
        idxChaptersAudiobook,
        idxProviderMappingsOwner
      ];
}

typedef $$ProfilesTableCreateCompanionBuilder = ProfilesCompanion Function({
  required String username,
  Value<String?> displayName,
  Value<String> source,
  Value<DateTime> createdAt,
  Value<bool> isActive,
  Value<int> rowid,
});
typedef $$ProfilesTableUpdateCompanionBuilder = ProfilesCompanion Function({
  Value<String> username,
  Value<String?> displayName,
  Value<String> source,
  Value<DateTime> createdAt,
  Value<bool> isActive,
  Value<int> rowid,
});

final class $$ProfilesTableReferences
    extends BaseReferences<_$AppDatabase, $ProfilesTable, Profile> {
  $$ProfilesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RecentlyPlayedTable, List<RecentlyPlayedData>>
      _recentlyPlayedRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.recentlyPlayed,
              aliasName: $_aliasNameGenerator(
                  db.profiles.username, db.recentlyPlayed.profileUsername));

  $$RecentlyPlayedTableProcessedTableManager get recentlyPlayedRefs {
    final manager = $$RecentlyPlayedTableTableManager($_db, $_db.recentlyPlayed)
        .filter((f) => f.profileUsername.username
            .sqlEquals($_itemColumn<String>('username')!));

    final cache = $_typedResult.readTableOrNull(_recentlyPlayedRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  Expression<bool> recentlyPlayedRefs(
      Expression<bool> Function($$RecentlyPlayedTableFilterComposer f) f) {
    final $$RecentlyPlayedTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.username,
        referencedTable: $db.recentlyPlayed,
        getReferencedColumn: (t) => t.profileUsername,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecentlyPlayedTableFilterComposer(
              $db: $db,
              $table: $db.recentlyPlayed,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));
}

class $$ProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> recentlyPlayedRefs<T extends Object>(
      Expression<T> Function($$RecentlyPlayedTableAnnotationComposer a) f) {
    final $$RecentlyPlayedTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.username,
        referencedTable: $db.recentlyPlayed,
        getReferencedColumn: (t) => t.profileUsername,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecentlyPlayedTableAnnotationComposer(
              $db: $db,
              $table: $db.recentlyPlayed,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProfilesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProfilesTable,
    Profile,
    $$ProfilesTableFilterComposer,
    $$ProfilesTableOrderingComposer,
    $$ProfilesTableAnnotationComposer,
    $$ProfilesTableCreateCompanionBuilder,
    $$ProfilesTableUpdateCompanionBuilder,
    (Profile, $$ProfilesTableReferences),
    Profile,
    PrefetchHooks Function({bool recentlyPlayedRefs})> {
  $$ProfilesTableTableManager(_$AppDatabase db, $ProfilesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> username = const Value.absent(),
            Value<String?> displayName = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProfilesCompanion(
            username: username,
            displayName: displayName,
            source: source,
            createdAt: createdAt,
            isActive: isActive,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String username,
            Value<String?> displayName = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProfilesCompanion.insert(
            username: username,
            displayName: displayName,
            source: source,
            createdAt: createdAt,
            isActive: isActive,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ProfilesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({recentlyPlayedRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (recentlyPlayedRefs) db.recentlyPlayed
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (recentlyPlayedRefs)
                    await $_getPrefetchedData<Profile, $ProfilesTable,
                            RecentlyPlayedData>(
                        currentTable: table,
                        referencedTable: $$ProfilesTableReferences
                            ._recentlyPlayedRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProfilesTableReferences(db, table, p0)
                                .recentlyPlayedRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems.where(
                                (e) => e.profileUsername == item.username),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ProfilesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProfilesTable,
    Profile,
    $$ProfilesTableFilterComposer,
    $$ProfilesTableOrderingComposer,
    $$ProfilesTableAnnotationComposer,
    $$ProfilesTableCreateCompanionBuilder,
    $$ProfilesTableUpdateCompanionBuilder,
    (Profile, $$ProfilesTableReferences),
    Profile,
    PrefetchHooks Function({bool recentlyPlayedRefs})>;
typedef $$RecentlyPlayedTableCreateCompanionBuilder = RecentlyPlayedCompanion
    Function({
  Value<int> id,
  required String profileUsername,
  required String mediaId,
  required String mediaType,
  required String name,
  Value<String?> artistName,
  Value<String?> imageUrl,
  Value<String?> metadata,
  required DateTime playedAt,
});
typedef $$RecentlyPlayedTableUpdateCompanionBuilder = RecentlyPlayedCompanion
    Function({
  Value<int> id,
  Value<String> profileUsername,
  Value<String> mediaId,
  Value<String> mediaType,
  Value<String> name,
  Value<String?> artistName,
  Value<String?> imageUrl,
  Value<String?> metadata,
  Value<DateTime> playedAt,
});

final class $$RecentlyPlayedTableReferences extends BaseReferences<
    _$AppDatabase, $RecentlyPlayedTable, RecentlyPlayedData> {
  $$RecentlyPlayedTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ProfilesTable _profileUsernameTable(_$AppDatabase db) =>
      db.profiles.createAlias($_aliasNameGenerator(
          db.recentlyPlayed.profileUsername, db.profiles.username));

  $$ProfilesTableProcessedTableManager get profileUsername {
    final $_column = $_itemColumn<String>('profile_username')!;

    final manager = $$ProfilesTableTableManager($_db, $_db.profiles)
        .filter((f) => f.username.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileUsernameTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$RecentlyPlayedTableFilterComposer
    extends Composer<_$AppDatabase, $RecentlyPlayedTable> {
  $$RecentlyPlayedTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mediaId => $composableBuilder(
      column: $table.mediaId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mediaType => $composableBuilder(
      column: $table.mediaType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get artistName => $composableBuilder(
      column: $table.artistName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imageUrl => $composableBuilder(
      column: $table.imageUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get metadata => $composableBuilder(
      column: $table.metadata, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get playedAt => $composableBuilder(
      column: $table.playedAt, builder: (column) => ColumnFilters(column));

  $$ProfilesTableFilterComposer get profileUsername {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.profileUsername,
        referencedTable: $db.profiles,
        getReferencedColumn: (t) => t.username,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProfilesTableFilterComposer(
              $db: $db,
              $table: $db.profiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RecentlyPlayedTableOrderingComposer
    extends Composer<_$AppDatabase, $RecentlyPlayedTable> {
  $$RecentlyPlayedTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mediaId => $composableBuilder(
      column: $table.mediaId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mediaType => $composableBuilder(
      column: $table.mediaType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get artistName => $composableBuilder(
      column: $table.artistName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imageUrl => $composableBuilder(
      column: $table.imageUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metadata => $composableBuilder(
      column: $table.metadata, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get playedAt => $composableBuilder(
      column: $table.playedAt, builder: (column) => ColumnOrderings(column));

  $$ProfilesTableOrderingComposer get profileUsername {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.profileUsername,
        referencedTable: $db.profiles,
        getReferencedColumn: (t) => t.username,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProfilesTableOrderingComposer(
              $db: $db,
              $table: $db.profiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RecentlyPlayedTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecentlyPlayedTable> {
  $$RecentlyPlayedTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get mediaId =>
      $composableBuilder(column: $table.mediaId, builder: (column) => column);

  GeneratedColumn<String> get mediaType =>
      $composableBuilder(column: $table.mediaType, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get artistName => $composableBuilder(
      column: $table.artistName, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);

  GeneratedColumn<DateTime> get playedAt =>
      $composableBuilder(column: $table.playedAt, builder: (column) => column);

  $$ProfilesTableAnnotationComposer get profileUsername {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.profileUsername,
        referencedTable: $db.profiles,
        getReferencedColumn: (t) => t.username,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProfilesTableAnnotationComposer(
              $db: $db,
              $table: $db.profiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RecentlyPlayedTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RecentlyPlayedTable,
    RecentlyPlayedData,
    $$RecentlyPlayedTableFilterComposer,
    $$RecentlyPlayedTableOrderingComposer,
    $$RecentlyPlayedTableAnnotationComposer,
    $$RecentlyPlayedTableCreateCompanionBuilder,
    $$RecentlyPlayedTableUpdateCompanionBuilder,
    (RecentlyPlayedData, $$RecentlyPlayedTableReferences),
    RecentlyPlayedData,
    PrefetchHooks Function({bool profileUsername})> {
  $$RecentlyPlayedTableTableManager(
      _$AppDatabase db, $RecentlyPlayedTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecentlyPlayedTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecentlyPlayedTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecentlyPlayedTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> profileUsername = const Value.absent(),
            Value<String> mediaId = const Value.absent(),
            Value<String> mediaType = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> artistName = const Value.absent(),
            Value<String?> imageUrl = const Value.absent(),
            Value<String?> metadata = const Value.absent(),
            Value<DateTime> playedAt = const Value.absent(),
          }) =>
              RecentlyPlayedCompanion(
            id: id,
            profileUsername: profileUsername,
            mediaId: mediaId,
            mediaType: mediaType,
            name: name,
            artistName: artistName,
            imageUrl: imageUrl,
            metadata: metadata,
            playedAt: playedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String profileUsername,
            required String mediaId,
            required String mediaType,
            required String name,
            Value<String?> artistName = const Value.absent(),
            Value<String?> imageUrl = const Value.absent(),
            Value<String?> metadata = const Value.absent(),
            required DateTime playedAt,
          }) =>
              RecentlyPlayedCompanion.insert(
            id: id,
            profileUsername: profileUsername,
            mediaId: mediaId,
            mediaType: mediaType,
            name: name,
            artistName: artistName,
            imageUrl: imageUrl,
            metadata: metadata,
            playedAt: playedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$RecentlyPlayedTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({profileUsername = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (profileUsername) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.profileUsername,
                    referencedTable: $$RecentlyPlayedTableReferences
                        ._profileUsernameTable(db),
                    referencedColumn: $$RecentlyPlayedTableReferences
                        ._profileUsernameTable(db)
                        .username,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$RecentlyPlayedTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RecentlyPlayedTable,
    RecentlyPlayedData,
    $$RecentlyPlayedTableFilterComposer,
    $$RecentlyPlayedTableOrderingComposer,
    $$RecentlyPlayedTableAnnotationComposer,
    $$RecentlyPlayedTableCreateCompanionBuilder,
    $$RecentlyPlayedTableUpdateCompanionBuilder,
    (RecentlyPlayedData, $$RecentlyPlayedTableReferences),
    RecentlyPlayedData,
    PrefetchHooks Function({bool profileUsername})>;
typedef $$LibraryCacheTableCreateCompanionBuilder = LibraryCacheCompanion
    Function({
  required String cacheKey,
  required String itemType,
  required String itemId,
  required String data,
  required DateTime lastSynced,
  Value<bool> isDeleted,
  Value<String> sourceProviders,
  Value<int> rowid,
});
typedef $$LibraryCacheTableUpdateCompanionBuilder = LibraryCacheCompanion
    Function({
  Value<String> cacheKey,
  Value<String> itemType,
  Value<String> itemId,
  Value<String> data,
  Value<DateTime> lastSynced,
  Value<bool> isDeleted,
  Value<String> sourceProviders,
  Value<int> rowid,
});

class $$LibraryCacheTableFilterComposer
    extends Composer<_$AppDatabase, $LibraryCacheTable> {
  $$LibraryCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get cacheKey => $composableBuilder(
      column: $table.cacheKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemType => $composableBuilder(
      column: $table.itemType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get data => $composableBuilder(
      column: $table.data, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSynced => $composableBuilder(
      column: $table.lastSynced, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceProviders => $composableBuilder(
      column: $table.sourceProviders,
      builder: (column) => ColumnFilters(column));
}

class $$LibraryCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $LibraryCacheTable> {
  $$LibraryCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get cacheKey => $composableBuilder(
      column: $table.cacheKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemType => $composableBuilder(
      column: $table.itemType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get data => $composableBuilder(
      column: $table.data, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSynced => $composableBuilder(
      column: $table.lastSynced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceProviders => $composableBuilder(
      column: $table.sourceProviders,
      builder: (column) => ColumnOrderings(column));
}

class $$LibraryCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $LibraryCacheTable> {
  $$LibraryCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get cacheKey =>
      $composableBuilder(column: $table.cacheKey, builder: (column) => column);

  GeneratedColumn<String> get itemType =>
      $composableBuilder(column: $table.itemType, builder: (column) => column);

  GeneratedColumn<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSynced => $composableBuilder(
      column: $table.lastSynced, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<String> get sourceProviders => $composableBuilder(
      column: $table.sourceProviders, builder: (column) => column);
}

class $$LibraryCacheTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LibraryCacheTable,
    LibraryCacheData,
    $$LibraryCacheTableFilterComposer,
    $$LibraryCacheTableOrderingComposer,
    $$LibraryCacheTableAnnotationComposer,
    $$LibraryCacheTableCreateCompanionBuilder,
    $$LibraryCacheTableUpdateCompanionBuilder,
    (
      LibraryCacheData,
      BaseReferences<_$AppDatabase, $LibraryCacheTable, LibraryCacheData>
    ),
    LibraryCacheData,
    PrefetchHooks Function()> {
  $$LibraryCacheTableTableManager(_$AppDatabase db, $LibraryCacheTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LibraryCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LibraryCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LibraryCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> cacheKey = const Value.absent(),
            Value<String> itemType = const Value.absent(),
            Value<String> itemId = const Value.absent(),
            Value<String> data = const Value.absent(),
            Value<DateTime> lastSynced = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<String> sourceProviders = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LibraryCacheCompanion(
            cacheKey: cacheKey,
            itemType: itemType,
            itemId: itemId,
            data: data,
            lastSynced: lastSynced,
            isDeleted: isDeleted,
            sourceProviders: sourceProviders,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String cacheKey,
            required String itemType,
            required String itemId,
            required String data,
            required DateTime lastSynced,
            Value<bool> isDeleted = const Value.absent(),
            Value<String> sourceProviders = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LibraryCacheCompanion.insert(
            cacheKey: cacheKey,
            itemType: itemType,
            itemId: itemId,
            data: data,
            lastSynced: lastSynced,
            isDeleted: isDeleted,
            sourceProviders: sourceProviders,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LibraryCacheTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LibraryCacheTable,
    LibraryCacheData,
    $$LibraryCacheTableFilterComposer,
    $$LibraryCacheTableOrderingComposer,
    $$LibraryCacheTableAnnotationComposer,
    $$LibraryCacheTableCreateCompanionBuilder,
    $$LibraryCacheTableUpdateCompanionBuilder,
    (
      LibraryCacheData,
      BaseReferences<_$AppDatabase, $LibraryCacheTable, LibraryCacheData>
    ),
    LibraryCacheData,
    PrefetchHooks Function()>;
typedef $$SyncMetadataTableCreateCompanionBuilder = SyncMetadataCompanion
    Function({
  required String syncType,
  required DateTime lastSyncedAt,
  Value<int> itemCount,
  Value<int> rowid,
});
typedef $$SyncMetadataTableUpdateCompanionBuilder = SyncMetadataCompanion
    Function({
  Value<String> syncType,
  Value<DateTime> lastSyncedAt,
  Value<int> itemCount,
  Value<int> rowid,
});

class $$SyncMetadataTableFilterComposer
    extends Composer<_$AppDatabase, $SyncMetadataTable> {
  $$SyncMetadataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get syncType => $composableBuilder(
      column: $table.syncType, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get itemCount => $composableBuilder(
      column: $table.itemCount, builder: (column) => ColumnFilters(column));
}

class $$SyncMetadataTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncMetadataTable> {
  $$SyncMetadataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get syncType => $composableBuilder(
      column: $table.syncType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get itemCount => $composableBuilder(
      column: $table.itemCount, builder: (column) => ColumnOrderings(column));
}

class $$SyncMetadataTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncMetadataTable> {
  $$SyncMetadataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get syncType =>
      $composableBuilder(column: $table.syncType, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => column);

  GeneratedColumn<int> get itemCount =>
      $composableBuilder(column: $table.itemCount, builder: (column) => column);
}

class $$SyncMetadataTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncMetadataTable,
    SyncMetadataData,
    $$SyncMetadataTableFilterComposer,
    $$SyncMetadataTableOrderingComposer,
    $$SyncMetadataTableAnnotationComposer,
    $$SyncMetadataTableCreateCompanionBuilder,
    $$SyncMetadataTableUpdateCompanionBuilder,
    (
      SyncMetadataData,
      BaseReferences<_$AppDatabase, $SyncMetadataTable, SyncMetadataData>
    ),
    SyncMetadataData,
    PrefetchHooks Function()> {
  $$SyncMetadataTableTableManager(_$AppDatabase db, $SyncMetadataTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncMetadataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncMetadataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncMetadataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> syncType = const Value.absent(),
            Value<DateTime> lastSyncedAt = const Value.absent(),
            Value<int> itemCount = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncMetadataCompanion(
            syncType: syncType,
            lastSyncedAt: lastSyncedAt,
            itemCount: itemCount,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String syncType,
            required DateTime lastSyncedAt,
            Value<int> itemCount = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncMetadataCompanion.insert(
            syncType: syncType,
            lastSyncedAt: lastSyncedAt,
            itemCount: itemCount,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncMetadataTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncMetadataTable,
    SyncMetadataData,
    $$SyncMetadataTableFilterComposer,
    $$SyncMetadataTableOrderingComposer,
    $$SyncMetadataTableAnnotationComposer,
    $$SyncMetadataTableCreateCompanionBuilder,
    $$SyncMetadataTableUpdateCompanionBuilder,
    (
      SyncMetadataData,
      BaseReferences<_$AppDatabase, $SyncMetadataTable, SyncMetadataData>
    ),
    SyncMetadataData,
    PrefetchHooks Function()>;
typedef $$PlaybackStateTableCreateCompanionBuilder = PlaybackStateCompanion
    Function({
  Value<String> id,
  Value<String?> playerId,
  Value<String?> playerName,
  Value<String?> currentTrackJson,
  Value<double> positionSeconds,
  Value<bool> isPlaying,
  required DateTime savedAt,
  Value<int> rowid,
});
typedef $$PlaybackStateTableUpdateCompanionBuilder = PlaybackStateCompanion
    Function({
  Value<String> id,
  Value<String?> playerId,
  Value<String?> playerName,
  Value<String?> currentTrackJson,
  Value<double> positionSeconds,
  Value<bool> isPlaying,
  Value<DateTime> savedAt,
  Value<int> rowid,
});

class $$PlaybackStateTableFilterComposer
    extends Composer<_$AppDatabase, $PlaybackStateTable> {
  $$PlaybackStateTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get playerId => $composableBuilder(
      column: $table.playerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get playerName => $composableBuilder(
      column: $table.playerName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currentTrackJson => $composableBuilder(
      column: $table.currentTrackJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get positionSeconds => $composableBuilder(
      column: $table.positionSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isPlaying => $composableBuilder(
      column: $table.isPlaying, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get savedAt => $composableBuilder(
      column: $table.savedAt, builder: (column) => ColumnFilters(column));
}

class $$PlaybackStateTableOrderingComposer
    extends Composer<_$AppDatabase, $PlaybackStateTable> {
  $$PlaybackStateTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get playerId => $composableBuilder(
      column: $table.playerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get playerName => $composableBuilder(
      column: $table.playerName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currentTrackJson => $composableBuilder(
      column: $table.currentTrackJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get positionSeconds => $composableBuilder(
      column: $table.positionSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isPlaying => $composableBuilder(
      column: $table.isPlaying, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get savedAt => $composableBuilder(
      column: $table.savedAt, builder: (column) => ColumnOrderings(column));
}

class $$PlaybackStateTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlaybackStateTable> {
  $$PlaybackStateTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get playerId =>
      $composableBuilder(column: $table.playerId, builder: (column) => column);

  GeneratedColumn<String> get playerName => $composableBuilder(
      column: $table.playerName, builder: (column) => column);

  GeneratedColumn<String> get currentTrackJson => $composableBuilder(
      column: $table.currentTrackJson, builder: (column) => column);

  GeneratedColumn<double> get positionSeconds => $composableBuilder(
      column: $table.positionSeconds, builder: (column) => column);

  GeneratedColumn<bool> get isPlaying =>
      $composableBuilder(column: $table.isPlaying, builder: (column) => column);

  GeneratedColumn<DateTime> get savedAt =>
      $composableBuilder(column: $table.savedAt, builder: (column) => column);
}

class $$PlaybackStateTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PlaybackStateTable,
    PlaybackStateData,
    $$PlaybackStateTableFilterComposer,
    $$PlaybackStateTableOrderingComposer,
    $$PlaybackStateTableAnnotationComposer,
    $$PlaybackStateTableCreateCompanionBuilder,
    $$PlaybackStateTableUpdateCompanionBuilder,
    (
      PlaybackStateData,
      BaseReferences<_$AppDatabase, $PlaybackStateTable, PlaybackStateData>
    ),
    PlaybackStateData,
    PrefetchHooks Function()> {
  $$PlaybackStateTableTableManager(_$AppDatabase db, $PlaybackStateTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlaybackStateTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlaybackStateTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlaybackStateTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> playerId = const Value.absent(),
            Value<String?> playerName = const Value.absent(),
            Value<String?> currentTrackJson = const Value.absent(),
            Value<double> positionSeconds = const Value.absent(),
            Value<bool> isPlaying = const Value.absent(),
            Value<DateTime> savedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PlaybackStateCompanion(
            id: id,
            playerId: playerId,
            playerName: playerName,
            currentTrackJson: currentTrackJson,
            positionSeconds: positionSeconds,
            isPlaying: isPlaying,
            savedAt: savedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> playerId = const Value.absent(),
            Value<String?> playerName = const Value.absent(),
            Value<String?> currentTrackJson = const Value.absent(),
            Value<double> positionSeconds = const Value.absent(),
            Value<bool> isPlaying = const Value.absent(),
            required DateTime savedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              PlaybackStateCompanion.insert(
            id: id,
            playerId: playerId,
            playerName: playerName,
            currentTrackJson: currentTrackJson,
            positionSeconds: positionSeconds,
            isPlaying: isPlaying,
            savedAt: savedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PlaybackStateTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PlaybackStateTable,
    PlaybackStateData,
    $$PlaybackStateTableFilterComposer,
    $$PlaybackStateTableOrderingComposer,
    $$PlaybackStateTableAnnotationComposer,
    $$PlaybackStateTableCreateCompanionBuilder,
    $$PlaybackStateTableUpdateCompanionBuilder,
    (
      PlaybackStateData,
      BaseReferences<_$AppDatabase, $PlaybackStateTable, PlaybackStateData>
    ),
    PlaybackStateData,
    PrefetchHooks Function()>;
typedef $$CachedPlayersTableCreateCompanionBuilder = CachedPlayersCompanion
    Function({
  required String playerId,
  required String playerJson,
  Value<String?> currentTrackJson,
  required DateTime lastUpdated,
  Value<int> rowid,
});
typedef $$CachedPlayersTableUpdateCompanionBuilder = CachedPlayersCompanion
    Function({
  Value<String> playerId,
  Value<String> playerJson,
  Value<String?> currentTrackJson,
  Value<DateTime> lastUpdated,
  Value<int> rowid,
});

class $$CachedPlayersTableFilterComposer
    extends Composer<_$AppDatabase, $CachedPlayersTable> {
  $$CachedPlayersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get playerId => $composableBuilder(
      column: $table.playerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get playerJson => $composableBuilder(
      column: $table.playerJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currentTrackJson => $composableBuilder(
      column: $table.currentTrackJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => ColumnFilters(column));
}

class $$CachedPlayersTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedPlayersTable> {
  $$CachedPlayersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get playerId => $composableBuilder(
      column: $table.playerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get playerJson => $composableBuilder(
      column: $table.playerJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currentTrackJson => $composableBuilder(
      column: $table.currentTrackJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => ColumnOrderings(column));
}

class $$CachedPlayersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedPlayersTable> {
  $$CachedPlayersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get playerId =>
      $composableBuilder(column: $table.playerId, builder: (column) => column);

  GeneratedColumn<String> get playerJson => $composableBuilder(
      column: $table.playerJson, builder: (column) => column);

  GeneratedColumn<String> get currentTrackJson => $composableBuilder(
      column: $table.currentTrackJson, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => column);
}

class $$CachedPlayersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CachedPlayersTable,
    CachedPlayer,
    $$CachedPlayersTableFilterComposer,
    $$CachedPlayersTableOrderingComposer,
    $$CachedPlayersTableAnnotationComposer,
    $$CachedPlayersTableCreateCompanionBuilder,
    $$CachedPlayersTableUpdateCompanionBuilder,
    (
      CachedPlayer,
      BaseReferences<_$AppDatabase, $CachedPlayersTable, CachedPlayer>
    ),
    CachedPlayer,
    PrefetchHooks Function()> {
  $$CachedPlayersTableTableManager(_$AppDatabase db, $CachedPlayersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedPlayersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedPlayersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedPlayersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> playerId = const Value.absent(),
            Value<String> playerJson = const Value.absent(),
            Value<String?> currentTrackJson = const Value.absent(),
            Value<DateTime> lastUpdated = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CachedPlayersCompanion(
            playerId: playerId,
            playerJson: playerJson,
            currentTrackJson: currentTrackJson,
            lastUpdated: lastUpdated,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String playerId,
            required String playerJson,
            Value<String?> currentTrackJson = const Value.absent(),
            required DateTime lastUpdated,
            Value<int> rowid = const Value.absent(),
          }) =>
              CachedPlayersCompanion.insert(
            playerId: playerId,
            playerJson: playerJson,
            currentTrackJson: currentTrackJson,
            lastUpdated: lastUpdated,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CachedPlayersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CachedPlayersTable,
    CachedPlayer,
    $$CachedPlayersTableFilterComposer,
    $$CachedPlayersTableOrderingComposer,
    $$CachedPlayersTableAnnotationComposer,
    $$CachedPlayersTableCreateCompanionBuilder,
    $$CachedPlayersTableUpdateCompanionBuilder,
    (
      CachedPlayer,
      BaseReferences<_$AppDatabase, $CachedPlayersTable, CachedPlayer>
    ),
    CachedPlayer,
    PrefetchHooks Function()>;
typedef $$CachedQueueTableCreateCompanionBuilder = CachedQueueCompanion
    Function({
  Value<int> id,
  required String playerId,
  required String itemJson,
  required int position,
});
typedef $$CachedQueueTableUpdateCompanionBuilder = CachedQueueCompanion
    Function({
  Value<int> id,
  Value<String> playerId,
  Value<String> itemJson,
  Value<int> position,
});

class $$CachedQueueTableFilterComposer
    extends Composer<_$AppDatabase, $CachedQueueTable> {
  $$CachedQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get playerId => $composableBuilder(
      column: $table.playerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemJson => $composableBuilder(
      column: $table.itemJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnFilters(column));
}

class $$CachedQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedQueueTable> {
  $$CachedQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get playerId => $composableBuilder(
      column: $table.playerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemJson => $composableBuilder(
      column: $table.itemJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnOrderings(column));
}

class $$CachedQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedQueueTable> {
  $$CachedQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get playerId =>
      $composableBuilder(column: $table.playerId, builder: (column) => column);

  GeneratedColumn<String> get itemJson =>
      $composableBuilder(column: $table.itemJson, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);
}

class $$CachedQueueTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CachedQueueTable,
    CachedQueueData,
    $$CachedQueueTableFilterComposer,
    $$CachedQueueTableOrderingComposer,
    $$CachedQueueTableAnnotationComposer,
    $$CachedQueueTableCreateCompanionBuilder,
    $$CachedQueueTableUpdateCompanionBuilder,
    (
      CachedQueueData,
      BaseReferences<_$AppDatabase, $CachedQueueTable, CachedQueueData>
    ),
    CachedQueueData,
    PrefetchHooks Function()> {
  $$CachedQueueTableTableManager(_$AppDatabase db, $CachedQueueTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> playerId = const Value.absent(),
            Value<String> itemJson = const Value.absent(),
            Value<int> position = const Value.absent(),
          }) =>
              CachedQueueCompanion(
            id: id,
            playerId: playerId,
            itemJson: itemJson,
            position: position,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String playerId,
            required String itemJson,
            required int position,
          }) =>
              CachedQueueCompanion.insert(
            id: id,
            playerId: playerId,
            itemJson: itemJson,
            position: position,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CachedQueueTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CachedQueueTable,
    CachedQueueData,
    $$CachedQueueTableFilterComposer,
    $$CachedQueueTableOrderingComposer,
    $$CachedQueueTableAnnotationComposer,
    $$CachedQueueTableCreateCompanionBuilder,
    $$CachedQueueTableUpdateCompanionBuilder,
    (
      CachedQueueData,
      BaseReferences<_$AppDatabase, $CachedQueueTable, CachedQueueData>
    ),
    CachedQueueData,
    PrefetchHooks Function()>;
typedef $$HomeRowCacheTableCreateCompanionBuilder = HomeRowCacheCompanion
    Function({
  required String rowType,
  required String itemsJson,
  required DateTime lastUpdated,
  Value<int> rowid,
});
typedef $$HomeRowCacheTableUpdateCompanionBuilder = HomeRowCacheCompanion
    Function({
  Value<String> rowType,
  Value<String> itemsJson,
  Value<DateTime> lastUpdated,
  Value<int> rowid,
});

class $$HomeRowCacheTableFilterComposer
    extends Composer<_$AppDatabase, $HomeRowCacheTable> {
  $$HomeRowCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get rowType => $composableBuilder(
      column: $table.rowType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemsJson => $composableBuilder(
      column: $table.itemsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => ColumnFilters(column));
}

class $$HomeRowCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $HomeRowCacheTable> {
  $$HomeRowCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get rowType => $composableBuilder(
      column: $table.rowType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemsJson => $composableBuilder(
      column: $table.itemsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => ColumnOrderings(column));
}

class $$HomeRowCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $HomeRowCacheTable> {
  $$HomeRowCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get rowType =>
      $composableBuilder(column: $table.rowType, builder: (column) => column);

  GeneratedColumn<String> get itemsJson =>
      $composableBuilder(column: $table.itemsJson, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => column);
}

class $$HomeRowCacheTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HomeRowCacheTable,
    HomeRowCacheData,
    $$HomeRowCacheTableFilterComposer,
    $$HomeRowCacheTableOrderingComposer,
    $$HomeRowCacheTableAnnotationComposer,
    $$HomeRowCacheTableCreateCompanionBuilder,
    $$HomeRowCacheTableUpdateCompanionBuilder,
    (
      HomeRowCacheData,
      BaseReferences<_$AppDatabase, $HomeRowCacheTable, HomeRowCacheData>
    ),
    HomeRowCacheData,
    PrefetchHooks Function()> {
  $$HomeRowCacheTableTableManager(_$AppDatabase db, $HomeRowCacheTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HomeRowCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HomeRowCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HomeRowCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> rowType = const Value.absent(),
            Value<String> itemsJson = const Value.absent(),
            Value<DateTime> lastUpdated = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HomeRowCacheCompanion(
            rowType: rowType,
            itemsJson: itemsJson,
            lastUpdated: lastUpdated,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String rowType,
            required String itemsJson,
            required DateTime lastUpdated,
            Value<int> rowid = const Value.absent(),
          }) =>
              HomeRowCacheCompanion.insert(
            rowType: rowType,
            itemsJson: itemsJson,
            lastUpdated: lastUpdated,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$HomeRowCacheTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HomeRowCacheTable,
    HomeRowCacheData,
    $$HomeRowCacheTableFilterComposer,
    $$HomeRowCacheTableOrderingComposer,
    $$HomeRowCacheTableAnnotationComposer,
    $$HomeRowCacheTableCreateCompanionBuilder,
    $$HomeRowCacheTableUpdateCompanionBuilder,
    (
      HomeRowCacheData,
      BaseReferences<_$AppDatabase, $HomeRowCacheTable, HomeRowCacheData>
    ),
    HomeRowCacheData,
    PrefetchHooks Function()>;
typedef $$SearchHistoryTableCreateCompanionBuilder = SearchHistoryCompanion
    Function({
  Value<int> id,
  required String query,
  required DateTime searchedAt,
});
typedef $$SearchHistoryTableUpdateCompanionBuilder = SearchHistoryCompanion
    Function({
  Value<int> id,
  Value<String> query,
  Value<DateTime> searchedAt,
});

class $$SearchHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $SearchHistoryTable> {
  $$SearchHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get query => $composableBuilder(
      column: $table.query, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get searchedAt => $composableBuilder(
      column: $table.searchedAt, builder: (column) => ColumnFilters(column));
}

class $$SearchHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $SearchHistoryTable> {
  $$SearchHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get query => $composableBuilder(
      column: $table.query, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get searchedAt => $composableBuilder(
      column: $table.searchedAt, builder: (column) => ColumnOrderings(column));
}

class $$SearchHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $SearchHistoryTable> {
  $$SearchHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get query =>
      $composableBuilder(column: $table.query, builder: (column) => column);

  GeneratedColumn<DateTime> get searchedAt => $composableBuilder(
      column: $table.searchedAt, builder: (column) => column);
}

class $$SearchHistoryTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SearchHistoryTable,
    SearchHistoryData,
    $$SearchHistoryTableFilterComposer,
    $$SearchHistoryTableOrderingComposer,
    $$SearchHistoryTableAnnotationComposer,
    $$SearchHistoryTableCreateCompanionBuilder,
    $$SearchHistoryTableUpdateCompanionBuilder,
    (
      SearchHistoryData,
      BaseReferences<_$AppDatabase, $SearchHistoryTable, SearchHistoryData>
    ),
    SearchHistoryData,
    PrefetchHooks Function()> {
  $$SearchHistoryTableTableManager(_$AppDatabase db, $SearchHistoryTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SearchHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SearchHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SearchHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> query = const Value.absent(),
            Value<DateTime> searchedAt = const Value.absent(),
          }) =>
              SearchHistoryCompanion(
            id: id,
            query: query,
            searchedAt: searchedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String query,
            required DateTime searchedAt,
          }) =>
              SearchHistoryCompanion.insert(
            id: id,
            query: query,
            searchedAt: searchedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SearchHistoryTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SearchHistoryTable,
    SearchHistoryData,
    $$SearchHistoryTableFilterComposer,
    $$SearchHistoryTableOrderingComposer,
    $$SearchHistoryTableAnnotationComposer,
    $$SearchHistoryTableCreateCompanionBuilder,
    $$SearchHistoryTableUpdateCompanionBuilder,
    (
      SearchHistoryData,
      BaseReferences<_$AppDatabase, $SearchHistoryTable, SearchHistoryData>
    ),
    SearchHistoryData,
    PrefetchHooks Function()>;
typedef $$DetailTrackCacheTableCreateCompanionBuilder
    = DetailTrackCacheCompanion Function({
  required String cacheKey,
  required String parentType,
  required String parentKey,
  required String tracksJson,
  required DateTime lastFetched,
  required DateTime lastAccessed,
  Value<int> rowid,
});
typedef $$DetailTrackCacheTableUpdateCompanionBuilder
    = DetailTrackCacheCompanion Function({
  Value<String> cacheKey,
  Value<String> parentType,
  Value<String> parentKey,
  Value<String> tracksJson,
  Value<DateTime> lastFetched,
  Value<DateTime> lastAccessed,
  Value<int> rowid,
});

class $$DetailTrackCacheTableFilterComposer
    extends Composer<_$AppDatabase, $DetailTrackCacheTable> {
  $$DetailTrackCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get cacheKey => $composableBuilder(
      column: $table.cacheKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get parentType => $composableBuilder(
      column: $table.parentType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get parentKey => $composableBuilder(
      column: $table.parentKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tracksJson => $composableBuilder(
      column: $table.tracksJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastFetched => $composableBuilder(
      column: $table.lastFetched, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastAccessed => $composableBuilder(
      column: $table.lastAccessed, builder: (column) => ColumnFilters(column));
}

class $$DetailTrackCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $DetailTrackCacheTable> {
  $$DetailTrackCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get cacheKey => $composableBuilder(
      column: $table.cacheKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get parentType => $composableBuilder(
      column: $table.parentType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get parentKey => $composableBuilder(
      column: $table.parentKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tracksJson => $composableBuilder(
      column: $table.tracksJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastFetched => $composableBuilder(
      column: $table.lastFetched, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastAccessed => $composableBuilder(
      column: $table.lastAccessed,
      builder: (column) => ColumnOrderings(column));
}

class $$DetailTrackCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $DetailTrackCacheTable> {
  $$DetailTrackCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get cacheKey =>
      $composableBuilder(column: $table.cacheKey, builder: (column) => column);

  GeneratedColumn<String> get parentType => $composableBuilder(
      column: $table.parentType, builder: (column) => column);

  GeneratedColumn<String> get parentKey =>
      $composableBuilder(column: $table.parentKey, builder: (column) => column);

  GeneratedColumn<String> get tracksJson => $composableBuilder(
      column: $table.tracksJson, builder: (column) => column);

  GeneratedColumn<DateTime> get lastFetched => $composableBuilder(
      column: $table.lastFetched, builder: (column) => column);

  GeneratedColumn<DateTime> get lastAccessed => $composableBuilder(
      column: $table.lastAccessed, builder: (column) => column);
}

class $$DetailTrackCacheTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DetailTrackCacheTable,
    DetailTrackCacheData,
    $$DetailTrackCacheTableFilterComposer,
    $$DetailTrackCacheTableOrderingComposer,
    $$DetailTrackCacheTableAnnotationComposer,
    $$DetailTrackCacheTableCreateCompanionBuilder,
    $$DetailTrackCacheTableUpdateCompanionBuilder,
    (
      DetailTrackCacheData,
      BaseReferences<_$AppDatabase, $DetailTrackCacheTable,
          DetailTrackCacheData>
    ),
    DetailTrackCacheData,
    PrefetchHooks Function()> {
  $$DetailTrackCacheTableTableManager(
      _$AppDatabase db, $DetailTrackCacheTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DetailTrackCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DetailTrackCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DetailTrackCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> cacheKey = const Value.absent(),
            Value<String> parentType = const Value.absent(),
            Value<String> parentKey = const Value.absent(),
            Value<String> tracksJson = const Value.absent(),
            Value<DateTime> lastFetched = const Value.absent(),
            Value<DateTime> lastAccessed = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DetailTrackCacheCompanion(
            cacheKey: cacheKey,
            parentType: parentType,
            parentKey: parentKey,
            tracksJson: tracksJson,
            lastFetched: lastFetched,
            lastAccessed: lastAccessed,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String cacheKey,
            required String parentType,
            required String parentKey,
            required String tracksJson,
            required DateTime lastFetched,
            required DateTime lastAccessed,
            Value<int> rowid = const Value.absent(),
          }) =>
              DetailTrackCacheCompanion.insert(
            cacheKey: cacheKey,
            parentType: parentType,
            parentKey: parentKey,
            tracksJson: tracksJson,
            lastFetched: lastFetched,
            lastAccessed: lastAccessed,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DetailTrackCacheTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DetailTrackCacheTable,
    DetailTrackCacheData,
    $$DetailTrackCacheTableFilterComposer,
    $$DetailTrackCacheTableOrderingComposer,
    $$DetailTrackCacheTableAnnotationComposer,
    $$DetailTrackCacheTableCreateCompanionBuilder,
    $$DetailTrackCacheTableUpdateCompanionBuilder,
    (
      DetailTrackCacheData,
      BaseReferences<_$AppDatabase, $DetailTrackCacheTable,
          DetailTrackCacheData>
    ),
    DetailTrackCacheData,
    PrefetchHooks Function()>;
typedef $$ArtistsTableCreateCompanionBuilder = ArtistsCompanion Function({
  required String provider,
  required String itemId,
  required String name,
  Value<String?> sortName,
  Value<String?> uri,
  Value<bool> favorite,
  Value<bool> inLibrary,
  Value<String?> metadataJson,
  required DateTime lastSynced,
  Value<int> rowid,
});
typedef $$ArtistsTableUpdateCompanionBuilder = ArtistsCompanion Function({
  Value<String> provider,
  Value<String> itemId,
  Value<String> name,
  Value<String?> sortName,
  Value<String?> uri,
  Value<bool> favorite,
  Value<bool> inLibrary,
  Value<String?> metadataJson,
  Value<DateTime> lastSynced,
  Value<int> rowid,
});

class $$ArtistsTableFilterComposer
    extends Composer<_$AppDatabase, $ArtistsTable> {
  $$ArtistsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get provider => $composableBuilder(
      column: $table.provider, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sortName => $composableBuilder(
      column: $table.sortName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uri => $composableBuilder(
      column: $table.uri, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get favorite => $composableBuilder(
      column: $table.favorite, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get inLibrary => $composableBuilder(
      column: $table.inLibrary, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get metadataJson => $composableBuilder(
      column: $table.metadataJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSynced => $composableBuilder(
      column: $table.lastSynced, builder: (column) => ColumnFilters(column));
}

class $$ArtistsTableOrderingComposer
    extends Composer<_$AppDatabase, $ArtistsTable> {
  $$ArtistsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get provider => $composableBuilder(
      column: $table.provider, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sortName => $composableBuilder(
      column: $table.sortName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uri => $composableBuilder(
      column: $table.uri, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get favorite => $composableBuilder(
      column: $table.favorite, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get inLibrary => $composableBuilder(
      column: $table.inLibrary, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metadataJson => $composableBuilder(
      column: $table.metadataJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSynced => $composableBuilder(
      column: $table.lastSynced, builder: (column) => ColumnOrderings(column));
}

class $$ArtistsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ArtistsTable> {
  $$ArtistsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get provider =>
      $composableBuilder(column: $table.provider, builder: (column) => column);

  GeneratedColumn<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get sortName =>
      $composableBuilder(column: $table.sortName, builder: (column) => column);

  GeneratedColumn<String> get uri =>
      $composableBuilder(column: $table.uri, builder: (column) => column);

  GeneratedColumn<bool> get favorite =>
      $composableBuilder(column: $table.favorite, builder: (column) => column);

  GeneratedColumn<bool> get inLibrary =>
      $composableBuilder(column: $table.inLibrary, builder: (column) => column);

  GeneratedColumn<String> get metadataJson => $composableBuilder(
      column: $table.metadataJson, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSynced => $composableBuilder(
      column: $table.lastSynced, builder: (column) => column);
}

class $$ArtistsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ArtistsTable,
    ArtistEntity,
    $$ArtistsTableFilterComposer,
    $$ArtistsTableOrderingComposer,
    $$ArtistsTableAnnotationComposer,
    $$ArtistsTableCreateCompanionBuilder,
    $$ArtistsTableUpdateCompanionBuilder,
    (ArtistEntity, BaseReferences<_$AppDatabase, $ArtistsTable, ArtistEntity>),
    ArtistEntity,
    PrefetchHooks Function()> {
  $$ArtistsTableTableManager(_$AppDatabase db, $ArtistsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ArtistsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ArtistsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ArtistsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> provider = const Value.absent(),
            Value<String> itemId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> sortName = const Value.absent(),
            Value<String?> uri = const Value.absent(),
            Value<bool> favorite = const Value.absent(),
            Value<bool> inLibrary = const Value.absent(),
            Value<String?> metadataJson = const Value.absent(),
            Value<DateTime> lastSynced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ArtistsCompanion(
            provider: provider,
            itemId: itemId,
            name: name,
            sortName: sortName,
            uri: uri,
            favorite: favorite,
            inLibrary: inLibrary,
            metadataJson: metadataJson,
            lastSynced: lastSynced,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String provider,
            required String itemId,
            required String name,
            Value<String?> sortName = const Value.absent(),
            Value<String?> uri = const Value.absent(),
            Value<bool> favorite = const Value.absent(),
            Value<bool> inLibrary = const Value.absent(),
            Value<String?> metadataJson = const Value.absent(),
            required DateTime lastSynced,
            Value<int> rowid = const Value.absent(),
          }) =>
              ArtistsCompanion.insert(
            provider: provider,
            itemId: itemId,
            name: name,
            sortName: sortName,
            uri: uri,
            favorite: favorite,
            inLibrary: inLibrary,
            metadataJson: metadataJson,
            lastSynced: lastSynced,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ArtistsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ArtistsTable,
    ArtistEntity,
    $$ArtistsTableFilterComposer,
    $$ArtistsTableOrderingComposer,
    $$ArtistsTableAnnotationComposer,
    $$ArtistsTableCreateCompanionBuilder,
    $$ArtistsTableUpdateCompanionBuilder,
    (ArtistEntity, BaseReferences<_$AppDatabase, $ArtistsTable, ArtistEntity>),
    ArtistEntity,
    PrefetchHooks Function()>;
typedef $$AlbumsTableCreateCompanionBuilder = AlbumsCompanion Function({
  required String provider,
  required String itemId,
  required String name,
  Value<String?> sortName,
  Value<String?> uri,
  Value<String?> albumType,
  Value<int?> year,
  Value<String?> artistsJson,
  Value<bool> favorite,
  Value<bool> inLibrary,
  Value<String?> metadataJson,
  required DateTime lastSynced,
  Value<int> rowid,
});
typedef $$AlbumsTableUpdateCompanionBuilder = AlbumsCompanion Function({
  Value<String> provider,
  Value<String> itemId,
  Value<String> name,
  Value<String?> sortName,
  Value<String?> uri,
  Value<String?> albumType,
  Value<int?> year,
  Value<String?> artistsJson,
  Value<bool> favorite,
  Value<bool> inLibrary,
  Value<String?> metadataJson,
  Value<DateTime> lastSynced,
  Value<int> rowid,
});

class $$AlbumsTableFilterComposer
    extends Composer<_$AppDatabase, $AlbumsTable> {
  $$AlbumsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get provider => $composableBuilder(
      column: $table.provider, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sortName => $composableBuilder(
      column: $table.sortName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uri => $composableBuilder(
      column: $table.uri, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get albumType => $composableBuilder(
      column: $table.albumType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get artistsJson => $composableBuilder(
      column: $table.artistsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get favorite => $composableBuilder(
      column: $table.favorite, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get inLibrary => $composableBuilder(
      column: $table.inLibrary, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get metadataJson => $composableBuilder(
      column: $table.metadataJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSynced => $composableBuilder(
      column: $table.lastSynced, builder: (column) => ColumnFilters(column));
}

class $$AlbumsTableOrderingComposer
    extends Composer<_$AppDatabase, $AlbumsTable> {
  $$AlbumsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get provider => $composableBuilder(
      column: $table.provider, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sortName => $composableBuilder(
      column: $table.sortName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uri => $composableBuilder(
      column: $table.uri, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get albumType => $composableBuilder(
      column: $table.albumType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get artistsJson => $composableBuilder(
      column: $table.artistsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get favorite => $composableBuilder(
      column: $table.favorite, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get inLibrary => $composableBuilder(
      column: $table.inLibrary, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metadataJson => $composableBuilder(
      column: $table.metadataJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSynced => $composableBuilder(
      column: $table.lastSynced, builder: (column) => ColumnOrderings(column));
}

class $$AlbumsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AlbumsTable> {
  $$AlbumsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get provider =>
      $composableBuilder(column: $table.provider, builder: (column) => column);

  GeneratedColumn<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get sortName =>
      $composableBuilder(column: $table.sortName, builder: (column) => column);

  GeneratedColumn<String> get uri =>
      $composableBuilder(column: $table.uri, builder: (column) => column);

  GeneratedColumn<String> get albumType =>
      $composableBuilder(column: $table.albumType, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<String> get artistsJson => $composableBuilder(
      column: $table.artistsJson, builder: (column) => column);

  GeneratedColumn<bool> get favorite =>
      $composableBuilder(column: $table.favorite, builder: (column) => column);

  GeneratedColumn<bool> get inLibrary =>
      $composableBuilder(column: $table.inLibrary, builder: (column) => column);

  GeneratedColumn<String> get metadataJson => $composableBuilder(
      column: $table.metadataJson, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSynced => $composableBuilder(
      column: $table.lastSynced, builder: (column) => column);
}

class $$AlbumsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AlbumsTable,
    AlbumEntity,
    $$AlbumsTableFilterComposer,
    $$AlbumsTableOrderingComposer,
    $$AlbumsTableAnnotationComposer,
    $$AlbumsTableCreateCompanionBuilder,
    $$AlbumsTableUpdateCompanionBuilder,
    (AlbumEntity, BaseReferences<_$AppDatabase, $AlbumsTable, AlbumEntity>),
    AlbumEntity,
    PrefetchHooks Function()> {
  $$AlbumsTableTableManager(_$AppDatabase db, $AlbumsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AlbumsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AlbumsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AlbumsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> provider = const Value.absent(),
            Value<String> itemId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> sortName = const Value.absent(),
            Value<String?> uri = const Value.absent(),
            Value<String?> albumType = const Value.absent(),
            Value<int?> year = const Value.absent(),
            Value<String?> artistsJson = const Value.absent(),
            Value<bool> favorite = const Value.absent(),
            Value<bool> inLibrary = const Value.absent(),
            Value<String?> metadataJson = const Value.absent(),
            Value<DateTime> lastSynced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AlbumsCompanion(
            provider: provider,
            itemId: itemId,
            name: name,
            sortName: sortName,
            uri: uri,
            albumType: albumType,
            year: year,
            artistsJson: artistsJson,
            favorite: favorite,
            inLibrary: inLibrary,
            metadataJson: metadataJson,
            lastSynced: lastSynced,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String provider,
            required String itemId,
            required String name,
            Value<String?> sortName = const Value.absent(),
            Value<String?> uri = const Value.absent(),
            Value<String?> albumType = const Value.absent(),
            Value<int?> year = const Value.absent(),
            Value<String?> artistsJson = const Value.absent(),
            Value<bool> favorite = const Value.absent(),
            Value<bool> inLibrary = const Value.absent(),
            Value<String?> metadataJson = const Value.absent(),
            required DateTime lastSynced,
            Value<int> rowid = const Value.absent(),
          }) =>
              AlbumsCompanion.insert(
            provider: provider,
            itemId: itemId,
            name: name,
            sortName: sortName,
            uri: uri,
            albumType: albumType,
            year: year,
            artistsJson: artistsJson,
            favorite: favorite,
            inLibrary: inLibrary,
            metadataJson: metadataJson,
            lastSynced: lastSynced,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AlbumsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AlbumsTable,
    AlbumEntity,
    $$AlbumsTableFilterComposer,
    $$AlbumsTableOrderingComposer,
    $$AlbumsTableAnnotationComposer,
    $$AlbumsTableCreateCompanionBuilder,
    $$AlbumsTableUpdateCompanionBuilder,
    (AlbumEntity, BaseReferences<_$AppDatabase, $AlbumsTable, AlbumEntity>),
    AlbumEntity,
    PrefetchHooks Function()>;
typedef $$TracksTableCreateCompanionBuilder = TracksCompanion Function({
  required String provider,
  required String itemId,
  required String name,
  Value<String?> sortName,
  Value<String?> uri,
  Value<int?> durationSeconds,
  Value<String?> artistsJson,
  Value<String?> albumProvider,
  Value<String?> albumItemId,
  Value<int?> position,
  Value<bool> favorite,
  Value<bool> inLibrary,
  Value<String?> metadataJson,
  required DateTime lastSynced,
  Value<int> rowid,
});
typedef $$TracksTableUpdateCompanionBuilder = TracksCompanion Function({
  Value<String> provider,
  Value<String> itemId,
  Value<String> name,
  Value<String?> sortName,
  Value<String?> uri,
  Value<int?> durationSeconds,
  Value<String?> artistsJson,
  Value<String?> albumProvider,
  Value<String?> albumItemId,
  Value<int?> position,
  Value<bool> favorite,
  Value<bool> inLibrary,
  Value<String?> metadataJson,
  Value<DateTime> lastSynced,
  Value<int> rowid,
});

class $$TracksTableFilterComposer
    extends Composer<_$AppDatabase, $TracksTable> {
  $$TracksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get provider => $composableBuilder(
      column: $table.provider, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sortName => $composableBuilder(
      column: $table.sortName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uri => $composableBuilder(
      column: $table.uri, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get artistsJson => $composableBuilder(
      column: $table.artistsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get albumProvider => $composableBuilder(
      column: $table.albumProvider, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get albumItemId => $composableBuilder(
      column: $table.albumItemId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get favorite => $composableBuilder(
      column: $table.favorite, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get inLibrary => $composableBuilder(
      column: $table.inLibrary, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get metadataJson => $composableBuilder(
      column: $table.metadataJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSynced => $composableBuilder(
      column: $table.lastSynced, builder: (column) => ColumnFilters(column));
}

class $$TracksTableOrderingComposer
    extends Composer<_$AppDatabase, $TracksTable> {
  $$TracksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get provider => $composableBuilder(
      column: $table.provider, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sortName => $composableBuilder(
      column: $table.sortName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uri => $composableBuilder(
      column: $table.uri, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get artistsJson => $composableBuilder(
      column: $table.artistsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get albumProvider => $composableBuilder(
      column: $table.albumProvider,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get albumItemId => $composableBuilder(
      column: $table.albumItemId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get favorite => $composableBuilder(
      column: $table.favorite, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get inLibrary => $composableBuilder(
      column: $table.inLibrary, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metadataJson => $composableBuilder(
      column: $table.metadataJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSynced => $composableBuilder(
      column: $table.lastSynced, builder: (column) => ColumnOrderings(column));
}

class $$TracksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TracksTable> {
  $$TracksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get provider =>
      $composableBuilder(column: $table.provider, builder: (column) => column);

  GeneratedColumn<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get sortName =>
      $composableBuilder(column: $table.sortName, builder: (column) => column);

  GeneratedColumn<String> get uri =>
      $composableBuilder(column: $table.uri, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds, builder: (column) => column);

  GeneratedColumn<String> get artistsJson => $composableBuilder(
      column: $table.artistsJson, builder: (column) => column);

  GeneratedColumn<String> get albumProvider => $composableBuilder(
      column: $table.albumProvider, builder: (column) => column);

  GeneratedColumn<String> get albumItemId => $composableBuilder(
      column: $table.albumItemId, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<bool> get favorite =>
      $composableBuilder(column: $table.favorite, builder: (column) => column);

  GeneratedColumn<bool> get inLibrary =>
      $composableBuilder(column: $table.inLibrary, builder: (column) => column);

  GeneratedColumn<String> get metadataJson => $composableBuilder(
      column: $table.metadataJson, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSynced => $composableBuilder(
      column: $table.lastSynced, builder: (column) => column);
}

class $$TracksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TracksTable,
    TrackEntity,
    $$TracksTableFilterComposer,
    $$TracksTableOrderingComposer,
    $$TracksTableAnnotationComposer,
    $$TracksTableCreateCompanionBuilder,
    $$TracksTableUpdateCompanionBuilder,
    (TrackEntity, BaseReferences<_$AppDatabase, $TracksTable, TrackEntity>),
    TrackEntity,
    PrefetchHooks Function()> {
  $$TracksTableTableManager(_$AppDatabase db, $TracksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TracksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TracksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TracksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> provider = const Value.absent(),
            Value<String> itemId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> sortName = const Value.absent(),
            Value<String?> uri = const Value.absent(),
            Value<int?> durationSeconds = const Value.absent(),
            Value<String?> artistsJson = const Value.absent(),
            Value<String?> albumProvider = const Value.absent(),
            Value<String?> albumItemId = const Value.absent(),
            Value<int?> position = const Value.absent(),
            Value<bool> favorite = const Value.absent(),
            Value<bool> inLibrary = const Value.absent(),
            Value<String?> metadataJson = const Value.absent(),
            Value<DateTime> lastSynced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TracksCompanion(
            provider: provider,
            itemId: itemId,
            name: name,
            sortName: sortName,
            uri: uri,
            durationSeconds: durationSeconds,
            artistsJson: artistsJson,
            albumProvider: albumProvider,
            albumItemId: albumItemId,
            position: position,
            favorite: favorite,
            inLibrary: inLibrary,
            metadataJson: metadataJson,
            lastSynced: lastSynced,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String provider,
            required String itemId,
            required String name,
            Value<String?> sortName = const Value.absent(),
            Value<String?> uri = const Value.absent(),
            Value<int?> durationSeconds = const Value.absent(),
            Value<String?> artistsJson = const Value.absent(),
            Value<String?> albumProvider = const Value.absent(),
            Value<String?> albumItemId = const Value.absent(),
            Value<int?> position = const Value.absent(),
            Value<bool> favorite = const Value.absent(),
            Value<bool> inLibrary = const Value.absent(),
            Value<String?> metadataJson = const Value.absent(),
            required DateTime lastSynced,
            Value<int> rowid = const Value.absent(),
          }) =>
              TracksCompanion.insert(
            provider: provider,
            itemId: itemId,
            name: name,
            sortName: sortName,
            uri: uri,
            durationSeconds: durationSeconds,
            artistsJson: artistsJson,
            albumProvider: albumProvider,
            albumItemId: albumItemId,
            position: position,
            favorite: favorite,
            inLibrary: inLibrary,
            metadataJson: metadataJson,
            lastSynced: lastSynced,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TracksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TracksTable,
    TrackEntity,
    $$TracksTableFilterComposer,
    $$TracksTableOrderingComposer,
    $$TracksTableAnnotationComposer,
    $$TracksTableCreateCompanionBuilder,
    $$TracksTableUpdateCompanionBuilder,
    (TrackEntity, BaseReferences<_$AppDatabase, $TracksTable, TrackEntity>),
    TrackEntity,
    PrefetchHooks Function()>;
typedef $$PlaylistsTableCreateCompanionBuilder = PlaylistsCompanion Function({
  required String provider,
  required String itemId,
  required String name,
  Value<String?> sortName,
  Value<String?> uri,
  Value<String?> owner,
  Value<bool?> isEditable,
  Value<int?> trackCount,
  Value<bool> favorite,
  Value<bool> inLibrary,
  Value<String?> metadataJson,
  required DateTime lastSynced,
  Value<int> rowid,
});
typedef $$PlaylistsTableUpdateCompanionBuilder = PlaylistsCompanion Function({
  Value<String> provider,
  Value<String> itemId,
  Value<String> name,
  Value<String?> sortName,
  Value<String?> uri,
  Value<String?> owner,
  Value<bool?> isEditable,
  Value<int?> trackCount,
  Value<bool> favorite,
  Value<bool> inLibrary,
  Value<String?> metadataJson,
  Value<DateTime> lastSynced,
  Value<int> rowid,
});

class $$PlaylistsTableFilterComposer
    extends Composer<_$AppDatabase, $PlaylistsTable> {
  $$PlaylistsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get provider => $composableBuilder(
      column: $table.provider, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sortName => $composableBuilder(
      column: $table.sortName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uri => $composableBuilder(
      column: $table.uri, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get owner => $composableBuilder(
      column: $table.owner, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isEditable => $composableBuilder(
      column: $table.isEditable, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get trackCount => $composableBuilder(
      column: $table.trackCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get favorite => $composableBuilder(
      column: $table.favorite, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get inLibrary => $composableBuilder(
      column: $table.inLibrary, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get metadataJson => $composableBuilder(
      column: $table.metadataJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSynced => $composableBuilder(
      column: $table.lastSynced, builder: (column) => ColumnFilters(column));
}

class $$PlaylistsTableOrderingComposer
    extends Composer<_$AppDatabase, $PlaylistsTable> {
  $$PlaylistsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get provider => $composableBuilder(
      column: $table.provider, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sortName => $composableBuilder(
      column: $table.sortName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uri => $composableBuilder(
      column: $table.uri, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get owner => $composableBuilder(
      column: $table.owner, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isEditable => $composableBuilder(
      column: $table.isEditable, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get trackCount => $composableBuilder(
      column: $table.trackCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get favorite => $composableBuilder(
      column: $table.favorite, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get inLibrary => $composableBuilder(
      column: $table.inLibrary, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metadataJson => $composableBuilder(
      column: $table.metadataJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSynced => $composableBuilder(
      column: $table.lastSynced, builder: (column) => ColumnOrderings(column));
}

class $$PlaylistsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlaylistsTable> {
  $$PlaylistsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get provider =>
      $composableBuilder(column: $table.provider, builder: (column) => column);

  GeneratedColumn<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get sortName =>
      $composableBuilder(column: $table.sortName, builder: (column) => column);

  GeneratedColumn<String> get uri =>
      $composableBuilder(column: $table.uri, builder: (column) => column);

  GeneratedColumn<String> get owner =>
      $composableBuilder(column: $table.owner, builder: (column) => column);

  GeneratedColumn<bool> get isEditable => $composableBuilder(
      column: $table.isEditable, builder: (column) => column);

  GeneratedColumn<int> get trackCount => $composableBuilder(
      column: $table.trackCount, builder: (column) => column);

  GeneratedColumn<bool> get favorite =>
      $composableBuilder(column: $table.favorite, builder: (column) => column);

  GeneratedColumn<bool> get inLibrary =>
      $composableBuilder(column: $table.inLibrary, builder: (column) => column);

  GeneratedColumn<String> get metadataJson => $composableBuilder(
      column: $table.metadataJson, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSynced => $composableBuilder(
      column: $table.lastSynced, builder: (column) => column);
}

class $$PlaylistsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PlaylistsTable,
    PlaylistEntity,
    $$PlaylistsTableFilterComposer,
    $$PlaylistsTableOrderingComposer,
    $$PlaylistsTableAnnotationComposer,
    $$PlaylistsTableCreateCompanionBuilder,
    $$PlaylistsTableUpdateCompanionBuilder,
    (
      PlaylistEntity,
      BaseReferences<_$AppDatabase, $PlaylistsTable, PlaylistEntity>
    ),
    PlaylistEntity,
    PrefetchHooks Function()> {
  $$PlaylistsTableTableManager(_$AppDatabase db, $PlaylistsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlaylistsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlaylistsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlaylistsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> provider = const Value.absent(),
            Value<String> itemId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> sortName = const Value.absent(),
            Value<String?> uri = const Value.absent(),
            Value<String?> owner = const Value.absent(),
            Value<bool?> isEditable = const Value.absent(),
            Value<int?> trackCount = const Value.absent(),
            Value<bool> favorite = const Value.absent(),
            Value<bool> inLibrary = const Value.absent(),
            Value<String?> metadataJson = const Value.absent(),
            Value<DateTime> lastSynced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PlaylistsCompanion(
            provider: provider,
            itemId: itemId,
            name: name,
            sortName: sortName,
            uri: uri,
            owner: owner,
            isEditable: isEditable,
            trackCount: trackCount,
            favorite: favorite,
            inLibrary: inLibrary,
            metadataJson: metadataJson,
            lastSynced: lastSynced,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String provider,
            required String itemId,
            required String name,
            Value<String?> sortName = const Value.absent(),
            Value<String?> uri = const Value.absent(),
            Value<String?> owner = const Value.absent(),
            Value<bool?> isEditable = const Value.absent(),
            Value<int?> trackCount = const Value.absent(),
            Value<bool> favorite = const Value.absent(),
            Value<bool> inLibrary = const Value.absent(),
            Value<String?> metadataJson = const Value.absent(),
            required DateTime lastSynced,
            Value<int> rowid = const Value.absent(),
          }) =>
              PlaylistsCompanion.insert(
            provider: provider,
            itemId: itemId,
            name: name,
            sortName: sortName,
            uri: uri,
            owner: owner,
            isEditable: isEditable,
            trackCount: trackCount,
            favorite: favorite,
            inLibrary: inLibrary,
            metadataJson: metadataJson,
            lastSynced: lastSynced,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PlaylistsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PlaylistsTable,
    PlaylistEntity,
    $$PlaylistsTableFilterComposer,
    $$PlaylistsTableOrderingComposer,
    $$PlaylistsTableAnnotationComposer,
    $$PlaylistsTableCreateCompanionBuilder,
    $$PlaylistsTableUpdateCompanionBuilder,
    (
      PlaylistEntity,
      BaseReferences<_$AppDatabase, $PlaylistsTable, PlaylistEntity>
    ),
    PlaylistEntity,
    PrefetchHooks Function()>;
typedef $$PlaylistTracksTableCreateCompanionBuilder = PlaylistTracksCompanion
    Function({
  Value<int> id,
  required String playlistProvider,
  required String playlistItemId,
  required String trackProvider,
  required String trackItemId,
  required int position,
});
typedef $$PlaylistTracksTableUpdateCompanionBuilder = PlaylistTracksCompanion
    Function({
  Value<int> id,
  Value<String> playlistProvider,
  Value<String> playlistItemId,
  Value<String> trackProvider,
  Value<String> trackItemId,
  Value<int> position,
});

class $$PlaylistTracksTableFilterComposer
    extends Composer<_$AppDatabase, $PlaylistTracksTable> {
  $$PlaylistTracksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get playlistProvider => $composableBuilder(
      column: $table.playlistProvider,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get playlistItemId => $composableBuilder(
      column: $table.playlistItemId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get trackProvider => $composableBuilder(
      column: $table.trackProvider, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get trackItemId => $composableBuilder(
      column: $table.trackItemId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnFilters(column));
}

class $$PlaylistTracksTableOrderingComposer
    extends Composer<_$AppDatabase, $PlaylistTracksTable> {
  $$PlaylistTracksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get playlistProvider => $composableBuilder(
      column: $table.playlistProvider,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get playlistItemId => $composableBuilder(
      column: $table.playlistItemId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get trackProvider => $composableBuilder(
      column: $table.trackProvider,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get trackItemId => $composableBuilder(
      column: $table.trackItemId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnOrderings(column));
}

class $$PlaylistTracksTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlaylistTracksTable> {
  $$PlaylistTracksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get playlistProvider => $composableBuilder(
      column: $table.playlistProvider, builder: (column) => column);

  GeneratedColumn<String> get playlistItemId => $composableBuilder(
      column: $table.playlistItemId, builder: (column) => column);

  GeneratedColumn<String> get trackProvider => $composableBuilder(
      column: $table.trackProvider, builder: (column) => column);

  GeneratedColumn<String> get trackItemId => $composableBuilder(
      column: $table.trackItemId, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);
}

class $$PlaylistTracksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PlaylistTracksTable,
    PlaylistTrackEntity,
    $$PlaylistTracksTableFilterComposer,
    $$PlaylistTracksTableOrderingComposer,
    $$PlaylistTracksTableAnnotationComposer,
    $$PlaylistTracksTableCreateCompanionBuilder,
    $$PlaylistTracksTableUpdateCompanionBuilder,
    (
      PlaylistTrackEntity,
      BaseReferences<_$AppDatabase, $PlaylistTracksTable, PlaylistTrackEntity>
    ),
    PlaylistTrackEntity,
    PrefetchHooks Function()> {
  $$PlaylistTracksTableTableManager(
      _$AppDatabase db, $PlaylistTracksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlaylistTracksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlaylistTracksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlaylistTracksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> playlistProvider = const Value.absent(),
            Value<String> playlistItemId = const Value.absent(),
            Value<String> trackProvider = const Value.absent(),
            Value<String> trackItemId = const Value.absent(),
            Value<int> position = const Value.absent(),
          }) =>
              PlaylistTracksCompanion(
            id: id,
            playlistProvider: playlistProvider,
            playlistItemId: playlistItemId,
            trackProvider: trackProvider,
            trackItemId: trackItemId,
            position: position,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String playlistProvider,
            required String playlistItemId,
            required String trackProvider,
            required String trackItemId,
            required int position,
          }) =>
              PlaylistTracksCompanion.insert(
            id: id,
            playlistProvider: playlistProvider,
            playlistItemId: playlistItemId,
            trackProvider: trackProvider,
            trackItemId: trackItemId,
            position: position,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PlaylistTracksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PlaylistTracksTable,
    PlaylistTrackEntity,
    $$PlaylistTracksTableFilterComposer,
    $$PlaylistTracksTableOrderingComposer,
    $$PlaylistTracksTableAnnotationComposer,
    $$PlaylistTracksTableCreateCompanionBuilder,
    $$PlaylistTracksTableUpdateCompanionBuilder,
    (
      PlaylistTrackEntity,
      BaseReferences<_$AppDatabase, $PlaylistTracksTable, PlaylistTrackEntity>
    ),
    PlaylistTrackEntity,
    PrefetchHooks Function()>;
typedef $$AudiobooksTableCreateCompanionBuilder = AudiobooksCompanion Function({
  required String provider,
  required String itemId,
  required String name,
  Value<String?> sortName,
  Value<String?> uri,
  Value<String?> authorsJson,
  Value<String?> narratorsJson,
  Value<String?> publisher,
  Value<String?> description,
  Value<int?> year,
  Value<int?> durationSeconds,
  Value<int?> resumePositionMs,
  Value<bool?> fullyPlayed,
  Value<int?> browseOrder,
  Value<bool> favorite,
  Value<bool> inLibrary,
  Value<String?> metadataJson,
  required DateTime lastSynced,
  Value<int> rowid,
});
typedef $$AudiobooksTableUpdateCompanionBuilder = AudiobooksCompanion Function({
  Value<String> provider,
  Value<String> itemId,
  Value<String> name,
  Value<String?> sortName,
  Value<String?> uri,
  Value<String?> authorsJson,
  Value<String?> narratorsJson,
  Value<String?> publisher,
  Value<String?> description,
  Value<int?> year,
  Value<int?> durationSeconds,
  Value<int?> resumePositionMs,
  Value<bool?> fullyPlayed,
  Value<int?> browseOrder,
  Value<bool> favorite,
  Value<bool> inLibrary,
  Value<String?> metadataJson,
  Value<DateTime> lastSynced,
  Value<int> rowid,
});

class $$AudiobooksTableFilterComposer
    extends Composer<_$AppDatabase, $AudiobooksTable> {
  $$AudiobooksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get provider => $composableBuilder(
      column: $table.provider, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sortName => $composableBuilder(
      column: $table.sortName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uri => $composableBuilder(
      column: $table.uri, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get authorsJson => $composableBuilder(
      column: $table.authorsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get narratorsJson => $composableBuilder(
      column: $table.narratorsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get publisher => $composableBuilder(
      column: $table.publisher, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get resumePositionMs => $composableBuilder(
      column: $table.resumePositionMs,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get fullyPlayed => $composableBuilder(
      column: $table.fullyPlayed, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get browseOrder => $composableBuilder(
      column: $table.browseOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get favorite => $composableBuilder(
      column: $table.favorite, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get inLibrary => $composableBuilder(
      column: $table.inLibrary, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get metadataJson => $composableBuilder(
      column: $table.metadataJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSynced => $composableBuilder(
      column: $table.lastSynced, builder: (column) => ColumnFilters(column));
}

class $$AudiobooksTableOrderingComposer
    extends Composer<_$AppDatabase, $AudiobooksTable> {
  $$AudiobooksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get provider => $composableBuilder(
      column: $table.provider, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sortName => $composableBuilder(
      column: $table.sortName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uri => $composableBuilder(
      column: $table.uri, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get authorsJson => $composableBuilder(
      column: $table.authorsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get narratorsJson => $composableBuilder(
      column: $table.narratorsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get publisher => $composableBuilder(
      column: $table.publisher, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get resumePositionMs => $composableBuilder(
      column: $table.resumePositionMs,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get fullyPlayed => $composableBuilder(
      column: $table.fullyPlayed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get browseOrder => $composableBuilder(
      column: $table.browseOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get favorite => $composableBuilder(
      column: $table.favorite, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get inLibrary => $composableBuilder(
      column: $table.inLibrary, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metadataJson => $composableBuilder(
      column: $table.metadataJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSynced => $composableBuilder(
      column: $table.lastSynced, builder: (column) => ColumnOrderings(column));
}

class $$AudiobooksTableAnnotationComposer
    extends Composer<_$AppDatabase, $AudiobooksTable> {
  $$AudiobooksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get provider =>
      $composableBuilder(column: $table.provider, builder: (column) => column);

  GeneratedColumn<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get sortName =>
      $composableBuilder(column: $table.sortName, builder: (column) => column);

  GeneratedColumn<String> get uri =>
      $composableBuilder(column: $table.uri, builder: (column) => column);

  GeneratedColumn<String> get authorsJson => $composableBuilder(
      column: $table.authorsJson, builder: (column) => column);

  GeneratedColumn<String> get narratorsJson => $composableBuilder(
      column: $table.narratorsJson, builder: (column) => column);

  GeneratedColumn<String> get publisher =>
      $composableBuilder(column: $table.publisher, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds, builder: (column) => column);

  GeneratedColumn<int> get resumePositionMs => $composableBuilder(
      column: $table.resumePositionMs, builder: (column) => column);

  GeneratedColumn<bool> get fullyPlayed => $composableBuilder(
      column: $table.fullyPlayed, builder: (column) => column);

  GeneratedColumn<int> get browseOrder => $composableBuilder(
      column: $table.browseOrder, builder: (column) => column);

  GeneratedColumn<bool> get favorite =>
      $composableBuilder(column: $table.favorite, builder: (column) => column);

  GeneratedColumn<bool> get inLibrary =>
      $composableBuilder(column: $table.inLibrary, builder: (column) => column);

  GeneratedColumn<String> get metadataJson => $composableBuilder(
      column: $table.metadataJson, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSynced => $composableBuilder(
      column: $table.lastSynced, builder: (column) => column);
}

class $$AudiobooksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AudiobooksTable,
    AudiobookEntity,
    $$AudiobooksTableFilterComposer,
    $$AudiobooksTableOrderingComposer,
    $$AudiobooksTableAnnotationComposer,
    $$AudiobooksTableCreateCompanionBuilder,
    $$AudiobooksTableUpdateCompanionBuilder,
    (
      AudiobookEntity,
      BaseReferences<_$AppDatabase, $AudiobooksTable, AudiobookEntity>
    ),
    AudiobookEntity,
    PrefetchHooks Function()> {
  $$AudiobooksTableTableManager(_$AppDatabase db, $AudiobooksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AudiobooksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AudiobooksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AudiobooksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> provider = const Value.absent(),
            Value<String> itemId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> sortName = const Value.absent(),
            Value<String?> uri = const Value.absent(),
            Value<String?> authorsJson = const Value.absent(),
            Value<String?> narratorsJson = const Value.absent(),
            Value<String?> publisher = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<int?> year = const Value.absent(),
            Value<int?> durationSeconds = const Value.absent(),
            Value<int?> resumePositionMs = const Value.absent(),
            Value<bool?> fullyPlayed = const Value.absent(),
            Value<int?> browseOrder = const Value.absent(),
            Value<bool> favorite = const Value.absent(),
            Value<bool> inLibrary = const Value.absent(),
            Value<String?> metadataJson = const Value.absent(),
            Value<DateTime> lastSynced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AudiobooksCompanion(
            provider: provider,
            itemId: itemId,
            name: name,
            sortName: sortName,
            uri: uri,
            authorsJson: authorsJson,
            narratorsJson: narratorsJson,
            publisher: publisher,
            description: description,
            year: year,
            durationSeconds: durationSeconds,
            resumePositionMs: resumePositionMs,
            fullyPlayed: fullyPlayed,
            browseOrder: browseOrder,
            favorite: favorite,
            inLibrary: inLibrary,
            metadataJson: metadataJson,
            lastSynced: lastSynced,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String provider,
            required String itemId,
            required String name,
            Value<String?> sortName = const Value.absent(),
            Value<String?> uri = const Value.absent(),
            Value<String?> authorsJson = const Value.absent(),
            Value<String?> narratorsJson = const Value.absent(),
            Value<String?> publisher = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<int?> year = const Value.absent(),
            Value<int?> durationSeconds = const Value.absent(),
            Value<int?> resumePositionMs = const Value.absent(),
            Value<bool?> fullyPlayed = const Value.absent(),
            Value<int?> browseOrder = const Value.absent(),
            Value<bool> favorite = const Value.absent(),
            Value<bool> inLibrary = const Value.absent(),
            Value<String?> metadataJson = const Value.absent(),
            required DateTime lastSynced,
            Value<int> rowid = const Value.absent(),
          }) =>
              AudiobooksCompanion.insert(
            provider: provider,
            itemId: itemId,
            name: name,
            sortName: sortName,
            uri: uri,
            authorsJson: authorsJson,
            narratorsJson: narratorsJson,
            publisher: publisher,
            description: description,
            year: year,
            durationSeconds: durationSeconds,
            resumePositionMs: resumePositionMs,
            fullyPlayed: fullyPlayed,
            browseOrder: browseOrder,
            favorite: favorite,
            inLibrary: inLibrary,
            metadataJson: metadataJson,
            lastSynced: lastSynced,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AudiobooksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AudiobooksTable,
    AudiobookEntity,
    $$AudiobooksTableFilterComposer,
    $$AudiobooksTableOrderingComposer,
    $$AudiobooksTableAnnotationComposer,
    $$AudiobooksTableCreateCompanionBuilder,
    $$AudiobooksTableUpdateCompanionBuilder,
    (
      AudiobookEntity,
      BaseReferences<_$AppDatabase, $AudiobooksTable, AudiobookEntity>
    ),
    AudiobookEntity,
    PrefetchHooks Function()>;
typedef $$ChaptersTableCreateCompanionBuilder = ChaptersCompanion Function({
  Value<int> id,
  required String audiobookProvider,
  required String audiobookItemId,
  required int chapterNumber,
  required int positionMs,
  required String title,
  Value<int?> durationMs,
});
typedef $$ChaptersTableUpdateCompanionBuilder = ChaptersCompanion Function({
  Value<int> id,
  Value<String> audiobookProvider,
  Value<String> audiobookItemId,
  Value<int> chapterNumber,
  Value<int> positionMs,
  Value<String> title,
  Value<int?> durationMs,
});

class $$ChaptersTableFilterComposer
    extends Composer<_$AppDatabase, $ChaptersTable> {
  $$ChaptersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get audiobookProvider => $composableBuilder(
      column: $table.audiobookProvider,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get audiobookItemId => $composableBuilder(
      column: $table.audiobookItemId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get chapterNumber => $composableBuilder(
      column: $table.chapterNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get positionMs => $composableBuilder(
      column: $table.positionMs, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationMs => $composableBuilder(
      column: $table.durationMs, builder: (column) => ColumnFilters(column));
}

class $$ChaptersTableOrderingComposer
    extends Composer<_$AppDatabase, $ChaptersTable> {
  $$ChaptersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get audiobookProvider => $composableBuilder(
      column: $table.audiobookProvider,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get audiobookItemId => $composableBuilder(
      column: $table.audiobookItemId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get chapterNumber => $composableBuilder(
      column: $table.chapterNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get positionMs => $composableBuilder(
      column: $table.positionMs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationMs => $composableBuilder(
      column: $table.durationMs, builder: (column) => ColumnOrderings(column));
}

class $$ChaptersTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChaptersTable> {
  $$ChaptersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get audiobookProvider => $composableBuilder(
      column: $table.audiobookProvider, builder: (column) => column);

  GeneratedColumn<String> get audiobookItemId => $composableBuilder(
      column: $table.audiobookItemId, builder: (column) => column);

  GeneratedColumn<int> get chapterNumber => $composableBuilder(
      column: $table.chapterNumber, builder: (column) => column);

  GeneratedColumn<int> get positionMs => $composableBuilder(
      column: $table.positionMs, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get durationMs => $composableBuilder(
      column: $table.durationMs, builder: (column) => column);
}

class $$ChaptersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChaptersTable,
    ChapterEntity,
    $$ChaptersTableFilterComposer,
    $$ChaptersTableOrderingComposer,
    $$ChaptersTableAnnotationComposer,
    $$ChaptersTableCreateCompanionBuilder,
    $$ChaptersTableUpdateCompanionBuilder,
    (
      ChapterEntity,
      BaseReferences<_$AppDatabase, $ChaptersTable, ChapterEntity>
    ),
    ChapterEntity,
    PrefetchHooks Function()> {
  $$ChaptersTableTableManager(_$AppDatabase db, $ChaptersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChaptersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChaptersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChaptersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> audiobookProvider = const Value.absent(),
            Value<String> audiobookItemId = const Value.absent(),
            Value<int> chapterNumber = const Value.absent(),
            Value<int> positionMs = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<int?> durationMs = const Value.absent(),
          }) =>
              ChaptersCompanion(
            id: id,
            audiobookProvider: audiobookProvider,
            audiobookItemId: audiobookItemId,
            chapterNumber: chapterNumber,
            positionMs: positionMs,
            title: title,
            durationMs: durationMs,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String audiobookProvider,
            required String audiobookItemId,
            required int chapterNumber,
            required int positionMs,
            required String title,
            Value<int?> durationMs = const Value.absent(),
          }) =>
              ChaptersCompanion.insert(
            id: id,
            audiobookProvider: audiobookProvider,
            audiobookItemId: audiobookItemId,
            chapterNumber: chapterNumber,
            positionMs: positionMs,
            title: title,
            durationMs: durationMs,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ChaptersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ChaptersTable,
    ChapterEntity,
    $$ChaptersTableFilterComposer,
    $$ChaptersTableOrderingComposer,
    $$ChaptersTableAnnotationComposer,
    $$ChaptersTableCreateCompanionBuilder,
    $$ChaptersTableUpdateCompanionBuilder,
    (
      ChapterEntity,
      BaseReferences<_$AppDatabase, $ChaptersTable, ChapterEntity>
    ),
    ChapterEntity,
    PrefetchHooks Function()>;
typedef $$ProviderMappingsTableCreateCompanionBuilder
    = ProviderMappingsCompanion Function({
  Value<int> id,
  required String ownerType,
  required String ownerProvider,
  required String ownerItemId,
  required String mappingItemId,
  required String providerDomain,
  required String providerInstance,
  Value<bool> available,
  Value<bool> inLibrary,
  Value<String?> audioFormatJson,
});
typedef $$ProviderMappingsTableUpdateCompanionBuilder
    = ProviderMappingsCompanion Function({
  Value<int> id,
  Value<String> ownerType,
  Value<String> ownerProvider,
  Value<String> ownerItemId,
  Value<String> mappingItemId,
  Value<String> providerDomain,
  Value<String> providerInstance,
  Value<bool> available,
  Value<bool> inLibrary,
  Value<String?> audioFormatJson,
});

class $$ProviderMappingsTableFilterComposer
    extends Composer<_$AppDatabase, $ProviderMappingsTable> {
  $$ProviderMappingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ownerType => $composableBuilder(
      column: $table.ownerType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ownerProvider => $composableBuilder(
      column: $table.ownerProvider, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ownerItemId => $composableBuilder(
      column: $table.ownerItemId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mappingItemId => $composableBuilder(
      column: $table.mappingItemId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get providerDomain => $composableBuilder(
      column: $table.providerDomain,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get providerInstance => $composableBuilder(
      column: $table.providerInstance,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get available => $composableBuilder(
      column: $table.available, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get inLibrary => $composableBuilder(
      column: $table.inLibrary, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get audioFormatJson => $composableBuilder(
      column: $table.audioFormatJson,
      builder: (column) => ColumnFilters(column));
}

class $$ProviderMappingsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProviderMappingsTable> {
  $$ProviderMappingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ownerType => $composableBuilder(
      column: $table.ownerType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ownerProvider => $composableBuilder(
      column: $table.ownerProvider,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ownerItemId => $composableBuilder(
      column: $table.ownerItemId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mappingItemId => $composableBuilder(
      column: $table.mappingItemId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get providerDomain => $composableBuilder(
      column: $table.providerDomain,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get providerInstance => $composableBuilder(
      column: $table.providerInstance,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get available => $composableBuilder(
      column: $table.available, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get inLibrary => $composableBuilder(
      column: $table.inLibrary, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get audioFormatJson => $composableBuilder(
      column: $table.audioFormatJson,
      builder: (column) => ColumnOrderings(column));
}

class $$ProviderMappingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProviderMappingsTable> {
  $$ProviderMappingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ownerType =>
      $composableBuilder(column: $table.ownerType, builder: (column) => column);

  GeneratedColumn<String> get ownerProvider => $composableBuilder(
      column: $table.ownerProvider, builder: (column) => column);

  GeneratedColumn<String> get ownerItemId => $composableBuilder(
      column: $table.ownerItemId, builder: (column) => column);

  GeneratedColumn<String> get mappingItemId => $composableBuilder(
      column: $table.mappingItemId, builder: (column) => column);

  GeneratedColumn<String> get providerDomain => $composableBuilder(
      column: $table.providerDomain, builder: (column) => column);

  GeneratedColumn<String> get providerInstance => $composableBuilder(
      column: $table.providerInstance, builder: (column) => column);

  GeneratedColumn<bool> get available =>
      $composableBuilder(column: $table.available, builder: (column) => column);

  GeneratedColumn<bool> get inLibrary =>
      $composableBuilder(column: $table.inLibrary, builder: (column) => column);

  GeneratedColumn<String> get audioFormatJson => $composableBuilder(
      column: $table.audioFormatJson, builder: (column) => column);
}

class $$ProviderMappingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProviderMappingsTable,
    ProviderMappingEntity,
    $$ProviderMappingsTableFilterComposer,
    $$ProviderMappingsTableOrderingComposer,
    $$ProviderMappingsTableAnnotationComposer,
    $$ProviderMappingsTableCreateCompanionBuilder,
    $$ProviderMappingsTableUpdateCompanionBuilder,
    (
      ProviderMappingEntity,
      BaseReferences<_$AppDatabase, $ProviderMappingsTable,
          ProviderMappingEntity>
    ),
    ProviderMappingEntity,
    PrefetchHooks Function()> {
  $$ProviderMappingsTableTableManager(
      _$AppDatabase db, $ProviderMappingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProviderMappingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProviderMappingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProviderMappingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> ownerType = const Value.absent(),
            Value<String> ownerProvider = const Value.absent(),
            Value<String> ownerItemId = const Value.absent(),
            Value<String> mappingItemId = const Value.absent(),
            Value<String> providerDomain = const Value.absent(),
            Value<String> providerInstance = const Value.absent(),
            Value<bool> available = const Value.absent(),
            Value<bool> inLibrary = const Value.absent(),
            Value<String?> audioFormatJson = const Value.absent(),
          }) =>
              ProviderMappingsCompanion(
            id: id,
            ownerType: ownerType,
            ownerProvider: ownerProvider,
            ownerItemId: ownerItemId,
            mappingItemId: mappingItemId,
            providerDomain: providerDomain,
            providerInstance: providerInstance,
            available: available,
            inLibrary: inLibrary,
            audioFormatJson: audioFormatJson,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String ownerType,
            required String ownerProvider,
            required String ownerItemId,
            required String mappingItemId,
            required String providerDomain,
            required String providerInstance,
            Value<bool> available = const Value.absent(),
            Value<bool> inLibrary = const Value.absent(),
            Value<String?> audioFormatJson = const Value.absent(),
          }) =>
              ProviderMappingsCompanion.insert(
            id: id,
            ownerType: ownerType,
            ownerProvider: ownerProvider,
            ownerItemId: ownerItemId,
            mappingItemId: mappingItemId,
            providerDomain: providerDomain,
            providerInstance: providerInstance,
            available: available,
            inLibrary: inLibrary,
            audioFormatJson: audioFormatJson,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ProviderMappingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProviderMappingsTable,
    ProviderMappingEntity,
    $$ProviderMappingsTableFilterComposer,
    $$ProviderMappingsTableOrderingComposer,
    $$ProviderMappingsTableAnnotationComposer,
    $$ProviderMappingsTableCreateCompanionBuilder,
    $$ProviderMappingsTableUpdateCompanionBuilder,
    (
      ProviderMappingEntity,
      BaseReferences<_$AppDatabase, $ProviderMappingsTable,
          ProviderMappingEntity>
    ),
    ProviderMappingEntity,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
  $$RecentlyPlayedTableTableManager get recentlyPlayed =>
      $$RecentlyPlayedTableTableManager(_db, _db.recentlyPlayed);
  $$LibraryCacheTableTableManager get libraryCache =>
      $$LibraryCacheTableTableManager(_db, _db.libraryCache);
  $$SyncMetadataTableTableManager get syncMetadata =>
      $$SyncMetadataTableTableManager(_db, _db.syncMetadata);
  $$PlaybackStateTableTableManager get playbackState =>
      $$PlaybackStateTableTableManager(_db, _db.playbackState);
  $$CachedPlayersTableTableManager get cachedPlayers =>
      $$CachedPlayersTableTableManager(_db, _db.cachedPlayers);
  $$CachedQueueTableTableManager get cachedQueue =>
      $$CachedQueueTableTableManager(_db, _db.cachedQueue);
  $$HomeRowCacheTableTableManager get homeRowCache =>
      $$HomeRowCacheTableTableManager(_db, _db.homeRowCache);
  $$SearchHistoryTableTableManager get searchHistory =>
      $$SearchHistoryTableTableManager(_db, _db.searchHistory);
  $$DetailTrackCacheTableTableManager get detailTrackCache =>
      $$DetailTrackCacheTableTableManager(_db, _db.detailTrackCache);
  $$ArtistsTableTableManager get artists =>
      $$ArtistsTableTableManager(_db, _db.artists);
  $$AlbumsTableTableManager get albums =>
      $$AlbumsTableTableManager(_db, _db.albums);
  $$TracksTableTableManager get tracks =>
      $$TracksTableTableManager(_db, _db.tracks);
  $$PlaylistsTableTableManager get playlists =>
      $$PlaylistsTableTableManager(_db, _db.playlists);
  $$PlaylistTracksTableTableManager get playlistTracks =>
      $$PlaylistTracksTableTableManager(_db, _db.playlistTracks);
  $$AudiobooksTableTableManager get audiobooks =>
      $$AudiobooksTableTableManager(_db, _db.audiobooks);
  $$ChaptersTableTableManager get chapters =>
      $$ChaptersTableTableManager(_db, _db.chapters);
  $$ProviderMappingsTableTableManager get providerMappings =>
      $$ProviderMappingsTableTableManager(_db, _db.providerMappings);
}
