package com.reactnativenavigation.events;

public class JsBundleLoadedEvent implements Event {
    public static final String TYPE = "JsBundleLoadedEvent";

    @Override
    public String getType() {
        return TYPE;
    }
}
