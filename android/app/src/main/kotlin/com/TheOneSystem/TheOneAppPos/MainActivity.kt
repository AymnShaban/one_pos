package com.TheOneSystem.TheOneAppPos

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel

/**
 * Bridges the Zebra DataWedge hardware scanner into Flutter via an
 * [EventChannel]. The Flutter side (barren `home_screen.dart`) listens on
 * [SCANNER_CHANNEL] and the Dart subscription lifecycle controls receiver
 * registration through [onListen] / [onCancel].
 *
 * The DataWedge profile on the device must be configured to:
 *   - Target this app's package (`com.example.one_pos`)
 *   - Output → Intent → action `com.example.one_pos.SCAN`
 *   - Delivery: send via broadcast
 *
 * Pattern adapted from the old `mujezat` build's MainActivity: hold the
 * [EventChannel.EventSink] at class level so it can be hit from
 * [BroadcastReceiver.onReceive] safely, and dispatch onto the UI thread
 * before calling `success` (event-sink methods are only safe on the
 * platform main thread).
 *
 * The camera-based scanner used by `mobile_scanner` does not touch this
 * code path; it goes through the plugin and the CAMERA permission in
 * `AndroidManifest.xml`.
 */
class MainActivity : FlutterActivity() {

    companion object {
        private const val SCANNER_CHANNEL = "com.example.one_pos/scanner"
        private const val SCAN_ACTION = "com.example.one_pos.SCAN"
        // DataWedge intent extra carrying the decoded barcode string.
        private const val BARCODE_KEY = "com.symbol.datawedge.data_string"
    }

    private var eventSink: EventChannel.EventSink? = null
    private var scanReceiver: BroadcastReceiver? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, SCANNER_CHANNEL)
            .setStreamHandler(object : EventChannel.StreamHandler {

                override fun onListen(arguments: Any?, sink: EventChannel.EventSink?) {
                    eventSink = sink
                    registerScanReceiver()
                }

                override fun onCancel(arguments: Any?) {
                    eventSink = null
                    unregisterScanReceiver()
                }
            })
    }

    private fun registerScanReceiver() {
        scanReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                val barcode = intent?.getStringExtra(BARCODE_KEY)
                if (!barcode.isNullOrEmpty()) {
                    // EventSink methods are only safe on the platform main
                    // thread; broadcasts may not arrive there.
                    runOnUiThread {
                        eventSink?.success(barcode)
                    }
                }
            }
        }

        val filter = IntentFilter(SCAN_ACTION)

        // Android 13+ requires the flag when registering for external
        // broadcasts (DataWedge is another app's process).
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            registerReceiver(scanReceiver, filter, Context.RECEIVER_EXPORTED)
        } else {
            @Suppress("UnspecifiedRegisterReceiverFlag")
            registerReceiver(scanReceiver, filter)
        }
    }

    private fun unregisterScanReceiver() {
        try {
            scanReceiver?.let { unregisterReceiver(it) }
        } catch (_: Exception) {
            // Already unregistered (e.g. quick orientation change).
        }
        scanReceiver = null
    }

    override fun onDestroy() {
        unregisterScanReceiver()
        super.onDestroy()
    }
}
