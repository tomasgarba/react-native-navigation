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

class OptionsScreen extends Component {
  static navigationOptions = {
    title: 'Static Title',
    topBarTextFontFamily: 'AmericanTypewriter-CondensedLight',
    topBarButtonColor: "yellow",
    topBarHidden: false,
    topBarTranslucent: false
  }

  constructor(props) {
    super(props);
    this.onClickDynamicOptions = this.onClickDynamicOptions.bind(this);
    this.onClickTopBarHidden = this.onClickTopBarHidden.bind(this);
    this.onClickScrollViewScreen = this.onClickScrollViewScreen.bind(this);
  }

  render() {
    return (
      <View style={styles.root}>
        <Text style={styles.h1}>{`Options Screen`}</Text>
        <Button title="Dynamic Options" onPress={this.onClickDynamicOptions} />
        <Button title="setTopBarHidden" onPress={this.onClickTopBarHidden} />
        <Button title="ScrollView Screen" onPress={this.onClickScrollViewScreen} />
        <Text style={styles.footer}>{`this.props.containerId = ${this.props.containerId}`}</Text>
      </View>
    );
  }

  onClickDynamicOptions() {
    Navigation.setOptions(this.props.containerId, {
      title: 'Dynamic Title',
      topBarButtonColor: "yellow",
      topBarTextFontFamily: 'AmericanTypewriter-CondensedLight',
      topBarHidden: false,
      topBarTranslucent: false,
      screenBackgroundColor: "red"
    });
  }

  onClickTopBarHidden() {
    Navigation.setOptions(this.props.containerId, {
      topBarHidden: true
    });
  }

  onClickScrollViewScreen() {
    Navigation.push(this.props.containerId, {
      name: 'navigation.playground.ScrollViewScreen'
    });
  }
  
}

const styles = {
  root: {
    flexGrow: 1,
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

export default OptionsScreen;
