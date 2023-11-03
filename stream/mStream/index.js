/**
 * @format
 */

import {AppRegistry} from 'react-native';
import App from './App';
import DIDStream from './src/DIDStream/index';
import RtcStream from './src/RtcStream/index';
import {name as appName} from './app.json';

AppRegistry.registerComponent(appName, () => RtcStream);
// AppRegistry.registerComponent(appName, () => DIDStream);
// AppRegistry.registerComponent(appName, () => App);
