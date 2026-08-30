package com.example.my_budget

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private var channel: MethodChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        channel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            QUICK_EXPENSE_CHANNEL
        ).apply {
            setMethodCallHandler { call, result ->
                when (call.method) {
                    "publish" -> {
                        val payload = call.arguments as? String
                        if (payload == null) {
                            result.error(
                                "invalid_payload",
                                "Expected the snapshot as a JSON string.",
                                null
                            )
                        } else {
                            QuickExpenseWidgetProvider.saveSnapshot(
                                applicationContext,
                                payload
                            )
                            QuickExpenseWidgetProvider.refresh(applicationContext)
                            result.success(null)
                        }
                    }
                    // The cold-start path: Dart pulls the launch intent once it
                    // is ready, because the engine cannot receive a push yet.
                    "consumeLaunchRequest" -> result.success(consumeLaunchRequest())
                    else -> result.notImplemented()
                }
            }
        }
    }

    /** The app was already running when the widget was tapped. */
    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        val request = consumeLaunchRequest() ?: return
        channel?.invokeMethod("openQuickAdd", request)
    }

    /**
     * Returns the widget's request when this launch came from it, otherwise
     * null. The extras are cleared so returning to the app later — from the
     * recents list, say — does not reopen the sheet.
     */
    private fun consumeLaunchRequest(): Map<String, Any?>? {
        val current = intent ?: return null
        if (!current.getBooleanExtra(
                QuickExpenseWidgetProvider.EXTRA_FROM_WIDGET,
                false
            )
        ) {
            return null
        }

        val categoryId =
            current.getStringExtra(QuickExpenseWidgetProvider.EXTRA_CATEGORY_ID)
        current.removeExtra(QuickExpenseWidgetProvider.EXTRA_FROM_WIDGET)
        current.removeExtra(QuickExpenseWidgetProvider.EXTRA_CATEGORY_ID)
        return mapOf("categoryId" to categoryId)
    }

    private companion object {
        const val QUICK_EXPENSE_CHANNEL = "com.example.my_budget/quick_expense"
    }
}
