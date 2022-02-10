extends Node2D

#
# This script is written as simple as possible. It is recommended to use 
# dialoges to show user how the purchase went. 
#
onready var resPopup: Popup = $Control/ResPop
onready var resLbl: Label = $Control/ResPop/ResPanel/ResVB/ResLbl

var myketBilling: JNISingleton = null
const SKU_PREMIUM = "myket_premium"


func _ready() -> void:
	if Engine.has_singleton("MyketInAppBilling"):
		myketBilling = Engine.get_singleton("MyketInAppBilling")
		myketBilling.setApplicationKey("MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCzbeVHUFVG95hRITKLveXxSnE5btwQC35DtIZtg39ix2yyQQ+m6U2aLmn8CZu2oYzuRgU0GL33dscX/VpWI4f/wm3c5Zb7kxmRXEZY8K8DIA1gtmLDA42cq7tHm/6uQdDSNfvK2SHN5j10SIwmxP3F/vlyPesc+hmnD9zpHMoXNwIDAQAB")
		myketBilling.connect("connected", self, "_on_MyketConnected")
		myketBilling.connect("query_sku_details_finished", self,
				"_on_MyketQuerySkuFinished")
		myketBilling.connect("purchase_finished", self,
				"_on_MyketPurchaseFinished")
	else:
		print("No MyketInAppBilling plugin.")
	
	return
	




func _on_Button_pressed() -> void:
	if myketBilling == null:
		resLbl.text = "InAppBilling plugin is not available for this device."
		resPopup.show()
		return
	
	myketBilling.startConnection()
	
	return
	


func _on_MyketConnected(successful: bool, resMsg: String) -> void:
	print("Connected: ", str(successful))
	
	if successful:
		myketBilling.querySkuDetails()
	else:
		# In this case the connection to Myket was not successful, fot better
		# experience you should show a dialog indicating that there was an error
		# in connection. This error can happen for either no internet connection
		# or if Myket is not installed.
		resLbl.text = resMsg
		resPopup.show()
		pass
	
	return
	


func _on_MyketQuerySkuFinished(results: Array) -> void:
	for res in results:
		print(res)
	
	if not results.has(SKU_PREMIUM):
		print(myketBilling.purchase(SKU_PREMIUM))
	else:
		_setGamePremium()
		pass
	
	return
	


func _on_MyketPurchaseFinished(result: Dictionary) -> void:
	print("Purchase Finished: ", result)
	
	# Use dialoges here to show if the purchase was not successful.
	
	return
	


func _setGamePremium() -> void:
	# Show premium contents.
	#
	# For better user experience it is recommended to show a dialog or an 
	# android Toast saying that the premium content have been made accessible.
	
	print("Game is premium now.")
	return
	
