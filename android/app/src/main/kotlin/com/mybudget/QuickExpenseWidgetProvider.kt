package com.mybudget

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.os.Build
import android.view.View
import android.widget.RemoteViews
import org.json.JSONException
import org.json.JSONObject

/**
 * The Quick Expense home screen widget.
 *
 * A widget cannot host a text field, so it collects the part it can — which
 * category — and hands the amount over to a focused sheet in the app. Tapping
 * a category opens that sheet with the category already chosen; tapping Add
 * opens it with the most used one.
 *
 * Everything it draws is written by the app as JSON, already translated and
 * formatted, because RemoteViews has no access to the app's localizations.
 */
class QuickExpenseWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        val views = buildViews(context)
        appWidgetIds.forEach { appWidgetManager.updateAppWidget(it, views) }
    }

    companion object {
        const val PREFS_NAME = "quick_expense_widget"
        const val KEY_SNAPSHOT = "snapshot"
        const val EXTRA_CATEGORY_ID = "quick_expense_category_id"

        private val CHIP_IDS = intArrayOf(
            R.id.quick_expense_chip_0,
            R.id.quick_expense_chip_1,
            R.id.quick_expense_chip_2,
            R.id.quick_expense_chip_3
        )
        private val CHIP_DOT_IDS = intArrayOf(
            R.id.quick_expense_chip_dot_0,
            R.id.quick_expense_chip_dot_1,
            R.id.quick_expense_chip_dot_2,
            R.id.quick_expense_chip_dot_3
        )
        private val CHIP_LABEL_IDS = intArrayOf(
            R.id.quick_expense_chip_label_0,
            R.id.quick_expense_chip_label_1,
            R.id.quick_expense_chip_label_2,
            R.id.quick_expense_chip_label_3
        )
        private val ROW_IDS = intArrayOf(
            R.id.quick_expense_row_0,
            R.id.quick_expense_row_1
        )

        /** Redraws every placed instance. Called after the app saves a snapshot. */
        fun refresh(context: Context) {
            val manager = AppWidgetManager.getInstance(context) ?: return
            val ids = manager.getAppWidgetIds(
                ComponentName(context, QuickExpenseWidgetProvider::class.java)
            )
            if (ids.isEmpty()) return
            val views = buildViews(context)
            ids.forEach { manager.updateAppWidget(it, views) }
        }

        fun saveSnapshot(context: Context, payload: String) {
            context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
                .edit()
                .putString(KEY_SNAPSHOT, payload)
                .apply()
        }

        private fun buildViews(context: Context): RemoteViews {
            val views = RemoteViews(context.packageName, R.layout.quick_expense_widget)
            val snapshot = readSnapshot(context)

            snapshot?.optString("title")?.takeIf { it.isNotEmpty() }?.let {
                views.setTextViewText(R.id.quick_expense_title, it)
            }
            views.setTextViewText(
                R.id.quick_expense_month,
                snapshot?.optString("monthLabel").orEmpty()
            )
            views.setTextViewText(
                R.id.quick_expense_total,
                snapshot?.optString("total")?.takeIf { it.isNotEmpty() }
                    ?: context.getString(R.string.quick_expense_empty_total)
            )
            snapshot?.optString("addLabel")?.takeIf { it.isNotEmpty() }?.let {
                views.setTextViewText(R.id.quick_expense_add, it)
            }

            val categories = snapshot?.optJSONArray("categories")
            var shown = 0
            for (slot in CHIP_IDS.indices) {
                val category = categories?.optJSONObject(slot)
                if (category == null) {
                    views.setViewVisibility(CHIP_IDS[slot], View.INVISIBLE)
                    continue
                }
                shown++
                views.setViewVisibility(CHIP_IDS[slot], View.VISIBLE)
                views.setTextViewText(
                    CHIP_LABEL_IDS[slot],
                    category.optString("name")
                )
                views.setInt(
                    CHIP_DOT_IDS[slot],
                    "setColorFilter",
                    parseColor(category.optString("color"))
                )
                views.setOnClickPendingIntent(
                    CHIP_IDS[slot],
                    quickAddIntent(
                        context,
                        requestCode = slot + 1,
                        categoryId = category.optString("id").takeIf { it.isNotEmpty() }
                    )
                )
            }

            // Drop the second row entirely when there is nothing to put in it,
            // so a small widget is not padded with blank space.
            views.setViewVisibility(
                ROW_IDS[1],
                if (shown > 2) View.VISIBLE else View.GONE
            )
            views.setViewVisibility(
                ROW_IDS[0],
                if (shown > 0) View.VISIBLE else View.GONE
            )

            views.setOnClickPendingIntent(
                R.id.quick_expense_add,
                quickAddIntent(context, requestCode = 0, categoryId = null)
            )
            return views
        }

        private fun readSnapshot(context: Context): JSONObject? {
            val raw = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
                .getString(KEY_SNAPSHOT, null) ?: return null
            return try {
                JSONObject(raw)
            } catch (error: JSONException) {
                // A malformed snapshot must not crash the launcher; the widget
                // simply falls back to its placeholder labels.
                null
            }
        }

        private fun parseColor(value: String?): Int = try {
            if (value.isNullOrEmpty()) Color.GRAY else Color.parseColor(value)
        } catch (error: IllegalArgumentException) {
            Color.GRAY
        }

        /**
         * Distinct request codes matter: PendingIntent equality ignores extras,
         * so without them every chip would reuse the first one's category.
         */
        private fun quickAddIntent(
            context: Context,
            requestCode: Int,
            categoryId: String?
        ): PendingIntent {
            // QuickAddActivity, never MainActivity: a widget tap must not
            // land the user on the app's home screen. CLEAR_TASK means a
            // second tap replaces the first rather than stacking, so the
            // category the user just pressed is always the one that opens.
            val intent = Intent(context, QuickAddActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                    Intent.FLAG_ACTIVITY_CLEAR_TASK
                if (categoryId != null) putExtra(EXTRA_CATEGORY_ID, categoryId)
            }
            var flags = PendingIntent.FLAG_UPDATE_CURRENT
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                flags = flags or PendingIntent.FLAG_IMMUTABLE
            }
            return PendingIntent.getActivity(context, requestCode, intent, flags)
        }
    }
}
