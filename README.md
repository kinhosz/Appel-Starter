# 📦 Appel Starter Pack

> The official boilerplate for creating graphical applications and games using the **Appel Engine**.

![Appel Version](https://img.shields.io/badge/Appel_Engine-v0.29.0-blueviolet) ![License](https://img.shields.io/badge/License-MIT-green) ![Platform](https://img.shields.io/badge/Platform-Linux-linux)

This starter pack provides a pre-configured environment with a smart **Makefile** system that handles dependency linking, asset management, and engine compilation automatically. Focus on your game logic; let the build system handle the rest.

---

## 🚀 Getting Started

### 1. Clone the Repository
Since the engine is a submodule, use the `--recursive` flag to download everything at once.

```bash
git clone --recursive git@github.com:kinhosz/Appel-Starter.git
cd Appel-Starter
```

### 2. Install Dependencies
You can install the required system libraries (like SFML) using the helper command:

```bash
# This will trigger the engine's installation script
make install
```

---

## 🛠️ How to Build & Run

### Compiling your Game
To build your project, simply run:

```bash
make
```
*Note: The first build might take a moment as it compiles the Appel Engine from scratch. Subsequent builds will be incremental and fast.*

### Running the Application
To run your compiled executable:

```bash
make run
```
*(Or manually via `./bin/Game`)*

### Cleaning the Project
To remove all compiled objects and binaries (both from your game and the engine):

```bash
make clear
```

---

## 📂 Project Structure

It is crucial to maintain the correct folder structure so the `Makefile` can find your sources and the compiled binary can find your assets.

```text
Appel-Starter/
├── Appel/              # The Engine (Git Submodule) - DO NOT EDIT DIRECTLY
├── assets/             # Put your models (.obj) and textures (.png) here
│   └── models/
├── src/                # Your game source code
│   └── main.cpp
├── include/            # Your local header files (optional)
├── lib/                # Your local libraries (optional)
├── bin/                # Compiled executable (generated)
└── Makefile            # The build system
```

---

## 💻 Development Guide

### Using the Engine
The engine uses the `Appel` namespace. Include headers using the `<Appel/...>` path.

**Example (`src/main.cpp`):**
```cpp
#include <Appel/Geometry/Point.h>  // Specific components

using namespace Appel;

int main() {
    // 1. Load an object from the 'assets' folder relative to project root
    TriangularMesh cube("assets/cube.obj");
    
    // 2. Setup Scene
    Scene scene(1);
    scene.addObject(cube);
    
    // ... logic ...
    return 0;
}
```

### ⚠️ Asset Path Warning
When running the game, the application looks for files relative to the **project root**, not the `src` or `bin` folder.
* **Correct:** `TriangularMesh m("assets/cube.obj");`
* **Incorrect:** `TriangularMesh m("../assets/cube.obj");`

---

## ⚙️ Advanced: Engine Tools (Proxy Commands)

This Starter Pack allows you to run **Engine Tools** without leaving your project root. The Makefile acts as a proxy.

| Command | Description |
| :--- | :--- |
| `make tests` | Runs the Engine's integration tests suite. |
| `make unit FNAME=...` | Compiles and runs a specific unit test file from the engine. |
| `make tests EGPU=1` | Runs tests enabling CUDA/GPU support (if available). |

**Example: Testing a specific vector math file**
```bash
make unit FNAME=tests/geometry/vetor.cpp
```

---

## 🤝 Contributing

1.  Create a branch (`git checkout -b feature/amazing-feature`)
2.  Commit your changes (`git commit -m 'feat: Add amazing feature'`)
3.  Push to the branch (`git push origin feature/amazing-feature`)
4.  Open a Pull Request

---

*Powered by [Appel Engine](https://github.com/kinhosz/Appel)*
