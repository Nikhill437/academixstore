// COMMENTED FOR STATIC APP - All Appwrite API integrations disabled
// import 'package:appwrite/appwrite.dart';
// import 'package:appwrite/models.dart' as models;

class AppwriteService {
  static final AppwriteService instance = AppwriteService._internal();

  // late Client client;
  // late Account account;
  // late Databases databases;
  // late Storage storage;

  AppwriteService._internal() {
    // COMMENTED FOR STATIC APP
    // client = Client()
    //     .setEndpoint('https://cloud.appwrite.io/v1')
    //     .setProject('67cf1ba2002bd1f33523'); // Replace with your Project ID

    // account = Account(client);
    // databases = Databases(client);
    // storage = Storage(client);
  }

  // COMMENTED FOR STATIC APP
  // Databases getDatabaseReference() => databases;
  // Storage getStorageReference() => storage;

  // COMMENTED FOR STATIC APP
  // Future<models.Session?> onLogin({
  //   required String email,
  //   required String password,
  // }) async {
  //   try {
  //     return await account.createEmailPasswordSession(
  //       email: email,
  //       password: password,
  //     );
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // COMMENTED FOR STATIC APP
  // Future<models.User?> onRegister({
  //   required String email,
  //   required String password,
  //   String? name,
  // }) async {
  //   try {
  //     return await account.create(
  //       userId: ID.unique(),
  //       email: email,
  //       password: password,
  //       name: name ?? '',
  //     );
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // COMMENTED FOR STATIC APP
  // Future<void> onLogout() async {
  //   try {
  //     await account.deleteSession(sessionId: 'current');
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // COMMENTED FOR STATIC APP
  // Future<bool> isUserLoggedIn() async {
  //   try {
  //     await account.get();
  //     return true;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  // STATIC APP - Return mock email
  Future<String?> getUserEmail() async {
    // COMMENTED FOR STATIC APP
    // try {
    //   final user = await account.get();
    //   return user.email;
    // } catch (e) {
    //   return null;
    // }
    return 'demo@academixstore.com';
  }

  // STATIC APP - Return mock user ID
  Future<String?> getUserId() async {
    // COMMENTED FOR STATIC APP
    // try {
    //   final user = await account.get();
    //   return user.$id;
    // } catch (e) {
    //   return null;
    // }
    return 'demo-user-123';
  }

  // COMMENTED FOR STATIC APP
  // Future<void> requestPasswordReset({
  //   required String email,
  //   required String resetUrl,
  // }) async {
  //   try {
  //     await account.createRecovery(email: email, url: resetUrl);
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
}
