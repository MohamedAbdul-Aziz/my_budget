package com.mohamed.mybudget

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine

/**
 * A FragmentActivity rather than a plain one: the app lock (local_auth) shows
 * the system's fingerprint, face or screen-lock prompt as a fragment.
 */
class MainActivity : FlutterFragmentActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        QuickExpenseChannel.register(this, flutterEngine)
    }
}
