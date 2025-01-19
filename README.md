# Foodly

## Introduction

This project detects the ingredients of a dish that are in a certain container. It includes localization, support for black and white themes, and operates on a trained model.

The project has expanded to include a backend, frontend, and mobile application.

## Features

### Backend

- User authentication (email/password and Google OAuth for mobile).
- User management (create, delete users).
- Password recovery via email.
- Email templates created with [React Email](https://react.email/) for ease of use.
- User avatar storage in an S3 bucket.
- Database management with [Prisma ORM](https://www.prisma.io/).

### Frontend

- Authentication via email and password (Google OAuth is currently not fully functional).
- Password recovery process handled entirely on the website.
- User profile viewing.
- The frontend is currently in beta and not the primary focus of the project.

### Mobile

- Google OAuth for user authentication.
- Functionality to select a photo from the gallery or take a new photo using the camera.
- Confirmation of the selected photo.
- Scanning the photo with a trained model to detect dish ingredients.
- Displaying the detected composition of the dish, with the ability to group ingredients by categories. Different colors are used for each group, which are also highlighted on the image to show their specific locations.
- History of scanned images:
  - Save scanned images.
  - View results from saved images.
  - Delete entries from history.
- Options for changing the app language and theme.
- User profile management:
  - View profile.
  - Delete account.
  - Update avatar.
  - Change password.

## Development Environment

The project uses Docker for running services. To start all services, use:

```
docker-compose up
```

### Note:

During the startup of all services via Docker Compose, the `localstack-s3` service might encounter an error. To fix this, ensure the `End of Line Sequence` in the `localstack-init.sh` file is set to `LF` instead of `CRLF`.

### Services in Docker Compose:

- Database
- Mailhog (for testing email functionality)
- Localstack (for S3 bucket emulation)

## Setup

### 1. Clone this repo:

Navigate into your workspace directory. Run:

```
git clone https://github.com/0deans/foodly.git
```

### 2. Install dependencies:

For the mobile app, run:

```
flutter pub get
```

### 3. Example `.env` files:

Refer to the `.env` files in the `backend` and `frontend` directories for configuration examples.

## Running the Project

### Mobile

To run the mobile application, turn on a virtual device or connect your own to your computer, then run:

```
flutter run
```

## Demo Images

### Mobile Application
![Mobile Application](demo/mobile.png)

### Frontend
![Frontend](demo/frontend.png)

## Project Status

This project is under active development and serves as a student project aimed at enhancing skills and exploring new technologies. Refer to the `README` files in the `frontend`, `backend`, and `mobile` directories for additional details.

