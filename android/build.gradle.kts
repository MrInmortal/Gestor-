// android/build.gradle.kts

// Define las versiones para usar en los módulos.
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // AGP (Android Gradle Plugin) actualizado a una versión moderna y estable.
        classpath("com.android.tools.build:gradle:8.2.2")
        // Versión de Kotlin recomendada para AGP 8.x.
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.9.22") 
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
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