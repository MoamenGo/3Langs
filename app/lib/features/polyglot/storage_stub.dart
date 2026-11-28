// Non-web platforms keep Polyglot Matrix data in the local database
// instead of localStorage (see storage.dart).

String? webStorageRead(String key) => null;

bool webStorageWrite(String key, String value) => false;
