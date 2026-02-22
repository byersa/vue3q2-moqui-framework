# Huddle Project: Setup & Configuration Walkthrough

## 1. System Liftoff (Project Initialization)
We successfully bootstrapped the **Moqui 4.0** environment for the Huddle project using the `huddle-liftoff` protocol.

*   **Workspace Setup:**
    *   Cloned the `moqui-framework` and checked out the `demo` component set.
    *   **UI Modernization:** Switched key UI components (`SimpleScreens`, `MarbleERP`, etc.) to the **`vue3quasar2`** branch for the latest frontend features.
    *   **Component Creation:** Created the core `huddle` component at `runtime/component/huddle` with the standard directory structure (`screen`, `service`, `entity`, `data`) and specific configuration files (`component.xml`, `Entities.xml`).
    *   **MCP Integration:** Verified integration of `moqui-mcp` for AI assistant capabilities.
    *   **Automation:** Created `start-huddle.sh` and `huddle_Master_Roadmap.md` to track project progress.

## 2. PostgreSQL Configuration (`/config`)
We configured the runtime to use a local PostgreSQL database instead of the default H2 database.

*   **Database Profile:** Configured `runtime/conf/MoquiDevConf.xml` to connect to:
    *   **DB Name:** `nursinghome`
    *   **User/Pass:** `ofbiz` / `heber`
    *   **Port:** `5434`
*   **Driver & Timezones:**
    *   Added an automated `installDrivers` task to `build.gradle` and successfully downloaded the PostgreSQL JDBC driver (`42.7.2`).
    *   **Timezone Enforcement:** Hardcoded `America/Denver` as the timezone in both `start-huddle.sh` and `build.gradle` (for all `JavaExec` tasks) to ensure consistency between the database and the application.

## 3. Build System Remediation
We encountered and resolved several Gradle 9 compatibility issues and deprecations across the ecosystem.

### **`moqui-fop` (PDF/Rendering Engine)**
*   **Branch Switch:** Switched `runtime/component/moqui-fop` to the **`upgrade`** branch to access newer fixes.
*   **Fixes Applied:**
    *   **Gradle DSL:** Replaced deprecated `module()` calls with standard `implementation (...) { exclude ... }` blocks.
    *   **Servlet API:** Migrated `HtmlRenderServlet.groovy` from `javax.servlet` (Servlet 4) to **`jakarta.servlet`** (Servlet 6) to match the new framework baseline.
    *   **Property Deprecation:** Updated `jar.archivePath` to `jar.archiveFile` in the `copyDependencies` task.

### **Other Component Fixes**
*   **`moqui-poi`:** Fixed the deprecated `jar.archivePath` property in `build.gradle`.
*   **`example`:** Fixed the deprecated `jar.archivePath` property in `build.gradle`.

## 4. Verification & Data Load
*   **Build Status:** Validated the entire project with `./gradlew clean build`, which now passes successfully (BUILD SUCCESSFUL).
*   **Data Population:** Ran `./gradlew load` to seed the PostgreSQL database. The logs confirmed that Seed, L10n, and Demo data were successfully loaded with a clean transaction shutdown.
