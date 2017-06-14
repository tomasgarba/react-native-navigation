package com.reactnativenavigation.views;

import android.widget.Toast;

import com.reactnativenavigation.NavigationApplication;

public class Toaster {
    public static void toast(String text) {
        Toast.makeText(NavigationApplication.instance, text, Toast.LENGTH_LONG).show();
    }
}
