allprojects {
    repositories {
        google()
        mavenCentral()
    }
    configurations.configureEach {
        resolutionStrategy.eachDependency {
            // home_widget 0.9 uses 1.+, which can select an incompatible alpha.
            if (requested.group == "androidx.glance") {
                useVersion("1.1.1")
                because("Keep home_widget compatible with compileSdk 36 and AGP 8")
            }
            if (requested.group == "org.jetbrains.kotlinx" &&
                requested.name.startsWith("kotlinx-coroutines-")) {
                useVersion("1.10.2")
                because("Resolve home_widget's dynamic dependency reproducibly")
            }
            if (requested.group == "androidx.work") {
                useVersion("2.9.0")
                because("Align home_widget with the app's WorkManager and Java 8 target")
            }
        }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
