# Battery Status App

This is a simple, basic and minimalistic app that shows the battery status of your home power supply. This app is connected to a server that provides the battery status and requires need refreshed manually.

## Development

Since we are using Google OAuth service, we need to define the `GOOGLE_CLIENT_ID` securely. Please, for development run the command:

```bash
flutter run --dart-define=GOOGLE_CLIENT_ID=your_google_client_id_here.apps.googleusercontent.com
```

_GOOGLE_CLIENT_ID is defined on `.env` file_
