import {
  NativeAppEventEmitter,
  DeviceEventEmitter,
  Platform
} from 'react-native';
export default class NativeEventsReceiver {
  constructor() {
    this.emitter = Platform.OS === 'android' ? DeviceEventEmitter : NativeAppEventEmitter;
  }

  containerStart(callback) {
    this.emitter.addListener('RNN.containerStart', callback);
  }

  containerStop(callback) {
    this.emitter.addListener('RNN.containerStop', callback);
  }

  appLaunched(callback) {
    this.emitter.addListener('RNN.appLaunched', callback);
  }
}
