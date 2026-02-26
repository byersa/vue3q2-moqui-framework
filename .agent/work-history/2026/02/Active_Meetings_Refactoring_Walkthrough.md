# Walkthrough: Refactoring Active Meetings with Blueprint Patterns

This walkthrough documents the architectural refactoring of the Active Meetings module, transitioning from raw Quasar components to a clean, "Blueprint-first" approach using the enhanced `DeterministicVueRenderer`.

## 🎯 Objectives
*   Implement a standardized **Blueprint List Pattern** for dynamic UI components.
*   Decouple screen logic from framework-specific Vue constructs (`v-for`, `v-if`).
*   Establish a formal **Abstract-to-Instance** workflow for clinical meetings.
*   Ensure robust server-side rendering of conditional sections.

## 🚀 Key Architectural Changes

### 1. The Blueprint List Pattern
We introduced a high-level abstraction for iterating over lists in XML without using Vue syntax.
*   **XML Structure**:
    ```xml
    <bp-tabbar list="window.useMeetingsStore().activeList">
        <bp-tab text="name" url="'/aitree/ActiveMeetings/MeetingDiscussion?activeAgendaContainerId=' + item.agendaContainerId" />
    </bp-tabbar>
    ```
*   **Mechanism**: The `bp-tabbar` component (in `MoquiAiVue.qvt2.js`) iterates over the resolved list and uses a `bp-tab-provider` to "provide" the current `item` context to its children. The `bp-tab` component "injects" this context to bind its properties.

### 2. Enhanced DeterministicVueRenderer
The Blueprint renderer was upgraded to handle Moqui's native structural tags more effectively:
*   **Transparent Sections**: The renderer now manually evaluates `<condition>` tags within a `<section>`. It then "walks" either the `<widgets>` or `<fail-widgets>` block, completely flattening the output JSON so the client only receives the final UI widgets.
*   **Strict XML Compliance**: Updated the renderer and XML screens to handle strict SAX parsing requirements (e.g., ensuring all Vue directives like `v-else` and `v-slot` have assigned values like `=""`).

### 3. Abstract-to-Instance Workflow
Transformed the "Activate Meeting" process from a purely client-side state change into a formal database-backed transition.
*   **`startMeetingInstance`**: A new server-side transition that creates a `RealTime` meeting instance from an `Abstract` template.
*   **Dynamic Activation**: The activation dialog now uses a JS `fetch` to create the instance on the server and then updates the Pinia store with the newly generated instance ID.

### 4. Meeting Discussion State Management
The `MeetingDiscussion.xml` screen now utilizes native Moqui `<section>` logic to toggle between:
*   **Prompt State**: If no instance ID is selected, it shows a guide message using `<fail-widgets>`.
*   **Discussion State**: If a valid instance ID is selected, it renders the discussion components.

## 🛠️ Components & Files
*   **`MoquiAiVue.qvt2.js`**: Enhanced `bp-tabbar` and `bp-tab` for list support.
*   **`MoquiAiScreenMacros.qvt2.ftl`**: Updated macros for the new Blueprint tags.
*   **`ActiveMeetings.xml`**: Main screen using the tabbar list pattern.
*   **`MeetingDiscussion.xml`**: Subscreen using section/condition logic.
*   **`DeterministicVueRenderer.groovy`**: Core platform logic for Blueprint generation.

## ✅ Verification
*   The "Start New Meeting" dialog successfully creates server-side records.
*   The dynamically generated tabs correctly route to the specific discussion instance.
*   The conditional guide message appears correctly when no session is selected.
