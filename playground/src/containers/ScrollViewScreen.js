import _ from 'lodash';
import React, { Component } from 'react';
import {
  StyleSheet,
  View,
  Text,
  ScrollView,
  Button
} from 'react-native';

import Navigation from 'react-native-navigation';

class ScrollViewScreen extends Component {
  static navigationOptions = {
    title: 'ScrollView Title',
    topBarTextFontFamily: 'AmericanTypewriter-CondensedLight',
    topBarButtonColor: "yellow",
    topBarHidden: false,
    topBarTranslucent: false,
    topBarHideOnScroll: true
  }

  constructor(props) {
    super(props);
  }

  render() {
    return (
      <ScrollView testID="scrollView" contentContainerStyle={styles.scrollView}>
        <Text style={styles.h1}>{`ScrollView Screen`}</Text>
        <Text style={styles.footer}>{`this.props.containerId = ${this.props.containerId}`}</Text>
      </ScrollView>
    );
  }
  
}

const styles = {
  scrollView: {
    height: 1500,
    justifyContent: 'center',
    alignItems: 'center'
  },
  h1: {
    fontSize: 24,
    textAlign: 'center',
    margin: 10
  },
  h2: {
    fontSize: 12,
    textAlign: 'center',
    margin: 10
  },
  footer: {
    fontSize: 10,
    color: '#888',
    marginTop: 10
  }
};

export default ScrollViewScreen;
