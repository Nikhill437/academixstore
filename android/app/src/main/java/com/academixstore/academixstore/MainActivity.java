package com.divyansh.academixstore;

import android.os.Bundle;
import android.view.WindowManager;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import androidx.annotation.NonNull;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.academixstore.app/security";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
            .setMethodCallHandler((call, result) -> {
                switch (call.method) {
                    case "enableSecureMode":
                        enableSecureMode();
                        result.success(true);
                        break;
                    case "disableSecureMode":
                        disableSecureMode();
                        result.success(true);
                        break;
                    default:
                        result.notImplemented();
                        break;
                }
            });
    }

    private void enableSecureMode() {
        // Prevent screenshots and screen recording
        getWindow().setFlags(
            WindowManager.LayoutParams.FLAG_SECURE,
            WindowManager.LayoutParams.FLAG_SECURE
        );
    }

    private void disableSecureMode() {
        // Allow screenshots and screen recording again
        getWindow().clearFlags(WindowManager.LayoutParams.FLAG_SECURE);
    }
}