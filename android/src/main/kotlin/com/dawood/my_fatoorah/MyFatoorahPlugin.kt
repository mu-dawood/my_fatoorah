package com.dawood.my_fatoorah

import android.app.Activity
import android.content.Intent
import android.graphics.Color
import com.google.gson.Gson
import com.myfatoorah.sdk.model.initiatepayment.MFInitiatePaymentRequest
import com.myfatoorah.sdk.model.initiatepayment.MFInitiatePaymentResponse
import com.myfatoorah.sdk.views.MFResult
import com.myfatoorah.sdk.views.MFSDK
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.PluginRegistry.Registrar
import io.flutter.plugin.common.PluginRegistry
import    android.util.Log;

class MyFatoorahPlugin : MethodCallHandler, PluginRegistry.ActivityResultListener {


    private var activity: Activity? = null
    private var pendingResult: Result? = null

    constructor(registrar: Registrar) {
        this.activity = registrar.activity()
        registrar.addActivityResultListener(this)
    }

    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "my_fatoorah")
            channel.setMethodCallHandler(MyFatoorahPlugin(registrar))

        }
    }

    private fun config(call: MethodCall, result: Result) {
        try {
            val arguments = call.arguments as Map<String, Any>
            val baseUrl = arguments["baseUrl"] as String?
            val token = arguments["token"] as String?
            val title = arguments["title"] as String?
            val toolBarTitleColor = arguments["toolBarTitleColor"] as String?
            val toolBarBackgroundColor = arguments["toolBarBackgroundColor"] as String?
            MFSDK.init(baseUrl!!, token!!)
            MFSDK.setUpActionBar(title, Color.parseColor(toolBarTitleColor), Color.parseColor(toolBarBackgroundColor), true)
            result.success("Initialized")
        } catch (e: Exception) {
            result.error("Exception", e.message, null)
        }

    }

    private fun initiatePayment(call: MethodCall, result: Result) {
        try {
            val arguments = call.arguments as Map<String, Any>
            val currencyIso = arguments["currencyIso"] as String
            val language = arguments["language"] as String
            val invoiceAmount = arguments["invoiceAmount"] as Double
            val request = MFInitiatePaymentRequest(invoiceAmount, currencyIso)
            MFSDK.initiatePayment(request, language!!) { _result: MFResult<MFInitiatePaymentResponse> ->
                if (pendingResult == null) {
                    when (_result) {
                        is MFResult.Success -> {
                            val response = Gson().toJson((_result as MFResult.Success<MFInitiatePaymentResponse>).response)
                            result.success(response)
                        }
                        is MFResult.Fail -> {
                            val error = (_result as MFResult.Fail<*>).error
                            val response = Gson().toJson(error)

                            result.error("Failed", error.message, response)
                        
                        }
                        else ->
                            result.error("Exception", "Unknown error", null)
                    }
                }
            }
        } catch (e: Exception) {
            result.error("Exception", e.message, null)
        }

    }




    override fun onMethodCall(call: MethodCall, result: Result) {
        Log.v("Method", call.method);
        if (call.method.equals("config")) {
            config(call, result)
        } else if (call.method.equals("initiatePayment")) {
            initiatePayment(call, result)
        } else if (call.method.equals("executePayment")) {
            val intent = Intent(activity, PaymentActivity::class.java)
            val arguments = call.arguments as Map<String, Any>
            val callBackUrl = arguments["callBackUrl"] as String?
            val errorUrl = arguments["errorUrl"] as String?
            val language = arguments["language"] as String?
            val invoiceAmount = arguments["invoiceAmount"] as Double
            val paymentMethod = arguments["paymentMethod"] as Int
            intent.putExtra("callBackUrl", callBackUrl)
            intent.putExtra("errorUrl", errorUrl)
            intent.putExtra("language", language)
            intent.putExtra("invoiceAmount", invoiceAmount)
            intent.putExtra("paymentMethod", paymentMethod)
            pendingResult = result
            activity!!.startActivityForResult(intent, 45645)
        } else {
            result.notImplemented()
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, intent: Intent?): Boolean {

        if (requestCode == 45645) {
            if (resultCode == Activity.RESULT_OK) {
                val response = intent?.getStringExtra("data")
                pendingResult?.success(response)
            } else {
                val message = intent?.getStringExtra("message")
                val error = intent?.getStringExtra("error")
                pendingResult?.error(error, message, null)
            }
            pendingResult = null
            return true
        }
        return false
    }


}
