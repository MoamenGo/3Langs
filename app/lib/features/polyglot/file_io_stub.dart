// Android and tests: no browser file download or picker; the export and
// import dialogs fall back to copy and paste.

bool downloadText(String fileName, String text) => false;

Future<String?> pickTextFile() async => null;

const canUseFiles = false;
