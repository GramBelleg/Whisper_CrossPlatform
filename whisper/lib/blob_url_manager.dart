class BlobUrlManager {
  // Global static map for storing blob names and URLs
  static final Map<String, String> _blobUrlCache = {};

  /// Checks if a blob URL exists in the cache
  static bool isExist(String blobName) {
    return _blobUrlCache.containsKey(blobName);
  }

  /// Adds a blob name and URL to the cache
  static void addBlobUrl(String blobName, String url) {
    _blobUrlCache[blobName] = url;
  }

  /// Retrieves the URL for a given blob name if it exists
  static String? getBlobUrl(String blobName) {
    return _blobUrlCache[blobName];
  }
}
