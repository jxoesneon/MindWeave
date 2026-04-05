allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.google.gms:google-services:4.4.2")
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
    
    // Fix for "Namespace not specified" error in older packages
    afterEvaluate {
        if (project.extensions.findByName("android") != null) {
            val android = project.extensions.getByName("android") as com.android.build.gradle.BaseExtension
            if (android.namespace == null) {
                // Try to get package from AndroidManifest.xml
                val manifestFile = project.file("src/main/AndroidManifest.xml")
                if (manifestFile.exists()) {
                    val manifestContent = manifestFile.readLines().joinToString(" ")
                    val packageMatch = Regex("package\\s*=\\s*\"([^\"]*)\"").find(manifestContent)
                    if (packageMatch != null) {
                        android.namespace = packageMatch.groupValues[1]
                        logger.quiet("Injecting namespace ${android.namespace} for project ${project.name} from AndroidManifest.xml")
                    } else {
                        android.namespace = "com.mindweave.generated_namespace.${project.name.replace("-", "_")}"
                        logger.quiet("Injecting generated namespace ${android.namespace} for project ${project.name}")
                    }
                } else {
                    android.namespace = "com.mindweave.generated_namespace.${project.name.replace("-", "_")}"
                    logger.quiet("Injecting generated namespace ${android.namespace} for project ${project.name} (no manifest found)")
                }
            }
            
            // Force JVM target and Java compatibility for all subprojects
            android.compileOptions {
                sourceCompatibility = JavaVersion.VERSION_17
                targetCompatibility = JavaVersion.VERSION_17
            }
        }
    }
    
    tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
        compilerOptions {
            jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
        }
    }
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
