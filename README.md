<h1><img src="https://github.com/radyslavkrechet/PDPBuyMe/blob/master/BuyMe/Resources/Assets/Assets.xcassets/AppIcon.appiconset/Untitled.png" width="23" height="23">BuyMe</h1>

<p float="left">
  <img src="/Screenshots/4.PNG" width="200px" />
  <img src="/Screenshots/2.PNG" width="200px" />
  <img src="/Screenshots/3.PNG" width="200px" />
  <img src="/Screenshots/5.PNG" width="200px" />
</p>

### Code examples for the In-App Purchase features: ###

* Consumable
* Auto-renewable subscription
* Subscription groups

### Setup the application before run: ###

* Create an app in App Store Connect
* Create consumable purchasewith with id ```[Bundle Identifier].realmoney```
* Create auto-renewable subscriptions with id ```[Bundle Identifier].subscription.forecast.weekly```, ```[Bundle Identifier].forecast.monthly```, ```[Bundle Identifier].forecastnews.weekly``` and ```[Bundle Identifier].forecastnews.monthly```
* Create group with name ```Subscription``` with separated  ```forecastnews``` and ```forecast``` subscriptions
* Replace ```sharedSecret``` in the file ```BuyMe/Source/Common/Managers/StoreManager.swift``` with yours
