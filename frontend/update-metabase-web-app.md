---
title: FilmMeister/Metabase Docker deployment & update guide
author: Fred
date: 2026-02-01
---

# FilmMeister/Metabase Docker deployment & update guide

---

## 1. Overview

This guide provides step-by-step instructions for deploying the Metabase-FilmMeister app using Docker and Azure Container Registry (ACR). It covers backing up databases, building a Docker image, uploading the image to ACR, and deploying the updated app.

**Prerequisites:**
- DBeaver (latest version, or the back-up tool will not work)
- KeePass (for environment variables)
- Docker CLI
- Azure CLI (for ACR login)
- Access to the FilmMeister Git repo

---

## 2. Step-by-Step Workflow

### Step 1: Backup Databases
**Goal:** Create backups of all required databases.

1. Open **DBeaver**.
2. Use the **backup tool** to create backups for:
   - `film-meister`
   - `metabaseappdb`
   - `postgres`
3. Verify backups are saved in a secure location.

---

### Step 2: Prepare Dockerfile Environment Variables
**Goal:** Inject Metabase database credentials into the Dockerfile.

1. Navigate to: `Film_Meister_Datavault\frontend\Dockerfile`
2. Open **KeePass** and locate the entry:
   **"env file voor metabase docker"**
3. Copy all environment variables from KeePass into the `ENV` section of the Dockerfile.

---

### Step 3: Build Docker Image
**Goal:** Create a Docker image with the updated environment variables.

Run the following command in the directory containing the Dockerfile:
```bash
docker build \
  --build-arg MB_DB_TYPE \
  --build-arg MB_DB_HOST \
  --build-arg MB_DB_PORT \
  --build-arg MB_DB_DBNAME \
  --build-arg MB_DB_USER \
  --build-arg MB_DB_PASS \
  -t metabase-image .
```

---

### Step 4: Stop the Metabase-FilmMeister Web App
**Goal:** Prevent conflicts during deployment.

- Stop the running Metabase-FilmMeister web app: Navigate to the app service and click **Stop**.

---

### Step 5: Upload Docker Image to Azure Container Registry
**Goal:** Push the new image to ACR for deployment.

#### 5.1: Log in to Azure ACR
```bash
docker login <Container Registry>.azurecr.io
```
- Use credentials found at settings/accessKey in the Azure Container Registry page.

#### 5.2: Tag the Image
```bash
docker tag metabase-image <Container Registry>.azurecr.io/metabase-image-filmmeister
```

#### 5.3: Push the Image
```bash
docker push <Container Registry>.azurecr.io/metabase-image-filmmeister:<version>
```
- Replace `<version>` with the appropriate tag (e.g., `v1.0.0`).

---

### Step 6: Deploy and Update
**Goal:** Start the updated app in Azure.

1. Navigate to the **Azure Portal**.
2. Navigate to the implementation centrum for the web-app and select the new image version.
2. Restart the Metabase-FilmMeister app using the new image.
3. Wait a few minutes for the update to complete.

---