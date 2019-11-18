package com.dawood.my_fatoorah

import android.app.Activity
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import com.google.gson.Gson
import com.myfatoorah.sdk.model.executepayment.MFExecutePaymentRequest
import com.myfatoorah.sdk.model.paymentstatus.MFGetPaymentStatusResponse
import com.myfatoorah.sdk.views.MFResult
import com.myfatoorah.sdk.views.MFSDK
import android.util.Log;
class PaymentActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_payment)
        val callBackUrl = intent.getStringExtra("callBackUrl")
        val errorUrl = intent.getStringExtra("errorUrl")
        val language = intent.getStringExtra("language")
        val invoiceAmount = intent.getDoubleExtra("invoiceAmount", 0.0)
        val paymentMethod = intent.getIntExtra("paymentMethod", 0)
        val back = Intent()
        try {
            val request = MFExecutePaymentRequest(paymentMethod, invoiceAmount, callBackUrl, errorUrl)
            MFSDK.executePayment(this, request, language
            ) { invoiceId: String, _result: MFResult<MFGetPaymentStatusResponse> ->
                when(_result){
                    is MFResult.Success -> {
                        val response = Gson().toJson((_result as MFResult.Success<MFGetPaymentStatusResponse>).response)
                        back.putExtra("data", response)
                        setResult(Activity.RESULT_OK, back)
                    }
                    is MFResult.Fail ->
                    {
                        val error = (_result as MFResult.Fail<*>).error
                        back.putExtra("error", "Failed")
                        back.putExtra("message", error.message)
                        setResult(Activity.RESULT_CANCELED, back)
                    }
                    else ->{
                        back.putExtra("error", "Failed")
                        back.putExtra("message", "Unknown")
                        setResult(Activity.RESULT_CANCELED, back)
                    }
                }
                finish()
            }
        } catch (e: Exception) {
            back.putExtra("error", "Exception")
            back.putExtra("message", e.message)
            setResult(Activity.RESULT_CANCELED, back)
            finish()
        }
    }
}
