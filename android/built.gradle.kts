allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Safely configure custom root project build directory
gradle.beforeProject {
    if (this == rootProject) {
        val newBuildDir = rootProject.layout.projectDirectory.dir("build").asFile.resolveSibling("custom-root-build")
        buildDir = newBuildDir
    }
}

// Configure custom build directory for each subproject
subprojects {
    val customBuildDir = rootProject.buildDir.resolve(name)
    buildDir = customBuildDir

    // Optionally: force subprojects to evaluate after :app
    if (name != "app" && rootProject.subprojects.any { it.name == "app" }) {
        evaluationDependsOn(":app")
    }
}

// Clean task
tasks.register<Delete>("clean") {
    delete(rootProject.buildDir)
}
