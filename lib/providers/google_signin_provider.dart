import 'package:flutter/foundation.dart';
import 'package:live_frontend/env.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  return GoogleSignIn(
    scopes: ['email', 'profile'],
    clientId: defaultTargetPlatform == TargetPlatform.iOS &&
            Env.googleIosClientId.isNotEmpty
        ? Env.googleIosClientId
        : null,
  );
});
