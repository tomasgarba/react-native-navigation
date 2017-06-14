package com.reactnativenavigation.react;

import android.app.Activity;
import android.content.Intent;
import android.view.View;

import com.facebook.react.ReactInstanceManager;
import com.facebook.react.ReactNativeHost;
import com.facebook.react.ReactPackage;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.modules.core.DefaultHardwareBackBtnHandler;
import com.facebook.react.shell.MainReactPackage;
import com.reactnativenavigation.NavigationApplication;
import com.reactnativenavigation.bridge.NavigationReactEventEmitter;
import com.reactnativenavigation.bridge.NavigationReactPackage;
import com.reactnativenavigation.controllers.NavigationActivity;
import com.reactnativenavigation.events.EventBus;
import com.reactnativenavigation.events.JsBundleLoadedEvent;
import com.reactnativenavigation.events.JsDevReloadEvent;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Nullable;

public class NavigationReactGateway implements ReactGateway {

    private final ReactNativeHost host;
    private NavigationReactEventEmitter reactEventEmitter;
    private JsDevReloadHandler jsDevReloadHandler;
    private final NavigationReactInitializer initializer;

    public NavigationReactGateway() {
        host = new ReactNativeHostImpl();
        jsDevReloadHandler = new JsDevReloadHandler();
        initializer = new NavigationReactInitializer(host.getReactInstanceManager());
    }

    @Override
    public void startReactContextOnceInBackgroundAndExecuteJS() {
        getReactInstanceManager().createReactContextInBackground();
    }

    public boolean isInitialized() {
        return host.hasInstance() && getReactInstanceManager().getCurrentReactContext() != null;
    }

    @Override
    public boolean hasStartedCreatingContext() {
        return getReactInstanceManager().hasStartedCreatingInitialContext();
    }

    public ReactContext getReactContext() {
        return getReactInstanceManager().getCurrentReactContext();
    }

    public NavigationReactEventEmitter getReactEventEmitter() {
        return reactEventEmitter;
    }

    @Override
    public ReactInstanceManager getReactInstanceManager() {
        return host.getReactInstanceManager();
    }

    public void onBackPressed() {
        getReactInstanceManager().onBackPressed();
    }

    public void onNewIntent(Intent intent) {
        getReactInstanceManager().onNewIntent(intent);
    }

    @Override
    public boolean onKeyUp(View currentFocus, int keyCode) {
        return jsDevReloadHandler.onKeyUp(currentFocus, keyCode);
    }

    @Override
    public void onActivityCreated(NavigationActivity activity) {
        initializer.onActivityCreated(activity);
    }

    @Override
    public void onActivityResumed(NavigationActivity activity, DefaultHardwareBackBtnHandler defaultHardwareBackBtnHandler) {
        initializer.onActivityResumed(activity);
        jsDevReloadHandler.onResumeActivity();
    }

    @Override
    public void onActivityPaused(NavigationActivity activity) {
        initializer.onActivityPaused(activity);
        jsDevReloadHandler.onPauseActivity();
    }

    @Override
    public void onActivityDestroyed(NavigationActivity activity) {
        initializer.onActivityDestroyed(activity);
    }

    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        Activity currentActivity = getReactInstanceManager().getCurrentReactContext().getCurrentActivity();
        getReactInstanceManager().onActivityResult(currentActivity, requestCode, resultCode, data);
    }

    public ReactNativeHost getReactNativeHost() {
        return host;
    }

    void onReactContextInitialized() {
        if (reactEventEmitter == null) {
            reactEventEmitter = new NavigationReactEventEmitter(getReactContext());
        }
    }

    private static class ReactNativeHostImpl extends ReactNativeHost implements ReactInstanceManager.ReactInstanceEventListener {

        ReactNativeHostImpl() {
            super(NavigationApplication.instance);
        }

        @Override
        public boolean getUseDeveloperSupport() {
            return NavigationApplication.instance.isDebug();
        }

        @Override
        protected List<ReactPackage> getPackages() {
            List<ReactPackage> list = new ArrayList<>();
            list.add(new MainReactPackage());
            list.add(new NavigationReactPackage());
            addAdditionalReactPackagesIfNeeded(list);
            return list;
        }

        private void addAdditionalReactPackagesIfNeeded(List<ReactPackage> list) {
            List<ReactPackage> additionalReactPackages = NavigationApplication.instance.createAdditionalReactPackages();
            if (additionalReactPackages == null) {
                return;
            }

            for (ReactPackage reactPackage : additionalReactPackages) {
                if (reactPackage instanceof MainReactPackage)
                    throw new RuntimeException("Do not create a new MainReactPackage. This is created for you.");
                if (reactPackage instanceof NavigationReactPackage)
                    throw new RuntimeException("Do not create a new NavigationReactPackage. This is created for you.");
            }

            list.addAll(additionalReactPackages);
        }

        @Override
        protected ReactInstanceManager createReactInstanceManager() {
            ReactInstanceManager manager = super.createReactInstanceManager();
            if (NavigationApplication.instance.isDebug()) {
                replaceJsDevReloadListener(manager);
            }
            manager.addReactInstanceEventListener(this);
            return manager;
        }

        private void replaceJsDevReloadListener(ReactInstanceManager manager) {
            new JsDevReloadListenerReplacer(manager, new JsDevReloadListenerReplacer.Listener() {
                @Override
                public void onJsDevReload() {
                    EventBus.instance.post(new JsDevReloadEvent());
                }

                @Override
                public void onJSBundleLoadedFromServer() {
                    EventBus.instance.post(new JsBundleLoadedEvent());
                }
            }).replace();
        }

        @Override
        public void onReactContextInitialized(ReactContext context) {
            ((NavigationReactGateway) NavigationApplication.instance.getReactGateway()).onReactContextInitialized();
            NavigationApplication.instance.onReactInitialized(context);
        }

        @Override
        public void clear() {
            getReactInstanceManager().removeReactInstanceEventListener(this);
            super.clear();
        }

        @Override
        protected String getJSMainModuleName() {
            String jsMainModuleName = NavigationApplication.instance.getJSMainModuleName();
            if (jsMainModuleName != null)
                return jsMainModuleName;
            return super.getJSMainModuleName();
        }

        @Nullable
        @Override
        protected String getJSBundleFile() {
            String jsBundleFile = NavigationApplication.instance.getJSBundleFile();
            if (jsBundleFile != null)
                return jsBundleFile;
            return super.getJSBundleFile();
        }

        @Nullable
        @Override
        protected String getBundleAssetName() {
            String bundleAssetName = NavigationApplication.instance.getBundleAssetName();
            if (bundleAssetName != null)
                return bundleAssetName;
            return super.getBundleAssetName();
        }
    }
}
