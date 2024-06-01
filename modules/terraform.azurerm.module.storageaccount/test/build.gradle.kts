plugins {
    id("org.jetbrains.kotlin.jvm").version("1.6.10")
    id("com.adarshr.test-logger").version("3.1.0")
    application
}

repositories {
    maven {
        url = uri("https://bosch.pkgs.visualstudio.com/_packaging/InfrastructureAsCode/maven/v1")
        credentials {
            username = "AZURE_ARTIFACTS"
            password = if (properties["Azure_PAT"] == null) System.getenv("AZURE_ARTIFACTS_ENV_ACCESS_TOKEN") else properties["Azure_PAT"].toString()        }
    }

    mavenCentral()
    mavenLocal()
}

tasks.test {
    useJUnitPlatform()
}

dependencies {
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8")

    testImplementation("org.jetbrains.kotlin:kotlin-test")
    testImplementation("org.jetbrains.kotlin:kotlin-test-junit5")
    testImplementation("org.junit.jupiter:junit-jupiter:5.8.2")
    testImplementation("com.fasterxml.jackson.module:jackson-module-kotlin:2.13.2")
    testImplementation("com.jayway.jsonpath:json-path:2.7.0")
    testImplementation("com.jayway.jsonpath:json-path-assert:2.7.0")
    testImplementation("com.bosch:terraform.test.common:2.1.0")
}