plugins {
    id("org.jetbrains.kotlin.jvm").version("1.3.20")
    id("com.adarshr.test-logger").version("1.7.0")
    application
}

repositories {
    maven {
        url = uri("https://pkgs.dev.azure.com/bosch/_packaging/InfrastructureAsCode/maven/v1")
        credentials {
            username = "AZURE_ARTIFACTS"
            password = if (properties["Azure_PAT"] == null) System.getenv("AZURE_ARTIFACTS_ENV_ACCESS_TOKEN") else properties["Azure_PAT"].toString()
        }
    }
    jcenter()
    mavenLocal()
}

tasks.test {
    useJUnitPlatform()
}

dependencies {
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8")

    testImplementation("org.jetbrains.kotlin:kotlin-test")
    testImplementation("org.jetbrains.kotlin:kotlin-test-junit5")
    testImplementation("org.junit.jupiter:junit-jupiter:5.5.2")
    testImplementation("com.fasterxml.jackson.module:jackson-module-kotlin:2.9.+")
    testImplementation("com.jayway.jsonpath:json-path:2.4.0")
    testImplementation("com.jayway.jsonpath:json-path-assert:2.4.0")
    testImplementation("com.bosch:terraform.test.common:1.0.0")

    testImplementation("com.microsoft.azure:azure-mgmt-network:1.22.0")
}