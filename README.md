# Multi-modal Distributed Interaction Framework for Cross-device Smart Home Control Panels Based on HarmonyOS

This project is a capstone project that implements a smart home control system using HarmonyOS. It supports device management, scene control, and user interaction.

---

##  Core Features

### 1. Cross-device Connection & Synchronization
- Seamless connection across multiple HarmonyOS devices  
- Real-time data synchronization  

### 2. Adaptive UI Design
- Responsive UI for different screen sizes  
- Optimized user experience across devices  

### 3. Scene Linkage & Personalization
- Multiple scene creation  
- Automation rules and one-click execution  

### 4. HarmonyOS Service Card
- Quick access via service cards  
- Lightweight interaction without opening the full app  

---

## Project Structure

```bash
├── AppScope/                          # Global application configuration and public resource directory, stores application-level common resources and the core global configuration file app.json5 (package name, version number, permission declarations, etc.)
├── entry/                              # Main module of the application, where the project's core business code, pages and logic are implemented
│   ├── src/main/                       # Core code directory of the main module
│   │   ├── ets/                        # 【Core Business Code Directory of the Graduation Project】 Storage directory for all ArkTS business code
│   │   │   ├── business/               # Core Business Logic Layer
│   │   │   │   ├── DeviceManager.ets    # Core class for device management, implements core capabilities including device discovery, connection, status management & control, and command delivery
│   │   │   │   └── SceneManager.ets     # Core class for scene management, implements CRUD operations for scenes, linkage rule configuration, one-click trigger and other capabilities
│   │   │   ├── model/                  # Data Model Layer, defines business data structures such as device information and scene information
│   │   │   ├── pages/                  # Application Page Layer, implements the UI and interaction logic for the homepage, device list page, and scene list page
│   │   │   ├── constant/               # Global constant configuration directory
│   │   │   ├── state/                  # Application global state management directory
│   │   │   ├── util/                   # Common utility class directory
│   │   │   ├── entryability/           # Main entry Ability of the application, responsible for application lifecycle management
│   │   │   └── entrybackupability/     # Implementation of application data backup and restoration capabilities
│   │   ├── resources/                   # Page resource directory exclusive to the main module
│   │   └── module.json5                 # Configuration file of the main module, declares Ability, routing, permission and other configurations
│   ├── mock/                            # API mock data directory
│   └── ohosTest/                        # HarmonyOS automated test case directory
├── images/                              # Directory for project document illustrations, function demo screenshots, and architecture diagrams
├── wukong_test_results/                 # Directory for HarmonyOS Wukong automated stability test results
├── result.py                            # Generate images based on the Wukong testing structure
├── hvigorfile.ts                        # Project build configuration script
├── oh-package.json5                     # Third-party dependency management configuration file for the project
└── README.md                            # Project documentation
```
---
##  Technologies Used

- **HarmonyOS**
- **ArkTS (Ark TypeScript)**
- **ArkUI**
- **DevEco Studio 4.0**
- **Wukong Automated Testing Tool**

---

##  Requirements

- DevEco Studio  
- HarmonyOS SDK  
- Node.js  

---

## ▶ How to Run

1. Clone the repository:
git clone https://github.com/jiaqihe547-prog/2026capstone.git and cd 2026capstone/Capstone
2. Open the project with DevEco Studio
3. Build and run the project on an emulator or a real device
---

## Author

**He Jiaqi**

B.Sc. Computer Science

Wenzhou-Kean University

Supervisor: Dr. Rashid Sangi