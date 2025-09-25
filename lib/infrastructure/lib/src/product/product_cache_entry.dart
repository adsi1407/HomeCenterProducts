class CacheEntry<T> {
  final T value;
  final DateTime insertedAt;
  final Duration timeToLive;

  CacheEntry(this.value, this.insertedAt, this.timeToLive);

  bool get isExpired => DateTime.now().difference(insertedAt) > timeToLive;
}