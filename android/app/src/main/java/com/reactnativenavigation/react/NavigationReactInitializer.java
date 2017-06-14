package com.reactnativenavigation.react;

import com.facebook.react.ReactInstanceManager;
import com.facebook.react.bridge.ReactContext;
import com.reactnativenavigation.NavigationApplication;
import com.reactnativenavigation.controllers.NavigationActivity;
import com.reactnativenavigation.events.Event;
import com.reactnativenavigation.events.EventBus;
import com.reactnativenavigation.events.JsBundleLoadedEvent;
import com.reactnativenavigation.events.Subscriber;

class NavigationReactInitializer implements ReactInstanceManager.ReactInstanceEventListener, Subscriber {

    private ReactInstanceManager reactInstanceManager;
    private boolean waitingForAppLaunchEvent = true;

    NavigationReactInitializer(ReactInstanceManager reactInstanceManager) {
        this.reactInstanceManager = reactInstanceManager;
        EventBus.instance.register(this);
    }

    @Override
    public void onReactContextInitialized(ReactContext context) {
        ((NavigationReactGateway) NavigationApplication.instance.getReactGateway()).onReactContextInitialized();
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
            prepareReactApp();
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

    private void prepareReactApp() {
        reactInstanceManager.addReactInstanceEventListener(this);
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

    @Override
    public void onEvent(Event event) {
        if (event.getType().equals(JsBundleLoadedEvent.TYPE)) {
//            prepareReactApp();
        }
    }
}
