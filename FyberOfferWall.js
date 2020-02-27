import EventEmitter from 'eventemitter3';

import { NativeModules, NativeEventEmitter } from 'react-native';

const RNFyberOfferWall = NativeModules.RNFyberOfferWall;

const clientEventEmitter = new EventEmitter();
const nativeEventEmitter = new NativeEventEmitter(RNFyberOfferWall);

const eventTypes = [
  'fyberOfferWallInitializeFailed',
  'fyberOfferWallInitializeSucceeded',
  'fyberOfferWallShowOfferWallSucceeded'
];

eventTypes.forEach((type) => nativeEventEmitter.addListener(
  type,
  (...args) => clientEventEmitter.emit(type, ...args)
));

const addEventListener = (type, handler, context) => {
  clientEventEmitter.addListener(type, handler, context)
};

const initializeOfferWall = (appId, securityToken, userId) => {
  return new Promise((resolve, reject) => {
    const failedListener = nativeEventEmitter.addListener(
      'fyberOfferWallInitializeFailed',
      ({ error }) => {
        removeListeners();

        reject(new Error(`Fyber Offer Wall initialization error: ${ error }`));
      }
    );

    const succeededListener = nativeEventEmitter.addListener(
      'fyberOfferWallInitializeSucceeded',
      () => {
        removeListeners();

        resolve();
      }
    );

    const removeListeners = () => {
      failedListener.remove();
      succeededListener.remove();
    };

    RNFyberOfferWall.initializeOfferWall(appId, securityToken, userId);
  });
};

const removeAllListeners = (type) => {
  clientEventEmitter.removeAllListeners(type)
};

const removeEventListener = (type, handler, context) => {
  clientEventEmitter.removeListener(type, handler, context)
};

const showOfferWall = () => {
  return new Promise((resolve) => {
    const succeededListener = nativeEventEmitter.addListener(
      'fyberOfferWallShowOfferWallSucceeded',
      () => {
        succeededListener.remove();

        resolve();
      }
    );

    RNFyberOfferWall.showOfferWall();
  });
};

export default {
  addEventListener,
  initializeOfferWall,
  removeAllListeners,
  removeEventListener,
  showOfferWall
}