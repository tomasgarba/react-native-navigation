package com.reactnativenavigation.react;

import android.content.Intent;
import android.view.View;

import com.facebook.react.ReactInstanceManager;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.modules.core.DefaultHardwareBackBtnHandler;
import com.reactnativenavigation.bridge.NavigationReactEventEmitter;
import com.reactnativenavigation.controllers.NavigationActivity;

public interface ReactGateway {

    void startReactContextOnceInBackgroundAndExecuteJS();

    boolean isInitialized();

    ReactContext getReactContext();

    NavigationReactEventEmitter getReactEventEmitter();

    ReactInstanceManager getReactInstanceManager();

    void onActivityCreated(NavigationActivity activity);

    void onActivityResumed(NavigationActivity activity, DefaultHardwareBackBtnHandler defaultHardwareBackBtnHandler);

    void onActivityPaused(NavigationActivity activity);

    void onActivityDestroyed(NavigationActivity activity);

    void onBackPressed();

    void onActivityResult(int requestCode, int resultCode, Intent data);

    boolean hasStartedCreatingContext();

    void onNewIntent(Intent intent);

    boolean onKeyUp(View currentFocus, int keyCode);
}
