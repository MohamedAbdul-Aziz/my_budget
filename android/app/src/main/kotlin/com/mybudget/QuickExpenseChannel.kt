package com.mybudget

import android.content.Context
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/**
 * The single channel the app uses to hand the widget its contents.
 *
 * Both entry points register it: the main app republishes whenever the data
 * changes, and the quick-add activity republishes right after it saves.
 */
object QuickExpenseChannel {

    const val NAME = "com.mybudget/quick_expense"

    fun register(context: Context, engine: FlutterEngine): MethodChannel {
        val appContext = context.applicationContext
        return MethodChannel(engine.dartExecutor.binaryMessenger, NAME).apply {
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
                            QuickExpenseWidgetProvider.saveSnapshot(appContext, payload)
                            QuickExpenseWidgetProvider.refresh(appContext)
                            result.success(null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
        }
    }
}
