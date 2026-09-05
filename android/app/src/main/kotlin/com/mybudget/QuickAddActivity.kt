package com.mybudget

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterActivityLaunchConfigs.BackgroundMode
import io.flutter.embedding.engine.FlutterEngine

/**
 * The widget's own entry point.
 *
 * Tapping a category must not drop the user on the app's home screen, so this
 * activity boots Flutter straight onto the quick-add route and shows nothing
 * else. It runs in its own task with a transparent window, so it reads as a
 * dialog over the launcher and finishing returns the user right back there.
 *
 * It still runs the app's own Dart code, which keeps the local database the
 * single source of truth — no expense is ever written from Kotlin.
 */
class QuickAddActivity : FlutterActivity() {

    /** Carries the tapped category into Dart as the engine's initial route. */
    override fun getInitialRoute(): String {
        val categoryId =
            intent?.getStringExtra(QuickExpenseWidgetProvider.EXTRA_CATEGORY_ID)
        return if (categoryId.isNullOrEmpty()) ROUTE else "$ROUTE?category=$categoryId"
    }

    /** Lets the Flutter UI draw its own scrim and card over the home screen. */
    override fun getBackgroundMode(): BackgroundMode = BackgroundMode.transparent

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        QuickExpenseChannel.register(this, flutterEngine)
    }

    companion object {
        const val ROUTE = "/quick-add"
    }
}
