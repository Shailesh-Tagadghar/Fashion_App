// firebase-messaging-sw.js

importScripts('https://www.gstatic.com/firebasejs/9.0.0/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/9.0.0/firebase-messaging.js');

// Initialize Firebase (replace with your Firebase config)
firebase.initializeApp({
  apiKey: "AIzaSyBT23e5PP4OdYKjNKrK_chW4Fqfucmabdw",
  authDomain: "ecommerce-9cd8e.firebaseapp.com",
  projectId: "ecommerce-9cd8e",
  storageBucket: "ecommerce-9cd8e.appspot.com",
  messagingSenderId: "572226647997",
  appId: "1:572226647997:web:46c880b29baca0894e04d4",
  measurementId: "G-W4VEESTBWW"
});

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);

// Retrieve Firebase Messaging object.
const messaging = firebase.messaging();

messaging.onBackgroundMessage(function(payload) {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);
  // Customize notification here
  const notificationTitle = 'Background Message Title';
  const notificationOptions = {
    body: 'Background Message body.',
    icon: '/firebase-logo.png'
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});
