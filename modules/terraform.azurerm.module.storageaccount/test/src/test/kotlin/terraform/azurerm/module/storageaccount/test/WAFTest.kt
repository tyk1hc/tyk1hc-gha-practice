package terraform.azurerm.module.storageaccount.test

import com.jayway.jsonpath.matchers.JsonPathMatchers
import org.hamcrest.MatcherAssert
import org.hamcrest.Matchers
import org.hamcrest.Matchers.equalTo
import org.junit.jupiter.api.AfterAll
import org.junit.jupiter.api.BeforeAll
import org.junit.jupiter.api.Test
import terraform.test.common.*
import java.io.File

class WAFTest {

    companion object {

        private const val network_rules_default_action = "Deny"
        private val network_rules_ip_rules = listOf("213.61.69.130")
        private val network_rules_bypass = listOf("AzureServices")
        private val fixtureDir = fixtureDir(WAFTest::class)
        private val releaseVersionFile = File("../RELEASE")

        private val vars = mapOf(
                "name" to nonce(),
                "location" to "westeurope",
                "network_rules_default_action" to network_rules_default_action,
                "network_rules_ip_rules" to network_rules_ip_rules,
                "network_rules_bypass" to network_rules_bypass
        )

        var res: Map<String, Any?>? = null

        @JvmStatic
        @BeforeAll
        fun before() {
            fixtureDir.tfInit()
            fixtureDir.tfApply(vars)
            res = resource(Resource.storageAccounts, vars["name"].toString(), vars.getValue("name").toString() + "-example-storageaccount-rg")
        }

        @JvmStatic
        @AfterAll
        fun after() {
            fixtureDir.tfDestroy(vars)
        }
    }

    @Test
    fun `Verify that provisioning is successful`() {
        MatcherAssert.assertThat(res, JsonPathMatchers.hasJsonPath("$.properties.provisioningState",
                Matchers.equalToIgnoringCase("succeeded")))
    }

    @Test
    fun `Verify that module version tag is set`() {
        MatcherAssert.assertThat(res, JsonPathMatchers.hasJsonPath("$.tags.module_version", Matchers.equalToIgnoringCase(releaseVersionFile.readText())))
    }

    @Test
    fun `Verify that the bypass is correctly set`() {
        MatcherAssert.assertThat(res, JsonPathMatchers.hasJsonPath("$.properties.networkAcls.bypass", Matchers.equalToIgnoringCase(network_rules_bypass.first())))
    }

    @Test
    fun `Verfiy the correct ipRules value settings`() {
        MatcherAssert.assertThat(res, JsonPathMatchers.hasJsonPath("$.properties.networkAcls.ipRules[0].value", Matchers.equalToIgnoringCase(network_rules_ip_rules.first())))
    }

    @Test
    fun `Verfiy the correct ipRules action settings`() {
        MatcherAssert.assertThat(res, JsonPathMatchers.hasJsonPath("$.properties.networkAcls.ipRules[0].action", equalTo("Allow")))
    }
}