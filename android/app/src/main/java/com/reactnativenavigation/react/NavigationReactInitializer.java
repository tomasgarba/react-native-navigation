package com.reactnativenavigation.react;

import android.text.TextUtils;

import com.facebook.react.ReactInstanceManager;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.devsupport.interfaces.PackagerStatusCallback;
import com.reactnativenavigation.NavigationApplication;
import com.reactnativenavigation.controllers.NavigationActivity;
import com.reactnativenavigation.views.Toaster;

class NavigationReactInitializer implements ReactInstanceManager.ReactInstanceEventListener {

    private ReactInstanceManager reactInstanceManager;
    private boolean waitingForAppLaunchEvent = true;
    private final boolean isDebug;

    NavigationReactInitializer(ReactInstanceManager reactInstanceManager) {
        this.reactInstanceManager = reactInstanceManager;
        this.isDebug = reactInstanceManager.getDevSupportManager().getDevSupportEnabled();
    }

    @Override
    public void onReactContextInitialized(ReactContext context) {
        ((NavigationReactGateway) NavigationApplication.instance.getReactGateway()).onReactContextInitialized(context);
        emitAppLaunched();
    }

    void onActivityCreated(NavigationActivity activity) {
        waitingForAppLaunchEvent = true;
    }

    void onActivityResumed(NavigationActivity activity) {
        if (ReactDevPermission.shouldAskPermission()) {
            ReactDevPermission.askPermission(activity);
        } else {
            reactInstanceManager.onHostResume(activity, activity);
            reactInstanceManager.addReactInstanceEventListener(this);
            checkBundleThenPrepareReact(activity);
        }
    }

    void onActivityPaused(NavigationActivity activity) {
        if (reactInstanceManager.hasStartedCreatingInitialContext()) {
            reactInstanceManager.onHostPause(activity);
        }
    }

    void onActivityDestroyed(NavigationActivity activity) {
        reactInstanceManager.removeReactInstanceEventListener(this);
        if (reactInstanceManager.hasStartedCreatingInitialContext()) {
            reactInstanceManager.onHostDestroy(activity);
        }
    }

    private void checkBundleThenPrepareReact(final NavigationActivity activity) {
        final String downloadedBundleFile = reactInstanceManager.getDevSupportManager().getDownloadedJSBundleFile();
        if (isDebug && TextUtils.isEmpty(downloadedBundleFile)) {
            reactInstanceManager.getDevSupportManager().isPackagerRunning(new PackagerStatusCallback() {
                @Override
                public void onPackagerStatusFetched(final boolean packagerIsRunning) {
                    NavigationApplication.instance.runOnMainThread(new Runnable() {
                        @Override
                        public void run() {
                            if (!packagerIsRunning) {
                                Toaster.toast("Packager is not running!");
                            } else {
                                prepareReactAppWithWorkingBundle();
                            }
                        }
                    });
                }
            });
        } else {
            prepareReactAppWithWorkingBundle();
        }
    }

    private void prepareReactAppWithWorkingBundle() {
        if (shouldCreateContext()) {
            reactInstanceManager.createReactContextInBackground();
        } else if (waitingForAppLaunchEvent) {
            emitAppLaunched();
        }
    }

    private boolean shouldCreateContext() {
        return !reactInstanceManager.hasStartedCreatingInitialContext();
    }

    private void emitAppLaunched() {
        waitingForAppLaunchEvent = false;
        NavigationApplication.instance.getEventEmitter().sendAppLaunchedEvent();
    }
}
